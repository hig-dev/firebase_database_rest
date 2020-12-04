import 'package:firebase_database_rest/src/models/api_constants.dart';
import 'package:firebase_database_rest/src/timestamp.dart';
import 'package:test/test.dart';

void main() {
  test('default constructor wraps datetime', () {
    final dateTime = DateTime.now();
    final timestamp = FirebaseTimestamp(dateTime);

    expect(timestamp.dateTime, dateTime);
    expect(timestamp.toJson(), dateTime.toIso8601String());

    final jStamp = FirebaseTimestamp.fromJson(dateTime.toIso8601String());
    expect(jStamp, timestamp);
  });

  test('server constructor wraps server timestamp placeholder', () {
    const timestamp = FirebaseTimestamp.server();

    expect(timestamp.dateTime, isNull);
    expect(timestamp.toJson(), ApiConstants.serverTimeStamp);

    expect(
      () => FirebaseTimestamp.fromJson(ApiConstants.serverTimeStamp),
      throwsA(isA<ArgumentError>()),
    );
  });
}
