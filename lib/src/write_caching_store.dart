import 'dart:async';

import 'package:hive/hive.dart';
import 'package:meta/meta.dart';

import 'box_proxy.dart';
import 'conflict_resolution.dart';
import 'filter.dart';
import 'generic_box_event.dart';
import 'models/db_exception.dart';
import 'rest_api.dart';
import 'store.dart';
import 'store_entry.dart';
import 'transaction.dart';

typedef _UpdateFn<T> = FutureOr<StoreEntry<T>> Function(StoreEntry<T> entry);

enum EntryState {
  value,
  valueModified,
  deleted,
  deletedModified,
}

class CovariantArgumentError extends ArgumentError {
  CovariantArgumentError(
    dynamic value,
    Type type, [
    String name,
  ]) : super.value(value.runtimeType, name, 'Must be a $type');

  static void checkIs<T>(
    dynamic value, [
    String name,
  ]) {
    if (value is! T) {
      throw CovariantArgumentError(value, T, name);
    }
  }
}

abstract class WriteFireBoxBase<T>
    with BoxProxy<StoreEntry<T>, T>
    implements BoxBase<T> {
  final FirebaseStore<T> firebaseStore;

  @override
  BoxBase<StoreEntry<T>> get box;

  WriteFireBoxBase(this.firebaseStore);

  Future<void> download([Filter filter]) async {
    final eTagReceiver = ETagReceiver();
    final remoteKeys = await (filter != null
        ? firebaseStore.queryKeys(filter, eTagReceiver)
        : firebaseStore.keys(eTagReceiver));
    // TODO use eTag for quick updating
    final deletedKeys = keys.toSet().difference(remoteKeys.toSet());
    for (final key in deletedKeys) {
      final localEntry = await _getLocal(key);
      if (localEntry.modified) {
        await _resolve(
          key,
          local: localEntry,
          remote: const StoreEntry(value: null),
        );
      } else {
        await _storeLocal(key);
      }
    }
    for (final key in remoteKeys) {
      await _downloadEntry(key);
    }
  }

  Future<void> upload({bool multipass = true}) async {
    bool hasChanges;
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
        ? firebaseStore.streamQueryKeys(filter)
        : firebaseStore.streamKeys());
    return stream.listen(
      (key) => _handleRemoteEvent(key, filter),
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  // TODO add syncDownloadRenewed

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
      _WriteFireBoxTransaction(
        fireBox: this,
        key: key,
        entry: await _getLocal(key),
      );

  Future<String> create(T value) async {
    final eTagReceiver = ETagReceiver();
    final key = await firebaseStore.create(value, eTagReceiver);
    await box.put(
      key,
      StoreEntry(
        value: value,
        eTag: eTagReceiver.eTag,
      ),
    );
    return key;
  }

  Future<Iterable<String>> createAll(Iterable<T> values) =>
      Stream.fromIterable(values).asyncMap((value) => create(value)).toList();

  // BoxBase implementation

  @override
  Future<int> add(T value) {
    throw UnsupportedError('add');
  }

  @override
  Future<Iterable<int>> addAll(Iterable<T> values) {
    throw UnsupportedError('addAll');
  }

  @override
  Future<void> delete(covariant String key) async {
    _checkKeyIsString(key);
    await _update(
      key,
      (entry) => entry.copyWith(
        value: null,
        modified: true,
      ),
    );
  }

  @override
  Future<void> deleteAll(covariant Iterable<String> keys) async {
    CovariantArgumentError.checkIs<Iterable<String>>(keys, 'keys');
    await Stream.fromIterable(keys).asyncMap((key) => delete(key)).toList();
  }

  @override
  Future<void> deleteAt(int index) async {
    await _updateAt(
      index,
      (entry) => entry.copyWith(
        value: null,
        modified: true,
      ),
    );
  }

  @override
  Future<void> put(covariant String key, T value) async {
    _checkKeyIsString(key);
    await _update(
      key,
      (entry) => entry.copyWith(
        value: value,
        modified: true,
      ),
    );
  }

  @override
  Future<void> putAll(covariant Map<String, T> entries) async {
    CovariantArgumentError.checkIs<Map<String, T>>(entries, 'entries');
    await Stream.fromIterable(entries.entries)
        .asyncMap((e) => put(e.key, e.value))
        .toList();
  }

  @override
  Future<void> putAt(int index, T value) async {
    await _updateAt(
      index,
      (entry) => entry.copyWith(
        value: value,
        modified: true,
      ),
    );
  }

  @override
  Stream<GenericBoxEvent<String, T>> watch({covariant String key}) async* {
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
  FutureOr<ConflictResolution<T>> resolveConflict(
    String key,
    T local,
    T remote,
  ) =>
      const ConflictResolution.remote();

  void _checkKeyIsString(String key) =>
      CovariantArgumentError.checkIs<String>(key, 'key');

  Future<StoreEntry<T>> _getRemote(String key) async {
    final eTagReceiver = ETagReceiver();
    final value = await firebaseStore.read(key, eTagReceiver);
    return StoreEntry(
      value: value,
      eTag: eTagReceiver.eTag,
    );
  }

  Future<StoreEntry<T>> _update(String key, _UpdateFn<T> update) async {
    final updated = await update(await _getLocal(key));
    await _storeLocal(key, updated);
    return updated;
  }

  Future<StoreEntry<T>> _updateAt(int index, _UpdateFn<T> update) async {
    final updated = await update(await _getLocalAt(index));
    await _storeLocalAt(index, updated);
    return updated;
  }

  Future<void> _downloadEntry(String key) async {
    final remoteEntry = await _getRemote(key);
    final localEntry = await _getLocal(key);
    if (localEntry.eTag != remoteEntry.eTag) {
      if (localEntry.modified) {
        await _resolve(key, local: localEntry, remote: remoteEntry);
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
        storeValue = await firebaseStore.write(
          key,
          entry.value,
          eTag: entry.eTag,
          eTagReceiver: eTagReceiver,
        );
      } else {
        await firebaseStore.delete(
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
        await _resolve(key, local: entry, remote: remoteEntry);
        return false;
      } else {
        rethrow;
      }
    }
  }

  Future<void> _resolve(
    String key, {
    @required StoreEntry<T> local,
    @required StoreEntry<T> remote,
  }) async {
    final resolution = await resolveConflict(key, local.value, remote.value);
    final resolvedEntry = resolution.when(
      local: () => local.copyWith(
        eTag: remote.eTag,
        modified: true,
      ),
      remote: () => remote,
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
    if (!entry.modified && entry.value == null) {
      await box.delete(key);
    } else {
      await box.put(key, entry);
    }
  }

  Future<void> _storeLocalAt(
    int index, [
    StoreEntry<T> entry = const StoreEntry(value: null),
  ]) async {
    if (!entry.modified && entry.value == null) {
      await box.deleteAt(index);
    } else {
      await box.putAt(index, entry);
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

  FutureOr<StoreEntry<T>> _getLocalAt(int index);
}

class WriteFireBox<T> extends WriteFireBoxBase<T> implements Box<T> {
  @override
  final Box<StoreEntry<T>> box;

  WriteFireBox(FirebaseStore<T> firebaseStore, this.box) : super(firebaseStore);

  EntryState getState(String key) {
    final entry = box.get(
      key,
      defaultValue: const StoreEntry(value: null),
    );
    if (entry.modified) {
      return entry.value != null
          ? EntryState.valueModified
          : EntryState.deletedModified;
    } else {
      return entry.value != null ? EntryState.value : EntryState.deleted;
    }
  }

  EntryState getStateAt(int index) {
    final entry = box.getAt(index);
    if (entry.modified) {
      return entry.value != null
          ? EntryState.valueModified
          : EntryState.deletedModified;
    } else {
      return entry.value != null ? EntryState.value : EntryState.deleted;
    }
  }

  @override
  T get(covariant String key, {T defaultValue}) =>
      box.get(key)?.value ?? defaultValue;

  @override
  T getAt(int index) => box.getAt(index).value;

  @override
  Map<String, T> toMap() => box
      .toMap()
      .cast<String, StoreEntry<T>>()
      .map((key, value) => MapEntry(key, value?.value));

  @override
  Iterable<T> get values => box.values.map((e) => e.value);

  @override
  Iterable<T> valuesBetween({
    covariant String startKey,
    covariant String endKey,
  }) =>
      box
          .valuesBetween(
            startKey: startKey,
            endKey: endKey,
          )
          .map((e) => e.value);

  @override
  FutureOr<StoreEntry<T>> _getLocal(String key) => box.get(
        key,
        defaultValue: const StoreEntry(value: null),
      );

  @override
  FutureOr<StoreEntry<T>> _getLocalAt(int index) => box.getAt(index);
}

class LazyWriteFireBox<T> extends WriteFireBoxBase<T> implements LazyBox<T> {
  @override
  final LazyBox<StoreEntry<T>> box;

  LazyWriteFireBox(FirebaseStore<T> firebaseStore, this.box)
      : super(firebaseStore);

  @override
  Future<T> get(covariant String key, {T defaultValue}) async {
    final entry = await box.get(key);
    return entry?.value ?? defaultValue;
  }

  @override
  Future<T> getAt(int index) async {
    final entry = await box.getAt(index);
    return entry.value;
  }

  @override
  FutureOr<StoreEntry<T>> _getLocal(String key) =>
      box.get(key, defaultValue: const StoreEntry(value: null));

  @override
  FutureOr<StoreEntry<T>> _getLocalAt(int index) => box.getAt(index);
}

class _WriteFireBoxTransaction<T> implements FirebaseTransaction<T> {
  final WriteFireBoxBase<T> fireBox;
  final StoreEntry<T> entry;

  @override
  final String key;

  @override
  T get value => entry.value;

  @override
  String get eTag => entry.eTag;

  _WriteFireBoxTransaction({
    @required this.fireBox,
    @required this.key,
    @required this.entry,
  });

  @override
  Future<T> commitUpdate(T data) async {
    // TODO check not already commited
    final updated = await fireBox._update(
      key,
      (entry) {
        if (entry.eTag == eTag) {
          return entry.copyWith(
            value: value,
            modified: true,
          );
        } else {
          throw TransactionFailedException(oldETag: eTag, newETag: entry.eTag);
        }
      },
    );
    return updated.value;
  }

  @override
  Future<void> commitDelete() async {
    // TODO check not already commited
    await fireBox._update(
      key,
      (entry) {
        if (entry.eTag == eTag) {
          return entry.copyWith(
            value: null,
            modified: true,
          );
        } else {
          throw TransactionFailedException(oldETag: eTag, newETag: entry.eTag);
        }
      },
    );
  }
}
