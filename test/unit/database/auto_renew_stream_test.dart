import 'dart:async';

import 'package:firebase_database_rest/src/database/auth_revoked_exception.dart';
import 'package:firebase_database_rest/src/database/auto_renew_stream.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../stream_matcher_queue.dart';

abstract class Callable {
  Future<Stream<int>> call();
}

class MockCallable extends Mock implements Callable {}

void main() {
  final mockStreamFactory = MockCallable();

  late int _authStreamCtr;
  Stream<int> _authStream(int limit) async* {
    if (_authStreamCtr < limit) {
      yield _authStreamCtr++;
      throw AuthRevokedException();
    }
  }

  Stream<int> _singleAuthStream(Iterable<int> data) async* {
    yield* Stream.fromIterable(data);
    throw AuthRevokedException();
  }

  setUp(() {
    reset(mockStreamFactory);
    _authStreamCtr = 0;
  });

  test('creates stream and forwards events', () async {
    when(() => mockStreamFactory.call())
        .thenAnswer((i) async => Stream.fromIterable([1, 2, 3, 4]));

    final stream = AutoRenewStream<int>(mockStreamFactory);
    expect(await stream.toList(), [1, 2, 3, 4]);
    verify(() => mockStreamFactory.call()).called(1);
  });

  test('creates stream that can be canceled', () async {
    when(() => mockStreamFactory.call()).thenAnswer(
      (i) async => Stream.fromFuture(
        Future.delayed(const Duration(milliseconds: 200), () => 42),
      ),
    );

    final stream = AutoRenewStream<int>(mockStreamFactory);
    final sub = stream.listen((e) => fail('stream was not canceled'));
    await Future<void>.delayed(const Duration(milliseconds: 100));
    await sub.cancel();
    await Future<void>.delayed(const Duration(milliseconds: 200));
    verify(() => mockStreamFactory.call()).called(1);
  });

  test('creates stream and forwards exceptions', () async {
    when(() => mockStreamFactory.call())
        .thenAnswer((i) async => Stream.fromFuture(Future.error(Exception())));

    final stream = AutoRenewStream<int>(mockStreamFactory);
    expect(() => stream.toList(), throwsA(isA<Exception>()));
    verify(() => mockStreamFactory.call()).called(1);
  });

  test('creates stream and forwards exceptions, without canceling', () async {
    when(() => mockStreamFactory.call()).thenAnswer(
      (i) async => Stream.fromFutures([
        Future.delayed(const Duration(milliseconds: 100), () => 1),
        Future.delayed(
          const Duration(milliseconds: 200),
          () => Future.error(Exception()),
        ),
        Future.delayed(const Duration(milliseconds: 300), () => 2),
      ]),
    );

    final stream = StreamMatcherQueue(AutoRenewStream<int>(mockStreamFactory));
    try {
      await expectLater(
        stream,
        emitsQueued(<dynamic>[
          1,
          asError(isA<Exception>()),
          2,
          isNull,
        ]),
      );
    } finally {
      await stream.close();
    }
    expect(stream, isEmpty);
  });

  test('creates stream that can be paused and resumed', () async {
    when(() => mockStreamFactory.call()).thenAnswer(
      (i) async => () async* {
        yield 1;
        yield 2;
        await Future<void>.delayed(const Duration(milliseconds: 200));
        yield 3;
        yield 4;
      }(),
    );

    final stream = StreamMatcherQueue(AutoRenewStream<int>(mockStreamFactory));
    try {
      await Future<void>.delayed(const Duration(milliseconds: 100));
      stream.sub.pause();
      await expectLater(stream, emitsQueued(const [1, 2]));
      expect(stream, isEmpty);

      await Future<void>.delayed(const Duration(milliseconds: 200));
      expect(stream, isEmpty);

      stream.sub.resume();
      await expectLater(stream, emitsQueued(const [3, 4, null]));
    } finally {
      await stream.close();
    }
    expect(stream, isEmpty);
  });

  test('recreates stream on auth exception', () async {
    when(() => mockStreamFactory.call())
        .thenAnswer((i) async => _authStream(4));

    final stream = AutoRenewStream<int>(mockStreamFactory);
    expect(await stream.toList(), [0, 1, 2, 3]);
    verify(() => mockStreamFactory.call()).called(5);
  });

  test('fromStream: uses base stream and then renew', () async {
    when(() => mockStreamFactory.call())
        .thenAnswer((i) async => _authStream(2));

    final stream = AutoRenewStream.fromStream(
      _singleAuthStream(const [7, 8, 9]),
      mockStreamFactory,
    );
    expect(await stream.toList(), [7, 8, 9, 0, 1]);
    verify(() => mockStreamFactory.call()).called(3);
  });

  test(
    'can cancel while refreshing',
    () async {
      when(() => mockStreamFactory.call()).thenAnswer(
        (i) async => Stream.fromFuture(
          Future.delayed(const Duration(milliseconds: 250), () => 42),
        ),
      );

      final stream = StreamMatcherQueue(AutoRenewStream.fromStream(
        _singleAuthStream(const [1, 2, 3]),
        mockStreamFactory,
      ));
      try {
        await expectLater(stream, emitsQueued(const [1, 2, 3]));
        await Future<void>.delayed(const Duration(milliseconds: 100));
        await stream.sub.cancel();
        expect(stream, isEmpty);

        await Future<void>.delayed(const Duration(milliseconds: 300));
        expect(stream, isEmpty);
      } finally {
        await stream.close();
      }
      expect(stream, isEmpty);
    },
    timeout: const Timeout(Duration(seconds: 3)),
  );

  test('can pause while refreshing', () async {
    when(() => mockStreamFactory.call()).thenAnswer(
      (i) async => Stream.fromFuture(
        Future.delayed(const Duration(milliseconds: 250), () => 42),
      ),
    );

    final stream = StreamMatcherQueue(AutoRenewStream.fromStream(
      _singleAuthStream(const [1, 2, 3]),
      mockStreamFactory,
    ));
    try {
      await expectLater(stream, emitsQueued(const [1, 2, 3]));
      await Future<void>.delayed(const Duration(milliseconds: 100));
      stream.sub.pause();
      expect(stream, isEmpty);

      await Future<void>.delayed(const Duration(milliseconds: 300));
      expect(stream, isEmpty);

      stream.sub.resume();
      await expectLater(stream, emitsQueued(const [42, null]));
    } finally {
      await stream.close();
    }
    expect(stream, isEmpty);
  });
}
