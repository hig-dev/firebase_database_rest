// ignore_for_file: prefer_const_constructors
import 'package:firebase_database_rest/src/stream/server_sent_event.dart';
import 'package:test/test.dart';

void main() {
  test("uses correct defaults", () {
    final sut = ServerSentEvent(data: "data");
    expect(sut.data, "data");
    expect(sut.event, "message");
    expect(sut.lastEventId, isNull);
  });
}
