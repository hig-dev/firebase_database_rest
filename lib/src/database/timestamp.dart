import 'package:freezed_annotation/freezed_annotation.dart';

import '../common/api_constants.dart';

part 'timestamp.freezed.dart';

/// A virtual timestamp that can either be a [DateTime] or a server set value.
///
/// If you want to use a server timestamp for a database entry, you should use
/// this class instead of [DateTime]. It can be either set to a date time,
/// allowing you to set an actual time, or to [FirebaseTimestamp.server], which
/// is a placeholder that will be replaced by the server time upon beeing
/// stored.
@freezed
class FirebaseTimestamp with _$FirebaseTimestamp {
  const FirebaseTimestamp._();

  /// Creates a timestamp from a [DateTime] value.
  // ignore: sort_unnamed_constructors_first
  const factory FirebaseTimestamp(
    /// The datetime value to be used.
    DateTime value,
  ) = _FirebaseTimestamp;

  /// Creates a timestamp placeholder that will be set to an actual [DateTime]
  /// upon beeing stored on the server.
  const factory FirebaseTimestamp.server() = _Server;

  /// @nodoc
  factory FirebaseTimestamp.fromJson(dynamic json) {
    if (json is! int) {
      throw ArgumentError.value(
        json,
        'json',
        'Cannot deserialize a server timestamp placeholder',
      );
    }
    return FirebaseTimestamp(DateTime.fromMillisecondsSinceEpoch(json));
  }

  /// @nodoc
  dynamic toJson() => when(
        (value) => value.millisecondsSinceEpoch,
        server: () => ApiConstants.serverTimeStamp,
      );

  /// Returns the datetime value of the timestamp.
  ///
  /// If used on a [FirebaseTimestamp.server], it will throw an error. Otherwise
  /// the datetime value is returned.
  ///
  /// **Note:** Timestamps returned from the database server are always actual
  /// datetime values and can be savely deconstructed. Only those exlicitly
  /// created as server timestamp can throw.
  DateTime get dateTime => when(
        (value) => value,
        server: () => throw UnsupportedError(
          'cannot call dateTime on a server timestamp',
        ),
      );
}
