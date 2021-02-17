import 'package:firebase_database_rest/src/database/store_helpers/map_transform.dart';
import 'package:test/test.dart';

class Sut with MapTransform<int> {
  Map<String, int> call(dynamic data) => mapTransform(
        data,
        (dynamic x) => x != null ? (x as int) * 2 : null,
      );
}

void main() {
  late Sut sut;

  setUp(() {
    sut = Sut();
  });

  test('mapTransform transforms map', () {
    final res = sut(<String, dynamic>{
      'a': 1,
      'b': 2,
      'c': null,
      'd': 4,
    });

    expect(res, {
      'a': 2,
      'b': 4,
      'd': 8,
    });
  });

  test('mapTransform', () {
    final res = sut(null);
    expect(res, const <String, int>{});
  });
}
