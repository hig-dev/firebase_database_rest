import 'package:meta/meta.dart';

@internal
mixin MapTransform<T> {
  @protected
  Map<String, T> mapTransform(
    dynamic data,
    T? Function(dynamic) dataFromJson,
  ) =>
      Map.fromEntries(
        (data as Map<String, dynamic>?)
                ?.entries
                .map(
                  (entry) => MapEntry(
                    entry.key,
                    dataFromJson(entry.value),
                  ),
                )
                .where((entry) => entry.value != null)
                .cast() ??
            const {},
      );
}
