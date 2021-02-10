import 'package:firebase_database_rest/src/database/etag_receiver.dart';
import 'package:firebase_database_rest/src/database/store.dart';
import 'package:firebase_database_rest/src/rest/models/db_response.dart';
import 'package:firebase_database_rest/src/rest/rest_api.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'store_test.mocks.dart';

@GenerateMocks([
  RestApi,
])
void main() {
  const path = 'base/path/x';
  final mockRestApi = MockRestApi();

  late FirebaseStore<int> sut;

  PostExpectation<Future<DbResponse>> _whenGet() => when(mockRestApi.get(
        path: anyNamed('path'),
        printMode: anyNamed('printMode'),
        formatMode: anyNamed('formatMode'),
        shallow: anyNamed('shallow'),
        filter: anyNamed('filter'),
        eTag: anyNamed('eTag'),
      ));

  setUp(() {
    reset(mockRestApi);

    _whenGet().thenAnswer((i) async => const DbResponse(data: null));

    sut = FirebaseStore<int>.apiCreate(
      restApi: mockRestApi,
      subPaths: ['base', 'path/x'],
      onDataFromJson: (dynamic json) => json as int,
      onDataToJson: (data) => data,
      onPatchData: (data, updatedFields) => data,
    );
  });

  group('methods', () {
    group('keys', () {
      test('calls api.get', () async {
        final result = await sut.keys();

        expect(result, isEmpty);
        verify(mockRestApi.get(
          path: path,
          shallow: true,
        ));
      });

      test('returns json keys as list', () async {
        _whenGet().thenAnswer(
          (i) async => const DbResponse(data: {
            'a': true,
            'b': 42,
            'c': 'cee',
            'd': [1, 2, 3],
            'e': {
              'x': 1.0,
              'y': 0.1,
            }
          }),
        );

        final result = await sut.keys();
        expect(result, ['a', 'b', 'c', 'd', 'e']);
      });

      test('requests eTag with etag receiver set', () async {
        _whenGet().thenAnswer(
          (i) async => const DbResponse(data: null, eTag: 'TAG'),
        );
        final result = await sut.keys(eTagReceiver: ETagReceiver());

        expect(result, isEmpty);
        verify(mockRestApi.get(
          path: path,
          shallow: true,
          eTag: true,
        ));
      });

      test('sets ETag on receiver', () async {
        _whenGet().thenAnswer(
          (i) async => const DbResponse(data: null, eTag: 'TAG'),
        );

        final receiver = ETagReceiver();
        final result = await sut.keys(eTagReceiver: receiver);

        expect(result, isEmpty);
        expect(receiver.eTag, 'TAG');
      });
    });

    group('all', () {
      test('calls api.get', () async {
        final result = await sut.all();

        expect(result, isEmpty);
        verify(mockRestApi.get(
          path: path,
        ));
      });

      test('returns json data as map', () async {
        _whenGet().thenAnswer(
          (i) async => const DbResponse(data: {
            'a': 1,
            'b': 2,
            'c': 3,
          }),
        );

        final result = await sut.all();
        expect(result, {
          'a': 1,
          'b': 2,
          'c': 3,
        });
      });

      test('throws if conversion fails', () async {
        _whenGet().thenAnswer(
          (i) async => const DbResponse(data: {
            'a': 1,
            'b': 2.0,
            'c': 3,
          }),
        );

        expect(() => sut.all(), throwsA(isA<TypeError>()));
      });

      test('requests eTag with etag receiver set', () async {
        _whenGet().thenAnswer(
          (i) async => const DbResponse(data: null, eTag: 'TAG'),
        );
        final result = await sut.all(eTagReceiver: ETagReceiver());

        expect(result, isEmpty);
        verify(mockRestApi.get(
          path: path,
          eTag: true,
        ));
      });

      test('sets ETag on receiver', () async {
        _whenGet().thenAnswer(
          (i) async => const DbResponse(data: null, eTag: 'TAG'),
        );

        final receiver = ETagReceiver();
        final result = await sut.all(eTagReceiver: receiver);

        expect(result, isEmpty);
        expect(receiver.eTag, 'TAG');
      });
    });
  });
}
