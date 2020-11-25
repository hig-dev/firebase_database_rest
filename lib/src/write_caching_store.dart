import 'dart:async';

import 'package:hive/hive.dart';
import 'package:meta/meta.dart';

import 'conflict_resolution.dart';
import 'filter.dart';
import 'models/db_exception.dart';
import 'read_caching_store.dart' show ReloadStrategy;
import 'rest_api.dart';
import 'store.dart';
import 'store_entry.dart';
import 'transaction.dart';

enum SyncDirection {
  uploadOnly,
  downloadOnly,
  fullSync,
}

typedef _UpdateFn<T> = FutureOr<StoreEntry<T>> Function(StoreEntry<T> entry);

abstract class WriteCachingStoreBase<T> {
  final FirebaseStore<T> store;
  BoxBase<StoreEntry<T>> get box;

  bool keepDeletedEntries = false;
  bool awaitBoxOperations = false;
  ReloadStrategy reloadStrategy = ReloadStrategy.compareValue;

  WriteCachingStoreBase(this.store);

  Future<void> synchronize({
    SyncDirection syncDirection = SyncDirection.fullSync,
    Filter filter,
    bool clearDeleted = true,
  }) async {
    final localStream = box.watch();
    final remoteStream = await (filter != null
        ? store.streamQueryKeys(filter)
        : store.streamKeys());
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
    await _boxAwait(box.put(
      key,
      StoreEntry(
        value: value,
        eTag: eTagReceiver.eTag,
      ),
    ));
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

  // TODO use generic event
  Stream<BoxEvent> watch({String key}) => box.watch(key: key);

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
      // throw OfflineException();
    }
  }

  Future<void> _boxAwait(Future<void> future) =>
      awaitBoxOperations ? future : Future<void>.value();

  Future<StoreEntry<T>> _getRemote(String key) async {
    final eTagReceiver = ETagReceiver();
    final value = await store.read(key, eTagReceiver);
    return StoreEntry(
      value: value,
      eTag: eTagReceiver.eTag,
    );
  }

  Future<void> _handleLocalEvent(BoxEvent event) async {
    if (event.deleted || event.value == null) {
      return;
    }

    final key = event.key as String;
    final entry = event.value as StoreEntry<T>;
    if (!entry.modified) {
      return;
    }

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
      await box.put(
        key,
        entry.copyWith(
          value: storeValue,
          eTag: eTagReceiver.eTag,
          modified: false,
        ),
      );
    } on DbException catch (e) {
      if (e.statusCode == RestApi.statusCodeETagMismatch) {
        final remoteEntry = await _getRemote(key);
        await _resolve(key, entry, remoteEntry);
      } else {
        rethrow;
      }
    }
  }

  Future<void> _handleRemoteEvent(String key) async {
    if (key == null) {
      // TODO
    } else {
      final remoteEntry = await _getRemote(key);
      final localEntry = await _getLocal(key);
      if (localEntry.eTag != remoteEntry.eTag) {
        if (localEntry.modified) {
          await _resolve(key, localEntry, remoteEntry);
        } else {
          await box.put(key, remoteEntry);
        }
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
    await box.put(key, resolvedEntry);
  }

  FutureOr<StoreEntry<T>> _getLocal(String key);

  Future<StoreEntry<T>> _update(String key, _UpdateFn<T> update);
}

class WriteCachingStore<T> extends WriteCachingStoreBase<T> {
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
