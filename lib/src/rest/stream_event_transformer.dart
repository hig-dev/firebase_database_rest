import 'dart:async';
import 'dart:convert';

import 'package:meta/meta.dart';

import '../common/api_constants.dart';
import '../common/db_exception.dart';
import '../common/transformer_sink.dart';
import '../stream/server_sent_event.dart';
import 'models/stream_event.dart';
import 'models/unknown_stream_event_error.dart';

/// @nodoc
@internal
class StreamEventTransformerSink
    extends TransformerSink<ServerSentEvent, StreamEvent> {
  /// @nodoc
  StreamEventTransformerSink(EventSink<StreamEvent> outSink) : super(outSink);

  @override
  void add(ServerSentEvent event) {
    switch (event.event) {
      case 'put':
        outSink.add(StreamEventPut.fromJson(
          json.decode(event.data) as Map<String, dynamic>,
        ));
        break;
      case 'patch':
        outSink.add(StreamEventPatch.fromJson(
          json.decode(event.data) as Map<String, dynamic>,
        ));
        break;
      case 'keep-alive':
        break; // no-op
      case 'cancel':
        outSink.addError(DbException(
          statusCode: ApiConstants.eventStreamCanceled,
          error: event.data,
        ));
        break;
      case 'auth_revoked':
        outSink.add(const StreamEvent.authRevoked());
        break;
      default:
        outSink.addError(UnknownStreamEventError(event));
        break;
    }
  }
}

/// A stream transformer that converts a stream of [ServerSentEvent]s into a
/// stream of [StreamEvent]s, decoding the event types used by firebase.
///
/// **Note:** Typically, you would use [RestApi.stream] instead of using this
/// class directly.
///
/// If any events are received that are not known by this library, a
/// [UnknownStreamEventError] is thrown. As this is an error, this should never
/// happen, unless firebase decides to change how their APIs work.
class StreamEventTransformer
    implements StreamTransformer<ServerSentEvent, StreamEvent> {
  /// All the SSE event types that are consumed by this transformer.
  static const eventTypes = [
    'put',
    'patch',
    'keep-alive',
    'cancel',
    'auth_revoked',
  ];

  /// Default constructor.
  const StreamEventTransformer();

  @override
  Stream<StreamEvent> bind(Stream<ServerSentEvent> stream) =>
      Stream.eventTransformed(
        stream,
        (sink) => StreamEventTransformerSink(sink),
      );

  @override
  StreamTransformer<RS, RT> cast<RS, RT>() =>
      StreamTransformer.castFrom<ServerSentEvent, StreamEvent, RS, RT>(this);
}
