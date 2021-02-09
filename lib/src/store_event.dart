import 'package:freezed_annotation/freezed_annotation.dart';

part 'store_event.freezed.dart';

abstract class PatchSet<T> {
  const PatchSet._();

  T apply(T value);
}

@freezed
abstract class StoreEvent<T> with _$StoreEvent<T> {
  const factory StoreEvent.reset(Map<String, T> data) = _StoreReset;
  const factory StoreEvent.put(String key, T value) = _StorePut;
  const factory StoreEvent.delete(String key) = _StoreDelete;
  const factory StoreEvent.patch(String key, PatchSet<T> value) = _StorePatch;

  const factory StoreEvent.invalid(String message) = _StoreInvalid;
}

@freezed
abstract class DataEvent<T> with _$DataEvent<T> {
  const factory DataEvent.clear() = _DataClear;
  const factory DataEvent.value(T data) = _DataValue;
  const factory DataEvent.invalid(String message) = _DataInvalid;
}
