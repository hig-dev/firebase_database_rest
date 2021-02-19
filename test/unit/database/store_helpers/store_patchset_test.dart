import 'package:firebase_database_rest/src/database/store.dart';
import 'package:firebase_database_rest/src/database/store_helpers/store_patchset.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class MockFirebaseStore extends Mock implements FirebaseStore<int> {
  @override
  int patchData(int? data, Map<String, dynamic>? updatedFields) =>
      super.noSuchMethod(
        Invocation.method(#patchData, [data, updatedFields]),
        returnValueForMissingStub: 0,
      ) as int;
}

void main() {
  const patchData = {'a': 1, 'b': 2};
  final mockFirebaseStore = MockFirebaseStore();

  late StorePatchSet<int> sut;

  setUp(() {
    reset(mockFirebaseStore);

    sut = StorePatchSet<int>(
      store: mockFirebaseStore,
      data: patchData,
    );
  });

  test('apply calls patchData on store with data', () {
    when(mockFirebaseStore.patchData(any, any)).thenReturn(42);

    final res = sut.apply(13);

    expect(res, 42);
    verify(mockFirebaseStore.patchData(13, patchData));
  });
}
