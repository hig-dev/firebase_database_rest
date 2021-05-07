import 'package:http/http.dart';

import 'server_sent_event.dart';

import 'sse_client_factory.dart'
    if (dart.library.io) 'vm/sse_client_vm_factory.dart'
    if (dart.library.html) 'js/sse_client_js_factory.dart';

/// An exception that gets emitted by the [SSEStream] on connection problems.
class SSEException implements Exception {}

/// A specialized [Stream] that allows event registration.
///
/// You can obtain an instance of such a stream via [SSEClient.stream]. After
/// obtaining it, you should immediatly start to listen on the stream, to
/// prevent data loss on some platforms.
///
/// By default, the stream will not emit any events. You have to explicitly
/// register each event type you want to receive via [addEventType]. You can
/// remove them again via [removeEventType]. It does not matter, if you call
/// these methods before or after listening to the stream.
abstract class SSEStream extends Stream<ServerSentEvent> {
  /// Adds the given [event] type to the stream for listening.
  ///
  /// After adding the [event], all further instances of that event that are
  /// sent by the server will be emitted by this stream. You can use
  /// [ServerSentEvent.event] to find out which data belongs to which event type
  /// when processing them.
  ///
  /// Calling this function multiple times for the same [event] does nothing.
  /// You can listen to multiple different [event]s at the same time.
  ///
  /// To remove an added event, you can use [removeEventType].
  void addEventType(String event);

  /// Removes the given [event] type from the stream for listening.
  ///
  /// This operation undos [addEventType] for the given [event], meaning that
  /// events of this type will not be received from the server anymore. The
  /// return value indicates if an event listener was acutally removed, or if
  /// there was none to begin with.
  bool removeEventType(String event);
}

/// A specialized [Client] that allows streaming server sent events.
abstract class SSEClient implements Client {
  /// Default constructor
  factory SSEClient() => SSEClientFactory.create(Client());

  /// Creates an [SSEClient] that uses [client] for all operations but [stream].
  factory SSEClient.proxy(Client client) => SSEClientFactory.create(client);

  /// Creates a stream of [ServerSentEvent]s from the given [url].
  ///
  /// Internally, this will connect to the server and start receiving events.
  /// You should call [SSEStream.listen] immediatly on the returned stream to
  /// prevent data loss.
  ///
  /// The stream is a single subscription stream and controls the connection to
  /// the server. To close it, simply cancel the subscription on the stream.
  Future<SSEStream> stream(Uri url);
}
