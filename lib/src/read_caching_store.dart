// ignore_for_file: unawaited_futures
import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

import 'auto_renew_stream.dart';
import 'filter.dart';
import 'generic_box_event.dart';
import 'store.dart';
import 'store_event.dart';
import 'transaction.dart';

enum ReloadStrategy {
  clear,
  compareKey,
  compareValue,
}

class OfflineException implements Exception {
  @override
  String toString() => 'The operation cannot be executed - device is offline';
}

abstract class ReadCachingStoreBase<T> {
  final FirebaseStore<T> store;

  BoxBase<T> get box;

  bool get awaitBoxOperations;

  ReloadStrategy reloadStrategy = ReloadStrategy.compareKey;

  ReadCachingStoreBase(this.store);

  Future<void> reload([Filter filter]) async {
    await _checkOnline();
    final newValues =
        await (filter != null ? store.query(filter) : store.all());
    await _reset(newValues);
  }

  Future<T> fetch(String key) async {
    await _checkOnline();
    final value = await store.read(key);
    await _boxAwait(box.put(key, value));
    return value;
  }

  Future<T> patch(String key, Map<String, dynamic> updateFields) async {
    await _checkOnline();
    final value = await store.update(key, updateFields);
    await _boxAwait(box.put(key, value));
    return value;
  }

  Future<FirebaseTransaction<T>> transaction(String key) async {
    await _checkOnline();
    return _ReadStoreTransaction(
      this,
      await store.transaction(key),
    );
  }

  Future<StreamSubscription<void>> stream({
    Filter filter,
    Function onError,
    void Function() onDone,
    bool cancelOnError = false,
  }) async {
    final stream =
        await (filter != null ? store.streamQuery(filter) : store.streamAll());
    return stream.listen(
      _handleStreamEvent,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  StreamSubscription<void> streamRenewed({
    FutureOr<Filter> Function() onRenewFilter,
    bool clearCache = true,
    Function onError,
    void Function() onDone,
    bool cancelOnError = true,
  }) {
    if (clearCache) {
      box.clear();
    }
    return AutoRenewStream(() async {
      final filter = onRenewFilter != null ? (await onRenewFilter()) : null;
      return filter != null ? store.streamQuery(filter) : store.streamAll();
    }).listen(
      _handleStreamEvent,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  Future<String> add(T value) async {
    await _checkOnline();
    final key = await store.create(value);
    await _boxAwait(box.put(key, value));
    return key;
  }

  Future<int> clear() => box.clear();

  Future<void> close() => box.close();

  Future<void> compact() => box.compact();

  bool containsKey(String key) => box.containsKey(key);

  Future<void> delete(String key) async {
    await _checkOnline();
    await store.delete(key, silent: true);
    await _boxAwait(box.delete(key));
  }

  Future<void> deleteFromDisk() => box.deleteFromDisk();

  bool get isEmpty => box.isEmpty;

  bool get isNotEmpty => box.isNotEmpty;

  bool get isOpen => box.isOpen;

  Iterable<String> get keys => box.keys.cast<String>();

  bool get lazy => box.lazy;

  int get length => box.length;

  String get name => box.name;

  String get path => box.path;

  Future<void> put(String key, T value) async {
    await _checkOnline();
    final savedValue = await store.write(key, value);
    await _boxAwait(box.put(key, savedValue));
  }

  Stream<GenericBoxEvent<String, T>> watch({String key}) async* {
    await for (final event in box.watch(key: key)) {
      yield GenericBoxEvent(
        key: event.key as String,
        value: event.value as T,
        deleted: event.deleted,
      );
    }
  }

  @protected
  FutureOr<bool> isOnline() => true;

  Future _checkOnline() async {
    if (!await isOnline()) {
      throw OfflineException();
    }
  }

  Future<void> _boxAwait(Future<void> future) =>
      awaitBoxOperations ? future : Future<void>.value();

  Future<void> _reset(Map<String, T> data) async {
    switch (reloadStrategy) {
      case ReloadStrategy.clear:
        final fClear = box.clear();
        final fPut = box.putAll(data);
        await _boxAwait(Future.wait([fClear, fPut]));
        break;
      case ReloadStrategy.compareKey:
        final oldKeys = box.keys.toSet();
        final deletedKeys = oldKeys.difference(data.keys.toSet());
        await _boxAwait(Future.wait([
          box.putAll(data),
          box.deleteAll(deletedKeys),
        ]));
        break;
      case ReloadStrategy.compareValue:
        final oldKeys = box.keys.toSet();
        final deletedKeys = oldKeys.difference(data.keys.toSet());
        await _filterByValue(data);
        await _boxAwait(Future.wait([
          box.putAll(data),
          box.deleteAll(deletedKeys),
        ]));
        break;
    }
  }

  Future<void> _handleStreamEvent(StoreEvent<T> event) => event.when(
        reset: (data) => _reset(data),
        put: (key, value) => _boxAwait(box.put(key, value)),
        delete: (key) => _boxAwait(box.delete(key)),
        patch: (key, value) => _applyPatch(key, value),
      );

  FutureOr<Map<String, T>> _filterByValue(Map<String, T> data);

  Future<void> _applyPatch(String key, PatchSet<T> patchSet);
}

class ReadCachingStore<T> extends ReadCachingStoreBase<T> {
  @override
  final Box<T> box;

  @override
  bool awaitBoxOperations = false;

  ReadCachingStore(FirebaseStore<T> store, this.box) : super(store);

  T get(String key, {T defaultValue}) =>
      box.get(key, defaultValue: defaultValue);

  Map<String, T> toMap() => box.toMap().cast<String, T>();

  Iterable<T> get values => box.values;

  Iterable<T> valuesBetween({String startKey, String endKey}) =>
      box.valuesBetween(startKey: startKey, endKey: endKey);

  @override
  FutureOr<Map<String, T>> _filterByValue(Map<String, T> data) => data
    ..removeWhere(
      (key, value) => box.get(key) == value,
    );

  @override
  Future<void> _applyPatch(String key, PatchSet<T> patchSet) =>
      _boxAwait(box.put(
        key,
        patchSet.apply(box.get(key)),
      ));
}

class LazyReadCachingStore<T> extends ReadCachingStoreBase<T> {
  @override
  final LazyBox<T> box;

  @override
  bool get awaitBoxOperations => true;

  LazyReadCachingStore(FirebaseStore<T> store, this.box) : super(store);

  @override
  FutureOr<Map<String, T>> _filterByValue(Map<String, T> data) async {
    final values = <String, T>{};
    for (final entry in data.entries) {
      final currentValue = await box.get(entry.key);
      if (currentValue != entry.value) {
        values[entry.key] = entry.value;
      }
    }
    return values;
  }

  @override
  Future<void> _applyPatch(String key, PatchSet<T> patchSet) async {
    final currentValue = await box.get(key);
    return _boxAwait(box.put(
      key,
      patchSet.apply(currentValue),
    ));
  }
}

class _ReadStoreTransaction<T> implements FirebaseTransaction<T> {
  final ReadCachingStoreBase<T> store;
  final FirebaseTransaction<T> storeTransaction;

  _ReadStoreTransaction(this.store, this.storeTransaction);

  @override
  String get key => storeTransaction.key;

  @override
  T get value => storeTransaction.value;

  @override
  String get eTag => storeTransaction.eTag;

  @override
  Future<T> commitDelete() async {
    await store._checkOnline();
    await storeTransaction.commitDelete();
    await store._boxAwait(store.box.delete(key));
    return null;
  }

  @override
  Future<T> commitUpdate(T data) async {
    await store._checkOnline();
    final result = await storeTransaction.commitUpdate(data);
    await store._boxAwait(store.box.put(key, result));
    return result;
  }
}
