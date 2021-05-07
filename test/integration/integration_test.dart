import 'dart:developer';

import 'package:firebase_auth_rest/firebase_auth_rest.dart';
import 'package:firebase_database_rest/src/common/api_constants.dart';
import 'package:firebase_database_rest/src/common/db_exception.dart';
import 'package:firebase_database_rest/src/common/filter.dart';
import 'package:firebase_database_rest/src/database/database.dart';
import 'package:firebase_database_rest/src/database/etag_receiver.dart';
import 'package:firebase_database_rest/src/database/store.dart';
import 'package:firebase_database_rest/src/database/store_event.dart';
import 'package:firebase_database_rest/src/database/timestamp.dart';
import 'package:firebase_database_rest/src/database/transaction.dart';
// TODO import 'package:firebase_database_rest/firebase_database_rest.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:http/http.dart';
import 'package:test/test.dart';
import 'package:tuple/tuple.dart';

import '../stream_matcher_queue.dart';
import '../test_data.dart';
import 'test_config_vm.dart' if (dart.library.js) 'test_config_js.dart';

part 'integration_test.freezed.dart';
part 'integration_test.g.dart';

@freezed
class TestModel with _$TestModel {
  const TestModel._();

  // ignore: sort_unnamed_constructors_first
  const factory TestModel({
    required int id,
    String? data,
    @Default(false) bool extra,
    FirebaseTimestamp? timestamp,
  }) = _TestModel;

  factory TestModel.fromJson(Map<String, dynamic> json) =>
      _$TestModelFromJson(json);

  TestModel patch(Map<String, dynamic> json) => (this as dynamic).copyWith(
        id: json.containsKey('id') ? json['id'] : freezed,
        data: json.containsKey('data') ? json['data'] : freezed,
        extra: json.containsKey('extra') ? json['extra'] : freezed,
        timestamp: json.containsKey('timestamp') ? json['timestamp'] : freezed,
      ) as TestModel;
}

class TestStore extends FirebaseStore<TestModel> {
  TestStore(FirebaseStore<dynamic> parent, int caseCtr)
      : super(
          parent: parent,
          path: '_test_path_$caseCtr',
        );

  @override
  TestModel dataFromJson(dynamic json) =>
      TestModel.fromJson(json as Map<String, dynamic>);

  @override
  dynamic dataToJson(TestModel data) => data.toJson();

  @override
  TestModel patchData(TestModel data, Map<String, dynamic> updatedFields) =>
      data.patch(updatedFields);
}

void main() {
  late final Client client;
  late final FirebaseAccount account;
  late final FirebaseDatabase database;

  setUpAll(() async {
    client = Client();
    final auth = FirebaseAuth(client, TestConfig.apiKey);
    account = await auth.signUpAnonymous(autoRefresh: false);
    database = FirebaseDatabase(
      account: account,
      database: TestConfig.projectId,
      basePath: 'firebase_database_rest/${account.localId}',
      client: client,
    );
  });

  tearDownAll(() async {
    var error = false;
    try {
      await database.rootStore.destroy();
    } catch (e, s) {
      error = true;
      log(
        'Root store destruction failed',
        error: e,
        stackTrace: s,
        level: 1000,
      );
    }

    try {
      await account.delete();
    } catch (e, s) {
      error = true;
      log(
        'Account deletion failed',
        error: e,
        stackTrace: s,
        level: 1000,
      );
    }

    await database.dispose();
    database.account?.dispose();
    client.close();

    if (error) {
      fail('tearDownAll failed');
    }
  });

  var caseCtr = 0;
  late TestStore store;

  setUp(() {
    store = TestStore(database.rootStore, caseCtr++);
  });

  test('setUp and tearDown run without errors', () async {
    await store.keys();
  });

  test('create and then read an entry', () async {
    const localData = TestModel(id: 42);
    final key = await store.create(localData);
    expect(key, isNotNull);

    final remoteData = await store.read(key);
    expect(remoteData, localData);
  });

  test('write and then read entry with custom key', () async {
    const key = 'test_key';
    const localData = TestModel(id: 3, data: 'data', extra: true);
    final writeData = await store.write(key, localData);
    expect(writeData, localData);
    final readData = await store.read(key);
    expect(readData, localData);
  });

  test('write, read, delete, read entry, with key existance check', () async {
    const key = 'test_key';
    const localData = TestModel(id: 77);

    var keys = await store.keys();
    expect(keys, isEmpty);

    final silentData = await store.write(key, localData, silent: true);
    expect(silentData, isNull);

    keys = await store.keys();
    expect(keys, [key]);
    final remoteData = await store.read(key);
    expect(remoteData, localData);

    await store.delete(key);
    keys = await store.keys();
    expect(keys, isEmpty);

    final deletedData = await store.read(key);
    expect(deletedData, isNull);
  });

  test('create, update, read works as excepted', () async {
    const localData = TestModel(id: 99, data: 'oldData');
    final updateLocal1 = localData.copyWith(
      data: 'newData',
      extra: true,
    );
    final updateLocal2 = updateLocal1.copyWith(
      data: 'veryNewData',
    );
    final key = await store.create(localData);
    expect(key, isNotNull);

    final updateRes = await store.update(key, <String, dynamic>{
      'data': 'newData',
      'extra': true,
    });
    expect(updateRes, isNull);

    final updateRemote1 = await store.read(key);
    expect(updateRemote1, updateLocal1);

    final updateRemote2 = await store.update(
      key,
      <String, dynamic>{'data': 'veryNewData'},
      currentData: updateLocal1,
    );
    expect(updateRemote2, updateLocal2);
  });

  test('firebase timestamp', () async {
    // create a manual timestamp
    final d1 = TestModel(
      id: 11,
      timestamp: FirebaseTimestamp(DateTime(2020, 10, 10)),
    );
    final res1 = await store.write('d1', d1);
    expect(res1, d1);

    // create a server timestamp
    final before = DateTime.now().subtract(const Duration(seconds: 3));
    const d2 = TestModel(
      id: 22,
      timestamp: FirebaseTimestamp.server(),
    );
    final res2 = await store.write('d2', d2);
    final after = DateTime.now().add(const Duration(seconds: 3));
    expect(res2, isNotNull);
    expect(res2!.id, d2.id);
    expect(
      res2.timestamp!.dateTime,
      predicate<DateTime>(
        (d) => d.isAfter(before) && d.isBefore(after),
        'is between $before and $after',
      ),
    );
  });

  test('all and keys report all data, destroy deletes all', () async {
    expect(TestConfig.allTestLimit, greaterThanOrEqualTo(5));

    for (var i = 0; i < TestConfig.allTestLimit; ++i) {
      await store.write('_$i', TestModel(id: i));
    }

    expect(
      await store.keys(),
      unorderedEquals(<String>[
        for (var i = 0; i < TestConfig.allTestLimit; ++i) '_$i',
      ]),
    );

    expect(
      await store.all(),
      {
        for (var i = 0; i < TestConfig.allTestLimit; ++i)
          '_$i': TestModel(id: i),
      },
    );

    await store.delete('_3');

    expect(
      await store.keys(),
      unorderedEquals(<String>[
        for (var i = 0; i < TestConfig.allTestLimit; ++i)
          if (i != 3) '_$i',
      ]),
    );

    expect(
      await store.all(),
      {
        for (final i in List<int>.generate(TestConfig.allTestLimit, (i) => i))
          if (i != 3) '_$i': TestModel(id: i),
      },
    );

    await store.destroy();

    expect(await store.keys(), isEmpty);
    expect(await store.all(), isEmpty);
  });

  test('reports and respects eTags', () async {
    const localData1 = TestModel(id: 11);
    const localData2 = TestModel(id: 12);
    const localData3 = TestModel(id: 13);
    final receiver = ETagReceiver();
    String? _getTag() {
      expect(receiver.eTag, isNotNull);
      final tag = receiver.eTag;
      receiver.eTag = null;
      return tag;
    }

    final key = await store.create(localData1, eTagReceiver: receiver);
    final createTag = _getTag();
    expect(createTag, isNot(ApiConstants.nullETag));

    await store.read(key, eTagReceiver: receiver);
    final readTag = _getTag();
    expect(readTag, createTag);

    await store.keys(eTagReceiver: receiver);
    final keysTag1 = _getTag();
    expect(keysTag1, isNot(ApiConstants.nullETag));
    await store.all(eTagReceiver: receiver);
    final allTag1 = _getTag();
    expect(allTag1, keysTag1);

    await store.write(
      key,
      localData2,
      eTag: createTag,
      eTagReceiver: receiver,
    );
    final writeTag = _getTag();
    expect(writeTag, isNot(createTag));
    expect(writeTag, isNot(ApiConstants.nullETag));

    await store.keys(eTagReceiver: receiver);
    final keysTag2 = _getTag();
    expect(keysTag2, isNot(ApiConstants.nullETag));
    expect(keysTag2, isNot(keysTag1));
    await store.all(eTagReceiver: receiver);
    final allTag2 = _getTag();
    expect(allTag2, keysTag2);

    await expectLater(
      () => store.write(
        key,
        localData3,
        eTag: createTag,
        eTagReceiver: receiver,
      ),
      throwsA(const DbException(
        statusCode: ApiConstants.statusCodeETagMismatch,
      )),
    );

    await expectLater(
      () => store.write(
        key,
        localData3,
        eTag: ApiConstants.nullETag,
        eTagReceiver: receiver,
      ),
      throwsA(const DbException(
        statusCode: ApiConstants.statusCodeETagMismatch,
      )),
    );

    await expectLater(
      () => store.delete(key, eTag: createTag),
      throwsA(const DbException(
        statusCode: ApiConstants.statusCodeETagMismatch,
      )),
    );

    await store.delete(key, eTag: writeTag, eTagReceiver: receiver);
    final deleteTag = _getTag();
    expect(deleteTag, ApiConstants.nullETag);

    await store.keys(eTagReceiver: receiver);
    final keysTag3 = _getTag();
    expect(keysTag3, ApiConstants.nullETag);
    await store.all(eTagReceiver: receiver);
    final allTag3 = _getTag();
    expect(allTag3, keysTag3);

    await store.write(
      key,
      localData3,
      eTag: deleteTag,
      eTagReceiver: receiver,
    );
    final writeTag2 = _getTag();
    expect(writeTag2, isNot(deleteTag));
    expect(writeTag2, isNot(writeTag));
    expect(writeTag2, isNot(createTag));

    await expectLater(
      () => store.destroy(eTag: keysTag3),
      throwsA(const DbException(
        statusCode: ApiConstants.statusCodeETagMismatch,
      )),
    );

    await store.keys(eTagReceiver: receiver);
    final keysTag4 = _getTag();
    expect(keysTag4, isNot(ApiConstants.nullETag));
    expect(keysTag4, isNot(keysTag3));

    await store.destroy(eTag: keysTag4, eTagReceiver: receiver);
    final destroyTag = _getTag();
    expect(destroyTag, ApiConstants.nullETag);
  });

  group('query', () {
    testData<
        Tuple2<FilterBuilder<int> Function(FilterBuilder<int>), List<int>>>(
      'property',
      [
        Tuple2((b) => b.limitToFirst(3), const [0, 1, 2]),
        Tuple2((b) => b.limitToLast(3), const [2, 3, 4]),
        Tuple2((b) => b.startAt(3), const [3, 4]),
        Tuple2((b) => b.endAt(1), const [0, 1]),
        Tuple2((b) => b.equalTo(2), const [2]),
        Tuple2((b) => b.startAt(2).limitToLast(2), const [3, 4]),
        Tuple2((b) => b.startAt(2).limitToFirst(2), const [2, 3]),
        Tuple2((b) => b.endAt(2).limitToLast(2), const [1, 2]),
        Tuple2((b) => b.endAt(2).limitToFirst(2), const [0, 1]),
      ],
      (fixture) async {
        for (var i = 0; i < 5; ++i) {
          await store.write(
            '_$i',
            TestModel(id: 4 - i),
          );
        }

        final filter = fixture.item1(Filter.property<int>('id')).build();

        expect(
          await store.queryKeys(filter),
          unorderedEquals(fixture.item2.map<String>((e) => '_${4 - e}')),
        );

        expect(
          await store.query(filter),
          {
            for (final i in fixture.item2) '_${4 - i}': TestModel(id: i),
          },
        );
      },
      fixtureToString: (fixture) =>
          // ignore: lines_longer_than_80_chars
          '${fixture.item1(Filter.property<int>('id')).build()} -> ${fixture.item2}',
    );

    testData<
        Tuple2<FilterBuilder<String> Function(FilterBuilder<String>),
            List<int>>>(
      'key',
      [
        Tuple2((b) => b.limitToFirst(3), const [0, 1, 2]),
        Tuple2((b) => b.limitToLast(3), const [2, 3, 4]),
        Tuple2((b) => b.startAt('_3'), const [3, 4]),
        Tuple2((b) => b.endAt('_1'), const [0, 1]),
        Tuple2((b) => b.equalTo('_2'), const [2]),
        Tuple2((b) => b.startAt('_2').limitToLast(2), const [3, 4]),
        Tuple2((b) => b.startAt('_2').limitToFirst(2), const [2, 3]),
        Tuple2((b) => b.endAt('_2').limitToLast(2), const [1, 2]),
        Tuple2((b) => b.endAt('_2').limitToFirst(2), const [0, 1]),
      ],
      (fixture) async {
        for (var i = 0; i < 5; ++i) {
          await store.write(
            '_$i',
            TestModel(id: 4 - i),
          );
        }

        final filter = fixture.item1(Filter.key()).build();

        expect(
          await store.queryKeys(filter),
          unorderedEquals(fixture.item2.map<String>((e) => '_$e')),
        );

        expect(
          await store.query(filter),
          {
            for (final i in fixture.item2) '_$i': TestModel(id: 4 - i),
          },
        );
      },
      fixtureToString: (fixture) =>
          // ignore: lines_longer_than_80_chars
          '${fixture.item1(Filter.key()).build()} -> ${fixture.item2}',
    );

    testData<
        Tuple2<FilterBuilder<int> Function(FilterBuilder<int>), List<int>>>(
      'valueXX',
      [
        Tuple2((b) => b.limitToFirst(3), const [0, 1, 2]),
        Tuple2((b) => b.limitToLast(3), const [2, 3, 4]),
        Tuple2((b) => b.startAt(3), const [3, 4]),
        Tuple2((b) => b.endAt(1), const [0, 1]),
        Tuple2((b) => b.equalTo(2), const [2]),
        Tuple2(
          (b) => b.startAt(2).limitToLast(2),
          const [3, 4],
        ),
        Tuple2(
          (b) => b.startAt(2).limitToFirst(2),
          const [2, 3],
        ),
        Tuple2(
          (b) => b.endAt(2).limitToLast(2),
          const [1, 2],
        ),
        Tuple2(
          (b) => b.endAt(2).limitToFirst(2),
          const [0, 1],
        ),
      ],
      (fixture) async {
        final intStore = database.rootStore.subStore<int>(
          path: store.subPaths.last,
          onDataFromJson: (dynamic j) => j as int,
          onDataToJson: (d) => d,
          onPatchData: (_, __) => throw UnimplementedError(),
        );
        for (var i = 0; i < 5; ++i) {
          await intStore.write('_${14 - i}', i);
        }
        final filter = fixture.item1(Filter.value<int>()).build();

        expect(
          await intStore.queryKeys(filter),
          unorderedEquals(fixture.item2.map<String>((e) => '_${14 - e}')),
        );

        expect(
          await intStore.query(filter),
          {
            for (final i in fixture.item2) '_${14 - i}': i,
          },
        );
      },
      fixtureToString: (fixture) =>
          // ignore: lines_longer_than_80_chars
          '${fixture.item1(Filter.value<int>()).build()} -> ${fixture.item2}',
    );
  });

  group('transaction', () {
    const localData = TestModel(id: 111);

    test('create new entry', () async {
      const key = 'test_key';

      final transaction = await store.transaction(key);
      expect(transaction.key, key);
      expect(transaction.value, isNull);
      expect(transaction.eTag, ApiConstants.nullETag);

      final transData = await transaction.commitUpdate(localData);
      expect(transData, localData);

      final readData = await store.read(key);
      expect(readData, localData);
    });

    test('modify existing entry', () async {
      final updateData = localData.copyWith(data: 'transacted');

      final key = await store.create(localData);

      final transaction = await store.transaction(key);
      expect(transaction.key, key);
      expect(transaction.value, localData);
      expect(transaction.eTag, isNot(ApiConstants.nullETag));

      final transData = await transaction.commitUpdate(updateData);
      expect(transData, updateData);

      final readData = await store.read(key);
      expect(readData, updateData);
    });

    test('modify after data was mutated', () async {
      final updateData1 = localData.copyWith(data: 'mutated');
      final updateData2 = localData.copyWith(data: 'transacted');

      final key = await store.create(localData);

      final transaction = await store.transaction(key);
      expect(transaction.key, key);
      expect(transaction.value, localData);
      expect(transaction.eTag, isNot(ApiConstants.nullETag));

      final receiver = ETagReceiver();
      await store.write(key, updateData1, eTagReceiver: receiver);
      expect(receiver.eTag, isNotNull);
      expect(receiver.eTag, isNot(transaction.eTag));

      expect(
        () => transaction.commitUpdate(updateData2),
        throwsA(isA<TransactionFailedException>()),
      );

      final readData = await store.read(key);
      expect(readData, updateData1);
    });

    test('delete existing entry', () async {
      final key = await store.create(localData);

      final transaction = await store.transaction(key);
      expect(transaction.key, key);
      expect(transaction.value, localData);
      expect(transaction.eTag, isNot(ApiConstants.nullETag));

      await transaction.commitDelete();

      final readData = await store.read(key);
      expect(readData, isNull);
    });

    test('delete mutated entry', () async {
      final updateData = localData.copyWith(data: 'mutated');

      final key = await store.create(localData);

      final transaction = await store.transaction(key);
      expect(transaction.key, key);
      expect(transaction.value, localData);
      expect(transaction.eTag, isNot(ApiConstants.nullETag));

      final receiver = ETagReceiver();
      await store.write(key, updateData, eTagReceiver: receiver);
      expect(receiver.eTag, isNotNull);
      expect(receiver.eTag, isNot(transaction.eTag));

      expect(
        () => transaction.commitDelete(),
        throwsA(isA<TransactionFailedException>()),
      );

      final readData = await store.read(key);
      expect(readData, updateData);
    });
  });

  group('stream', () {
    test('all', () async {
      for (var i = 0; i < 3; ++i) {
        await store.write('_$i', TestModel(id: i));
      }

      final stream = StreamMatcherQueue(await store.streamAll());
      try {
        await expectLater(
          stream,
          emitsQueued(const StoreEvent<TestModel>.reset({
            '_0': TestModel(id: 0),
            '_1': TestModel(id: 1),
            '_2': TestModel(id: 2),
          })),
        );

        await store.write('_3', const TestModel(id: 3));
        await expectLater(
          stream,
          emitsQueued(const StoreEvent.put('_3', TestModel(id: 3))),
        );

        await store.write('_0', const TestModel(id: 1));
        await store.write('_0', const TestModel(id: 0));
        await expectLater(
          stream,
          emitsQueued(const [
            StoreEvent.put('_0', TestModel(id: 1)),
            StoreEvent.put('_0', TestModel(id: 0)),
          ]),
        );

        final key = await store.create(const TestModel(id: 42));
        await expectLater(
          stream,
          emitsQueued(StoreEvent.put(key, const TestModel(id: 42))),
        );

        await store.delete('_3');
        await expectLater(
          stream,
          emitsQueued(const StoreEvent<TestModel>.delete('_3')),
        );

        await store.update('_0', const <String, dynamic>{'extra': true});
        final patchEvent = await stream.next();
        expect(patchEvent, isNotNull);
        final patch = patchEvent!.maybeWhen(
          patch: (key, value) => key == '_0' ? value : null,
          orElse: () => null,
        );
        expect(patch, isNotNull);
        final patched = patch!.apply(const TestModel(id: 1));
        expect(patched, const TestModel(id: 1, extra: true));

        final subStore = store.subStore<dynamic>(
          path: '_0',
          onDataFromJson: (dynamic json) => json,
          onDataToJson: (dynamic data) => data,
          onPatchData: (dynamic data, _) => data,
        );
        await subStore.write('sub', 42);
        await expectLater(
          stream,
          emitsQueued(const StoreEvent<TestModel>.invalidPath('/_0/sub')),
        );
      } finally {
        await stream.close();
      }

      expect(stream, isEmpty);
    });

    test('keys', () async {
      for (var i = 0; i < 3; ++i) {
        await store.write('_$i', TestModel(id: i));
      }

      final stream = StreamMatcherQueue(await store.streamKeys());
      try {
        await expectLater(
          stream,
          emitsQueued(const KeyEvent.reset(['_0', '_1', '_2'])),
        );

        await store.write('_3', const TestModel(id: 3));
        await expectLater(
          stream,
          emitsQueued(const KeyEvent.update('_3')),
        );

        await store.write('_0', const TestModel(id: 1));
        await store.write('_0', const TestModel(id: 0));
        await expectLater(
          stream,
          emitsQueued(const [
            KeyEvent.update('_0'),
            KeyEvent.update('_0'),
          ]),
        );

        final key = await store.create(const TestModel(id: 42));
        await expectLater(
          stream,
          emitsQueued(KeyEvent.update(key)),
        );

        await store.delete('_3');
        await expectLater(
          stream,
          emitsQueued(const KeyEvent.delete('_3')),
        );

        await store.update('_0', const <String, dynamic>{'extra': true});
        await expectLater(
          stream,
          emitsQueued(const KeyEvent.update('_0')),
        );

        final subStore = store.subStore<dynamic>(
          path: '_0',
          onDataFromJson: (dynamic json) => json,
          onDataToJson: (dynamic data) => data,
          onPatchData: (dynamic data, _) => data,
        );
        await subStore.write('sub', 42);
        await expectLater(
          stream,
          emitsQueued(const KeyEvent.invalidPath('/_0/sub')),
        );
      } finally {
        await stream.close();
      }

      expect(stream, isEmpty);
    });

    test('entry', () async {
      final key = await store.create(const TestModel(id: 42));

      final stream = StreamMatcherQueue(await store.streamEntry(key));
      try {
        await expectLater(
          stream,
          emitsQueued(const ValueEvent.update(TestModel(id: 42))),
        );

        await store.write(key, const TestModel(id: 3));
        await expectLater(
          stream,
          emitsQueued(const ValueEvent.update(TestModel(id: 3))),
        );

        await store.write(key, const TestModel(id: 4));
        await store.write(key, const TestModel(id: 5));
        await expectLater(
          stream,
          emitsQueued(const [
            ValueEvent.update(TestModel(id: 4)),
            ValueEvent.update(TestModel(id: 5)),
          ]),
        );

        await store.create(const TestModel(id: 42));
        expect(stream, isEmpty);

        await store.update(key, const <String, dynamic>{'extra': true});
        final patchEvent = await stream.next();
        expect(patchEvent, isNotNull);
        final patch = patchEvent!.maybeWhen(
          patch: (patchSet) => patchSet,
          orElse: () => null,
        );
        expect(patch, isNotNull);
        final patched = patch!.apply(const TestModel(id: 1));
        expect(patched, const TestModel(id: 1, extra: true));

        await store.delete(key);
        await expectLater(
          stream,
          emitsQueued(const ValueEvent<TestModel>.delete()),
        );

        final subStore = store.subStore<dynamic>(
          path: key,
          onDataFromJson: (dynamic json) => json,
          onDataToJson: (dynamic data) => data,
          onPatchData: (dynamic data, _) => data,
        );
        await subStore.write('sub', 42);
        await expectLater(
          stream,
          emitsQueued(const ValueEvent<TestModel>.invalidPath('/sub')),
        );
      } finally {
        await stream.close();
      }

      expect(stream, isEmpty);
    });

    test('query', () async {
      for (var i = 4; i < 8; ++i) {
        await store.write('_$i', TestModel(id: i));
      }

      final stream = StreamMatcherQueue(await store.streamQuery(
        Filter.key().startAt('_6').limitToFirst(4).build(),
      ));
      try {
        await expectLater(
          stream,
          emitsQueued(const StoreEvent<TestModel>.reset({
            '_6': TestModel(id: 6),
            '_7': TestModel(id: 7),
          })),
        );

        for (var i = 12; i > 2; --i) {
          await store.write('_$i', TestModel(id: i * i));
        }
        await store.write('_8', const TestModel(id: 888));

        await expectLater(
          stream,
          emitsQueued(const [
            StoreEvent<TestModel>.put('_9', TestModel(id: 9 * 9)),
            StoreEvent<TestModel>.put('_8', TestModel(id: 8 * 8)),
            StoreEvent<TestModel>.put('_7', TestModel(id: 7 * 7)),
            StoreEvent<TestModel>.put('_6', TestModel(id: 6 * 6)),
            StoreEvent<TestModel>.put('_8', TestModel(id: 888)),
          ]),
        );

        await store.update('_7', <String, dynamic>{'extra': true});
        final event = await stream.next();
        expect(
          event!.maybeWhen(
            patch: (_, __) => true,
            orElse: () => false,
          ),
          true,
        );

        await store.delete('_10');
        await store.delete('_9');
        await expectLater(
          stream,
          emitsQueued(const StoreEvent<TestModel>.delete('_9')),
        );
      } finally {
        await stream.close();
      }

      expect(stream, isEmpty);
    });

    test('queryKeys', () async {
      for (var i = 4; i < 8; ++i) {
        await store.write('_$i', TestModel(id: i));
      }

      final stream = StreamMatcherQueue(await store.streamQueryKeys(
        Filter.key().startAt('_6').limitToFirst(4).build(),
      ));
      try {
        await expectLater(
          stream,
          emitsQueued(const KeyEvent.reset(['_6', '_7'])),
        );

        for (var i = 12; i > 2; --i) {
          await store.write('_$i', TestModel(id: i * i));
        }
        await store.write('_8', const TestModel(id: 888));

        await expectLater(
          stream,
          emitsQueued(const [
            KeyEvent.update('_9'),
            KeyEvent.update('_8'),
            KeyEvent.update('_7'),
            KeyEvent.update('_6'),
            KeyEvent.update('_8'),
          ]),
        );

        await store.update('_7', <String, dynamic>{'extra': true});
        await expectLater(
          stream,
          emitsQueued(const KeyEvent.update('_7')),
        );

        await store.delete('_10');
        await store.delete('_9');
        await expectLater(
          stream,
          emitsQueued(const KeyEvent.delete('_9')),
        );
      } finally {
        await stream.close();
      }

      expect(stream, isEmpty);
    });
  });
}
