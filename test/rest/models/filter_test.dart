import 'package:firebase_database_rest/src/rest/models/filter.dart';
import 'package:test/test.dart';

void main() {
  group('order', () {
    test('property sets orderBy to name', () {
      final filters = Filter.property<int>('name').build();

      expect(filters.filters, const {
        'orderBy': '"name"',
      });
    });

    test(r'key sets orderBy to $key', () {
      final filters = Filter.key().build();

      expect(filters.filters, const {
        'orderBy': r'"$key"',
      });
    });

    test(r'value sets orderBy to $value', () {
      final filters = Filter.value<bool>().build();

      expect(filters.filters, const {
        'orderBy': r'"$value"',
      });
    });
  });

  group('filter', () {
    test('limitToFirst sets value as query parameter', () {
      final filters = Filter.key().limitToFirst(10).build();

      expect(filters.filters, const {
        'orderBy': r'"$key"',
        'limitToFirst': '10',
      });
    });

    test('limitToLast sets value as query parameter', () {
      final filters = Filter.key().limitToLast(10).build();

      expect(filters.filters, const {
        'orderBy': r'"$key"',
        'limitToLast': '10',
      });
    });

    test('startAt sets value as query parameter', () {
      final filters = Filter.key().startAt('A').build();

      expect(filters.filters, const {
        'orderBy': r'"$key"',
        'startAt': '"A"',
      });
    });

    test('endAt sets value as query parameter', () {
      final filters = Filter.key().endAt('A').build();

      expect(filters.filters, const {
        'orderBy': r'"$key"',
        'endAt': '"A"',
      });
    });

    test('equalTo sets value as query parameter', () {
      final filters = Filter.key().equalTo('A').build();

      expect(filters.filters, const {
        'orderBy': r'"$key"',
        'equalTo': '"A"',
      });
    });
  });
}
