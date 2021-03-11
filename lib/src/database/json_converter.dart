// coverage:ignore-file

/// A small interface for classes that can be used as a json converter for [T]
abstract class JsonConverter<T> {
  const JsonConverter._();

  /// A virtual method that converts a [json] object to a data type.
  ///
  /// The [json] beeing passed to this method can never be `null`.
  T dataFromJson(dynamic json);

  /// A virtual method that converts a [data] type to a json object.
  ///
  /// The json beeing returned from this method **must never** be `null`.
  dynamic dataToJson(T data);

  /// A virtual method that applies a set of [updatedFields] on existing [data].
  ///
  /// This should return a copy of [data], with all fields that appear in
  /// [updatedFields] updated to the respective value. Any fields that do not
  /// appear in [updatedFields] should stay unchanged.
  T patchData(T data, Map<String, dynamic> updatedFields);
}
