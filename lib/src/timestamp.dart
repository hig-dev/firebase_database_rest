import 'package:freezed_annotation/freezed_annotation.dart';

import 'rest_api.dart';

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
    assert(json is String);
    return FirebaseTimestamp(DateTime.parse(json as String));
  }

  dynamic toJson() => when(
        (value) => value.toIso8601String(),
        server: () => RestApi.serverTimeStamp,
      );

  DateTime get dateTime => when(
        (value) => value,
        server: () => null,
      );
}
