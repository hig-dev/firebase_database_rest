// ignore_for_file: unawaited_futures
import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

import 'filter.dart';
import 'store.dart';

class OfflineException implements Exception {
  @override
  String toString() => 'The operation cannot be executed - device is offline';
}

abstract class ReadCachingStore<T> {
  final FirebaseStore<T> store;
  final Box<T> box;

  ReadCachingStore(this.store, this.box);

  Future<void> reload([Filter filter]);

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
    await box.delete(key);
  }

  Future<void> deleteFromDisk() => box.deleteFromDisk();

  T get(covariant String key, {T defaultValue}) =>
      box.get(key, defaultValue: defaultValue);

  @override
  T getAt(int index) {
    // TODO: implement getAt
    throw UnimplementedError();
  }

  @override
  // TODO: implement isEmpty
  bool get isEmpty => throw UnimplementedError();

  @override
  // TODO: implement isNotEmpty
  bool get isNotEmpty => throw UnimplementedError();

  @override
  // TODO: implement isOpen
  bool get isOpen => throw UnimplementedError();

  @override
  String keyAt(int index) {
    // TODO: implement keyAt
    throw UnimplementedError();
  }

  @override
  // TODO: implement keys
  Iterable get keys => throw UnimplementedError();

  @override
  // TODO: implement lazy
  bool get lazy => throw UnimplementedError();

  @override
  // TODO: implement length
  int get length => throw UnimplementedError();

  @override
  // TODO: implement name
  String get name => throw UnimplementedError();

  @override
  // TODO: implement path
  String get path => throw UnimplementedError();

  @override
  Future<void> put(covariant String key, T value) {
    // TODO: implement put
    throw UnimplementedError();
  }

  @override
  Future<void> putAll(covariant Map<String, T> entries) {
    // TODO: implement putAll
    throw UnimplementedError();
  }

  @override
  Future<void> putAt(int index, T value) {
    // TODO: implement putAt
    throw UnimplementedError();
  }

  @override
  Map<String, T> toMap() {
    // TODO: implement toMap
    throw UnimplementedError();
  }

  @override
  // TODO: implement values
  Iterable<T> get values => throw UnimplementedError();

  @override
  Iterable<T> valuesBetween({
    covariant String startKey,
    covariant String endKey,
  }) {
    // TODO: implement valuesBetween
    throw UnimplementedError();
  }

  @override
  Stream<BoxEvent> watch({covariant String key}) {
    // TODO: implement watch
    throw UnimplementedError();
  }

  @protected
  FutureOr<bool> isOnline() => true;

  Future _checkOnline() async {
    if (!await isOnline()) {
      throw OfflineException();
    }
  }
}
