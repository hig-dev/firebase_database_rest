import 'package:firebase_database_rest/src/rest/api_constants.dart';
import 'package:test/test.dart';
import 'package:tuple/tuple.dart';

import '../../test_data.dart';

void main() {
  testData<Tuple2<PrintMode, String>>(
    'PrintMode provides correct values',
    const [
      Tuple2(PrintMode.pretty, 'pretty'),
      Tuple2(PrintMode.silent, 'silent'),
    ],
    (fixture) {
      expect(fixture.item1.value, fixture.item2);
    },
  );

  testData<Tuple2<FormatMode, String>>(
    'FormatMode provides correct values',
    const [
      Tuple2(FormatMode.export, 'export'),
    ],
    (fixture) {
      expect(fixture.item1.value, fixture.item2);
    },
  );

  testData<Tuple2<WriteSizeLimit, String>>(
    'WriteSizeLimit provides correct values',
    const [
      Tuple2(WriteSizeLimit.tiny, 'tiny'),
      Tuple2(WriteSizeLimit.small, 'small'),
      Tuple2(WriteSizeLimit.medium, 'medium'),
      Tuple2(WriteSizeLimit.large, 'large'),
      Tuple2(WriteSizeLimit.unlimited, 'unlimited'),
    ],
    (fixture) {
      expect(fixture.item1.value, fixture.item2);
    },
  );
}
