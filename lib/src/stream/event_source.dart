import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';

import 'event_stream_decoder.dart';
import 'server_sent_event.dart';

/// An exception that is thrown if [EventSourceClientX.stream] fails.
///
/// In the case the HTTP-request to the server fails, this exception will be
/// thrown with the original response as payload. This allows you to handle
/// HTTP-errors cleanly.
///
/// **Note:** If the HTTP-Request succeeds, but some errors occure while
/// streaming data, any exception will be thrown from the stream itself. This
/// exception is only used for the case that the initial request fails.
class ClientStreamException implements Exception {
  /// The http response that indicates an error.
  final Response response;

  /// Default constructor
  const ClientStreamException(this.response);
}

/// A SSE stream that transforms a HTTP stream response to [SeverSentEvent]s.
///
/// **Note:** The easiest way to obtain an [EventSource] is to use
/// [EventSourceClientX.stream].
class EventSource extends Stream<ServerSentEvent> {
  /// The HTTP-response beeing streamed.
  final StreamedResponse response;

  /// Default constructor.
  ///
  /// Takes the HTTP-response that is to be streamed.
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

/// An extension on the `http` packages [Client] that allows you to easily
/// send SSE-requests.
extension EventSourceClientX on Client {
  /// Send a HTTP-request that results in a stream of [ServerSentEvent]s in form
  /// of a [EventSource].
  ///
  /// This methods makes a GET-requests (or whatever [verb] is set to) with the
  /// given [url]. It will add some additional headers to [headers], leading to
  /// the server returning an "endless" stream of data in form of
  /// [ServerSentEvent]s.
  ///
  /// If the server supports it, and you had to cancel a stream at some point,
  /// you might be able to resume it by passing the
  /// [ServerSentEvent.lastEventId] of the last event that has been received to
  /// [lastEventId].
  ///
  /// If the requests succeeds, the returned future will resolve to a stream of
  /// SSEs, an [EventSource]. If the request does not succeed (any statuscode
  /// but 200), instead a [ClientStreamException] will be thrown, containing
  /// the faulty result.
  Future<EventSource> stream(
    Uri url, {
    Map<String, String>? headers,
    String? lastEventId,
    String verb = 'GET',
  }) async {
    final request = Request(verb, url);
    if (headers != null) {
      request.headers.addAll(headers);
    }
    request.headers['Accept'] = 'text/event-stream';
    request.headers['Cache-Control'] = 'no-cache';
    if (lastEventId != null) {
      request.headers['Last-Event-ID'] = lastEventId;
    }

    final response = await send(request);
    if (response.statusCode != 200) {
      throw ClientStreamException(await Response.fromStream(response));
    }
    return EventSource(response);
  }
}
