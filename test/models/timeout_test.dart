import 'package:firebase_database_rest/src/models/timeout.dart';
import 'package:test/test.dart' hide Timeout;

import '../test_fixture.dart';

void main() {
  testWithData('constructs correct timeouts from unit constructors', const [
    Fixture(Timeout.ms(10), Duration(milliseconds: 10), '10ms'),
    Fixture(Timeout.ms(20000), Duration(seconds: 20), '20000ms'),
    Fixture(Timeout.s(10), Duration(seconds: 10), '10s'),
    Fixture(Timeout.s(180), Duration(minutes: 3), '180s'),
    Fixture(Timeout.min(10), Duration(minutes: 10), '10min'),
  ], (fixture) {
    final timeout = fixture.get0<Timeout>();
    final duration = fixture.get1<Duration>();
    final stringValue = fixture.get2<String>();
    expect(timeout.duration, duration);
    expect(timeout.serialize(), stringValue);
  });

  testWithData('fromDuration converts to correct timeout', const [
    Fixture(Duration(milliseconds: 60), Timeout.ms(60)),
    Fixture(Duration(milliseconds: 6000), Timeout.s(6)),
    Fixture(Duration(milliseconds: 6500), Timeout.ms(6500)),
    Fixture(Duration(milliseconds: 60000), Timeout.min(1)),
    Fixture(Duration(milliseconds: 63000), Timeout.s(63)),
    Fixture(Duration(milliseconds: 63500), Timeout.ms(63500)),
  ], (fixture) {
    final duration = fixture.get0<Duration>();
    final timeout = fixture.get1<Timeout>();

    final t = Timeout.fromDuration(duration);
    expect(t, timeout);
    expect(t.duration, duration);
  });

  test('Limits Timeouts to positive times up to 15 minutes', () {
    expect(() => Timeout.ms(-5), throwsA(isA<AssertionError>()));
    expect(
      () => Timeout.ms(15 * 60 * 1000 + 1),
      throwsA(isA<AssertionError>()),
    );
    expect(() => Timeout.s(-5), throwsA(isA<AssertionError>()));
    expect(() => Timeout.s(15 * 60 + 1), throwsA(isA<AssertionError>()));
    expect(() => Timeout.min(-5), throwsA(isA<AssertionError>()));
    expect(() => Timeout.min(15 + 1), throwsA(isA<AssertionError>()));
    expect(
      () => Timeout.fromDuration(const Duration(microseconds: 10)),
      throwsA(isA<AssertionError>()),
    );
    expect(
      () => Timeout.fromDuration(const Duration(minutes: 20)),
      throwsA(isA<AssertionError>()),
    );
  });
}
