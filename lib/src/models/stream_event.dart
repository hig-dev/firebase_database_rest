import 'package:freezed_annotation/freezed_annotation.dart';

part 'stream_event.freezed.dart';
part 'stream_event.g.dart';

@freezed
abstract class StreamEvent with _$StreamEvent {
  const factory StreamEvent.put({
    @required String path,
    @required @nullable dynamic data,
  }) = StreamEventPut;

  const factory StreamEvent.patch({
    @required String path,
    @required @nullable dynamic data,
  }) = StreamEventPatch;

  const factory StreamEvent.authRevoked() = StreamEventAuthRevoked;

  factory StreamEvent.fromJson(Map<String, dynamic> json) =>
      _$StreamEventFromJson(json);
}
