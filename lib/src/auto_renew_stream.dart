import 'dart:async';

import 'auth_revoked_exception.dart';

typedef StreamFactory<T> = Future<Stream<T>> Function();

class AutoRenewStream<T> extends Stream<T> {
  final Stream<T> _initialStream;

  final StreamFactory<T> streamFactory;

  AutoRenewStream(this.streamFactory) : _initialStream = null;

  AutoRenewStream.fromStream(Stream<T> initialStream, this.streamFactory)
      : _initialStream = initialStream;

  @override
  StreamSubscription<T> listen(
    void Function(T event) onData, {
    Function onError,
    void Function() onDone,
    bool cancelOnError,
  }) =>
      _renewableStream().listen(
        onData,
        onError: onError,
        onDone: onDone,
        cancelOnError: cancelOnError,
      );

  Stream<T> _renewableStream() async* {
    var streamEnded = false;
    var currentStream = _initialStream ?? await streamFactory();
    do {
      try {
        yield* currentStream;
        streamEnded = true;
      } on AuthRevokedException {
        currentStream = await streamFactory();
      }
    } while (!streamEnded);
  }
}
