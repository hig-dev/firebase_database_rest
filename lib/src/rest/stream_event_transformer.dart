import 'dart:async';
import 'dart:convert';

import 'package:meta/meta.dart';

import '../common/transformer_sink.dart';
import '../stream/server_sent_event.dart';
import 'api_constants.dart';
import 'models/db_exception.dart';
import 'models/stream_event.dart';
import 'models/unknown_stream_event_error.dart';

@internal
class StreamEventTransformerSink
    extends TransformerSink<ServerSentEvent, StreamEvent> {
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

class StreamEventTransformer
    implements StreamTransformer<ServerSentEvent, StreamEvent> {
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
