import 'dart:async';
import 'dart:html';

import 'package:firebase_database_rest/src/stream/js/sse_client_js.dart';
import 'package:firebase_database_rest/src/stream/server_sent_event.dart';
import 'package:firebase_database_rest/src/stream/sse_client.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

// ignore: avoid_implementing_value_types
class FakeEvent extends Fake implements Event {}

class MockClient extends Mock implements http.Client {}

// ignore: avoid_implementing_value_types
class MockErrorEvent extends Mock implements ErrorEvent {}

// ignore: avoid_implementing_value_types
class MockEventSource extends Mock implements EventSource {}

class MockSSEClientJS extends Mock implements SSEClientJS {}

class SutSSEClientJS extends SSEClientJS {
  final MockSSEClientJS mock;

  SutSSEClientJS(this.mock, http.Client client) : super(client);

  @override
  EventSource createEventSource(Uri url) => mock.createEventSource(url);
}

void setupTests() => group('SSEClientJS', () {
      final mockClient = MockClient();
      final mockEventSource = MockEventSource();
      final mockSSEClient = MockSSEClientJS();

      late SutSSEClientJS clientSut;

      setUpAll(() {
        registerFallbackValue(Uri());
      });

      setUp(() {
        reset(mockClient);
        reset(mockEventSource);
        reset(mockSSEClient);

        // ignore: invalid_use_of_protected_member
        when(() => mockSSEClient.createEventSource(any()))
            .thenReturn(mockEventSource);

        clientSut = SutSSEClientJS(mockSSEClient, mockClient);
      });

      test('default constructor creates SSEClientJS with http.Client', () {
        final client = SSEClient();

        expect(
          client,
          isA<SSEClientJS>().having(
            (c) => c.client,
            'client',
            isNot(mockClient),
          ),
        );
      });

      test('proxy constructor creates SSEClientJS with given Client', () {
        final client = SSEClient.proxy(mockClient);

        expect(
          client,
          isA<SSEClientJS>().having(
            (c) => c.client,
            'client',
            mockClient,
          ),
        );
      });

      test('createEventSource create EventSource', () {
        final client = SSEClientJS(mockClient);
        final eventSource =
            // ignore: invalid_use_of_protected_member
            client.createEventSource(Uri.http('localhost', '/'));

        expect(eventSource, isA<EventSource>());
        eventSource.close();
      });

      test('stream creates SSEStream instance', () async {
        final url = Uri();
        final stream = await clientSut.stream(url);

        expect(stream, isA<SSEStream>());
      });

      group('stream', () {
        final url = Uri.http('example.org', '/');
        late SSEStream streamSut;

        setUp(() async {
          streamSut = await clientSut.stream(url);
        });

        group('listen', () {
          test('creates event source when listening', () {
            streamSut.listen(null);

            // ignore: invalid_use_of_protected_member
            verify(() => mockSSEClient.createEventSource(url));
          });

          test('listens to error events', () {
            streamSut.listen(null);

            verify(() => mockEventSource.addEventListener('error', any()));
          });

          test('emits generic SSEException on generic error events ', () {
            when(
              () => mockEventSource.addEventListener('error', any()),
            ).thenAnswer((i) {
              final cb = i.positionalArguments[1] as void Function(Event);
              cb(FakeEvent());
            });

            expect(
              streamSut,
              emitsError(
                isA<SSEException>().having(
                  (e) => e.toString(),
                  'toString()',
                  'Unknown error',
                ),
              ),
            );
          });

          test('emits specific SSEException on explicit error events ', () {
            const message = 'error-message';
            final mockEvent = MockErrorEvent();

            when(() => mockEvent.message).thenReturn(message);
            when(
              () => mockEventSource.addEventListener('error', any()),
            ).thenAnswer((i) {
              final cb = i.positionalArguments[1] as void Function(Event);
              cb(mockEvent);
            });

            expect(
              streamSut,
              emitsError(
                isA<SSEException>().having(
                  (e) => e.toString(),
                  'toString()',
                  message,
                ),
              ),
            );
          });

          test('adds no other event listeners by default', () {
            streamSut.listen(null);

            verifyNever(
              () => mockEventSource.addEventListener(
                any(that: isNot('error')),
                any(),
              ),
            );
          });

          test('add previously enabled event listeners', () {
            streamSut
              ..addEventType('A')
              ..addEventType('B')
              ..addEventType('C')
              ..removeEventType('B')
              ..addEventType('D')
              ..listen(null);

            verify(() => mockEventSource.addEventListener('error', any()));
            verify(() => mockEventSource.addEventListener('A', any()));
            verify(() => mockEventSource.addEventListener('C', any()));
            verify(() => mockEventSource.addEventListener('D', any()));
            verifyNever(() => mockEventSource.addEventListener(any(), any()));
          });
        });

        group('simple sub', () {
          late StreamSubscription<ServerSentEvent> subSut;

          setUp(() {
            subSut = streamSut.listen(null);
          });

          test('cancel closes event source', () async {
            await subSut.cancel();

            verify(() => mockEventSource.close());
          });

          group('addEventType', () {
            test('immediatly adds event listener', () {
              const type = 'X';
              streamSut.addEventType(type);

              verify(() => mockEventSource.addEventListener(type, any()));
            });

            test('adds event listener only once', () {
              const type = 'X';
              streamSut..addEventType(type)..addEventType(type);

              verify(
                () => mockEventSource.addEventListener(type, any()),
              ).called(1);
            });
          });

          group('removeEventType', () {
            setUp(() {
              streamSut.addEventType('R');
            });

            test('does nothing if not registered', () {
              final res = streamSut.removeEventType('T');

              expect(res, isFalse);

              verifyNever(
                () => mockEventSource.removeEventListener(any(), any()),
              );
            });

            test('immediatly removes event listener', () {
              final res = streamSut.removeEventType('R');

              expect(res, isTrue);

              verify(() => mockEventSource.removeEventListener('R', any()));
            });

            test('removes event listener only once', () {
              final res1 = streamSut.removeEventType('R');
              final res2 = streamSut.removeEventType('R');

              expect(res1, isTrue);
              expect(res2, isFalse);

              verify(
                () => mockEventSource.removeEventListener('R', any()),
              ).called(1);
            });

            test('removes same handler as the one that was registered', () {
              streamSut.addEventType('L');

              final handler = verify(
                      () => mockEventSource.addEventListener('L', captureAny()))
                  .captured
                  .single as dynamic Function(Event)?;

              streamSut.removeEventType('L');

              verify(() => mockEventSource.removeEventListener('L', handler));
            });
          });
        });

        group('onData', () {
          test('forwards added events', () {
            const eventType = 'test-event';
            final events = [
              MessageEvent(eventType, data: 'event1', lastEventId: '1'),
              MessageEvent('message', data: 'event2'),
              MessageEvent('whatever', data: 'event3', lastEventId: '10'),
            ];

            when(() => mockEventSource.addEventListener(eventType, any()))
                .thenAnswer((i) {
              final handler =
                  i.positionalArguments[1] as dynamic Function(Event);
              for (final event in events) {
                handler(event);
              }
            });

            streamSut.addEventType(eventType);
            expect(
              streamSut,
              emitsInOrder(const <ServerSentEvent>[
                ServerSentEvent(
                  event: eventType,
                  data: 'event1',
                  lastEventId: '1',
                ),
                ServerSentEvent(
                  event: eventType,
                  data: 'event2',
                ),
                ServerSentEvent(
                  event: eventType,
                  data: 'event3',
                  lastEventId: '10',
                ),
              ]),
            );
          });

          test('ignores events when paused', () async {
            final data = <ServerSentEvent>[];
            final sub = (streamSut..addEventType('message')).listen(data.add);

            final handler = verify(() =>
                    mockEventSource.addEventListener('message', captureAny()))
                .captured
                .single as dynamic Function(Event);

            expect(data, isEmpty);

            handler(MessageEvent('message', data: 'data1'));
            await Future<void>.delayed(const Duration(milliseconds: 500));
            expect(data, const [ServerSentEvent(data: 'data1')]);

            sub.pause();

            handler(MessageEvent('message', data: 'data2'));
            await Future<void>.delayed(const Duration(milliseconds: 500));
            expect(data, const [ServerSentEvent(data: 'data1')]);

            sub.resume();

            handler(MessageEvent('message', data: 'data3'));
            await Future<void>.delayed(const Duration(milliseconds: 500));
            expect(data, const [
              ServerSentEvent(data: 'data1'),
              ServerSentEvent(data: 'data3'),
            ]);

            await sub.cancel();
          });
        });
      });
    });
