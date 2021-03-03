import 'package:freezed_annotation/freezed_annotation.dart';

import '../store.dart';
import '../store_event.dart';

part 'store_patchset.freezed.dart';

/// @nodoc
@internal
@freezed
class StorePatchSet<T> with _$StorePatchSet<T> implements PatchSet<T> {
  const StorePatchSet._();

  /// @nodoc
  // ignore: sort_unnamed_constructors_first
  const factory StorePatchSet({
    required FirebaseStore<T> store,
    required Map<String, dynamic> data,
  }) = _StorePatchSet<T>;

  @override
  // ignore: invalid_use_of_protected_member
  T apply(T value) => store.patchData(value, data);
}
