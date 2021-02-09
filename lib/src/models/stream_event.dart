import 'package:freezed_annotation/freezed_annotation.dart';

part 'stream_event.freezed.dart';
part 'stream_event.g.dart';

@freezed
abstract class StreamEvent with _$StreamEvent {
  const factory StreamEvent.put({
    required String path,
    required dynamic data,
  }) = StreamEventPut;

  const factory StreamEvent.patch({
    required String path,
    required dynamic data,
  }) = StreamEventPatch;

  const factory StreamEvent.authRevoked() = StreamEventAuthRevoked;

  const factory StreamEvent.unknown({
    required String event,
    required String data,
  }) = StreamEventUnknown;

  factory StreamEvent.fromJson(Map<String, dynamic> json) =>
      _$StreamEventFromJson(json);
}
