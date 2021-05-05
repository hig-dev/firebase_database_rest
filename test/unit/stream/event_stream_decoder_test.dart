import 'dart:async';

import 'package:firebase_database_rest/src/stream/event_stream_decoder.dart';
import 'package:firebase_database_rest/src/stream/server_sent_event.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:tuple/tuple.dart';

import '../../test_data.dart';

class MockSSESink extends Mock implements EventSink<ServerSentEvent> {}

void main() {
  setUpAll(() {
    registerFallbackValue(const ServerSentEvent(data: ''));
  });

  group('EventStreamDecoderSink', () {
    final mockSSESink = MockSSESink();

    late EventStreamDecoderSink sut;

    setUp(() {
      reset(mockSSESink);

      sut = EventStreamDecoderSink(mockSSESink);
    });

    group('add', () {
      testData<Tuple2<List<String>, ServerSentEvent?>>(
        'generate correct events',
        const [
          // empty
          Tuple2([], null),
          Tuple2([':comment'], null),
          // data
          Tuple2(
            ['data: data'],
            ServerSentEvent(event: 'message', data: 'data'),
          ),
          Tuple2(
            ['data:data'],
            ServerSentEvent(event: 'message', data: 'data'),
          ),
          Tuple2(
            ['data:  data   '],
            ServerSentEvent(event: 'message', data: ' data   '),
          ),
          Tuple2(
            ['data'],
            ServerSentEvent(event: 'message', data: ''),
          ),
          Tuple2(
            ['data: data1', 'data: data2', 'data', 'data: data3'],
            ServerSentEvent(event: 'message', data: 'data1\ndata2\n\ndata3'),
          ),
          Tuple2(
            [':comment', 'data: data'],
            ServerSentEvent(event: 'message', data: 'data'),
          ),
          // event
          Tuple2(['event: event'], null),
          Tuple2(
            ['event: event', 'data: data'],
            ServerSentEvent(event: 'event', data: 'data'),
          ),
          Tuple2(
            ['event:event', 'data: data'],
            ServerSentEvent(event: 'event', data: 'data'),
          ),
          Tuple2(
            ['event:  event   ', 'data: data'],
            ServerSentEvent(event: ' event   ', data: 'data'),
          ),
          Tuple2(
            ['event', 'data: data'],
            ServerSentEvent(event: 'message', data: 'data'),
          ),
          Tuple2(
            ['data: data', 'event: event'],
            ServerSentEvent(event: 'event', data: 'data'),
          ),
          Tuple2(
            ['event: event1', 'event: event2', 'data: data'],
            ServerSentEvent(event: 'event2', data: 'data'),
          ),
          Tuple2(
            [':comment', 'event: event', 'data: data'],
            ServerSentEvent(event: 'event', data: 'data'),
          ),
          // id
          Tuple2(['id: id'], null),
          Tuple2(
            ['data: data', 'id: id'],
            ServerSentEvent(event: 'message', data: 'data', lastEventId: 'id'),
          ),
          Tuple2(
            ['data: data', 'id:id'],
            ServerSentEvent(event: 'message', data: 'data', lastEventId: 'id'),
          ),
          Tuple2(
            ['data: data', 'id:  id  '],
            ServerSentEvent(
                event: 'message', data: 'data', lastEventId: ' id  '),
          ),
          Tuple2(
            ['data: data', 'id'],
            ServerSentEvent(event: 'message', data: 'data'),
          ),
          Tuple2(
            ['data: data', 'id: id1', 'id: id2'],
            ServerSentEvent(event: 'message', data: 'data', lastEventId: 'id2'),
          ),
          Tuple2(
            [':comment', 'data: data', 'id: id'],
            ServerSentEvent(event: 'message', data: 'data', lastEventId: 'id'),
          ),
        ],
        (fixture) {
          fixture.item1.forEach(sut.add);
          sut.add(''); // complete event

          if (fixture.item2 != null) {
            verify(() => mockSSESink.add(fixture.item2!));
            verifyNoMoreInteractions(mockSSESink);
          } else {
            verifyZeroInteractions(mockSSESink);
          }
        },
      );

      test('clears data and event type between events', () {
        sut
          ..add('data: d1')
          ..add('data: d2')
          ..add('event: e1')
          ..add('')
          ..add('data: d3')
          ..add('');

        verify(
          () => mockSSESink
              .add(const ServerSentEvent(data: 'd1\nd2', event: 'e1')),
        );
        verify(
          () => mockSSESink
              .add(const ServerSentEvent(data: 'd3', event: 'message')),
        );
      });

      test('keeps last event id until cleared', () {
        sut
          ..add('data: d1')
          ..add('id: id1')
          ..add('')
          ..add('data: d2')
          ..add('')
          ..add('data: d3')
          ..add('id')
          ..add('');

        verify(
          () => mockSSESink
              .add(const ServerSentEvent(data: 'd1', lastEventId: 'id1')),
        );
        verify(
          () => mockSSESink
              .add(const ServerSentEvent(data: 'd2', lastEventId: 'id1')),
        );
        verify(
          () => mockSSESink.add(const ServerSentEvent(data: 'd3')),
        );
      });
    });

    test('addError forwards addError event', () async {
      const error = 'error';
      final trace = StackTrace.current;

      sut.addError(error, trace);

      verify(() => mockSSESink.addError(error, trace));
    });

    group('close', () {
      test('forwards close event', () {
        sut.close();

        verify(() => mockSSESink.close());
      });

      test('does not complete partial events', () {
        sut
          ..add('data: d1')
          ..close();

        verifyNever(() => mockSSESink.add(any()));
      });
    });
  });

  group('EventStreamDecoder', () {
    late EventStreamDecoder sut;

    setUp(() {
      // ignore: prefer_const_constructors
      sut = EventStreamDecoder();
    });

    test('bind creates eventTransformed stream', () async {
      final boundStream = sut.bind(Stream.fromIterable(
        const ['data: data', ''],
      ));

      final res = await boundStream.single;

      expect(res, const ServerSentEvent(data: 'data'));
    });

    test('cast returns transformed instance', () {
      final castTransformer = sut.cast<String, ServerSentEvent>();
      expect(castTransformer, isNotNull);
    });
  });
}
