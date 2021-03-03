import 'package:freezed_annotation/freezed_annotation.dart';

part 'server_sent_event.freezed.dart';

/// A dataclass representing a Server Sent Event.
@freezed
class ServerSentEvent with _$ServerSentEvent {
  /// Default constructor
  const factory ServerSentEvent({
    /// The event type of this SSE. Defaults to `message`, if not set.
    @Default('message') String event,

    /// The data that was sent by the server. Can be an empty string.
    required String data,

    /// An optional ID of the last event.
    ///
    /// Can be used to resume a stream if supported by the server. See
    /// [EventSourceClientX.stream].
    String? lastEventId,
  }) = _ServerSentEvent;
}
