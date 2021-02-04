import 'package:firebase_database_rest/src/auth_revoked_exception.dart';
import 'package:firebase_database_rest/src/auto_renew_stream.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'mock_callable.dart';

void main() {
  final mockStreamFactory = MockCallable0<Future<Stream<int>>>();

  late int _authStreamCtr;
  Stream<int> _authStream(int limit) async* {
    if (_authStreamCtr < limit) {
      yield _authStreamCtr++;
      throw AuthRevokedException();
    }
  }

  setUp(() {
    reset(mockStreamFactory);
    _authStreamCtr = 0;
  });

  test('creates stream and forwards events', () async {
    when(mockStreamFactory.call())
        .thenAnswer((i) async => Stream.fromIterable([1, 2, 3, 4]));

    final stream = AutoRenewStream<int>(mockStreamFactory);
    expect(await stream.toList(), [1, 2, 3, 4]);
    verify(mockStreamFactory.call()).called(1);
  });

  test('recreates stream on auth exception', () async {
    when(mockStreamFactory.call()).thenAnswer((i) async => _authStream(4));

    final stream = AutoRenewStream<int>(mockStreamFactory);
    expect(await stream.toList(), [0, 1, 2, 3]);
    verify(mockStreamFactory.call()).called(5);
  });

  test('aborts on other errors', () async {
    final baseStream = () async* {
      yield 1;
      yield 2;
      throw Exception('error');
    }();
    when(mockStreamFactory.call()).thenAnswer((i) async => baseStream);

    final stream = AutoRenewStream<int>(mockStreamFactory);
    await expectLater(() => stream.toList(), throwsA(isA<Exception>()));
    verify(mockStreamFactory.call());
  });

  test('fromStream: uses base stream and then renew', () async {
    when(mockStreamFactory.call()).thenAnswer((i) async => _authStream(2));

    final stream = AutoRenewStream.fromStream(
      () async* {
        yield 7;
        yield 8;
        yield 9;
        throw AuthRevokedException();
      }(),
      mockStreamFactory,
    );
    expect(await stream.toList(), [7, 8, 9, 0, 1]);
    verify(mockStreamFactory.call()).called(3);
  });
}
