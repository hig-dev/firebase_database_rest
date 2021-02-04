import 'package:freezed_annotation/freezed_annotation.dart';

part 'db_exception.freezed.dart';
part 'db_exception.g.dart';

@freezed
abstract class DbException with _$DbException implements Exception {
  const factory DbException({
    @Default(400) int statusCode,
    String? error,
  }) = _Exception;

  factory DbException.fromJson(Map<String, dynamic> json) =>
      _$DbExceptionFromJson(json);
}
