import 'dart:convert';

import 'package:firebase_database_rest/src/stream/event_source.dart';
import 'package:firebase_database_rest/src/stream/server_sent_event.dart';
import 'package:http/http.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'event_source_test.mocks.dart';

@GenerateMocks([
  Client,
  StreamedResponse,
])
void main() {
  final mockResponse = MockStreamedResponse();

  setUp(() {
    reset(mockResponse);

    when(mockResponse.statusCode).thenReturn(200);
    when(mockResponse.headers).thenReturn({});
  });

  group('EventSource', () {
    late EventSource sut;

    setUp(() {
      sut = EventSource(mockResponse);
    });

    test('should create transformed event source stream', () async {
      when(mockResponse.stream).thenAnswer((i) {
        const data = '''
event: ev1
data: data1

data: data2

''';
        return ByteStream(Stream.fromIterable([utf8.encode(data)]));
      });

      final result = await sut.toList();
      expect(result, const [
        ServerSentEvent(data: 'data1', event: 'ev1'),
        ServerSentEvent(data: 'data2'),
      ]);
    });
  });

  group('stream extension', () {
    final mockClient = MockClient();

    setUp(() {
      reset(mockClient);

      when(mockClient.send(any)).thenAnswer((i) async => mockResponse);
    });

    test('calls send on client with parameters', () async {
      final url = Uri.https('example.com', '/test');
      await mockClient.stream(
        url,
        headers: const {
          'a': '1',
          'b': '2',
          'Accept': 'application/json',
        },
      );

      final request = verify(
        mockClient.send(captureAny),
      ).captured.single as Request;
      expect(request.method, 'GET');
      expect(request.url, url);
      expect(request.persistentConnection, true);
      expect(request.headers, const {
        'a': '1',
        'b': '2',
        'Accept': 'text/event-stream',
        'Cache-Control': 'no-cache',
      });
      expect(request.contentLength, 0);
    });

    test('sets last event id header if given', () async {
      await mockClient.stream(Uri(), lastEventId: '42');

      final request = verify(
        mockClient.send(captureAny),
      ).captured.single as Request;
      expect(request.headers, const {
        'Accept': 'text/event-stream',
        'Cache-Control': 'no-cache',
        'Last-Event-ID': '42',
      });
    });

    test('Returns event source with reponse', () async {
      final res = await mockClient.stream(Uri());

      expect(res, isNotNull);
      expect(res.response, mockResponse);
    });

    test('throws ClientStreamException on failure status code', () async {
      when(mockResponse.statusCode).thenReturn(400);
      when(mockResponse.request).thenReturn(null);
      when(mockResponse.isRedirect).thenReturn(false);
      when(mockResponse.persistentConnection).thenReturn(false);
      when(mockResponse.reasonPhrase).thenReturn(null);
      when(mockResponse.stream)
          .thenAnswer((i) => const ByteStream(Stream.empty()));

      expect(
        mockClient.stream(Uri()),
        throwsA(predicate<ClientStreamException>((e) {
          expect(e, isA<ClientStreamException>());
          expect(e.response, isNotNull);
          expect(e.response.statusCode, 400);
          return true;
        })),
      );
    });
  });
}
