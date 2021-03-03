// coverage:ignore-file
import 'package:freezed_annotation/freezed_annotation.dart';

import 'api_constants.dart';

part 'db_exception.freezed.dart';
part 'db_exception.g.dart';

/// A generic exception representing an error when accessing the realtime
/// database
///
/// This error is thrown everywhere in the library, where the realtime database
/// is beeing accessed. It wrapps the HTTP-Errors that can happen when using
/// the REST-API, including the HTTP-Status code.
@freezed
class DbException with _$DbException implements Exception {
  const DbException._();

  /// Default constructor
  ///
  /// Generates an exception from the HTTP [statusCode] and an [error] message
  // ignore: sort_unnamed_constructors_first
  const factory DbException({
    /// The HTTP status code returned by the request
    @Default(400) int statusCode,

    /// An optional error message, if the firebase servers provided one.
    String? error,
  }) = _Exception;

  /// Checks if this error is the virtual "event stream canceled" error event
  bool get isEventStreamCanceled =>
      statusCode == ApiConstants.eventStreamCanceled;

  /// @nodoc
  factory DbException.fromJson(Map<String, dynamic> json) =>
      _$DbExceptionFromJson(json);
}
