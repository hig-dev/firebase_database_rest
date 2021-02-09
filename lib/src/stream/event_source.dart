import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';

import 'event_stream_decoder.dart';
import 'server_sent_event.dart';

class ClientStreamException implements Exception {
  final Response response;

  const ClientStreamException(this.response);
}

class EventSource extends Stream<ServerSentEvent> {
  final StreamedResponse response;

  EventSource(this.response);

  @override
  StreamSubscription<ServerSentEvent> listen(
    void Function(ServerSentEvent event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) =>
      response.stream
          .transform(utf8.decoder)
          .transform(const LineSplitter())
          .transform(const EventStreamDecoder())
          .listen(
            onData,
            onError: onError,
            onDone: onDone,
            cancelOnError: cancelOnError,
          );
}

extension EventSourceClientX on Client {
  Future<EventSource> stream(
    Uri url, {
    Map<String, String>? headers,
    String? lastEventID,
  }) async {
    final request = Request('GET', url);
    if (headers != null) {
      request.headers.addAll(headers);
    }
    request.headers['Accept'] = 'text/event-stream';
    request.headers['Cache-Control'] = 'no-cache';
    if (lastEventID != null) {
      request.headers['Last-Event-ID'] = lastEventID;
    }

    final response = await send(request);
    if (response.statusCode != 200) {
      throw ClientStreamException(await Response.fromStream(response));
    }
    return EventSource(response);
  }
}
