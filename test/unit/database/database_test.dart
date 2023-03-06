import 'package:firebase_database_rest/src/common/api_constants.dart';
import 'package:firebase_database_rest/src/common/timeout.dart';
import 'package:firebase_database_rest/src/database/database.dart';
import 'package:firebase_database_rest/src/database/store_helpers/callback_store.dart';
import 'package:firebase_database_rest/src/rest/rest_api.dart';
import 'package:firebase_database_rest/src/stream/sse_client.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart' hide Timeout;

class MockSSEClient extends Mock implements SSEClient {}

class MockRestApi extends Mock implements RestApi {}

void main() {
  const testDb = 'test-db';
  final mockSSEClient = MockSSEClient();
  final mockRestApi = MockRestApi();

  setUp(() {
    reset(mockSSEClient);
    reset(mockRestApi);
  });

  group('construction', () {
    group('default', () {
      test('builds database as expected', () {
        final sut = FirebaseDatabase(
          client: mockSSEClient,
          database: testDb,
        );

        expect(sut.api.client, mockSSEClient);
        expect(sut.api.database, testDb);
        expect(sut.api.basePath, isEmpty);
        expect(sut.api.idToken, null);
        expect(sut.api.timeout, isNull);
        expect(sut.api.writeSizeLimit, isNull);
        expect(sut.rootStore, isA<CallbackFirebaseStore>());
        expect(sut.rootStore.restApi, sut.api);
        expect(sut.rootStore.subPaths, isEmpty);
      });

      test('honors all parameters', () {
        const basePath = '/base/path';
        const timeout = Timeout.min(5);
        const writeSizeLimit = WriteSizeLimit.medium;

        final sut = FirebaseDatabase(
          database: testDb,
          basePath: basePath,
          client: mockSSEClient,
          timeout: timeout,
          writeSizeLimit: writeSizeLimit,
        );

        expect(sut.api.client, mockSSEClient);
        expect(sut.api.database, testDb);
        expect(sut.api.basePath, basePath);
        expect(sut.api.idToken, null);
        expect(sut.api.timeout, timeout);
        expect(sut.api.writeSizeLimit, writeSizeLimit);
        expect(sut.rootStore, isA<CallbackFirebaseStore>());
        expect(sut.rootStore.restApi, sut.api);
        expect(sut.rootStore.subPaths, isEmpty);
      });
    });

    group('unauthenticated', () {
      test('builds database as expected', () {
        final sut = FirebaseDatabase(
          client: mockSSEClient,
          database: testDb,
        );

        expect(sut.api.client, mockSSEClient);
        expect(sut.api.database, testDb);
        expect(sut.api.basePath, isEmpty);
        expect(sut.api.idToken, isNull);
        expect(sut.api.timeout, isNull);
        expect(sut.api.writeSizeLimit, isNull);
        expect(sut.rootStore, isA<CallbackFirebaseStore>());
        expect(sut.rootStore.restApi, sut.api);
        expect(sut.rootStore.subPaths, isEmpty);
      });

      test('honors all parameters', () {
        const basePath = '/base/path';
        const timeout = Timeout.min(5);
        const writeSizeLimit = WriteSizeLimit.medium;

        final sut = FirebaseDatabase(
          database: testDb,
          basePath: basePath,
          client: mockSSEClient,
          timeout: timeout,
          writeSizeLimit: writeSizeLimit,
        );

        expect(sut.api.client, mockSSEClient);
        expect(sut.api.database, testDb);
        expect(sut.api.basePath, basePath);
        expect(sut.api.idToken, isNull);
        expect(sut.api.timeout, timeout);
        expect(sut.api.writeSizeLimit, writeSizeLimit);
        expect(sut.rootStore, isA<CallbackFirebaseStore>());
        expect(sut.rootStore.restApi, sut.api);
        expect(sut.rootStore.subPaths, isEmpty);
      });
    });

    group('api', () {
      test('builds database as expected', () {
        final sut = FirebaseDatabase.api(mockRestApi);

        expect(sut.api, mockRestApi);
        expect(sut.rootStore, isA<CallbackFirebaseStore>());
        expect(sut.rootStore.restApi, mockRestApi);
        expect(sut.rootStore.subPaths, isEmpty);
      });
    });

    test('rootStore simply returns data as is', () {
      final sut = FirebaseDatabase.api(mockRestApi);

      expect(
        sut.rootStore.dataFromJson(const [1, true, '3']),
        const [1, true, '3'],
      );
      expect(
        sut.rootStore.dataToJson(const [<String>[], 1.5, null]),
        const [<String>[], 1.5, null],
      );
      expect(
        sut.rootStore.patchData(
          <String, dynamic>{
            'a': 1,
            'b': false,
            'c': {'x': 1, 'y': 2},
          },
          const <String, dynamic>{
            'b': null,
            'c': [1, 2, 3],
            'd': '42',
          },
        ),
        const <String, dynamic>{
          'a': 1,
          'b': null,
          'c': [1, 2, 3],
          'd': '42',
        },
      );
    });

    test('createRootStore creates a typed variant', () {
      final sut = FirebaseDatabase.api(mockRestApi);

      final store = sut.createRootStore<int>(
        onDataFromJson: (dynamic json) => (json as int) + 1,
        onDataToJson: (data) => data - 1,
        onPatchData: (data, updatedFields) => data * 2,
      );

      expect(store.restApi, mockRestApi);
      expect(store.subPaths, isEmpty);

      expect(store.dataFromJson(10), 11);
      expect(store.dataToJson(10), 9);
      expect(store.patchData(10, const <String, dynamic>{}), 20);
    });
  });
}
