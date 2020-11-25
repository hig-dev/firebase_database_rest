import 'dart:async';

import 'package:hive/hive.dart';
import 'package:meta/meta.dart';

import 'conflict_resolution.dart';
import 'filter.dart';
import 'models/db_exception.dart';
import 'read_caching_store.dart';
import 'rest_api.dart';
import 'store.dart';
import 'transaction.dart';

class _StoreEntry<T> extends HiveObject {
  T value;
  String eTag;
  bool modified;

  @override
  String get key => super.key as String;
}

class StoreEntryTypeAdapter<T> extends TypeAdapter<_StoreEntry<T>> {
  @override
  final int typeId;

  StoreEntryTypeAdapter({
    @required this.typeId,
  });

  @override
  _StoreEntry<T> read(BinaryReader reader) => _StoreEntry()
    ..value = reader.read() as T
    ..eTag = reader.readString()
    ..modified = reader.readBool();

  @override
  void write(BinaryWriter writer, _StoreEntry<T> obj) {
    writer
      ..write(obj.value, writeTypeId: true)
      ..writeString(obj.eTag)
      ..writeBool(obj.modified);
  }
}

class _WriteStoreTransaction<T> implements FirebaseTransaction<T> {
  final WriteCachingStoreBase<T> store;
  final _StoreEntry<T> entry;

  @override
  String get key => entry.key as String;

  @override
  T get value => entry.value;

  @override
  String get eTag => entry.eTag;

  const _WriteStoreTransaction(
    this.store,
    this.entry,
  );

  @override
  Future<T> commitUpdate(T data) async {
    final eTagReceiver = ETagReceiver();
    final result = await store.store.write(
      key,
      data,
      eTag: eTag,
      eTagReceiver: eTagReceiver,
    );
    entry
      ..eTag = eTagReceiver.eTag
      ..modified = false
      ..value = result;
    await store._boxAwait(entry.save());
    return result;
  }

  @override
  Future<void> commitDelete() async {
    if (store.keepDeletedEntries) {
      final eTagReceiver = ETagReceiver();
      await store.store.delete(
        key,
        eTag: eTag,
        eTagReceiver: eTagReceiver,
        silent: true,
      );
      entry
        ..eTag = eTagReceiver.eTag
        ..modified = false
        ..value = null;
      await store._boxAwait(entry.save());
    } else {
      await store.store.delete(
        key,
        eTag: eTag,
        silent: true,
      );
      await store._boxAwait(entry.delete());
    }
  }

  Future<void> commitSelf() {
    assert(entry.modified);
    if (entry.value != null) {
      return commitUpdate(entry.value);
    } else {
      return commitDelete();
    }
  }
}

abstract class WriteCachingStoreBase<T> {
  final FirebaseStore<T> store;
  BoxBase<_StoreEntry<T>> get box;

  bool keepDeletedEntries = false;
  bool awaitBoxOperations = false;
  ReloadStrategy reloadStrategy = ReloadStrategy.compareValue;

  WriteCachingStoreBase(this.store);

  Future<void> upload() async {
    for (final key in box.keys.cast<String>()) {
      final entry = await _getLocal(key);
      if (!entry.modified) {
        continue;
      }

      try {
        await _update(entry);
      } on DbException catch (e) {
        if (e.statusCode == RestApi.statusCodeETagMismatch) {
          final transact = await transaction(key);
          final resolved = await resolveConflict(entry.value, transact.value);
          await resolved.when(
            local: () => transact.commitUpdate(entry.value),
            remote: () {
              // TODO check later
              entry
                ..eTag = transact.eTag
                ..modified = false
                ..value = transact.value;
              return _boxAwait(entry.save());
            },
            delete: () => transact.commitDelete(),
            update: (data) => transact.commitUpdate(data),
          );
          // TODO handle exception again
        } else {
          rethrow;
        }
      }
    }
  }

  Future<void> download();
  Future<void> sync();

  @protected
  FutureOr<ConflictResolution<T>> resolveConflict(
    String key,
    T local,
    T remote,
  ) =>
      const ConflictResolution.remote();

  FutureOr<_StoreEntry<T>> _getLocal(String key);

  Future<_StoreEntry<T>> _getRemote(String key) async {
    final eTagReceiver = ETagReceiver();
    final value = await store.read(key, eTagReceiver);
    return _StoreEntry<T>()
      ..modified = false
      ..eTag = eTagReceiver.eTag
      ..value = value;
  }

  Future<void> _syncEntry(_StoreEntry<T> local, _StoreEntry<T> remote) async {
    assert(remote.key == null || local.key == null || remote.key == local.key);
    final key = local.key ?? remote.key;
    assert(key != null);

    if (local.eTag == remote.eTag) {
      return;
    }

    final resolved = await resolveConflict(
      local.key,
      local.value,
      remote.value,
    );
    await resolved.when(
      local: () async {
        if (local.value != null) {
          return _update(local);
        } else {
          return _delete(key);
        }
      },
      remote: () {
        // TODO
      },
      delete: () => _delete(key),
      update: (data) {
        if (local.value != null) {
          return _update(local..value = data);
        } else {
          return _delete(key);
        }
      },
    );
  }

  Future<void> _update(_StoreEntry<T> entry) async {
    assert(entry.key != null);
    final eTagReceiver = ETagReceiver();
    final result = await store.write(
      entry.key,
      entry.value,
      eTag: entry.eTag,
      eTagReceiver: eTagReceiver,
    );
    entry
      ..eTag = eTagReceiver.eTag
      ..modified = false
      ..value = result;
    await _boxAwait(entry.save());
    return result;
  }

  Future<void> _delete(String key);

  // spacer

  Future<void> reload([Filter filter]) async {
    await _checkOnline();

    final eTagReceiver = ETagReceiver();
    final keys = await (filter != null
        ? store.queryKeys(filter, eTagReceiver)
        : store.keys(eTagReceiver));
    final currentETag = box.get(_listKey)?.eTag;
    if (eTagReceiver.eTag == currentETag) {
      return;
    }

    final entries = await Stream.fromIterable(keys).asyncMap((key) async {
      final eTagReceiver = ETagReceiver();
      final value = await store.read(key, eTagReceiver);
      return MapEntry(
        key,
        _StoreEntry<T>()
          ..eTag = eTagReceiver.eTag
          ..value = value,
      );
    }).toList();
    await _reset(
      Map.fromEntries(entries),
      currentETag,
      eTagReceiver.eTag,
    );
  }

  Future<T> fetch(String key) async {
    await _checkOnline();
    final eTagReceiver = ETagReceiver();
    final value = await store.read(key, eTagReceiver);
    await _boxAwait(box.put(
      key,
      _StoreEntry()
        ..eTag = eTagReceiver.eTag
        ..value = value,
    ));
    return value;
  }

  // Future<T> transaction(String key, TransactionCallback<T> transaction) async {
  //   await _checkOnline();
  //   final eTagReceiver = ETagReceiver();
  //   final value = await store.transaction(
  //     key,
  //     transaction,
  //     eTagReceiver: eTagReceiver,
  //   );
  //   await _boxAwait(box.put(
  //     key,
  //     _StoreEntry<T>()
  //       ..eTag = eTagReceiver.eTag
  //       ..value = value,
  //   ));
  //   return value;
  // }

  Future<StreamSubscription<void>> stream({
    Filter filter,
    Function onError,
    void Function() onDone,
    bool cancelOnError = true,
  }) async {
    final stream = await (filter != null
        ? store.streamQueryKeys(filter)
        : store.streamKeys());
    return stream.listen(
      _handleStreamEvent,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  @protected
  FutureOr<bool> isOnline();

  Future _checkOnline() async {
    if (!await isOnline()) {
      throw OfflineException();
    }
  }

  String _boxKey(String key, {bool isMeta = false}) =>
      isMeta ? '_meta_$key' : '_entry_$key';

  String get _listKey => _boxKey('list', isMeta: true);

  Future<void> _boxAwait(
    Future<void> future, {
    String oldKeyTag,
    String newKeyTag,
  }) {
    Future<void> boxOp;
    if (oldKeyTag != null) {
      boxOp = () async {
        await future;
        final currentKeyTag = box.get(_listKey)?.eTag;
        if (currentKeyTag == oldKeyTag) {
          await box.put(_listKey, _StoreEntry()..eTag = newKeyTag);
        } else {
          await box.delete(_listKey);
        }
      }();
    } else {
      boxOp = () async {
        await future;
        await box.delete(_listKey);
      }();
    }
    return awaitBoxOperations ? boxOp : Future<void>.value();
  }

  Future<void> _reset(
    Map<String, _StoreEntry<T>> data,
    String oldkeyTag,
    String newkeyTag,
  ) async {
    switch (reloadStrategy) {
      case ReloadStrategy.clear:
        final fClear = box.clear();
        final fPut = box.putAll(data);
        await _boxAwait(
          Future.wait([fClear, fPut]),
          oldKeyTag: oldkeyTag,
          newKeyTag: newkeyTag,
        );
        break;
      case ReloadStrategy.compareKey:
        final oldKeys = box.keys.toSet();
        oldKeys.remove(_listKey);
        final deletedKeys = oldKeys.difference(data.keys.toSet());
        await _boxAwait(
          Future.wait([
            box.putAll(data),
            box.deleteAll(deletedKeys),
          ]),
          oldKeyTag: oldkeyTag,
          newKeyTag: newkeyTag,
        );
        break;
      case ReloadStrategy.compareValue:
        final oldKeys = box.keys.toSet();
        oldKeys.remove(_listKey);
        final deletedKeys = oldKeys.difference(data.keys.toSet());
        data.removeWhere(
          (key, value) => box.get(key).eTag == value.eTag,
        );
        await _boxAwait(
          Future.wait([
            box.putAll(data),
            box.deleteAll(deletedKeys),
          ]),
          oldKeyTag: oldkeyTag,
          newKeyTag: newkeyTag,
        );
        break;
    }
  }

  Future<void> _handleStreamEvent(String key, [Filter filter]) async {
    if (key == null) {
      await reload();
    }
    final eTagReceiver = ETagReceiver();
    final value = await store.read(key, eTagReceiver);
    await _boxAwait(box.put(
      key,
      _StoreEntry<T>()
        ..eTag = eTagReceiver.eTag
        ..value = value,
    ));
  }
}
