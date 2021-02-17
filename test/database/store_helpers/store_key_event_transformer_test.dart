import 'dart:async';

import 'package:firebase_database_rest/src/database/auth_revoked_exception.dart';
import 'package:firebase_database_rest/src/database/store_event.dart';
import 'package:firebase_database_rest/src/database/store_helpers/store_key_event_transformer.dart';
import 'package:firebase_database_rest/src/rest/models/stream_event.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:tuple/tuple.dart';

import '../../test_data.dart';
import 'store_key_event_transformer_test.mocks.dart';

abstract class KeyEventSink extends EventSink<KeyEvent> {}

@GenerateMocks([], customMocks: [
  MockSpec<KeyEventSink>(returnNullOnMissingStub: true),
])
void main() {
  group('StoreKeyEventTransformerSink', () {
    final mockKeyEventSink = MockKeyEventSink();

    late StoreKeyEventTransformerSink sut;

    setUp(() {
      reset(mockKeyEventSink);

      sut = StoreKeyEventTransformerSink(mockKeyEventSink);
    });

    tearDown(() {
      sut.close();
    });

    group('add', () {
      testData<Tuple2<StreamEvent, KeyEvent>>(
        'maps events correctly',
        const [
          Tuple2(
            StreamEvent.put(
              path: '/',
              data: {
                'a': 1,
                'b': 2,
                'c': 3,
                'd': null,
              },
            ),
            KeyEvent.reset(['a', 'b', 'c']),
          ),
          Tuple2(
            StreamEvent.put(
              path: '/',
              data: null,
            ),
            KeyEvent.reset([]),
          ),
          Tuple2(
            StreamEvent.put(
              path: '/d',
              data: 4,
            ),
            KeyEvent.update('d'),
          ),
          Tuple2(
            StreamEvent.put(
              path: '/e',
              data: null,
            ),
            KeyEvent.delete('e'),
          ),
          Tuple2(
            StreamEvent.put(
              path: '/f/id',
              data: 6,
            ),
            KeyEvent.invalidPath('/f/id'),
          ),
          Tuple2(
            StreamEvent.patch(
              path: '/g',
              data: 7,
            ),
            KeyEvent.update('g'),
          ),
          Tuple2(
            StreamEvent.patch(
              path: '/h/data',
              data: 8,
            ),
            KeyEvent.invalidPath('/h/data'),
          ),
        ],
        (fixture) {},
      );

      test('maps auth revoked to error', () {
        sut.add(const StreamEvent.authRevoked());
        verify(
          mockKeyEventSink.addError(argThat(isA<AuthRevokedException>())),
        );
        verifyNoMoreInteractions(mockKeyEventSink);
      });
    });

    test('addError forwards addError event', () async {
      const error = 'error';
      final trace = StackTrace.current;

      sut.addError(error, trace);

      verify(mockKeyEventSink.addError(error, trace));
    });

    test('close forwards close event', () {
      sut.close();

      verify(mockKeyEventSink.close());
    });
  });

  group('StoreEventTransformer', () {
    late StoreKeyEventTransformer sut;

    setUp(() {
      sut = const StoreKeyEventTransformer();
    });

    test('bind creates eventTransformed stream', () async {
      final boundStream = sut.bind(Stream.fromIterable(const [
        StreamEvent.put(
          path: '/x',
          data: 42,
        ),
      ]));

      final res = await boundStream.single;

      expect(res, const KeyEvent.update('x'));
    });

    test('cast returns transformed instance', () {
      final castTransformer = sut.cast<StreamEvent, KeyEvent>();
      expect(castTransformer, isNotNull);
    });
  });
}
