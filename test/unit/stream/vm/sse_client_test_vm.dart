import 'dart:convert';

import 'package:firebase_database_rest/src/stream/server_sent_event.dart';
import 'package:firebase_database_rest/src/stream/sse_client.dart';
import 'package:firebase_database_rest/src/stream/vm/sse_client_vm.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockResponse extends Mock implements StreamedResponse {}

class MockClient extends Mock implements Client {}

void setupTests() => group('SSEClientVM', () {
      final mockClient = MockClient();
      final mockResponse = MockResponse();

      late SSEClientVM sut;

      setUp(() {
        reset(mockClient);
        reset(mockResponse);

        when(() => mockResponse.statusCode).thenReturn(200);
        when(() => mockResponse.stream)
            .thenAnswer((i) => const ByteStream(Stream.empty()));
        when(() => mockClient.send(any()))
            .thenAnswer((i) async => mockResponse);

        sut = SSEClientVM(mockClient);
      });

      test('default constructor creates SSEClientVM with http.Client', () {
        final client = SSEClient();

        expect(
          client,
          isA<SSEClientVM>().having(
            (c) => c.client,
            'client',
            isNot(mockClient),
          ),
        );
      });

      test('proxy constructor creates SSEClientVM with given Client', () {
        final client = SSEClient.proxy(mockClient);

        expect(
          client,
          isA<SSEClientVM>().having(
            (c) => c.client,
            'client',
            mockClient,
          ),
        );
      });

      group('stream', () {
        final url = Uri.http('localhost', '/');

        test('sends get request with SSE headers', () async {
          await sut.stream(url);

          verify(
            () => mockClient.send(
              any(
                that: isA<Request>()
                    .having((r) => r.method, 'method', 'GET')
                    .having((r) => r.url, 'url', url)
                    .having(
                      (r) => r.persistentConnection,
                      'persistentConnection',
                      true,
                    )
                    .having(
                      (r) => r.followRedirects,
                      'followRedirects',
                      true,
                    )
                    .having((r) => r.headers, 'headers', <String, String>{
                  'Accept': 'text/event-stream',
                  'Cache-Control': 'no-cache',
                }),
              ),
            ),
          );
        });

        test('emits error if send request fails', () async {
          when(() => mockResponse.statusCode).thenReturn(400);
          when(() => mockResponse.isRedirect).thenReturn(false);
          when(() => mockResponse.persistentConnection).thenReturn(true);
          when(() => mockResponse.headers).thenReturn(const {});
          when(() => mockResponse.stream).thenAnswer(
            (i) => ByteStream(
              Stream.value('error').transform(utf8.encoder),
            ),
          );

          final stream = await sut.stream(url);

          expect(stream, emitsError(isA<SSEException>()));
        });

        test('returns transformed stream of SSEs', () async {
          when(() => mockResponse.stream).thenAnswer(
            (i) => ByteStream(
              Stream.value('''
event: ev1
data: data1

event: ev2
data: data2

data: data3

''').transform(utf8.encoder),
            ),
          );

          final stream = await sut.stream(url);
          stream
            ..addEventType('ev2')
            ..addEventType('ev1')
            ..addEventType('ev2')
            ..addEventType('message')
            ..removeEventType('ev2');
          expect(
            stream,
            emitsInOrder(const <ServerSentEvent>[
              ServerSentEvent(data: 'data1', event: 'ev1'),
              ServerSentEvent(data: 'data3'),
            ]),
          );
        });
      });
    });
