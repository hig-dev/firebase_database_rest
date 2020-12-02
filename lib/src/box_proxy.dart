import 'package:hive/hive.dart';

mixin BoxProxy<TBase, TImpl> implements BoxBase<TImpl> {
  BoxBase<TBase> get box;

  @override
  Future<int> clear() => box.clear();

  @override
  Future<void> close() => box.close();

  @override
  Future<void> compact() => box.compact();

  @override
  bool containsKey(covariant String key) => box.containsKey(key);

  @override
  Future<void> deleteFromDisk() => box.deleteFromDisk();

  @override
  bool get isEmpty => box.isEmpty;

  @override
  bool get isNotEmpty => box.isNotEmpty;

  @override
  bool get isOpen => box.isOpen;

  @override
  String keyAt(int index) => box.keyAt(index) as String;

  @override
  Iterable<String> get keys => box.keys.cast();

  @override
  bool get lazy => box.lazy;

  @override
  int get length => box.length;

  @override
  String get name => box.name;

  @override
  String get path => box.path;
}
