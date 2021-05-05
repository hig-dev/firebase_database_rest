import 'package:firebase_database_rest/src/database/store_helpers/callback_store.dart';
import 'package:firebase_database_rest/src/rest/rest_api.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

abstract class Callable1 {
  dynamic call(dynamic a1);
}

abstract class Callable2 {
  dynamic call(dynamic a1, dynamic a2);
}

class FakeRestApi extends Fake implements RestApi {}

class MockCallable1 extends Mock implements Callable1 {}

class MockCallable2 extends Mock implements Callable2 {}

void main() {
  final fakeRestApi = FakeRestApi();
  final mockDataFromJson = MockCallable1();
  final mockDataToJson = MockCallable1();
  final mockPatchData = MockCallable2();

  late CallbackFirebaseStore<dynamic> sut;

  setUp(() {
    reset(mockDataFromJson);
    reset(mockDataToJson);
    reset(mockPatchData);

    sut = CallbackFirebaseStore<dynamic>.api(
      restApi: fakeRestApi,
      subPaths: const ['a', 'b'],
      onDataFromJson: mockDataFromJson,
      onDataToJson: mockDataToJson,
      onPatchData: mockPatchData,
    );
  });

  test('passes restApi and subPaths to super', () {
    expect(sut.restApi, fakeRestApi);
    expect(sut.subPaths, const ['a', 'b']);
  });

  test('passes parent and path to super', () {
    final sut2 = CallbackFirebaseStore<dynamic>(
      parent: sut,
      path: 'c',
      onDataFromJson: mockDataFromJson,
      onDataToJson: mockDataToJson,
      onPatchData: mockPatchData,
    );

    expect(sut2.restApi, fakeRestApi);
    expect(sut2.subPaths, const ['a', 'b', 'c']);
  });

  test('dataFromJson calls callback', () async {
    when<dynamic>(() => mockDataFromJson.call(any<dynamic>())).thenReturn(42);

    final dynamic res = sut.dataFromJson('42');

    expect(res, 42);
    verify<dynamic>(() => mockDataFromJson.call('42'));
  });

  test('dataToJson calls callback', () async {
    when<dynamic>(() => mockDataToJson.call(any<dynamic>())).thenReturn(42);

    final dynamic res = sut.dataToJson('42');

    expect(res, 42);
    verify<dynamic>(() => mockDataToJson.call('42'));
  });

  test('patchData calls callback', () async {
    when<dynamic>(() => mockPatchData.call(
          any<dynamic>(),
          any<dynamic>(),
        )).thenReturn(42);

    final dynamic res = sut.patchData('42', <String, dynamic>{'a': true});

    expect(res, 42);
    verify<dynamic>(
        () => mockPatchData.call('42', <String, dynamic>{'a': true}));
  });
}
