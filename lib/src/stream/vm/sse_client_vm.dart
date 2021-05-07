import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:meta/meta.dart';

import '../server_sent_event.dart';
import '../sse_client.dart';
import '../sse_client_factory.dart';
import 'event_stream_decoder.dart';

class _SSEExceptionVM implements SSEException {
  final Response _response;

  _SSEExceptionVM(this._response);

  @override
  String toString() => _response.body;
}

class _SSEStreamVM extends SSEStream {
  final _filters = <String>{};
  final Stream<ServerSentEvent> _stream;

  _SSEStreamVM(this._stream);

  @override
  StreamSubscription<ServerSentEvent> listen(
    void Function(ServerSentEvent event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) =>
      _stream.where((event) => _filters.contains(event.event)).listen(
            onData,
            onError: onError,
            onDone: onDone,
            cancelOnError: cancelOnError,
          );

  @override
  void addEventType(String event) => _filters.add(event);

  @override
  bool removeEventType(String event) => _filters.remove(event);
}

/// @nodoc
@internal
class SSEClientVM with ClientProxy implements SSEClient {
  @override
  final Client client;

  /// @nodoc
  SSEClientVM(this.client);

  @override
  Future<SSEStream> stream(Uri url) async {
    final request = Request('GET', url)
      ..persistentConnection = true
      ..followRedirects = true
      ..headers['Accept'] = 'text/event-stream'
      ..headers['Cache-Control'] = 'no-cache';

    final response = await client.send(request);
    if (response.statusCode != 200) {
      return _SSEStreamVM(Stream.error(
        _SSEExceptionVM(await Response.fromStream(response)),
      ));
    }

    return _SSEStreamVM(
      response.stream
          .transform(utf8.decoder)
          .transform(const LineSplitter())
          .transform(const EventStreamDecoder()),
    );
  }
}
