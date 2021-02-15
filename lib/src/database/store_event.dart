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
abstract class DataEvent<T> with _$DataEvent<T> {
  const factory DataEvent.clear() = _DataClear<T>;
  const factory DataEvent.value(T data) = _DataValue<T>;
  const factory DataEvent.invalidPath(String path) = _DataInvalidPath<T>;
}
