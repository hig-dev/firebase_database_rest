import 'dart:async';

import 'package:meta/meta.dart';

import '../common/transformer_sink.dart';

import 'server_sent_event.dart';

/// @nodoc
@internal
class EventStreamDecoderSink extends TransformerSink<String, ServerSentEvent> {
  String? _eventType;
  String? _lastEventId;
  final _data = <String>[];

  /// @nodoc
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

/// A stream transformer that converts a string stream into a stream of
/// [ServerSentEvent]s
///
/// **Note:** Typically, you would use [EventSource] instead of using this
/// class directly.
///
/// Expects each string to represent one line. This means any input stream must
/// first be split into lines before beeing passed to this transformer. It will
/// consume multiple lines to generate SSE events from the data.
///
/// A typical usage would be to use for example the [StreamedResponse] from the
/// `http` package and transform it in multiple steps like this:
/// ```.dart
/// StreamedResponse response = // ...
/// final sseStream = response.stream
///   .transform(utf8.decoder)
///   .transform(const LineSplitter())
///   .transform(const EventStreamDecoder());
/// ```
class EventStreamDecoder implements StreamTransformer<String, ServerSentEvent> {
  /// Default constructor
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
