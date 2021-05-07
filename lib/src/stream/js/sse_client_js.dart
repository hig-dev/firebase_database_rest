import 'dart:async';
import 'dart:html';

import 'package:http/http.dart';
import 'package:meta/meta.dart';

import '../server_sent_event.dart';
import '../sse_client.dart';
import '../sse_client_factory.dart';

class _SSEExceptionJS implements SSEException {
  final Event _errorEvent;

  _SSEExceptionJS(this._errorEvent);

  @override
  String toString() {
    String? message;
    if (_errorEvent is ErrorEvent) {
      message = (_errorEvent as ErrorEvent).message;
    }
    return message ?? 'Unknown error';
  }
}

class _SSEStreamControllerJS {
  final Uri url;
  final EventSource Function(Uri url) _eventSourceFactory;

  final _eventListeners = <String, EventListener>{};
  late final EventSource _eventSource;
  late final _controller = StreamController<ServerSentEvent>(
    onListen: _onListen,
    onCancel: _onCancel,
  );

  // coverage:ignore-start
  _SSEStreamControllerJS(
    this.url,
    this._eventSourceFactory,
  );
  // coverage:ignore-end

  Stream<ServerSentEvent> get stream => _controller.stream;

  void addEventType(String event) {
    _eventListeners.putIfAbsent(event, () {
      void listener(Event eventData) => _handleEvent(
            event,
            eventData as MessageEvent,
          );
      if (_controller.hasListener) {
        _eventSource.addEventListener(event, listener);
      }
      return listener;
    });
  }

  bool removeEventType(String event) {
    final listener = _eventListeners.remove(event);
    if (listener != null) {
      if (_controller.hasListener) {
        _eventSource.removeEventListener(event, listener);
      }
      return true;
    }
    return false;
  }

  void _onListen() {
    _eventSource = _eventSourceFactory(url)
      ..addEventListener(
        'error',
        (event) => _controller.addError(_SSEExceptionJS(event)),
      );
    for (final entry in _eventListeners.entries) {
      _eventSource.addEventListener(entry.key, entry.value);
    }
  }

  void _onCancel() {
    _eventSource.close();
    _controller.close();
  }

  void _handleEvent(String event, MessageEvent eventData) {
    if (_controller.isPaused) {
      return;
    }

    _controller.add(ServerSentEvent(
      event: event,
      data: eventData.data as String,
      lastEventId:
          eventData.lastEventId == 'null' ? null : eventData.lastEventId,
    ));
  }
}

class _SSEStreamJS extends SSEStream {
  final _SSEStreamControllerJS _sseStreamController;

  _SSEStreamJS(this._sseStreamController); // coverage:ignore-line

  @override
  StreamSubscription<ServerSentEvent> listen(
    void Function(ServerSentEvent event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) =>
      _sseStreamController.stream.listen(
        onData,
        onError: onError,
        onDone: onDone,
        cancelOnError: cancelOnError,
      );

  @override
  void addEventType(String event) => _sseStreamController.addEventType(event);

  @override
  bool removeEventType(String event) =>
      _sseStreamController.removeEventType(event);
}

/// @nodoc
@internal
class SSEClientJS with ClientProxy implements SSEClient {
  @override
  final Client client;

  /// @nodoc
  const SSEClientJS(this.client);

  @override
  Future<SSEStream> stream(Uri url) => Future.value(
        _SSEStreamJS(
          _SSEStreamControllerJS(url, createEventSource),
        ),
      );

  /// @nodoc
  @protected
  EventSource createEventSource(Uri url) => EventSource(url.toString());
}
