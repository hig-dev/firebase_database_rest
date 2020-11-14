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

abstract class ReadCachingStore<T> implements Box<T> {
  final FirebaseStore<T> store;
  final Box<T> box;

  ReadCachingStore(this.store, this.box);

  Future<void> reload([Filter filter]);

  @override
  Future<int> add(T value) async {
    if (!await isOnline()) {
      throw OfflineException();
    }
    final key = await store.create(value);
    box.put(key, value);
    return key;
  }

  @override
  Future<Iterable<int>> addAll(Iterable<T> values) {
    // TODO: implement addAll
    throw UnimplementedError();
  }

  @override
  Future<int> clear() {
    // TODO: implement clear
    throw UnimplementedError();
  }

  @override
  Future<void> close() {
    // TODO: implement close
    throw UnimplementedError();
  }

  @override
  Future<void> compact() {
    // TODO: implement compact
    throw UnimplementedError();
  }

  @override
  bool containsKey(covariant String key) {
    // TODO: implement containsKey
    throw UnimplementedError();
  }

  @override
  Future<void> delete(covariant String key) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<void> deleteAll(Iterable keys) {
    // TODO: implement deleteAll
    throw UnimplementedError();
  }

  @override
  Future<void> deleteAt(int index) {
    // TODO: implement deleteAt
    throw UnimplementedError();
  }

  @override
  Future<void> deleteFromDisk() {
    // TODO: implement deleteFromDisk
    throw UnimplementedError();
  }

  @override
  T get(covariant String key, {T defaultValue}) {
    // TODO: implement get
    throw UnimplementedError();
  }

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
  FutureOr<bool> isOnline();
}
