// ignore_for_file: unawaited_futures
import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

import 'auto_renew_stream.dart';
import 'box_forwarding.dart';
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

class ReadOnlyBoxError extends UnsupportedError {
  ReadOnlyBoxError(String method)
      : super('"$method" cannot be called on a read-only box');
}

abstract class ReadFireBoxBase<T> extends BoxBaseProxy<T>
    with BoxForward<T>
    implements BoxBase<T> {
  final FirebaseStore<T> firebaseStore;

  ReadFireBoxBase(this.firebaseStore);

  @override
  BoxBase<T> get box;

  bool get awaitBoxOperations;

  ReloadStrategy reloadStrategy = ReloadStrategy.compareKey;

  @protected
  FutureOr<bool> isOnline() => true;

  Future<void> reload([Filter filter]) async {
    final newValues = await (filter != null
        ? firebaseStore.query(filter)
        : firebaseStore.all());
    await _reset(newValues);
  }

  Future<T> fetch(String key) async {
    final value = await firebaseStore.read(key);
    await _boxAwait(box.put(key, value));
    return value;
  }

  Future<String> create(T value) async {
    final key = await firebaseStore.create(value);
    await _boxAwait(box.put(key, value));
    return key;
  }

  Future<void> store(String key, T value) async {
    final savedValue = await firebaseStore.write(key, value);
    await _boxAwait(box.put(key, savedValue));
  }

  Future<T> patch(String key, Map<String, dynamic> updateFields) async {
    final value = await firebaseStore.update(key, updateFields);
    await _boxAwait(box.put(key, value));
    return value;
  }

  Future<void> remove(String key) async {
    await firebaseStore.delete(key, silent: true);
    await _boxAwait(box.delete(key));
  }

  Future<FirebaseTransaction<T>> transaction(String key) async =>
      _ReadFireBoxTransaction(
        this,
        await firebaseStore.transaction(key),
      );

  Future<StreamSubscription<void>> stream({
    Filter filter,
    Function onError,
    void Function() onDone,
    bool cancelOnError = false,
  }) async {
    final stream = await (filter != null
        ? firebaseStore.streamQuery(filter)
        : firebaseStore.streamAll());
    return stream.listen(
      _handleStreamEvent,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  StreamSubscription<void> streamRenewed({
    FutureOr<Filter> Function() onRenewFilter,
    Function onError,
    void Function() onDone,
    bool cancelOnError = true,
  }) =>
      AutoRenewStream(() async {
        final filter = onRenewFilter != null ? (await onRenewFilter()) : null;
        return filter != null
            ? firebaseStore.streamQuery(filter)
            : firebaseStore.streamAll();
      }).listen(
        _handleStreamEvent,
        onError: onError,
        onDone: onDone,
        cancelOnError: cancelOnError,
      );

  // BoxBase implementation
  @override
  Future<int> add(T value) {
    throw ReadOnlyBoxError('add');
  }

  @override
  Future<Iterable<int>> addAll(Iterable<T> values) {
    throw ReadOnlyBoxError('addAll');
  }

  @override
  Future<void> delete(covariant String key) {
    throw ReadOnlyBoxError('delete');
  }

  @override
  Future<void> deleteAll(Iterable keys) {
    throw ReadOnlyBoxError('deleteAll');
  }

  @override
  Future<void> deleteAt(int index) {
    throw ReadOnlyBoxError('deleteAt');
  }

  @override
  Future<void> put(covariant String key, T value) {
    throw ReadOnlyBoxError('put');
  }

  @override
  Future<void> putAll(covariant Map<String, T> entries) {
    throw ReadOnlyBoxError('putAll');
  }

  @override
  Future<void> putAt(int index, T value) {
    throw ReadOnlyBoxError('putAt');
  }

  @override
  Stream<GenericBoxEvent<String, T>> watch({covariant String key}) async* {
    await for (final event in box.watch(key: key)) {
      yield GenericBoxEvent(
        key: event.key as String,
        value: event.value as T,
        deleted: event.deleted,
      );
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

class ReadFireBox<T> extends ReadFireBoxBase<T> implements Box<T> {
  @override
  final Box<T> box;

  @override
  bool awaitBoxOperations = false;

  ReadFireBox({
    @required FirebaseStore<T> firebaseStore,
    @required this.box,
  }) : super(firebaseStore);

  @override
  T get(covariant String key, {T defaultValue}) =>
      box.get(key, defaultValue: defaultValue);

  @override
  T getAt(int index) => box.getAt(index);

  @override
  Map<String, T> toMap() => box.toMap().cast<String, T>();

  @override
  Iterable<T> get values => box.values;

  @override
  Iterable<T> valuesBetween({
    covariant String startKey,
    covariant String endKey,
  }) =>
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

class LazyReadFireBoxBase<T> extends ReadFireBoxBase<T> implements LazyBox<T> {
  @override
  final LazyBox<T> box;

  @override
  bool get awaitBoxOperations => true;

  LazyReadFireBoxBase({
    @required FirebaseStore<T> firebaseStore,
    @required this.box,
  }) : super(firebaseStore);

  @override
  Future<T> get(covariant String key, {T defaultValue}) => box.get(
        key,
        defaultValue: defaultValue,
      );

  @override
  Future<T> getAt(int index) => box.getAt(index);

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

class _ReadFireBoxTransaction<T> implements FirebaseTransaction<T> {
  final ReadFireBoxBase<T> fireBox;
  final FirebaseTransaction<T> storeTransaction;

  _ReadFireBoxTransaction(this.fireBox, this.storeTransaction);

  @override
  String get key => storeTransaction.key;

  @override
  T get value => storeTransaction.value;

  @override
  String get eTag => storeTransaction.eTag;

  @override
  Future<T> commitDelete() async {
    await storeTransaction.commitDelete();
    await fireBox._boxAwait(fireBox.box.delete(key));
    return null;
  }

  @override
  Future<T> commitUpdate(T data) async {
    final result = await storeTransaction.commitUpdate(data);
    await fireBox._boxAwait(fireBox.box.put(key, result));
    return result;
  }
}
