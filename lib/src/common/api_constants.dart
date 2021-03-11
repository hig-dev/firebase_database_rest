/// Formats the data returned in the response from the server.
enum PrintMode {
  /// View the data in a human-readable format.
  pretty,

  ///  Used to suppress the output from the server when writing data. The
  /// resulting response will be empty and indicated by a 204 No Content HTTP
  /// status code.
  silent,
}

/// Extension on [PrintMode] to get the server expected string
extension PrintModeX on PrintMode {
  /// Returns the value of the given element
  String get value => toString().split('.').last;
}

/// Specifies how the server should format the reponse
enum FormatMode {
  /// Include priority information in the response.
  export,
}

/// Extension on [FormatMode] to get the server expected string
extension FormatModeX on FormatMode {
  /// Returns the value of the given element
  String get value => toString().split('.').last;
}

/// Realtime Database estimates the size of each write request and aborts
/// requests that will take longer than the target time.
enum WriteSizeLimit {
  /// target=1s
  tiny,

  /// target=10s
  small,

  /// target=30s
  medium,

  /// target=60s
  large,

  /// Exceptionally large writes (with up to 256MB payload) are allowed
  unlimited,
}

/// Extension on [WriteSizeLimit] to get the server expected string
extension WriteSizeLimitX on WriteSizeLimit {
  /// Returns the value of the given element
  String get value => toString().split('.').last;
}

/// Various constants, relevant for the Realtime database API
abstract class ApiConstants {
  const ApiConstants._(); // coverage:ignore-line

  /// The time since UNIX epoch, in milliseconds.
  static const serverTimeStamp = <String, dynamic>{'.sv': 'timestamp'};

  /// 412 Precondition Failed
  ///
  /// The request's specified ETag value in the if-match header did not match
  /// the server's value.
  static const statusCodeETagMismatch = 412;

  /// ETag that indicates a null value at the server.
  static const nullETag = 'null_etag';

  /// Internal error code, used for remotely canceled server streams.
  static const eventStreamCanceled = 542;
}
