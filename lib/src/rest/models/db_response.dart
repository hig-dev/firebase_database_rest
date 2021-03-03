// coverage:ignore-file
import 'package:freezed_annotation/freezed_annotation.dart';

part 'db_response.freezed.dart';

/// A generic reponse for database methods
@freezed
class DbResponse with _$DbResponse {
  /// Default constructor
  const factory DbResponse({
    /// The data that was returned by the server.
    required dynamic data,

    /// An optional ETag of the data, if it was requested.
    String? eTag,
  }) = _DbResponse;
}
