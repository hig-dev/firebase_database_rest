import 'dart:async';

import 'package:firebase_auth_rest/firebase_auth_rest.dart';
import 'package:firebase_auth_rest/rest.dart' as auth_rest;
import 'package:firebase_database_rest/src/common/api_constants.dart';
import 'package:firebase_database_rest/src/common/timeout.dart';
import 'package:firebase_database_rest/src/database/database.dart';
import 'package:firebase_database_rest/src/database/store_helpers/callback_store.dart';
import 'package:firebase_database_rest/src/rest/rest_api.dart';
import 'package:firebase_database_rest/src/stream/sse_client.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart' hide Timeout;

class MockFirebaseAccount extends Mock implements FirebaseAccount {}

class MockAuthRestApi extends Mock implements auth_rest.RestApi {}

class MockSSEClient extends Mock implements SSEClient {}

class MockRestApi extends Mock implements RestApi {}

class MockIdTokenStream extends Mock implements Stream<String> {}

class MockIdTokenStreamSub extends Mock implements StreamSubscription<String> {}

void main() {
  const testDb = 'test-db';
  final mockFirebaseAccount = MockFirebaseAccount();
  final mockAuthRestApi = MockAuthRestApi();
  final mockSSEClient = MockSSEClient();
  final mockRestApi = MockRestApi();

  setUp(() {
    reset(mockFirebaseAccount);
    reset(mockAuthRestApi);
    reset(mockSSEClient);
    reset(mockRestApi);

    when(() => mockFirebaseAccount.api).thenReturn(mockAuthRestApi);
    when(() => mockFirebaseAccount.idTokenStream)
        .thenAnswer((i) => const Stream.empty());
  });

  group('construction', () {
    group('default', () {
      test('builds database as expected', () {
        const idToken = 'id-token';

        when(() => mockFirebaseAccount.idToken).thenReturn(idToken);
        when(() => mockAuthRestApi.client).thenReturn(mockSSEClient);

        final sut = FirebaseDatabase(
          account: mockFirebaseAccount,
          database: testDb,
        );

        expect(sut.account, mockFirebaseAccount);
        expect(sut.api.client, mockSSEClient);
        expect(sut.api.database, testDb);
        expect(sut.api.basePath, isEmpty);
        expect(sut.api.idToken, idToken);
        expect(sut.api.timeout, isNull);
        expect(sut.api.writeSizeLimit, isNull);
        expect(sut.rootStore, isA<CallbackFirebaseStore>());
        expect(sut.rootStore.restApi, sut.api);
        expect(sut.rootStore.subPaths, isEmpty);

        verify(() => mockFirebaseAccount.idTokenStream);
      });

      test('honors all parameters', () {
        const idToken = 'id-token';
        const basePath = '/base/path';
        const timeout = Timeout.min(5);
        const writeSizeLimit = WriteSizeLimit.medium;

        when(() => mockFirebaseAccount.idToken).thenReturn(idToken);

        final sut = FirebaseDatabase(
          account: mockFirebaseAccount,
          database: testDb,
          basePath: basePath,
          client: mockSSEClient,
          timeout: timeout,
          writeSizeLimit: writeSizeLimit,
        );

        expect(sut.account, mockFirebaseAccount);
        expect(sut.api.client, mockSSEClient);
        expect(sut.api.database, testDb);
        expect(sut.api.basePath, basePath);
        expect(sut.api.idToken, idToken);
        expect(sut.api.timeout, timeout);
        expect(sut.api.writeSizeLimit, writeSizeLimit);
        expect(sut.rootStore, isA<CallbackFirebaseStore>());
        expect(sut.rootStore.restApi, sut.api);
        expect(sut.rootStore.subPaths, isEmpty);

        verify(() => mockFirebaseAccount.idTokenStream);
      });
    });

    group('unauthenticated', () {
      test('builds database as expected', () {
        final sut = FirebaseDatabase.unauthenticated(
          client: mockSSEClient,
          database: testDb,
        );

        expect(sut.account, isNull);
        expect(sut.api.client, mockSSEClient);
        expect(sut.api.database, testDb);
        expect(sut.api.basePath, isEmpty);
        expect(sut.api.idToken, isNull);
        expect(sut.api.timeout, isNull);
        expect(sut.api.writeSizeLimit, isNull);
        expect(sut.rootStore, isA<CallbackFirebaseStore>());
        expect(sut.rootStore.restApi, sut.api);
        expect(sut.rootStore.subPaths, isEmpty);

        verifyNever(() => mockFirebaseAccount.idTokenStream);
      });

      test('honors all parameters', () {
        const basePath = '/base/path';
        const timeout = Timeout.min(5);
        const writeSizeLimit = WriteSizeLimit.medium;

        final sut = FirebaseDatabase.unauthenticated(
          database: testDb,
          basePath: basePath,
          client: mockSSEClient,
          timeout: timeout,
          writeSizeLimit: writeSizeLimit,
        );

        expect(sut.account, isNull);
        expect(sut.api.client, mockSSEClient);
        expect(sut.api.database, testDb);
        expect(sut.api.basePath, basePath);
        expect(sut.api.idToken, isNull);
        expect(sut.api.timeout, timeout);
        expect(sut.api.writeSizeLimit, writeSizeLimit);
        expect(sut.rootStore, isA<CallbackFirebaseStore>());
        expect(sut.rootStore.restApi, sut.api);
        expect(sut.rootStore.subPaths, isEmpty);

        verifyNever(() => mockFirebaseAccount.idTokenStream);
      });
    });

    group('api', () {
      test('builds database as expected', () {
        final sut = FirebaseDatabase.api(mockRestApi);

        expect(sut.account, isNull);
        expect(sut.api, mockRestApi);
        expect(sut.rootStore, isA<CallbackFirebaseStore>());
        expect(sut.rootStore.restApi, mockRestApi);
        expect(sut.rootStore.subPaths, isEmpty);

        verifyNever(() => mockFirebaseAccount.idTokenStream);
      });

      test('registers token stream if account is given', () {
        final sut = FirebaseDatabase.api(
          mockRestApi,
          account: mockFirebaseAccount,
        );

        expect(sut.account, mockFirebaseAccount);
        expect(sut.api, mockRestApi);
        expect(sut.rootStore, isA<CallbackFirebaseStore>());
        expect(sut.rootStore.restApi, mockRestApi);
        expect(sut.rootStore.subPaths, isEmpty);

        verify(() => mockFirebaseAccount.idTokenStream);
      });

      test('updates api idToken if idTokenStream produces one', () async {
        const idToken = 'id-token-update';
        when(() => mockFirebaseAccount.idTokenStream)
            .thenAnswer((i) => Stream.value(idToken));

        FirebaseDatabase.api(
          mockRestApi,
          account: mockFirebaseAccount,
        );

        verify(() => mockFirebaseAccount.idTokenStream);

        await Future<void>.delayed(const Duration(milliseconds: 500));

        verify(() => mockRestApi.idToken = idToken);
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

    test('dispose cancels stream', () async {
      final mockStream = MockIdTokenStream();
      final mockStreamSub = MockIdTokenStreamSub();

      when(() => mockStreamSub.cancel()).thenAnswer((i) async {});
      when(() => mockStream.listen(
            any(),
            onError: any(named: 'onError'),
            onDone: any(named: 'onDone'),
            cancelOnError: any(named: 'cancelOnError'),
          )).thenReturn(mockStreamSub);
      when(() => mockFirebaseAccount.idTokenStream)
          .thenAnswer((i) => mockStream);

      final sut = FirebaseDatabase.api(
        mockRestApi,
        account: mockFirebaseAccount,
      );

      verify(() => mockStream.listen(any(), cancelOnError: false));

      await sut.dispose();

      verify(() => mockStreamSub.cancel());
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
