import 'dart:async';

import 'auth_revoked_exception.dart';

typedef StreamFactory<T> = Future<Stream<T>> Function();

class AutoRenewStream<T> extends Stream<T> {
  final StreamFactory<T> streamFactory;

  final Stream<T>? _initialStream;
  late final _controller = StreamController<T>(
    onListen: _onListen,
    onCancel: _onCancel,
    onPause: _onPause,
    onResume: _onResume,
  );

  StreamSubscription<T>? _currentSub;

  AutoRenewStream(this.streamFactory) : _initialStream = null;

  AutoRenewStream.fromStream(Stream<T> initialStream, this.streamFactory)
      : _initialStream = initialStream;

  @override
  StreamSubscription<T> listen(
    void Function(T event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) =>
      _controller.stream.listen(
        onData,
        onError: onError,
        onDone: onDone,
        cancelOnError: cancelOnError,
      );

  Future<void> _onListen() async =>
      _listenNext(_initialStream ?? await streamFactory());

  Future<void> _onCancel() async {
    await _currentSub?.cancel();
    if (!_controller.isClosed) {
      await _controller.close();
    }
  }

  void _onPause() => _currentSub?.pause();

  void _onResume() => _currentSub?.resume();

  void _listenNext(Stream<T> stream) {
    if (_controller.isClosed) {
      return;
    }

    _currentSub = stream.listen(
      _controller.add,
      onDone: _controller.close,
      onError: _handleError,
      cancelOnError: false,
    );

    if (_controller.isPaused) {
      _currentSub!.pause();
    }
  }

  Future<void> _handleError(Object error, StackTrace stackTrace) async {
    if (error is! AuthRevokedException) {
      _controller.addError(error, stackTrace);
      return;
    }

    final sub = _currentSub;
    _currentSub = null;
    await sub?.cancel();
    _listenNext(await streamFactory());
  }
}
