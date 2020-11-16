// ignore_for_file: unawaited_futures
import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

import 'filter.dart';
import 'store.dart';

enum ReloadStrategy {
  clear,
  compareKey,
  compareValue,
}

class OfflineException implements Exception {
  @override
  String toString() => 'The operation cannot be executed - device is offline';
}

abstract class ReadCachingStore<T> {
  final FirebaseStore<T> store;
  final Box<T> box;

  bool awaitBoxOperations = false;
  ReloadStrategy reloadStrategy = ReloadStrategy.compareKey;

  ReadCachingStore(this.store, this.box);

  Future<void> reload([Filter filter]) async {
    await _checkOnline();
    final newValues =
        await (filter != null ? store.query(filter) : store.all());
    switch (reloadStrategy) {
      case ReloadStrategy.clear:
        await box.clear();
        await box.putAll(newValues);
        break;
      case ReloadStrategy.compareKey:
        final oldKeys = box.keys.toSet();
        final deletedKeys = oldKeys.difference(newValues.keys.toSet());
        await Future.wait([
          box.putAll(newValues),
          box.deleteAll(deletedKeys),
        ]);
        break;
      case ReloadStrategy.compareValue:
        final oldKeys = box.keys.toSet();
        final deletedKeys = oldKeys.difference(newValues.keys.toSet());
        newValues.removeWhere(
          (key, value) => box.get(key) == value,
        );
        await Future.wait([
          box.putAll(newValues),
          box.deleteAll(deletedKeys),
        ]);
        break;
    }
  }

  Future<T> fetch(String key) async {
    await _checkOnline();
    final value = await store.read(key);
    await _boxAwait(box.put(key, value));
    return value;
  }

  Future<String> add(T value) async {
    await _checkOnline();
    final key = await store.create(value);
    await box.put(key, value);
    return key;
  }

  Future<int> clear() => box.clear();

  Future<void> close() => box.close();

  Future<void> compact() => box.close();

  bool containsKey(covariant String key) => box.containsKey(key);

  Future<void> delete(covariant String key) async {
    await _checkOnline();
    await store.delete(key, silent: true);
    await _boxAwait(box.delete(key));
  }

  Future<void> deleteFromDisk() => box.deleteFromDisk();

  T get(covariant String key, {T defaultValue}) =>
      box.get(key, defaultValue: defaultValue);

  bool get isEmpty => box.isEmpty;

  bool get isNotEmpty => box.isNotEmpty;

  bool get isOpen => box.isOpen;

  Iterable<String> get keys => box.keys.cast<String>();

  bool get lazy => box.lazy; // TODO enable or remove

  int get length => box.length;

  String get name => box.name;

  String get path => box.path;

  Future<void> put(covariant String key, T value) async {
    await _checkOnline();
    final savedValue = await store.write(key, value);
    await _boxAwait(box.put(key, savedValue));
  }

  Map<String, T> toMap() => box.toMap().cast<String, T>();

  Iterable<T> get values => box.values;

  Iterable<T> valuesBetween({
    covariant String startKey,
    covariant String endKey,
  }) =>
      box.valuesBetween(startKey: startKey, endKey: endKey);

  Stream<BoxEvent> watch({covariant String key}) => box.watch(key: key);

  @protected
  FutureOr<bool> isOnline() => true;

  Future _checkOnline() async {
    if (!await isOnline()) {
      throw OfflineException();
    }
  }

  Future<void> _boxAwait(Future<void> future) =>
      awaitBoxOperations ? future : Future<void>.value();
}
