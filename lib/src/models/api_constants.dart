enum PrintMode {
  pretty,
  silent,
}

extension PrintModeX on PrintMode {
  String get value {
    switch (this) {
      case PrintMode.pretty:
        return 'pretty';
      case PrintMode.silent:
        return 'silent';
      default:
        return null;
    }
  }
}

enum FormatMode {
  export,
}

extension FormatModeX on FormatMode {
  String get value {
    switch (this) {
      case FormatMode.export:
        return 'export';
      default:
        return null;
    }
  }
}

enum WriteSizeLimit {
  tiny,
  small,
  medium,
  large,
  unlimited,
}

extension WriteSizeLimitX on WriteSizeLimit {
  String get value {
    switch (this) {
      case WriteSizeLimit.tiny:
        return 'tiny';
      case WriteSizeLimit.small:
        return 'small';
      case WriteSizeLimit.medium:
        return 'medium';
      case WriteSizeLimit.large:
        return 'large';
      case WriteSizeLimit.unlimited:
        return 'unlimited';
      default:
        return null;
    }
  }
}

abstract class ApiConstants {
  factory ApiConstants._() => null;

  static const serverTimeStamp = {'.sv': 'timestamp'};
  static const statusCodeETagMismatch = 412;
  static const nullETag = 'null_etag';
}
