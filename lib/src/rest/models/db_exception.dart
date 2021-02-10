import 'package:freezed_annotation/freezed_annotation.dart';

import '../api_constants.dart';

part 'db_exception.freezed.dart';
part 'db_exception.g.dart';

@freezed
abstract class DbException with _$DbException implements Exception {
  const DbException._();

  // ignore: sort_unnamed_constructors_first
  const factory DbException({
    @Default(400) int statusCode,
    String? error,
  }) = _Exception;

  bool get isEventStreamCanceled =>
      statusCode == ApiConstants.eventStreamCanceled;

  factory DbException.fromJson(Map<String, dynamic> json) =>
      _$DbExceptionFromJson(json);
}
