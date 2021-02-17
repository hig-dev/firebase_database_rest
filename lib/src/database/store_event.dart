import 'package:freezed_annotation/freezed_annotation.dart';

part 'store_event.freezed.dart';

@immutable
abstract class PatchSet<T> {
  const PatchSet._();

  T apply(T value);
}

@freezed
abstract class StoreEvent<T> with _$StoreEvent<T> {
  const factory StoreEvent.reset(Map<String, T> data) = _StoreReset<T>;
  const factory StoreEvent.put(String key, T value) = _StorePut<T>;
  const factory StoreEvent.delete(String key) = _StoreDelete<T>;
  const factory StoreEvent.patch(String key, PatchSet<T> value) =
      _StorePatch<T>;
  const factory StoreEvent.invalidPath(String path) = _StoreInvalidPath<T>;
}

@freezed
abstract class KeyEvent with _$KeyEvent {
  const factory KeyEvent.reset(List<String> keys) = _KeyReset;
  const factory KeyEvent.update(String key) = _KeyUpdate;
  const factory KeyEvent.delete(String key) = _KeyDelete;
  const factory KeyEvent.invalidPath(String path) = _KeyInvalidPath;
}

@freezed
abstract class ValueEvent<T> with _$ValueEvent<T> {
  const factory ValueEvent.update(T data) = _ValueUpdate<T>;
  const factory ValueEvent.delete() = _ValueDelete<T>;
  const factory ValueEvent.invalidPath(String path) = _ValueInvalidPath<T>;
}
