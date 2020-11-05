import 'package:firebase_database_rest/src/filter.dart';
import 'package:firebase_database_rest/src/models/db_exception.dart';
import 'package:firebase_database_rest/src/models/db_response.dart';
import 'package:firebase_database_rest/src/rest_api.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart' hide Timeout;

class MockClient extends Mock implements Client {}

class MockResponse extends Mock implements Response {}

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
  });
}
