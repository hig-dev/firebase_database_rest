import 'package:freezed_annotation/freezed_annotation.dart';

part 'server_sent_event.freezed.dart';

@freezed
abstract class ServerSentEvent with _$ServerSentEvent {
  const factory ServerSentEvent({
    @Default('message') String event,
    required String data,
    String? lastEventId,
  }) = _ServerSentEvent;
}
