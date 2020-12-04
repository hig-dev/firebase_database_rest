import 'package:firebase_database_rest/src/models/api_constants.dart';
import 'package:firebase_database_rest/src/models/db_response.dart';
import 'package:firebase_database_rest/src/rest_api.dart';
import 'package:firebase_database_rest/src/store.dart';
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

  FirebaseStore<int> sut;

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

        expect(result, <String>[]);
        verify(mockRestApi.get(
          path: path,
          shallow: true,
          // ignore: avoid_redundant_argument_values
          eTag: false,
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
        final result = await sut.keys(eTagReceiver: ETagReceiver());

        expect(result, <String>[]);
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

        expect(result, <String>[]);
        expect(receiver.eTag, 'TAG');
      });
    });
  });
}
