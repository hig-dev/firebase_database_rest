import 'dart:async';

import 'package:firebase_database_rest/src/common/api_constants.dart';
import 'package:firebase_database_rest/src/common/db_exception.dart';
import 'package:firebase_database_rest/src/rest/models/stream_event.dart';
import 'package:firebase_database_rest/src/rest/models/unknown_stream_event_error.dart';
import 'package:firebase_database_rest/src/rest/stream_event_transformer.dart';
import 'package:firebase_database_rest/src/stream/server_sent_event.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:tuple/tuple.dart';

import '../../test_data.dart';

class MockStreamEventSink extends Mock implements EventSink<StreamEvent> {}

void main() {
  group('StreamEventTransformerSink', () {
    final mockStreamEventSink = MockStreamEventSink();

    late StreamEventTransformerSink sut;

    setUp(() {
      reset(mockStreamEventSink);

      sut = StreamEventTransformerSink(mockStreamEventSink);
    });

    tearDown(() {
      sut.close();
    });

    group('add', () {
      testData<Tuple2<ServerSentEvent, StreamEvent?>>(
        'maps events correctly',
        const [
          Tuple2(
            ServerSentEvent(event: 'put', data: '{"path": "p", "data": null}'),
            StreamEvent.put(path: 'p', data: null),
          ),
          Tuple2(
            ServerSentEvent(event: 'put', data: '{"path": "p", "data": true}'),
            StreamEvent.put(path: 'p', data: true),
          ),
          Tuple2(
            ServerSentEvent(event: 'put', data: '{"path": "p", "data": [1,2]}'),
            StreamEvent.put(path: 'p', data: [1, 2]),
          ),
          Tuple2(
            ServerSentEvent(event: 'patch', data: '{"path": "p", "data": 0}'),
            StreamEvent.patch(path: 'p', data: 0),
          ),
          Tuple2(
            ServerSentEvent(event: 'patch', data: '{"path": "p", "data": "X"}'),
            StreamEvent.patch(path: 'p', data: 'X'),
          ),
          Tuple2(
            ServerSentEvent(event: 'keep-alive', data: 'null'),
            null,
          ),
          Tuple2(
            ServerSentEvent(event: 'auth_revoked', data: 'null'),
            StreamEvent.authRevoked(),
          ),
        ],
        (fixture) {
          sut.add(fixture.item1);
          if (fixture.item2 != null) {
            verify(() => mockStreamEventSink.add(fixture.item2!));
            verifyNoMoreInteractions(mockStreamEventSink);
          } else {
            verifyZeroInteractions(mockStreamEventSink);
          }
        },
      );

      test('maps cancel event to DbException', () {
        sut.add(const ServerSentEvent(event: 'cancel', data: 'error message'));

        verify(() => mockStreamEventSink.addError(const DbException(
              statusCode: ApiConstants.eventStreamCanceled,
              error: 'error message',
            )));
        verifyNoMoreInteractions(mockStreamEventSink);
      });

      test('maps unknows events to UnknownStreamEventError', () {
        const event = ServerSentEvent(
          event: 'unsupported',
          data: 'unsupported event',
          lastEventId: '42',
        );
        sut.add(event);

        verify(
          () => mockStreamEventSink.addError(
            any(that: predicate((e) {
              final err = e! as UnknownStreamEventError;
              return err.event == event;
            })),
          ),
        );
        verifyNoMoreInteractions(mockStreamEventSink);
      });
    });

    test('addError forwards addError event', () async {
      const error = 'error';
      final trace = StackTrace.current;

      sut.addError(error, trace);

      verify(() => mockStreamEventSink.addError(error, trace));
    });

    test('close forwards close event', () {
      sut.close();

      verify(() => mockStreamEventSink.close());
    });
  });

  group('StreamEventTransformer', () {
    late StreamEventTransformer sut;

    setUp(() {
      // ignore: prefer_const_constructors
      sut = StreamEventTransformer();
    });

    test('bind creates eventTransformed stream', () async {
      final boundStream = sut.bind(Stream.fromIterable(const [
        ServerSentEvent(
          event: 'put',
          data: '{"path": "path", "data": "data"}',
        ),
      ]));

      final res = await boundStream.single;

      expect(res, const StreamEvent.put(path: 'path', data: 'data'));
    });

    test('cast returns transformed instance', () {
      final castTransformer = sut.cast<ServerSentEvent, StreamEvent>();
      expect(castTransformer, isNotNull);
    });
  });
}
