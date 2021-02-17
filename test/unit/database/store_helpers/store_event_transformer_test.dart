import 'dart:async';

import 'package:firebase_database_rest/src/database/auth_revoked_exception.dart';
import 'package:firebase_database_rest/src/database/store_event.dart';
import 'package:firebase_database_rest/src/database/store_helpers/store_event_transformer.dart';
import 'package:firebase_database_rest/src/rest/models/stream_event.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:tuple/tuple.dart';

import '../../../test_data.dart';
import 'store_event_transformer_test.mocks.dart';

part 'store_event_transformer_test.freezed.dart';
part 'store_event_transformer_test.g.dart';

@freezed
abstract class TestModel with _$TestModel {
  const factory TestModel(int id, String data) = _TestModel;

  factory TestModel.fromJson(Map<String, dynamic> json) =>
      _$TestModelFromJson(json);
}

@freezed
abstract class TestModelPatchSet
    implements _$TestModelPatchSet, PatchSet<TestModel> {
  const TestModelPatchSet._();

  // ignore: sort_unnamed_constructors_first
  const factory TestModelPatchSet(Map<String, dynamic> data) =
      _TestModelPatchSet;

  @override
  TestModel apply(TestModel value) => throw UnimplementedError();
}

abstract class StoreEventSink extends EventSink<StoreEvent<TestModel>> {}

@GenerateMocks([], customMocks: [
  MockSpec<StoreEventSink>(returnNullOnMissingStub: true),
])
void main() {
  group('StoreEventTransformerSink', () {
    final mockStoreEventSink = MockStoreEventSink();

    late StoreEventTransformerSink<TestModel> sut;

    setUp(() {
      reset(mockStoreEventSink);

      sut = StoreEventTransformerSink<TestModel>(
        outSink: mockStoreEventSink,
        dataFromJson: (dynamic json) =>
            TestModel.fromJson(json as Map<String, dynamic>),
        patchSetFactory: (data) => TestModelPatchSet(data),
      );
    });

    tearDown(() {
      sut.close();
    });

    group('add', () {
      testData<Tuple2<StreamEvent, StoreEvent<TestModel>>>(
        'maps events correctly',
        const [
          Tuple2(
            StreamEvent.put(
              path: '/',
              data: {
                'a': {'id': 1, 'data': 'A'},
                'b': {'id': 2, 'data': 'B'},
                'c': {'id': 3, 'data': 'C'},
                'd': null,
              },
            ),
            StoreEvent.reset({
              'a': TestModel(1, 'A'),
              'b': TestModel(2, 'B'),
              'c': TestModel(3, 'C'),
            }),
          ),
          Tuple2(
            StreamEvent.put(
              path: '/',
              data: null,
            ),
            StoreEvent.reset({}),
          ),
          Tuple2(
            StreamEvent.put(
              path: '/d',
              data: {'id': 4, 'data': 'D'},
            ),
            StoreEvent.put('d', TestModel(4, 'D')),
          ),
          Tuple2(
            StreamEvent.put(
              path: '/e',
              data: null,
            ),
            StoreEvent.delete('e'),
          ),
          Tuple2(
            StreamEvent.put(
              path: '/f/id',
              data: 6,
            ),
            StoreEvent.invalidPath('/f/id'),
          ),
          Tuple2(
            StreamEvent.patch(
              path: '/g',
              data: {'data': 'G'},
            ),
            StoreEvent.patch(
              'g',
              TestModelPatchSet(<String, dynamic>{'data': 'G'}),
            ),
          ),
          Tuple2(
            StreamEvent.patch(
              path: '/h/data',
              data: 'H',
            ),
            StoreEvent.invalidPath('/h/data'),
          ),
        ],
        (fixture) {
          sut.add(fixture.item1);
          verify(mockStoreEventSink.add(fixture.item2));
          verifyNoMoreInteractions(mockStoreEventSink);
        },
      );

      test('maps auth revoked to error', () {
        sut.add(const StreamEvent.authRevoked());
        verify(
          mockStoreEventSink.addError(argThat(isA<AuthRevokedException>())),
        );
        verifyNoMoreInteractions(mockStoreEventSink);
      });
    });

    test('addError forwards addError event', () async {
      const error = 'error';
      final trace = StackTrace.current;

      sut.addError(error, trace);

      verify(mockStoreEventSink.addError(error, trace));
    });

    test('close forwards close event', () {
      sut.close();

      verify(mockStoreEventSink.close());
    });
  });

  group('StoreEventTransformer', () {
    late StoreEventTransformer sut;

    setUp(() {
      sut = StoreEventTransformer<TestModel>(
        dataFromJson: (dynamic json) =>
            TestModel.fromJson(json as Map<String, dynamic>),
        patchSetFactory: (data) => TestModelPatchSet(data),
      );
    });

    test('bind creates eventTransformed stream', () async {
      final boundStream = sut.bind(Stream.fromIterable(const [
        StreamEvent.put(
          path: '/x',
          data: {'id': 42, 'data': 'X'},
        ),
      ]));

      final res = await boundStream.single;

      expect(res, const StoreEvent.put('x', TestModel(42, 'X')));
    });

    test('cast returns transformed instance', () {
      final castTransformer = sut.cast<StreamEvent, StoreEvent<TestModel>>();
      expect(castTransformer, isNotNull);
    });
  });
}
