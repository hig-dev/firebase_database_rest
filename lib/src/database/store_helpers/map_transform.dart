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
  ) =>
      Map.fromEntries(
        (data as Map<String, dynamic>?)
                ?.entries
                .where((entry) => entry.value != null)
                .map(
                  (entry) => MapEntry(
                    entry.key,
                    dataFromJson(entry.value),
                  ),
                )
                .cast() ??
            const {},
      );
}
