import 'package:freezed_annotation/freezed_annotation.dart';

part 'store_event.freezed.dart';

abstract class PatchSet<T> {
  const PatchSet._();

  T apply(T value);
}

@freezed
abstract class StoreEvent<T> with _$StoreEvent<T> {
  const factory StoreEvent.reset(Map<String, T> data) = _Reset;
  const factory StoreEvent.put(String key, T value) = _Put;
  const factory StoreEvent.delete(String key) = _Delete;
  const factory StoreEvent.patch(String key, PatchSet<T> value) = _Patch;
}
