import 'dart:async';

import 'auth_revoked_exception.dart';

/// Method signature of a stream factory method.
typedef StreamFactory<T> = Future<Stream<T>> Function();

/// A wrapper around streams that throw [AuthRevokedException]s to automatically
/// reconnect and continue the stream seamlessly.
///
/// This works by providing a [streamFactory], which is used to generate new
/// streams. The stream events are simply forwarded to the consumer of this
/// stream. If the original stream throws an [AuthRevokedException], instead of
/// forwarding, the original stream gets canceled and [streamFactory] is used to
/// create a new stream, which is then forwarded.
///
/// **Note:** This only recreates streams for that specific exceptions. All
/// other errors are simply forwarded. If the original stream gets closed or
/// canceled, so does this stream.
class AutoRenewStream<T> extends Stream<T> {
  /// The stream factory that is used to generate new streams.
  final StreamFactory<T> streamFactory;

  final Stream<T>? _initialStream;
  late final _controller = StreamController<T>(
    onListen: _onListen,
    onCancel: _onCancel,
    onPause: _onPause,
    onResume: _onResume,
  );

  StreamSubscription<T>? _currentSub;

  /// Default constructor
  ///
  /// Constructs a stream from a [streamFactory]. The first time someone calls
  /// [listen] on this stream, the factory is used to create the initial stream,
  /// which is then consumed as usual.
  AutoRenewStream(this.streamFactory) : _initialStream = null;

  /// Existing stream constructor.
  ///
  /// In case you already have an [initialStream], you can use this constructor.
  /// It will use the [initialStream] as soon as [listen] is is called. Only
  /// when this initial stream throws an [AuthRevokedException], the
  /// [streamFactory] is used to create a new one.
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
