import 'package:firebase_database_rest/src/common/api_constants.dart';
import 'package:firebase_database_rest/src/common/filter.dart';
import 'package:firebase_database_rest/src/database/etag_receiver.dart';
import 'package:firebase_database_rest/src/database/store.dart';
import 'package:firebase_database_rest/src/database/store_event.dart';
import 'package:firebase_database_rest/src/database/store_helpers/callback_store.dart';
import 'package:firebase_database_rest/src/rest/models/db_response.dart';
import 'package:firebase_database_rest/src/rest/models/stream_event.dart';
import 'package:firebase_database_rest/src/rest/rest_api.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

part 'store_test.freezed.dart';
part 'store_test.g.dart';

@freezed
class TestModel with _$TestModel {
  const factory TestModel(int id, String data) = _TestModel;

  factory TestModel.fromJson(Map<String, dynamic> json) => _$TestModelFromJson(json);
}

class MockRestApi extends Mock implements RestApi {}

class MockParentStore extends Mock implements FirebaseStore<dynamic> {}

class ConstructorTestStore extends FirebaseStore<int> {
  ConstructorTestStore({
    required FirebaseStore<dynamic> parent,
    required String path,
  }) : super(
          parent: parent,
          path: path,
        );

  ConstructorTestStore.api({
    required RestApi restApi,
    required List<String> subPaths,
  }) : super.api(
          restApi: restApi,
          subPaths: subPaths,
        );

  @override
  int dataFromJson(dynamic json) {
    throw UnimplementedError();
  }

  @override
  dynamic dataToJson(int data) {
    throw UnimplementedError();
  }

  @override
  int patchData(int data, Map<String, dynamic> updatedFields) {
    throw UnimplementedError();
  }
}

void main() {
  final mockRestApi = MockRestApi();

  When<Future<DbResponse>> _whenGet() => when(() => mockRestApi.get(
        path: any(named: 'path'),
        printMode: any(named: 'printMode'),
        formatMode: any(named: 'formatMode'),
        shallow: any(named: 'shallow'),
        filter: any(named: 'filter'),
        eTag: any(named: 'eTag'),
      ));

  When<Future<DbResponse>> _whenPut() => when(() => mockRestApi.put(
        any<dynamic>(),
        path: any(named: 'path'),
        printMode: any(named: 'printMode'),
        eTag: any(named: 'eTag'),
        ifMatch: any(named: 'ifMatch'),
      ));

  When<Future<DbResponse>> _whenPost() => when(() => mockRestApi.post(
        any<dynamic>(),
        path: any(named: 'path'),
        printMode: any(named: 'printMode'),
        eTag: any(named: 'eTag'),
      ));

  When<Future<DbResponse>> _whenPatch() => when(() => mockRestApi.patch(
        any(),
        path: any(named: 'path'),
        printMode: any(named: 'printMode'),
      ));

  When<Future<DbResponse>> _whenDelete() => when(() => mockRestApi.delete(
        path: any(named: 'path'),
        printMode: any(named: 'printMode'),
        eTag: any(named: 'eTag'),
        ifMatch: any(named: 'ifMatch'),
      ));

  When<Future<Stream<StreamEvent>>> _whenStream() => when(() => mockRestApi.stream(
        path: any(named: 'path'),
        printMode: any(named: 'printMode'),
        formatMode: any(named: 'formatMode'),
        shallow: any(named: 'shallow'),
        filter: any(named: 'filter'),
      ));

  setUp(() {
    reset(mockRestApi);
  });

  group('constructors', () {
    final mockParentStore = MockParentStore();
    const subPath = 'x';
    const path = 'base/path/x';

    setUp(() {
      reset(mockParentStore);

      when(() => mockParentStore.restApi).thenReturn(mockRestApi);
      when(() => mockParentStore.subPaths).thenReturn(['base', 'path']);
    });

    test('default constructor initializes members', () {
      final sut = ConstructorTestStore(
        parent: mockParentStore,
        path: subPath,
      );

      expect(sut.path, path);
      expect(sut.restApi, mockRestApi);
    });

    test('api constructor initializes members', () {
      final sut = ConstructorTestStore.api(
        restApi: mockRestApi,
        subPaths: [subPath],
      );

      expect(sut.path, subPath);
      expect(sut.restApi, mockRestApi);
    });

    test('create constructor initializes members', () {
      final sut = FirebaseStore<dynamic>.create(
        parent: mockParentStore,
        path: subPath,
        onDataFromJson: (dynamic json) => json,
        onDataToJson: (dynamic data) => data,
        onPatchData: (dynamic data, updatedFields) => data,
      );

      expect(sut, isA<CallbackFirebaseStore<dynamic>>());
      expect(sut.path, path);
      expect(sut.restApi, mockRestApi);
    });

    test('apiCreate constructor initializes members', () {
      final sut = FirebaseStore<dynamic>.apiCreate(
        restApi: mockRestApi,
        subPaths: [subPath],
        onDataFromJson: (dynamic json) => json,
        onDataToJson: (dynamic data) => data,
        onPatchData: (dynamic data, updatedFields) => data,
      );

      expect(sut, isA<CallbackFirebaseStore<dynamic>>());
      expect(sut.path, subPath);
      expect(sut.restApi, mockRestApi);
    });
  });

  group('members', () {
    const path = 'base/path/x';

    late FirebaseStore<TestModel> sut;

    setUp(() {
      _whenGet().thenAnswer((i) async => const DbResponse(data: null));
      _whenPut().thenAnswer((i) async => const DbResponse(data: null));
      _whenPost().thenAnswer((i) async => const DbResponse(data: {
            'name': '',
          }));
      _whenPatch().thenAnswer((i) async => const DbResponse(data: null));
      _whenDelete().thenAnswer((i) async => const DbResponse(data: null));
      _whenStream().thenAnswer((i) async => const Stream.empty());

      sut = FirebaseStore<TestModel>.apiCreate(
        restApi: mockRestApi,
        subPaths: ['base', 'path/x'],
        onDataFromJson: (dynamic json) => TestModel.fromJson(json as Map<String, dynamic>),
        onDataToJson: (data) => data.toJson(),
        onPatchData: (data, updatedFields) => TestModel(
          updatedFields['id'] as int? ?? data.id,
          updatedFields['data'] as String? ?? data.data,
        ),
      );
    });

    test('subStore creates callback substore', () {
      const subPath = 'y';
      final subStore = sut.subStore<int>(
        path: subPath,
        onDataFromJson: (dynamic json) => json as int,
        onDataToJson: (data) => data,
        onPatchData: (data, updatedFields) => data,
      );

      expect(subStore, isA<CallbackFirebaseStore<dynamic>>());
      expect(subStore.path, '$path/$subPath');
      expect(subStore.restApi, mockRestApi);
    });

    group('keys', () {
      test('calls api.get', () async {
        final result = await sut.keys();

        expect(result, isEmpty);
        verify(() => mockRestApi.get(
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
        verify(() => mockRestApi.get(
              path: path,
              shallow: false,
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
        verify(() => mockRestApi.get(
              path: path,
            ));
      });

      test('returns json data as map', () async {
        _whenGet().thenAnswer(
          (i) async => const DbResponse(data: {
            'a': {'id': 1, 'data': 'A'},
            'b': {'id': 2, 'data': 'B'},
            'c': {'id': 3, 'data': 'C'},
          }),
        );

        final result = await sut.all();
        expect(result, const {
          'a': TestModel(1, 'A'),
          'b': TestModel(2, 'B'),
          'c': TestModel(3, 'C'),
        });
      });

      test('requests eTag with etag receiver set', () async {
        _whenGet().thenAnswer(
          (i) async => const DbResponse(data: null, eTag: 'TAG'),
        );
        final result = await sut.all(eTagReceiver: ETagReceiver());

        expect(result, isEmpty);
        verify(() => mockRestApi.get(
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

    group('read', () {
      const key = 'read';

      test('calls api.get', () async {
        final result = await sut.read(key);

        expect(result, isNull);
        verify(() => mockRestApi.get(
              path: '$path/$key',
            ));
      });

      test('returns parsed data', () async {
        _whenGet().thenAnswer(
          (i) async => const DbResponse(data: {'id': 1, 'data': 'A'}),
        );

        final result = await sut.read(key);
        expect(result, const TestModel(1, 'A'));
      });

      test('requests eTag with etag receiver set', () async {
        _whenGet().thenAnswer(
          (i) async => const DbResponse(data: null, eTag: 'TAG'),
        );
        final result = await sut.read(key, eTagReceiver: ETagReceiver());

        expect(result, isNull);
        verify(() => mockRestApi.get(
              path: '$path/$key',
              eTag: true,
            ));
      });

      test('sets ETag on receiver', () async {
        _whenGet().thenAnswer(
          (i) async => const DbResponse(data: null, eTag: 'TAG'),
        );

        final receiver = ETagReceiver();
        final result = await sut.read(key, eTagReceiver: receiver);

        expect(result, isNull);
        expect(receiver.eTag, 'TAG');
      });
    });

    group('write', () {
      const key = 'write';
      const data = TestModel(13, 'W');

      test('calls api.put', () async {
        final result = await sut.write(key, data);

        expect(result, isNull);
        verify(() => mockRestApi.put(
              const {'id': 13, 'data': 'W'},
              path: '$path/$key',
            ));
      });

      test('returns parsed data', () async {
        _whenPut().thenAnswer(
          (i) async => const DbResponse(data: {'id': 1, 'data': 'A'}),
        );

        final result = await sut.write(key, data);
        expect(result, const TestModel(1, 'A'));
      });

      test('calls api.put silent and ignore result', () async {
        _whenPut().thenAnswer(
          (i) async => const DbResponse(data: {'id': 1, 'data': 'A'}),
        );

        final result = await sut.write(key, data, silent: true);

        expect(result, isNull);
        verify(() => mockRestApi.put(
              const {'id': 13, 'data': 'W'},
              path: '$path/$key',
              printMode: PrintMode.silent,
            ));
      });

      test('requests eTag with etag receiver set', () async {
        _whenPut().thenAnswer(
          (i) async => const DbResponse(data: null, eTag: 'TAG'),
        );
        final result = await sut.write(key, data, eTagReceiver: ETagReceiver());

        expect(result, isNull);
        verify(() => mockRestApi.put(
              const {'id': 13, 'data': 'W'},
              path: '$path/$key',
              eTag: true,
            ));
      });

      test('sets ETag on receiver', () async {
        _whenPut().thenAnswer(
          (i) async => const DbResponse(data: null, eTag: 'TAG'),
        );

        final receiver = ETagReceiver();
        final result = await sut.write(key, data, eTagReceiver: receiver);

        expect(result, isNull);
        expect(receiver.eTag, 'TAG');
      });

      test('asserts if both silent and eTag are requested', () async {
        expect(
          () => sut.write(key, data, silent: true, eTag: 'eTag'),
          throwsA(isA<AssertionError>().having(
            (e) => e.message,
            'message',
            'Cannot set silent and eTag at the same time',
          )),
        );
      });

      test('forwards eTag to api.put', () async {
        const eTag = 'eTag';
        final result = await sut.write(key, data, eTag: eTag);

        expect(result, isNull);
        verify(() => mockRestApi.put(
              const {'id': 13, 'data': 'W'},
              path: '$path/$key',
              ifMatch: eTag,
            ));
      });
    });

    group('create', () {
      const data = TestModel(24, 'D');

      test('calls api.post', () async {
        final result = await sut.create(data);

        expect(result, isEmpty);
        verify(() => mockRestApi.post(
              const {'id': 24, 'data': 'D'},
              path: path,
            ));
      });

      test('returns parsed data', () async {
        _whenPost().thenAnswer(
          (i) async => const DbResponse(data: {'name': 'created'}),
        );

        final result = await sut.create(data);
        expect(result, 'created');
      });

      test('requests eTag with etag receiver set', () async {
        _whenPost().thenAnswer(
          (i) async => const DbResponse(data: {'name': ''}, eTag: 'TAG'),
        );
        final result = await sut.create(data, eTagReceiver: ETagReceiver());

        expect(result, isEmpty);
        verify(() => mockRestApi.post(
              const {'id': 24, 'data': 'D'},
              path: path,
              eTag: true,
            ));
      });

      test('sets ETag on receiver', () async {
        _whenPost().thenAnswer(
          (i) async => const DbResponse(data: {'name': ''}, eTag: 'TAG'),
        );

        final receiver = ETagReceiver();
        final result = await sut.create(data, eTagReceiver: receiver);

        expect(result, isEmpty);
        expect(receiver.eTag, 'TAG');
      });
    });

    group('update', () {
      const key = 'update';
      const updateFields = {
        'a': 1,
        'b': 2.0,
        'c': 'C',
      };

      test('calls api.patch', () async {
        final result = await sut.update(key, updateFields);

        expect(result, isNull);
        verify(() => mockRestApi.patch(
              updateFields,
              path: '$path/$key',
              printMode: PrintMode.silent,
            ));
      });

      test('patches data with returned message', () async {
        _whenPatch().thenAnswer((i) async => const DbResponse(data: {'data': 'newData'}));

        final result = await sut.update(
          key,
          updateFields,
          currentData: const TestModel(42, 'oldData'),
        );

        expect(result, const TestModel(42, 'newData'));
        verify(() => mockRestApi.patch(
              updateFields,
              path: '$path/$key',
            ));
      });
    });

    group('delete', () {
      const key = 'delete';

      test('calls api.delete', () async {
        await sut.delete(key);

        verify(() => mockRestApi.delete(
              path: '$path/$key',
              printMode: PrintMode.silent,
            ));
      });

      test('requests eTag with etag receiver set', () async {
        _whenDelete().thenAnswer(
          (i) async => const DbResponse(data: null, eTag: 'TAG'),
        );
        await sut.delete(key, eTagReceiver: ETagReceiver());

        verify(() => mockRestApi.delete(
              path: '$path/$key',
              eTag: true,
              printMode: PrintMode.silent,
            ));
      });

      test('sets ETag on receiver', () async {
        _whenDelete().thenAnswer(
          (i) async => const DbResponse(data: null, eTag: 'TAG'),
        );

        final receiver = ETagReceiver();
        await sut.delete(key, eTagReceiver: receiver);

        expect(receiver.eTag, 'TAG');
      });

      test('forwards eTag to api.delete', () async {
        const eTag = 'eTag';
        await sut.delete(key, eTag: eTag);

        verify(() => mockRestApi.delete(
              path: '$path/$key',
              ifMatch: eTag,
            ));
      });
    });

    group('query', () {
      final filter = Filter.key().build();

      test('calls api.get', () async {
        final result = await sut.query(filter);

        expect(result, isEmpty);
        verify(() => mockRestApi.get(
              path: path,
              filter: filter,
            ));
      });

      test('returns json data as map', () async {
        _whenGet().thenAnswer(
          (i) async => const DbResponse(data: {
            'a': {'id': 1, 'data': 'A'},
            'b': {'id': 2, 'data': 'B'},
            'c': {'id': 3, 'data': 'C'},
          }),
        );

        final result = await sut.query(filter);
        expect(result, const {
          'a': TestModel(1, 'A'),
          'b': TestModel(2, 'B'),
          'c': TestModel(3, 'C'),
        });
      });
    });

    group('queryKeys', () {
      final filter = Filter.key().build();

      test('calls api.get', () async {
        final result = await sut.queryKeys(filter);

        expect(result, isEmpty);
        verify(() => mockRestApi.get(
              path: path,
              filter: filter,
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

        final result = await sut.queryKeys(filter);
        expect(result, ['a', 'b', 'c', 'd', 'e']);
      });
    });

    group('transaction', () {
      const key = 'transaction';

      test('calls api.get', () async {
        _whenGet().thenAnswer(
          (i) async => const DbResponse(data: null, eTag: 'TAG'),
        );

        final result = await sut.transaction(key);

        expect(result, isNotNull);
        expect(result.value, isNull);
        verify(() => mockRestApi.get(
              path: '$path/$key',
              eTag: true,
            ));
      });

      test('returns correctly initialized transaction', () async {
        _whenGet().thenAnswer(
          (i) async => const DbResponse(
            data: {'id': 11, 'data': 'T'},
            eTag: 'TAG',
          ),
        );

        final result = await sut.transaction(key);
        expect(result.key, key);
        expect(result.value, const TestModel(11, 'T'));
        expect(result.eTag, 'TAG');
      });

      test('created transaction uses store and ETagReceiver', () async {
        _whenGet().thenAnswer(
          (i) async => const DbResponse(data: null, eTag: 'TAG1'),
        );
        _whenDelete().thenAnswer(
          (i) async => const DbResponse(data: null, eTag: 'TAG2'),
        );

        final receiver = ETagReceiver();
        final result = await sut.transaction(key, eTagReceiver: receiver);
        expect(result.eTag, 'TAG1');

        await result.commitDelete();
        verify(() => mockRestApi.delete(
              path: '$path/$key',
              ifMatch: 'TAG1',
              eTag: true,
            ));
        expect(receiver.eTag, 'TAG2');
      });
    });

    group('streamAll', () {
      test('calls api.stream', () async {
        final result = await sut.streamAll();

        expect(result, neverEmits(anything));
        verify(() => mockRestApi.stream(
              path: path,
            ));
      });

      test('applies correct stream transformer', () async {
        _whenStream().thenAnswer(
          (i) async => Stream.value(const StreamEvent.put(
            path: '/',
            data: <String, dynamic>{},
          )),
        );

        final result = await sut.streamAll();
        expect(result, emits(const StoreEvent.reset(<String, TestModel>{})));
      });
    });

    group('streamKeys', () {
      test('calls api.stream', () async {
        final result = await sut.streamKeys();

        expect(result, neverEmits(anything));
        verify(() => mockRestApi.stream(
              path: path,
              shallow: true,
            ));
      });

      test('applies correct stream transformer', () async {
        _whenStream().thenAnswer(
          (i) async => Stream.value(const StreamEvent.put(
            path: '/',
            data: <String, dynamic>{},
          )),
        );

        final result = await sut.streamKeys();
        expect(result, emits(const KeyEvent.reset([])));
      });
    });

    group('streamEntry', () {
      const key = 'streamEntry';

      test('calls api.stream', () async {
        final result = await sut.streamEntry(key);

        expect(result, neverEmits(anything));
        verify(() => mockRestApi.stream(
              path: '$path/$key',
            ));
      });

      test('applies correct stream transformer', () async {
        _whenStream().thenAnswer(
          (i) async => Stream.value(const StreamEvent.put(
            path: '/',
            data: null,
          )),
        );

        final result = await sut.streamEntry(key);
        expect(result, emits(const ValueEvent<Never>.delete()));
      });
    });

    group('streamQuery', () {
      final filter = Filter.key().build();

      test('calls api.stream', () async {
        final result = await sut.streamQuery(filter);

        expect(result, neverEmits(anything));
        verify(() => mockRestApi.stream(
              path: path,
              filter: filter,
            ));
      });

      test('applies correct stream transformer', () async {
        _whenStream().thenAnswer(
          (i) async => Stream.value(const StreamEvent.put(
            path: '/',
            data: <String, dynamic>{},
          )),
        );

        final result = await sut.streamQuery(filter);
        expect(result, emits(const StoreEvent.reset(<String, TestModel>{})));
      });
    });

    group('streamQueryKeys', () {
      final filter = Filter.key().build();

      test('calls api.stream', () async {
        final result = await sut.streamQueryKeys(filter);

        expect(result, neverEmits(anything));
        verify(() => mockRestApi.stream(
              path: path,
              filter: filter,
            ));
      });

      test('applies correct stream transformer', () async {
        _whenStream().thenAnswer(
          (i) async => Stream.value(const StreamEvent.put(
            path: '/',
            data: <String, dynamic>{},
          )),
        );

        final result = await sut.streamQueryKeys(filter);
        expect(result, emits(const KeyEvent.reset([])));
      });
    });

    group('destroy', () {
      test('calls api.delete', () async {
        await sut.destroy();

        verify(() => mockRestApi.delete(
              path: path,
              printMode: PrintMode.silent,
            ));
      });

      test('requests eTag with etag receiver set', () async {
        _whenDelete().thenAnswer(
          (i) async => const DbResponse(data: null, eTag: 'TAG'),
        );
        await sut.destroy(eTagReceiver: ETagReceiver());

        verify(() => mockRestApi.delete(
              path: path,
              eTag: true,
              printMode: PrintMode.silent,
            ));
      });

      test('sets ETag on receiver', () async {
        _whenDelete().thenAnswer(
          (i) async => const DbResponse(data: null, eTag: 'TAG'),
        );

        final receiver = ETagReceiver();
        await sut.destroy(eTagReceiver: receiver);

        expect(receiver.eTag, 'TAG');
      });

      test('forwards eTag to api.delete', () async {
        const eTag = 'eTag';
        await sut.destroy(eTag: eTag);

        verify(() => mockRestApi.delete(
              path: path,
              ifMatch: eTag,
            ));
      });
    });
  });
}
