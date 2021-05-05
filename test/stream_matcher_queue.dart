import 'dart:async';
import 'dart:collection';

import 'package:test/test.dart';
// ignore: deprecated_member_use
import 'package:test_api/src/frontend/async_matcher.dart';

enum _MatchType {
  data,
  error,
  done,
}

class _MatchData<T> {
  final _MatchType _type;
  final dynamic _raw;

  _MatchData.data(T data)
      : _type = _MatchType.data,
        _raw = data;

  _MatchData.error(Object error)
      : _type = _MatchType.error,
        _raw = error;

  _MatchData.done()
      : _type = _MatchType.done,
        _raw = null;

  T? get value {
    switch (_type) {
      case _MatchType.data:
        return _raw as T;
      case _MatchType.error:
        // ignore: only_throw_errors
        throw _raw as Object;
      case _MatchType.done:
        return null;
    }
  }

  @override
  String toString() => _raw?.toString() ?? '#done';
}

class StreamMatcherQueue<T> {
  late final StreamSubscription<T> _sub;

  final _events = Queue<_MatchData<T>>();
  _MatchData<T>? _lastMatch;

  StreamMatcherQueue(Stream<T> stream) {
    _sub = stream.listen(
      _onData,
      onError: _onError,
      onDone: _onDone,
      cancelOnError: false,
    );
  }

  bool get isEmpty => _events.isEmpty;

  bool get isNotEmpty => _events.isNotEmpty;

  Iterable<_MatchData<T>> get events => _events;

  StreamSubscription<T> get sub => _sub;

  Future<T?> next({bool pop = true}) async {
    while (isEmpty) {
      await Future<void>.delayed(const Duration(milliseconds: 10));
    }
    _lastMatch = pop ? _events.removeFirst() : _events.first;
    return _lastMatch!.value;
  }

  void dropDescribe() => _lastMatch = null;

  void _onData(T data) => _events.add(_MatchData.data(data));

  void _onError(Object error) => _events.add(_MatchData.error(error));

  void _onDone() => _events.add(_MatchData.done());

  Future<void> close() => _sub.cancel();

  @override
  String toString() => _lastMatch?.toString() ?? _events.toString();
}

class _QueueMatcher extends AsyncMatcher {
  final List<dynamic> matchers;

  Matcher? _lastMatcher;

  _QueueMatcher(this.matchers);

  @override
  Description describe(Description description) =>
      description.addDescriptionOf(_lastMatcher);

  @override
  FutureOr<String?> matchAsync(covariant StreamMatcherQueue item) async {
    for (final matcher in matchers) {
      if (matcher is _ErrorMatcher) {
        _lastMatcher = throwsA(matcher.matcher);
        if (!_lastMatcher!.matches(() => item.next(), <dynamic, dynamic>{})) {
          return 'did not match. Remaining queue: ${item.events}';
        }
        item.dropDescribe();
      } else {
        _lastMatcher = matcher is Matcher ? matcher : equals(matcher);
        final dynamic event = await item.next();
        if (!_lastMatcher!.matches(event, <dynamic, dynamic>{})) {
          return 'did not match. Remaining queue: ${item.events}';
        }
        item.dropDescribe();
      }
    }
    return null;
  }
}

Matcher emitsQueued(dynamic matchers) =>
    _QueueMatcher(matchers is List ? matchers : <dynamic>[matchers]);

class _ErrorMatcher {
  final dynamic matcher;

  const _ErrorMatcher(this.matcher);
}

dynamic asError(dynamic matcher) => _ErrorMatcher(matcher);
