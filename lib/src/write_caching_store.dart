import 'dart:async';

import 'package:hive/hive.dart';
import 'package:meta/meta.dart';

import 'conflict_resolution.dart';
import 'filter.dart';
import 'generic_box_event.dart';
import 'models/db_exception.dart';
import 'read_caching_store.dart' show ReloadStrategy;
import 'rest_api.dart';
import 'store.dart';
import 'store_entry.dart';
import 'transaction.dart';

typedef _UpdateFn<T> = FutureOr<StoreEntry<T>> Function(StoreEntry<T> entry);

abstract class WriteCachingStoreBase<T> {
  final FirebaseStore<T> store;
  BoxBase<StoreEntry<T>> get box;

  bool keepDeletedEntries = false;
  ReloadStrategy reloadStrategy = ReloadStrategy.compareValue;

  WriteCachingStoreBase(this.store);

  Future<void> download([Filter filter]) async {
    final eTagReceiver = ETagReceiver();
    final remoteKeys = await (filter != null
        ? store.queryKeys(filter, eTagReceiver)
        : store.keys(eTagReceiver));
    final deletedKeys = keys.toSet().difference(remoteKeys.toSet());
    for (final key in deletedKeys) {
      final localEntry = await _getLocal(key);
      if (localEntry.modified) {
        await _resolve(key, localEntry, const StoreEntry(value: null));
      } else {
        await _storeLocal(key);
      }
    }
    for (final key in remoteKeys) {
      await _downloadEntry(key);
    }
  }

  Future<void> upload({bool multipass = true}) async {
    var hasChanges = false;
    do {
      hasChanges = false;
      for (final key in keys) {
        final entry = await _getLocal(key);
        if (entry.modified) {
          final uploaded = await _uploadEntry(key, entry);
          hasChanges |= !uploaded;
        }
      }
    } while (multipass && hasChanges);
  }

  Future<StreamSubscription<void>> syncDownload({
    Filter filter,
    Function onError,
    void Function() onDone,
    bool cancelOnError = false,
  }) async {
    final stream = await (filter != null
        ? store.streamQueryKeys(filter)
        : store.streamKeys());
    return stream.listen(
      (key) => _handleRemoteEvent(key, filter),
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  Future<StreamSubscription<void>> syncUpload({
    Function onError,
    void Function() onDone,
    bool cancelOnError = false,
  }) async {
    final subscription = box.watch().listen(
          _handleLocalEvent,
          onError: onError,
          onDone: onDone,
          cancelOnError: cancelOnError,
        );
    try {
      subscription.pause();
      await upload(multipass: false);
      subscription.resume();
      return subscription;
    } catch (e) {
      await subscription.cancel();
      rethrow;
    }
  }

  Future<FirebaseTransaction<T>> transaction(String key) async =>
      _WriteStoreTransaction(
        store: this,
        key: key,
        entry: await _getLocal(key),
      );

  Future<String> add(T value) async {
    await _checkOnline();
    final eTagReceiver = ETagReceiver();
    final key = await store.create(value, eTagReceiver);
    await box.put(
      key,
      StoreEntry(
        value: value,
        eTag: eTagReceiver.eTag,
      ),
    );
    return key;
  }

  Future<int> clear() => box.clear();

  Future<void> close() => box.close();

  Future<void> compact() => box.compact();

  bool containsKey(String key) => box.containsKey(key);

  Future<void> delete(String key) => _update(
        key,
        (entry) => entry.copyWith(
          value: null,
          modified: true,
        ),
      );

  Future<void> deleteFromDisk() => box.deleteFromDisk();

  bool get isEmpty => box.isEmpty;

  bool get isNotEmpty => box.isNotEmpty;

  bool get isOpen => box.isOpen;

  Iterable<String> get keys => box.keys.cast<String>();

  bool get lazy => box.lazy;

  int get length => box.length;

  String get name => box.name;

  String get path => box.path;

  Future<void> put(String key, T value) => _update(
        key,
        (entry) => entry.copyWith(
          value: value,
          modified: true,
        ),
      );

  Stream<GenericBoxEvent<String, T>> watch({String key}) async* {
    await for (final event in box.watch(key: key)) {
      final entry = event.value as StoreEntry<T>;
      yield GenericBoxEvent(
        key: event.key as String,
        value: entry?.value,
        deleted: event.deleted || entry?.value == null,
      );
    }
  }

  @protected
  FutureOr<bool> isOnline();

  @protected
  FutureOr<ConflictResolution<T>> resolveConflict(
    String key,
    T local,
    T remote,
  );

  Future<void> _checkOnline() async {
    if (!await isOnline()) {
      // TODO throw OfflineException();
    }
  }

  Future<StoreEntry<T>> _getRemote(String key) async {
    final eTagReceiver = ETagReceiver();
    final value = await store.read(key, eTagReceiver);
    return StoreEntry(
      value: value,
      eTag: eTagReceiver.eTag,
    );
  }

  Future<StoreEntry<T>> _update(String key, _UpdateFn<T> update) async {
    final updated = await update(await _getLocal(key));
    await box.put(key, updated);
    return updated;
  }

  Future<void> _downloadEntry(String key) async {
    final remoteEntry = await _getRemote(key);
    final localEntry = await _getLocal(key);
    if (localEntry.eTag != remoteEntry.eTag) {
      if (localEntry.modified) {
        await _resolve(key, localEntry, remoteEntry);
      } else {
        await _storeLocal(key, remoteEntry);
      }
    }
  }

  Future<bool> _uploadEntry(String key, StoreEntry<T> entry) async {
    assert(entry.modified);
    // optimistic sync approach
    try {
      final eTagReceiver = ETagReceiver();
      T storeValue;
      if (entry.value != null) {
        storeValue = await store.write(
          key,
          entry.value,
          eTag: entry.eTag,
          eTagReceiver: eTagReceiver,
        );
      } else {
        await store.delete(
          key,
          eTag: entry.eTag,
          eTagReceiver: eTagReceiver,
          silent: true,
        );
      }
      await _storeLocal(
        key,
        StoreEntry(
          value: storeValue,
          eTag: eTagReceiver.eTag,
        ),
      );
      return true;
    } on DbException catch (e) {
      if (e.statusCode == RestApi.statusCodeETagMismatch) {
        final remoteEntry = await _getRemote(key);
        await _resolve(key, entry, remoteEntry);
        return false;
      } else {
        rethrow;
      }
    }
  }

  Future<void> _resolve(
    String key,
    StoreEntry<T> local,
    StoreEntry<T> remote,
  ) async {
    final resolution = await resolveConflict(key, local.value, remote.value);
    final resolvedEntry = resolution.when(
      local: () => local.copyWith(
        eTag: remote.eTag,
        modified: true,
      ),
      remote: () => remote.copyWith(
        modified: false,
      ),
      delete: () => StoreEntry(
        value: null,
        eTag: remote.eTag,
        modified: true,
      ),
      update: (data) => StoreEntry(
        value: data,
        eTag: remote.eTag,
        modified: true,
      ),
    );
    await _storeLocal(key, resolvedEntry);
  }

  Future<void> _storeLocal(
    String key, [
    StoreEntry<T> entry = const StoreEntry(value: null),
  ]) async {
    if (!entry.modified && entry.value == null && !keepDeletedEntries) {
      await box.delete(key);
    } else {
      await box.put(key, entry);
    }
  }

  Future<void> _handleRemoteEvent(String key, [Filter filter]) async {
    if (key == null) {
      await download(filter);
    } else {
      await _downloadEntry(key);
    }
  }

  Future<void> _handleLocalEvent(BoxEvent event) async {
    if (event.deleted || event.value == null) {
      return;
    }

    // use current entry value, as events might be outdated
    final entry = await _getLocal(event.key as String);
    if (!entry.modified) {
      return;
    }

    await _uploadEntry(event.key as String, entry);
  }

  FutureOr<StoreEntry<T>> _getLocal(String key);
}

abstract class WriteCachingStore<T> extends WriteCachingStoreBase<T> {
  @override
  final Box<StoreEntry<T>> box;

  WriteCachingStore(FirebaseStore<T> store, this.box) : super(store);

  T get(String key, {T defaultValue}) => box.get(key)?.value ?? defaultValue;

  Map<String, T> toMap() => box
      .toMap()
      .cast<String, StoreEntry<T>>()
      .map((key, value) => MapEntry(key, value.value));

  Iterable<T> get values => box.values.map((e) => e.value);

  Iterable<T> valuesBetween({String startKey, String endKey}) =>
      box.valuesBetween(startKey: startKey, endKey: endKey).map((e) => e.value);

  @override
  FutureOr<StoreEntry<T>> _getLocal(String key) => box.get(
        key,
        defaultValue: const StoreEntry(value: null),
      );
}

class _WriteStoreTransaction<T> implements FirebaseTransaction<T> {
  final WriteCachingStoreBase<T> store;
  final StoreEntry<T> entry;

  @override
  final String key;

  @override
  T get value => entry.value;

  @override
  String get eTag => entry.eTag;

  _WriteStoreTransaction({
    @required this.store,
    @required this.key,
    @required this.entry,
  });

  @override
  Future<T> commitUpdate(T data) async {
    final updated = await store._update(
      key,
      (entry) {
        if (entry.eTag == eTag) {
          return entry.copyWith(
            value: value,
            modified: true,
          );
        } else {
          throw const DbException(
            statusCode: RestApi.statusCodeETagMismatch,
            error: 'ETag mismatch',
          );
        }
      },
    );
    return updated.value;
  }

  @override
  Future<void> commitDelete() async {
    await store._update(
      key,
      (entry) {
        if (entry.eTag == eTag) {
          return entry.copyWith(
            value: null,
            modified: true,
          );
        } else {
          throw const DbException(
            statusCode: RestApi.statusCodeETagMismatch,
            error: 'ETag mismatch',
          );
        }
      },
    );
  }
}
