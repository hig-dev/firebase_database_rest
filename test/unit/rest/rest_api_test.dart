import 'dart:async';

import 'package:firebase_database_rest/src/common/api_constants.dart';
import 'package:firebase_database_rest/src/common/db_exception.dart';
import 'package:firebase_database_rest/src/common/filter.dart';
import 'package:firebase_database_rest/src/common/timeout.dart';
import 'package:firebase_database_rest/src/rest/models/db_response.dart';
import 'package:firebase_database_rest/src/rest/models/stream_event.dart';
import 'package:firebase_database_rest/src/rest/models/unknown_stream_event_error.dart';
import 'package:firebase_database_rest/src/rest/rest_api.dart';
import 'package:firebase_database_rest/src/stream/server_sent_event.dart';
import 'package:firebase_database_rest/src/stream/sse_client.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart' hide Timeout;

class MockSSEClient extends Mock implements SSEClient {}

class MockResponse extends Mock implements Response {}

class FakeBaseRequest extends Mock implements BaseRequest {}

class MockSSEStream extends Mock implements SSEStream {}

class SutSSEStream extends SSEStream {
  final MockSSEStream mock;

  SutSSEStream(this.mock);

  @override
  void addEventType(String event) => mock.addEventType(event);

  @override
  bool removeEventType(String event) => mock.removeEventType(event);

  @override
  StreamSubscription<ServerSentEvent> listen(
    void Function(ServerSentEvent event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) =>
      mock.listen(
        onData,
        onError: onError,
        onDone: onDone,
        cancelOnError: cancelOnError,
      );
}

void main() {
  const databaseName = 'database';
  final mockResponse = MockResponse();
  final mockClient = MockSSEClient();

  late RestApi sut;

  setUpAll(() {
    registerFallbackValue(Uri());
    registerFallbackValue<BaseRequest>(FakeBaseRequest());
  });

  setUp(() {
    reset(mockResponse);
    reset(mockClient);

    when(() => mockResponse.statusCode).thenReturn(200);
    when(() => mockResponse.body).thenReturn('null');
    when(() => mockResponse.headers).thenReturn(const {});
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

  test('constructor creates SSEClient from Client', () {
    sut = RestApi(
      client: Client(),
      database: databaseName,
    );

    expect(sut.client, isA<SSEClient>());
    expect(sut.database, databaseName);
    expect(sut.basePath, '');
    expect(sut.idToken, null);
    expect(sut.timeout, null);
    expect(sut.writeSizeLimit, null);
  });

  group('methods', () {
    setUp(() {
      sut = RestApi(
        client: mockClient,
        database: databaseName,
      );
    });

    group('get', () {
      setUp(() {
        when(() => mockClient.get(
              any(),
              headers: any(named: 'headers'),
            )).thenAnswer((i) async => mockResponse);
      });

      test('call client.get with default parameters', () async {
        await sut.get();

        verify(() => mockClient.get(
              Uri.https(
                'database.firebaseio.com',
                '.json',
                const <String, String>{},
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

        verify(() => mockClient.get(
              Uri.https(
                'database.firebaseio.com',
                'some/path.json',
                const <String, String>{
                  'auth': 'token',
                  'timeout': '5ms',
                  'writeSizeLimit': 'tiny',
                  'print': 'pretty',
                  'format': 'export',
                  'shallow': 'true',
                  'orderBy': r'"$key"',
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
        when(() => mockResponse.body).thenReturn('{"a": 1}');

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
        when(() => mockResponse.headers).thenReturn(const {
          'etag': 'tag',
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
        when(() => mockResponse.statusCode).thenReturn(204);
        when(() => mockResponse.body).thenReturn('{"a": 1}');
        when(() => mockResponse.headers).thenReturn(const {
          'etag': 'tag',
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
        when(() => mockResponse.statusCode).thenReturn(404);
        when(() => mockResponse.body).thenReturn('{"error": "message"}');

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
        when(() => mockClient.post(
              any(),
              headers: any(named: 'headers'),
              body: any(named: 'body'),
            )).thenAnswer((i) async => mockResponse);
      });

      test('call client.post with default parameters', () async {
        await sut.post(42);

        verify(() => mockClient.post(
              Uri.https(
                'database.firebaseio.com',
                '.json',
                const <String, String>{},
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

        verify(() => mockClient.post(
              Uri.https(
                'database.firebaseio.com',
                'a/b.json',
                const <String, String>{
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
        when(() => mockResponse.body).thenReturn('{"a": 1}');

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
        when(() => mockResponse.headers).thenReturn(const {
          'etag': 'tag',
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
        when(() => mockResponse.statusCode).thenReturn(204);
        when(() => mockResponse.body).thenReturn('{"a": 1}');
        when(() => mockResponse.headers).thenReturn(const {
          'etag': 'tag',
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
        when(() => mockResponse.statusCode).thenReturn(404);
        when(() => mockResponse.body).thenReturn('{"error": "message"}');

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
        when(() => mockClient.put(
              any(),
              headers: any(named: 'headers'),
              body: any(named: 'body'),
            )).thenAnswer((i) async => mockResponse);
      });

      test('call client.put with default parameters', () async {
        await sut.put(false);

        verify(() => mockClient.put(
              Uri.https(
                'database.firebaseio.com',
                '.json',
                const <String, String>{},
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

        verify(() => mockClient.put(
              Uri.https(
                'database.firebaseio.com',
                'pkg/cls/mtd.json',
                const <String, String>{
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
        when(() => mockResponse.body).thenReturn('{"a": 1}');

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
        when(() => mockResponse.headers).thenReturn(const {
          'etag': 'tag',
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
        when(() => mockResponse.statusCode).thenReturn(204);
        when(() => mockResponse.body).thenReturn('{"a": 1}');
        when(() => mockResponse.headers).thenReturn(const {
          'etag': 'tag',
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
        when(() => mockResponse.statusCode).thenReturn(404);
        when(() => mockResponse.body).thenReturn('{"error": "message"}');

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
        when(() => mockClient.patch(
              any(),
              headers: any(named: 'headers'),
              body: any(named: 'body'),
            )).thenAnswer((i) async => mockResponse);
      });

      test('call client.patch with default parameters', () async {
        await sut.patch(const <String, dynamic>{'a': 42});

        verify(() => mockClient.patch(
              Uri.https(
                'database.firebaseio.com',
                '.json',
                const <String, String>{},
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

        verify(() => mockClient.patch(
              Uri.https(
                'database.firebaseio.com',
                'some/stuff/.json',
                const <String, String>{
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
        when(() => mockResponse.body).thenReturn('{"a": 1}');

        final result = await sut.patch(const <String, dynamic>{});
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
        when(() => mockResponse.statusCode).thenReturn(204);
        when(() => mockResponse.body).thenReturn('{"a": 1}');

        final result = await sut.patch(const <String, dynamic>{});
        expect(
          result,
          const DbResponse(
            data: null,
          ),
        );
      });

      test('throws DbError for failed requests', () async {
        when(() => mockResponse.statusCode).thenReturn(404);
        when(() => mockResponse.body).thenReturn('{"error": "message"}');

        expect(
          () => sut.patch(const <String, dynamic>{}),
          throwsA(const DbException(
            statusCode: 404,
            error: 'message',
          )),
        );
      });
    });

    group('delete', () {
      setUp(() {
        when(() => mockClient.delete(
              any(),
              headers: any(named: 'headers'),
            )).thenAnswer((i) async => mockResponse);
      });

      test('call client.delete with default parameters', () async {
        await sut.delete();

        verify(() => mockClient.delete(
              Uri.https(
                'database.firebaseio.com',
                '.json',
                const <String, String>{},
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

        verify(() => mockClient.delete(
              Uri.https(
                'database.firebaseio.com',
                'delete/this.json',
                const <String, String>{
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
        when(() => mockResponse.body).thenReturn('{"a": 1}');

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
        when(() => mockResponse.headers).thenReturn(const {
          'etag': 'tag',
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
        when(() => mockResponse.statusCode).thenReturn(204);
        when(() => mockResponse.body).thenReturn('{"a": 1}');
        when(() => mockResponse.headers).thenReturn(const {
          'etag': 'tag',
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
        when(() => mockResponse.statusCode).thenReturn(404);
        when(() => mockResponse.body).thenReturn('{"error": "message"}');

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
      final mockStream = MockSSEStream();

      late SutSSEStream sutStream;

      void _mockListen(Stream<ServerSentEvent> data) => when(
          () => mockStream.listen(
                any(),
                onError: any(named: 'onError'),
                onDone: any(named: 'onDone'),
                cancelOnError: any(named: 'cancelOnError'),
              )).thenAnswer((i) => data.listen(
            i.positionalArguments[0] as void Function(ServerSentEvent)?,
            onError: i.namedArguments['onError'] as Function?,
            onDone: i.namedArguments['onData'] as void Function()?,
            cancelOnError: i.namedArguments['cancelOnError'] as bool?,
          ));

      setUp(() {
        reset(mockStream);

        sutStream = SutSSEStream(mockStream);

        when(() => mockClient.stream(any())).thenAnswer((i) async => sutStream);
      });

      test('calls client.stream with default parameters', () async {
        await sut.stream();

        verify(
          () => mockClient.stream(Uri.https(
            'database.firebaseio.com',
            '.json',
            const <String, String>{},
          )),
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

        verify(
          () => mockClient.stream(Uri.https(
            'database.firebaseio.com',
            'stream/path.json',
            const <String, String>{
              'auth': 'token',
              'timeout': '999ms',
              'writeSizeLimit': 'unlimited',
              'print': 'silent',
              'format': 'export',
              'shallow': 'false',
              'orderBy': r'"$value"',
              'equalTo': '42',
            },
          )),
        );
      });

      test('register event types on SSEStream', () async {
        await sut.stream();

        verify(() => mockStream.addEventType('put'));
        verify(() => mockStream.addEventType('patch'));
        verify(() => mockStream.addEventType('keep-alive'));
        verify(() => mockStream.addEventType('cancel'));
        verify(() => mockStream.addEventType('auth_revoked'));
        verifyNever(() => mockStream.addEventType(any()));
      });

      test('returns stream events', () async {
        _mockListen(Stream.fromIterable(const [
          ServerSentEvent(event: 'put', data: '{"path": "/a", "data": 42}'),
          ServerSentEvent(event: 'keep-alive', data: 'null'),
          ServerSentEvent(
            event: 'patch',
            data: '{"path": "/b/c", "data": true}',
          ),
        ]));

        final stream = await sut.stream();
        expect(stream, isNotNull);

        expect(
          stream,
          emitsInOrder(const <StreamEvent>[
            StreamEventPut(path: '/a', data: 42),
            StreamEventPatch(path: '/b/c', data: true),
          ]),
        );
      });

      test('throws DbException on error', () async {
        _mockListen(Stream.fromIterable(const [
          ServerSentEvent(event: 'put', data: '{"path": "/a", "data": null}'),
          ServerSentEvent(event: 'cancel', data: 'error'),
          ServerSentEvent(event: 'put', data: '{"path": "/b", "data": null}'),
        ]));

        final stream = await sut.stream();

        expect(
          stream,
          emitsInOrder(<dynamic>[
            const StreamEventPut(path: '/a', data: null),
            emitsError(const DbException(
              statusCode: ApiConstants.eventStreamCanceled,
              error: 'error',
            )),
            const StreamEventPut(path: '/b', data: null),
          ]),
        );
      });

      test('yields authRevoked if auth was revoked', () async {
        _mockListen(Stream.fromIterable(const [
          ServerSentEvent(
            event: 'put',
            data: '{"path": "/a", "data": [1, 2, 3]}',
          ),
          ServerSentEvent(event: 'auth_revoked', data: 'null'),
          ServerSentEvent(
            event: 'patch',
            data: '{"path": "/b", "data": {"a": false}}',
          ),
        ]));

        final stream = await sut.stream();

        expect(
          stream,
          emitsInOrder(const <StreamEvent>[
            StreamEventPut(path: '/a', data: [1, 2, 3]),
            StreamEvent.authRevoked(),
            StreamEventPatch(path: '/b', data: {'a': false}),
          ]),
        );
      });

      test('throws error on unknown event', () async {
        _mockListen(Stream.value(
          const ServerSentEvent(event: '__test_event', data: '42'),
        ));

        final stream = await sut.stream();
        expect(stream, isNotNull);

        expect(stream.single, throwsA(isA<UnknownStreamEventError>()));
      });
    });
  });
}
