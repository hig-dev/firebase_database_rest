import 'package:firebase_database_rest/src/database/etag_receiver.dart';
import 'package:test/test.dart';

void main() {
  late ETagReceiver sut;

  setUp(() {
    sut = ETagReceiver();
  });

  test('eTag is initially null', () {
    expect(sut.eTag, isNull);
  });

  test('can set eTag', () {
    sut.eTag = 'new_etag';
    expect(sut.eTag, 'new_etag');
  });

  test('equals and hashCode work correctly', () {
    final sut2 = ETagReceiver();
    final sut3 = ETagReceiver();
    sut.eTag = '2';
    sut2.eTag = '2';
    sut3.eTag = '3';

    expect(sut, sut2);
    expect(sut.hashCode, sut2.hashCode);
    expect(sut, isNot(sut3));
    expect(sut.hashCode, isNot(sut3.hashCode));
  });
}
