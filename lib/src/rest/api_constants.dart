enum PrintMode {
  pretty,
  silent,
}

extension PrintModeX on PrintMode {
  String get value => toString().split('.').last;
}

enum FormatMode {
  export,
}

extension FormatModeX on FormatMode {
  String get value => toString().split('.').last;
}

enum WriteSizeLimit {
  tiny,
  small,
  medium,
  large,
  unlimited,
}

extension WriteSizeLimitX on WriteSizeLimit {
  String get value => toString().split('.').last;
}

abstract class ApiConstants {
  const ApiConstants._();

  static const serverTimeStamp = <String, dynamic>{'.sv': 'timestamp'};
  static const statusCodeETagMismatch = 412;
  static const nullETag = 'null_etag';

  static const eventStreamCanceled = 542;
}
