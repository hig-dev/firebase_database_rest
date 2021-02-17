import 'dart:async';

import 'package:firebase_database_rest/src/database/auth_revoked_exception.dart';
import 'package:firebase_database_rest/src/database/patch_on_null_error.dart';
import 'package:firebase_database_rest/src/database/store_event.dart';
import 'package:firebase_database_rest/src/database/store_helpers/store_value_event_transformer.dart';
import 'package:firebase_database_rest/src/rest/models/stream_event.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:tuple/tuple.dart';

import '../../test_data.dart';
import 'store_value_event_transformer_test.mocks.dart';

part 'store_value_event_transformer_test.freezed.dart';
part 'store_value_event_transformer_test.g.dart';

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
  TestModel apply(TestModel value) => TestModel(
        data['id'] as int? ?? value.id,
        data['data'] as String? ?? value.data,
      );
}

abstract class ValueEventSink extends EventSink<ValueEvent<TestModel>> {}

@GenerateMocks([], customMocks: [
  MockSpec<ValueEventSink>(returnNullOnMissingStub: true),
])
void main() {
  group('StoreValueEventTransformerSink', () {
    final mockValueEventSink = MockValueEventSink();

    late StoreValueEventTransformerSink<TestModel> sut;

    setUp(() {
      reset(mockValueEventSink);

      sut = StoreValueEventTransformerSink<TestModel>(
        outSink: mockValueEventSink,
        dataFromJson: (dynamic json) => json != null
            ? TestModel.fromJson(json as Map<String, dynamic>)
            : null,
        patchSetFactory: (data) => TestModelPatchSet(data),
      );
    });

    tearDown(() {
      sut.close();
    });

    group('add', () {
      testData<Tuple3<StreamEvent, ValueEvent<TestModel>, TestModel?>>(
        'maps events correctly',
        const [
          Tuple3(
            StreamEvent.put(path: '/', data: {'id': 1, 'data': 'A'}),
            ValueEvent.update(TestModel(1, 'A')),
            null,
          ),
          Tuple3(
            StreamEvent.put(path: '/', data: null),
            ValueEvent.delete(),
            null,
          ),
          Tuple3(
            StreamEvent.put(path: '/id', data: 3),
            ValueEvent.invalidPath('/id'),
            null,
          ),
          Tuple3(
            StreamEvent.patch(path: '/', data: {'data': 'D'}),
            ValueEvent.update(TestModel(4, 'D')),
            TestModel(4, 'A'),
          ),
          Tuple3(
            StreamEvent.patch(path: '/data', data: 'E'),
            ValueEvent.invalidPath('/data'),
            null,
          ),
        ],
        (fixture) {
          if (fixture.item3 != null) {
            sut.add(StreamEvent.put(path: '/', data: fixture.item3!.toJson()));
            clearInteractions(mockValueEventSink);
          }

          sut.add(fixture.item1);
          verify(mockValueEventSink.add(fixture.item2));
          verifyNoMoreInteractions(mockValueEventSink);
        },
      );

      test('maps patch on null to error', () {
        sut.add(const StreamEvent.patch(path: '/', data: {'data': 'F'}));
        verify(
          mockValueEventSink.addError(argThat(isA<PatchOnNullError>())),
        );
        verifyNoMoreInteractions(mockValueEventSink);
      });

      test('maps auth revoked to error', () {
        sut.add(const StreamEvent.authRevoked());
        verify(
          mockValueEventSink.addError(argThat(isA<AuthRevokedException>())),
        );
        verifyNoMoreInteractions(mockValueEventSink);
      });
    });

    test('addError forwards addError event', () async {
      const error = 'error';
      final trace = StackTrace.current;

      sut.addError(error, trace);

      verify(mockValueEventSink.addError(error, trace));
    });

    test('close forwards close event', () {
      sut.close();

      verify(mockValueEventSink.close());
    });
  });

  group('StoreEventTransformer', () {
    late StoreValueEventTransformer sut;

    setUp(() {
      sut = StoreValueEventTransformer<TestModel>(
        dataFromJson: (dynamic json) => json != null
            ? TestModel.fromJson(json as Map<String, dynamic>)
            : null,
        patchSetFactory: (data) => TestModelPatchSet(data),
      );
    });

    test('bind creates eventTransformed stream', () async {
      final boundStream = sut.bind(Stream.fromIterable(const [
        StreamEvent.put(
          path: '/',
          data: {'id': 42, 'data': 'X'},
        ),
      ]));

      final res = await boundStream.single;

      expect(res, const ValueEvent.update(TestModel(42, 'X')));
    });

    test('cast returns transformed instance', () {
      final castTransformer = sut.cast<StreamEvent, ValueEvent<TestModel>>();
      expect(castTransformer, isNotNull);
    });
  });
}
