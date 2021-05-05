import 'package:meta/meta.dart';

import '../store.dart';

/// @nodoc
@internal
mixin MapTransform<T> {
  /// @nodoc
  @protected
  Map<String, T> mapTransform(
    dynamic data,
    DataFromJsonCallback<T> dataFromJson,
  ) {
    final transformedMap = <String, T>{};
    (data as Map<String, dynamic>?)?.forEach((key, dynamic value) {
      if (value != null) {
        transformedMap[key] = dataFromJson(value);
      }
    });
    return transformedMap;
  }
}
