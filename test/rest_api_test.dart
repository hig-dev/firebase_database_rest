import 'dart:async';
import 'dart:convert';

import 'package:firebase_database_rest/src/filter.dart';
import 'package:firebase_database_rest/src/models/db_exception.dart';
import 'package:firebase_database_rest/src/models/db_response.dart';
import 'package:firebase_database_rest/src/models/stream_event.dart';
import 'package:firebase_database_rest/src/models/timeout.dart';
import 'package:firebase_database_rest/src/rest_api.dart';
import 'package:http/http.dart';
import 'package:logging/logging.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart' hide Timeout;

class MockClient extends Mock implements Client {}

class MockResponse extends Mock implements Response {}

class MockStreamedResponse extends Mock implements StreamedResponse {}

void main() {
  const databaseName = 'database';
  final mockResponse = MockResponse();
  final mockClient = MockClient();

  RestApi sut;

  setUp(() {
    reset(mockResponse);
    reset(mockClient);

    when(mockResponse.statusCode).thenReturn(200);
    when(mockResponse.body).thenReturn('null');
    when(mockResponse.headers).thenReturn(const {});
  });

  test('constructor initializes default properties', () {
    sut = RestApi(
      client: mockClient,
      database: databaseName,
    );

    expect(sut.client, mockClient);
    expect(sut.database, databaseName);
    expect(sut.basePath, '');
    expect(sut.idToken, null);
    expect(sut.timeout, null);
    expect(sut.writeSizeLimit, null);
  });

  // TODO test different base path / params

  group('methods', () {
    setUp(() {
      sut = RestApi(
        client: mockClient,
        database: databaseName,
      );
    });

    group('get', () {
      setUp(() {
        when(mockClient.get(
          any,
          headers: anyNamed('headers'),
        )).thenAnswer((i) async => mockResponse);
      });

      test('call client.get with default parameters', () async {
        await sut.get();

        verify(mockClient.get(
          Uri.https(
            'database.firebaseio.com',
            '.json',
            const {},
          ),
          headers: const {
            'Accept': 'application/json',
          },
        ));
      });

      test('calls client.get with all parameters', () async {
        sut
          ..idToken = 'token'
          ..timeout = const Timeout.ms(5)
          ..writeSizeLimit = WriteSizeLimit.tiny;

        await sut.get(
          path: 'some/path',
          filter: Filter.key().limitToFirst(1).build(),
          printMode: PrintMode.pretty,
          formatMode: FormatMode.export,
          shallow: true,
          eTag: true,
        );

        verify(mockClient.get(
          Uri.https(
            'database.firebaseio.com',
            'some/path.json',
            const {
              'auth': 'token',
              'timeout': '5ms',
              'writeSizeLimit': 'tiny',
              'print': 'pretty',
              'format': 'export',
              'shallow': 'true',
              'orderBy': r'$key',
              'limitToFirst': '1',
            },
          ),
          headers: const {
            'Accept': 'application/json',
            'X-Firebase-ETag': 'true',
          },
        ));
      });

      test('parses valid response', () async {
        when(mockResponse.body).thenReturn('{"a": 1}');

        final result = await sut.get();
        expect(
          result,
          const DbResponse(
            data: {
              'a': 1,
            },
          ),
        );
      });

      test('parses valid response with eTag', () async {
        when(mockResponse.headers).thenReturn(const {
          'ETag': 'tag',
        });

        final result = await sut.get(eTag: true);
        expect(
          result,
          const DbResponse(
            eTag: 'tag',
            data: null,
          ),
        );
      });

      test('returns empty response with etag', () async {
        when(mockResponse.statusCode).thenReturn(204);
        when(mockResponse.body).thenReturn('{"a": 1}');
        when(mockResponse.headers).thenReturn(const {
          'ETag': 'tag',
        });

        final result = await sut.get(eTag: true);
        expect(
          result,
          const DbResponse(
            eTag: 'tag',
            data: null,
          ),
        );
      });

      test('throws DbError for failed requests', () async {
        when(mockResponse.statusCode).thenReturn(404);
        when(mockResponse.body).thenReturn('{"error": "message"}');

        expect(
          sut.get,
          throwsA(const DbException(
            statusCode: 404,
            error: 'message',
          )),
        );
      });
    });

    group('post', () {
      setUp(() {
        when(mockClient.post(
          any,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        )).thenAnswer((i) async => mockResponse);
      });

      test('call client.post with default parameters', () async {
        await sut.post(42);

        verify(mockClient.post(
          Uri.https(
            'database.firebaseio.com',
            '.json',
            const {},
          ),
          headers: const {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
          body: '42',
        ));
      });

      test('call client.post with all parameters', () async {
        sut
          ..idToken = 'token'
          ..timeout = const Timeout.s(10)
          ..writeSizeLimit = WriteSizeLimit.small;

        await sut.post(
          'test',
          eTag: true,
          path: 'a/b',
          printMode: PrintMode.silent,
        );

        verify(mockClient.post(
          Uri.https(
            'database.firebaseio.com',
            'a/b.json',
            const {
              'auth': 'token',
              'timeout': '10s',
              'writeSizeLimit': 'small',
              'print': 'silent',
            },
          ),
          headers: const {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'X-Firebase-ETag': 'true',
          },
          body: '"test"',
        ));
      });

      test('parses valid response', () async {
        when(mockResponse.body).thenReturn('{"a": 1}');

        final result = await sut.post(null);
        expect(
          result,
          const DbResponse(
            data: {
              'a': 1,
            },
          ),
        );
      });

      test('parses valid response with eTag', () async {
        when(mockResponse.headers).thenReturn(const {
          'ETag': 'tag',
        });

        final result = await sut.post(null, eTag: true);
        expect(
          result,
          const DbResponse(
            eTag: 'tag',
            data: null,
          ),
        );
      });

      test('returns empty response with etag', () async {
        when(mockResponse.statusCode).thenReturn(204);
        when(mockResponse.body).thenReturn('{"a": 1}');
        when(mockResponse.headers).thenReturn(const {
          'ETag': 'tag',
        });

        final result = await sut.post(null, eTag: true);
        expect(
          result,
          const DbResponse(
            eTag: 'tag',
            data: null,
          ),
        );
      });

      test('throws DbError for failed requests', () async {
        when(mockResponse.statusCode).thenReturn(404);
        when(mockResponse.body).thenReturn('{"error": "message"}');

        expect(
          () => sut.post(null),
          throwsA(const DbException(
            statusCode: 404,
            error: 'message',
          )),
        );
      });
    });

    group('put', () {
      setUp(() {
        when(mockClient.put(
          any,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        )).thenAnswer((i) async => mockResponse);
      });

      test('call client.put with default parameters', () async {
        await sut.put(false);

        verify(mockClient.put(
          Uri.https(
            'database.firebaseio.com',
            '.json',
            const {},
          ),
          headers: const {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
          body: 'false',
        ));
      });

      test('call client.put with all parameters', () async {
        sut
          ..idToken = 'token'
          ..timeout = const Timeout.min(15)
          ..writeSizeLimit = WriteSizeLimit.medium;

        await sut.put(
          null,
          eTag: true,
          path: 'pkg/cls/mtd',
          printMode: PrintMode.pretty,
          ifMatch: 'another-tag',
        );

        verify(mockClient.put(
          Uri.https(
            'database.firebaseio.com',
            'pkg/cls/mtd.json',
            const {
              'auth': 'token',
              'timeout': '15min',
              'writeSizeLimit': 'medium',
              'print': 'pretty',
            },
          ),
          headers: const {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'X-Firebase-ETag': 'true',
            'if-match': 'another-tag',
          },
          body: 'null',
        ));
      });

      test('parses valid response', () async {
        when(mockResponse.body).thenReturn('{"a": 1}');

        final result = await sut.put(null);
        expect(
          result,
          const DbResponse(
            data: {
              'a': 1,
            },
          ),
        );
      });

      test('parses valid response with eTag', () async {
        when(mockResponse.headers).thenReturn(const {
          'ETag': 'tag',
        });

        final result = await sut.put(null, eTag: true);
        expect(
          result,
          const DbResponse(
            eTag: 'tag',
            data: null,
          ),
        );
      });

      test('returns empty response with etag', () async {
        when(mockResponse.statusCode).thenReturn(204);
        when(mockResponse.body).thenReturn('{"a": 1}');
        when(mockResponse.headers).thenReturn(const {
          'ETag': 'tag',
        });

        final result = await sut.put(null, eTag: true);
        expect(
          result,
          const DbResponse(
            eTag: 'tag',
            data: null,
          ),
        );
      });

      test('throws DbError for failed requests', () async {
        when(mockResponse.statusCode).thenReturn(404);
        when(mockResponse.body).thenReturn('{"error": "message"}');

        expect(
          () => sut.put(null),
          throwsA(const DbException(
            statusCode: 404,
            error: 'message',
          )),
        );
      });
    });

    group('patch', () {
      setUp(() {
        when(mockClient.patch(
          any,
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        )).thenAnswer((i) async => mockResponse);
      });

      test('call client.patch with default parameters', () async {
        await sut.patch(const <String, dynamic>{'a': 42});

        verify(mockClient.patch(
          Uri.https(
            'database.firebaseio.com',
            '.json',
            const {},
          ),
          headers: const {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
          body: '{"a":42}',
        ));
      });

      test('call client.patch with all parameters', () async {
        sut
          ..idToken = 'token'
          ..timeout = const Timeout.min(15)
          ..writeSizeLimit = WriteSizeLimit.large;

        await sut.patch(
          const <String, dynamic>{'c': false},
          path: 'some/stuff/',
          printMode: PrintMode.silent,
        );

        verify(mockClient.patch(
          Uri.https(
            'database.firebaseio.com',
            'some/stuff/.json',
            const {
              'auth': 'token',
              'timeout': '15min',
              'writeSizeLimit': 'large',
              'print': 'silent',
            },
          ),
          headers: const {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
          body: '{"c":false}',
        ));
      });

      test('parses valid response', () async {
        when(mockResponse.body).thenReturn('{"a": 1}');

        final result = await sut.patch(null);
        expect(
          result,
          const DbResponse(
            data: {
              'a': 1,
            },
          ),
        );
      });

      test('returns empty response ', () async {
        when(mockResponse.statusCode).thenReturn(204);
        when(mockResponse.body).thenReturn('{"a": 1}');

        final result = await sut.patch(null);
        expect(
          result,
          const DbResponse(
            data: null,
          ),
        );
      });

      test('throws DbError for failed requests', () async {
        when(mockResponse.statusCode).thenReturn(404);
        when(mockResponse.body).thenReturn('{"error": "message"}');

        expect(
          () => sut.patch(null),
          throwsA(const DbException(
            statusCode: 404,
            error: 'message',
          )),
        );
      });
    });

    group('delete', () {
      setUp(() {
        when(mockClient.delete(
          any,
          headers: anyNamed('headers'),
        )).thenAnswer((i) async => mockResponse);
      });

      test('call client.delete with default parameters', () async {
        await sut.delete();

        verify(mockClient.delete(
          Uri.https(
            'database.firebaseio.com',
            '.json',
            const {},
          ),
          headers: const {
            'Accept': 'application/json',
          },
        ));
      });

      test('call client.delete with all parameters', () async {
        sut
          ..idToken = 'token'
          ..timeout = const Timeout.min(1)
          ..writeSizeLimit = WriteSizeLimit.unlimited;

        await sut.delete(
          path: 'delete/this',
          printMode: PrintMode.silent,
          eTag: true,
          ifMatch: 'another-tag',
        );

        verify(mockClient.delete(
          Uri.https(
            'database.firebaseio.com',
            'delete/this.json',
            const {
              'auth': 'token',
              'timeout': '1min',
              'writeSizeLimit': 'unlimited',
              'print': 'silent',
            },
          ),
          headers: const {
            'Accept': 'application/json',
            'X-Firebase-ETag': 'true',
            'if-match': 'another-tag',
          },
        ));
      });

      test('parses valid response', () async {
        when(mockResponse.body).thenReturn('{"a": 1}');

        final result = await sut.delete();
        expect(
          result,
          const DbResponse(
            data: {
              'a': 1,
            },
          ),
        );
      });

      test('parses valid response with eTag', () async {
        when(mockResponse.headers).thenReturn(const {
          'ETag': 'tag',
        });

        final result = await sut.delete(eTag: true);
        expect(
          result,
          const DbResponse(
            eTag: 'tag',
            data: null,
          ),
        );
      });

      test('returns empty response with etag', () async {
        when(mockResponse.statusCode).thenReturn(204);
        when(mockResponse.body).thenReturn('{"a": 1}');
        when(mockResponse.headers).thenReturn(const {
          'ETag': 'tag',
        });

        final result = await sut.delete(eTag: true);
        expect(
          result,
          const DbResponse(
            eTag: 'tag',
            data: null,
          ),
        );
      });

      test('throws DbError for failed requests', () async {
        when(mockResponse.statusCode).thenReturn(404);
        when(mockResponse.body).thenReturn('{"error": "message"}');

        expect(
          () => sut.delete(),
          throwsA(const DbException(
            statusCode: 404,
            error: 'message',
          )),
        );
      });
    });

    group('stream', () {
      void _verifyStream(
        dynamic url, {
        Map<String, String> headers,
      }) {
        final captured = verify(mockClient.send(captureAny)).captured;
        final request = captured.single as Request;
        expect(request.method, 'GET');
        expect(request.url, url);
        expect(request.headers, headers);
      }

      void _mockStream(
        MockStreamedResponse response,
        Iterable<String> elements,
      ) {
        when(response.stream).thenAnswer(
          (i) => ByteStream(
            Stream.fromIterable(elements).transform(utf8.encoder),
          ),
        );
      }

      final mockStreamedResponse = MockStreamedResponse();

      setUp(() {
        reset(mockStreamedResponse);

        when(mockStreamedResponse.statusCode).thenReturn(200);
        when(mockStreamedResponse.stream).thenAnswer(
          (i) => ByteStream(const Stream.empty()),
        );
        when(mockStreamedResponse.headers).thenReturn(const {});

        when(mockClient.send(any))
            .thenAnswer((i) async => mockStreamedResponse);
      });

      test('calls client.delete with default parameters', () async {
        await sut.stream();

        _verifyStream(
          Uri.https(
            'database.firebaseio.com',
            '.json',
            const {},
          ),
          headers: const {
            'Accept': 'text/event-stream',
            'Cache-Control': 'no-cache',
          },
        );
      });

      test('calls client.stream with all parameters', () async {
        sut
          ..idToken = 'token'
          ..timeout = const Timeout.ms(999)
          ..writeSizeLimit = WriteSizeLimit.unlimited;

        await sut.stream(
          path: 'stream/path',
          filter: Filter.value<int>().equalTo(42).build(),
          printMode: PrintMode.silent,
          formatMode: FormatMode.export,
          shallow: false,
        );

        _verifyStream(
          Uri.https(
            'database.firebaseio.com',
            'stream/path.json',
            const {
              'auth': 'token',
              'timeout': '999ms',
              'writeSizeLimit': 'unlimited',
              'print': 'silent',
              'format': 'export',
              'shallow': 'false',
              'orderBy': r'$value',
              'equalTo': '42',
            },
          ),
          headers: const {
            'Accept': 'text/event-stream',
            'Cache-Control': 'no-cache',
          },
        );
      });

      test('returns stream events', () async {
        _mockStream(mockStreamedResponse, const [
          'event: put\n',
          'data: {"path": "/a", "data": 42}\n',
          '\n',
          'event: keep-alive\n',
          'data: null\n',
          '\n',
          'event: patch\n',
          'data: {"path": "/b/c", "data": true}\n',
          '\n',
        ]);

        final stream = await sut.stream();
        expect(stream, isNotNull);

        expect(await stream.toList(), const [
          StreamEventPut(path: '/a', data: 42),
          StreamEventPatch(path: '/b/c', data: true),
        ]);
      });

      test('throws DbException on error', () async {
        _mockStream(
          mockStreamedResponse,
          const [
            'event: put\n',
            'data: {"path": "/a", "data": null}\n',
            '\n',
            'event: cancel\n',
            'data: error\n',
            '\n',
            'event: put\n',
            'data: {"path": "/b", "data": null}\n',
            '\n',
          ],
        );

        final stream = await sut.stream();
        final events = <StreamEvent>[];
        final completer = Completer<void>();
        stream.listen(
          events.add,
          onError: completer.completeError,
          onDone: () {
            if (!completer.isCompleted) {
              completer.complete();
            }
          },
        );

        await expectLater(
          () => completer.future,
          throwsA(const DbException(
            statusCode: 400,
            error: 'error',
          )),
        );
        expect(events, const [
          StreamEventPut(path: '/a', data: null),
        ]);
      });

      test('yields authRevoked if auth was revoked', () async {
        _mockStream(mockStreamedResponse, const [
          'event: put\n',
          'data: {"path": "/a", "data": [1, 2, 3]}\n',
          '\n',
          'event: auth_revoked\n',
          'data: null\n',
          '\n',
          'event: patch\n',
          'data: {"path": "/b", "data": {"a": false}}\n',
          '\n',
        ]);

        final stream = await sut.stream();
        expect(stream, isNotNull);

        expect(await stream.toList(), const [
          StreamEventPut(path: '/a', data: [1, 2, 3]),
          StreamEvent.authRevoked(),
          StreamEventPatch(path: '/b', data: {'a': false}),
        ]);
      });

      test('logs warning on unknown event', () async {
        Logger.root.level = Level.ALL;
        final test = Logger.root.onRecord.any(
          (e) => e.message == 'Ignoring unsupported stream event: __test_event',
        );

        _mockStream(mockStreamedResponse, const [
          'event: __test_event\n',
          'data: 42\n',
          '\n',
        ]);

        final stream = await sut.stream();
        expect(await stream.length, 0);

        final result = await test;
        expect(result, true);
      });
    });
  });
}
