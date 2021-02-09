import 'dart:async';

import '../common/transformer_sink.dart';

import 'server_sent_event.dart';

class EventStreamDecoderSink extends TransformerSink<String, ServerSentEvent> {
  String? _eventType;
  String? _lastEventId;
  final _data = <String>[];

  EventStreamDecoderSink(EventSink<ServerSentEvent> outSink) : super(outSink);

  @override
  void add(String event) {
    if (event.isEmpty) {
      if (_data.isNotEmpty) {
        outSink.add(ServerSentEvent(
          event: _eventType ?? 'message',
          data: _data.join('\n'),
          lastEventId: _lastEventId,
        ));
      }
      _eventType = null;
      _data.clear();
    } else if (event.startsWith(':')) {
      return;
    } else {
      final colonIndex = event.indexOf(':');
      var field = '';
      var value = '';
      if (colonIndex != -1) {
        field = event.substring(0, colonIndex);
        value = event.substring(colonIndex + 1);
        if (value.startsWith(' ')) {
          value = value.substring(1);
        }
      } else {
        field = event;
      }
      switch (field) {
        case 'event':
          _eventType = value.isNotEmpty ? value : null;
          break;
        case 'data':
          _data.add(value);
          break;
        case 'id':
          _lastEventId = value.isNotEmpty ? value : null;
          break;
        // case 'retry':  Not implemented
        default:
          break;
      }
    }
  }
}

class EventStreamDecoder implements StreamTransformer<String, ServerSentEvent> {
  const EventStreamDecoder();

  @override
  Stream<ServerSentEvent> bind(Stream<String> stream) =>
      Stream.eventTransformed(
        stream,
        (sink) => EventStreamDecoderSink(sink),
      );

  @override
  StreamTransformer<RS, RT> cast<RS, RT>() =>
      StreamTransformer.castFrom<String, ServerSentEvent, RS, RT>(this);
}
