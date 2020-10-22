import 'package:freezed_annotation/freezed_annotation.dart';

part 'db_error.freezed.dart';
part 'db_error.g.dart';

@freezed
abstract class DbError with _$DbError {
  const factory DbError({
    String error,
  }) = _DbError;

  factory DbError.fromJson(Map<String, dynamic> json) =>
      _$DbErrorFromJson(json);
}
