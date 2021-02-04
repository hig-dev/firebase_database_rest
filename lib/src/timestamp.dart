import 'package:freezed_annotation/freezed_annotation.dart';

import 'models/api_constants.dart';

part 'timestamp.freezed.dart';

@freezed
abstract class FirebaseTimestamp implements _$FirebaseTimestamp {
  const FirebaseTimestamp._();

  // ignore: sort_unnamed_constructors_first
  const factory FirebaseTimestamp(
    DateTime value,
  ) = _FirebaseTimestamp;
  const factory FirebaseTimestamp.server() = _Server;

  factory FirebaseTimestamp.fromJson(dynamic json) {
    if (json is! String) {
      throw ArgumentError.value(
        json,
        'json',
        'Cannot deserialize a server timestamp placeholder',
      );
    }
    return FirebaseTimestamp(DateTime.parse(json));
  }

  dynamic toJson() => when(
        (value) => value.toIso8601String(),
        server: () => ApiConstants.serverTimeStamp,
      );

  DateTime get dateTime => when(
        (value) => value,
        server: () => throw UnsupportedError(
          'cannot call dateTime on a server timestamp',
        ),
      );
}
