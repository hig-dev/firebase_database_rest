// ignore_for_file: invalid_use_of_protected_member

import 'package:firebase_database_rest/src/database/transaction.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'transaction_test.mocks.dart';

class TestTransaction extends SingleCommitTransaction<int?> {
  final mock = MockHelper();

  @override
  String get eTag => mock.eTag;

  @override
  String get key => mock.key;

  @override
  int? get value => mock.value;

  @override
  Future<void> commitDeleteImpl() => mock.commitDelete();

  @override
  Future<int?> commitUpdateImpl(int? data) => mock.commitUpdate(data);
}

@GenerateMocks([], customMocks: [
  MockSpec<FirebaseTransaction<int?>>(as: #MockHelper),
])
void main() {
  group('SingleCommitTransaction', () {
    late TestTransaction sut;

    setUp(() {
      sut = TestTransaction();
    });

    test('does not affect properties', () {
      when(sut.mock.eTag).thenReturn('eTag');
      when(sut.mock.key).thenReturn('key');
      when(sut.mock.value).thenReturn(42);

      expect(sut.eTag, 'eTag');
      expect(sut.key, 'key');
      expect(sut.value, 42);
    });

    group('allow only once commit', () {
      setUp(() {
        when(sut.mock.commitDelete()).thenAnswer((i) async {});
        when(sut.mock.commitUpdate(any)).thenAnswer((i) async => 42);
      });

      test('update, update', () async {
        final res = await sut.commitUpdate(13);
        expect(res, 42);
        verify(sut.mock.commitUpdate(13));

        expect(
          () => sut.commitUpdate(31),
          throwsA(isA<AlreadyComittedError>()),
        );
        verifyNoMoreInteractions(sut.mock);
      });

      test('update, delete', () async {
        final res = await sut.commitUpdate(13);
        expect(res, 42);
        verify(sut.mock.commitUpdate(13));

        expect(
          () => sut.commitDelete(),
          throwsA(isA<AlreadyComittedError>()),
        );
        verifyNoMoreInteractions(sut.mock);
      });

      test('delete, update', () async {
        await sut.commitDelete();
        verify(sut.mock.commitDelete());

        expect(
          () => sut.commitUpdate(31),
          throwsA(isA<AlreadyComittedError>()),
        );
        verifyNoMoreInteractions(sut.mock);
      });

      test('delete, delete', () async {
        await sut.commitDelete();
        verify(sut.mock.commitDelete());

        expect(
          () => sut.commitDelete(),
          throwsA(isA<AlreadyComittedError>()),
        );
        verifyNoMoreInteractions(sut.mock);
      });
    });
  });
}
