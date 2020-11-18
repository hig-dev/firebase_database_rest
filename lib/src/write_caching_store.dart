import 'dart:async';

import 'package:hive/hive.dart';
import 'package:meta/meta.dart';

import 'filter.dart';
import 'read_caching_store.dart';
import 'store.dart';

class _StoreEntry<T> extends HiveObject {
  String eTag;
  T value;
}

class StoreEntryTypeAdapter<T> extends TypeAdapter<_StoreEntry<T>> {
  @override
  final int typeId;

  StoreEntryTypeAdapter({
    @required this.typeId,
  });

  @override
  _StoreEntry<T> read(BinaryReader reader) {
    return _StoreEntry()
      ..eTag = reader.readString()
      ..value = reader.read() as T;
  }

  @override
  void write(BinaryWriter writer, _StoreEntry<T> obj) {
    writer
      ..writeString(obj.eTag)
      ..write(obj.value, writeTypeId: true);
  }
}

abstract class WriteCachingStore<T> {
  static const _boxIndexKey = '__WriteCachingStore_index_key__';

  final FirebaseStore<T> store;
  final Box<_StoreEntry<T>> box;

  bool awaitBoxOperations = false;
  ReloadStrategy reloadStrategy = ReloadStrategy.compareValue;

  WriteCachingStore(this.store, this.box);

  Future<void> reload([Filter filter]) async {
    await _checkOnline();

    final eTagReceiver = ETagReceiver();
    final keys = await (filter != null
        ? store.queryKeys(filter, eTagReceiver)
        : store.keys(eTagReceiver));
    final currentETag = box.get(_boxIndexKey)?.eTag;
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

  Future<T> transaction(String key, TransactionCallback<T> transaction) async {
    await _checkOnline();
    final eTagReceiver = ETagReceiver();
    final value = await store.transaction(
      key,
      transaction,
      eTagReceiver: eTagReceiver,
    );
    await _boxAwait(box.put(
      key,
      _StoreEntry<T>()
        ..eTag = eTagReceiver.eTag
        ..value = value,
    ));
    return value;
  }

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

  Future<void> _boxAwait(
    Future<void> future, {
    String oldKeyTag,
    String newKeyTag,
  }) {
    Future<void> boxOp;
    if (oldKeyTag != null) {
      boxOp = () async {
        await future;
        final currentKeyTag = box.get(_boxIndexKey)?.eTag;
        if (currentKeyTag == oldKeyTag) {
          await box.put(_boxIndexKey, _StoreEntry()..eTag = newKeyTag);
        } else {
          await box.delete(_boxIndexKey);
        }
      }();
    } else {
      boxOp = () async {
        await future;
        await box.delete(_boxIndexKey);
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
        oldKeys.remove(_boxIndexKey);
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
        oldKeys.remove(_boxIndexKey);
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
