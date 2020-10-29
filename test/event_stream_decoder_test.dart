import 'dart:async';

import 'package:firebase_database_rest/src/stream/event_stream_decoder.dart';
import 'package:firebase_database_rest/src/stream/server_sent_event.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

abstract class Callable0 {
  void call();
}

abstract class Callable1<T1> {
  void call(T1 p1);
}

abstract class Callable2<T1, T2> {
  void call(T1 p1, T2 p2);
}

class MockStream extends Mock implements Stream<String> {}

class MockStreamSubscription extends Mock
    implements StreamSubscription<String> {}

class MockCallable0 extends Mock implements Callable0 {}

class MockCallable1<T1> extends Mock implements Callable1<T1> {}

class MockCallable2<T1, T2> extends Mock implements Callable2<T1, T2> {}

void main() {
  final mockSub = MockStreamSubscription();
  final mockStream = MockStream();

  // ignore: prefer_const_constructors
  final sut = EventStreamDecoder();

  setUp(() {
    reset(mockSub);
    reset(mockStream);

    when(mockStream.listen(
      any,
      onDone: anyNamed("onDone"),
      onError: anyNamed("onError"),
      cancelOnError: anyNamed("cancelOnError"),
    )).thenReturn(mockSub);
  });

  test("calls listen on base stream", () async {
    final stream = sut.bind(mockStream);
    stream.listen((event) {});
    await _pump();

    verify(mockStream.listen(
      any,
      onDone: anyNamed("onDone"),
      onError: anyNamed("onError"),
      cancelOnError: true,
    ));
  });

  test("forwards onDone event", () async {
    final mockOnDone = MockCallable0();

    final stream = sut.bind(mockStream);
    stream.listen((event) {}, onDone: mockOnDone);
    await _pump();

    final onDone = verify(mockStream.listen(
      any,
      onDone: captureAnyNamed("onDone"),
      onError: anyNamed("onError"),
      cancelOnError: true,
    )).captured.single as void Function();
    expect(onDone, isNotNull);

    onDone();
    await _pump();
    verify(mockOnDone.call());
  });

  test("forwards onError event", () async {
    final mockOnError = MockCallable2<Object, StackTrace>();

    final stream = sut.bind(mockStream);
    stream.listen((event) {}, onError: mockOnError);
    await _pump();

    final onError = verify(mockStream.listen(
      any,
      onDone: anyNamed("onDone"),
      onError: captureAnyNamed("onError"),
      cancelOnError: true,
    )).captured.single as Function;
    expect(onError, isNotNull);

    final trace = StackTrace.current;
    onError("error", trace);
    await _pump();
    verify(mockOnError.call("error", trace));
  });

  test("Transforms lines to events", () async {
    final stream = sut.bind(Stream.fromIterable(const [
      "event: ev1",
      "data: data1",
      "",
      "event: ev2",
      "data: data2.1",
      "data",
      "data: data2.2",
      "",
      "data:   data3 ",
      "event:    ev3    ",
      "",
      "data: data4",
      "",
      "event: ev5",
      "",
      "event: ev6",
      "event: ev7",
      "data: data7",
      "",
      ": comment",
      "",
      "data: data8",
      "id: 42",
      "",
      "data: data9",
      "ignored: data",
      "",
      "data: data10",
      "id",
      "",
      "data",
      "event",
    ]));

    final res = await stream.toList();
    expect(res, const [
      ServerSentEvent(event: "ev1", data: "data1"),
      ServerSentEvent(event: "ev2", data: "data2.1\n\ndata2.2"),
      ServerSentEvent(event: "   ev3    ", data: "  data3 "),
      ServerSentEvent(event: "message", data: "data4"),
      ServerSentEvent(event: "ev7", data: "data7"),
      ServerSentEvent(event: "message", data: "data8", lastEventId: "42"),
      ServerSentEvent(event: "message", data: "data9", lastEventId: "42"),
      ServerSentEvent(event: "message", data: "data10"),
      ServerSentEvent(event: "message", data: ""),
    ]);
  });

  test("cast returns transformed instance", () {
    final castTransformer = sut.cast<String, ServerSentEvent>();
    expect(castTransformer, isNotNull);
  });
}

Future<void> _pump([Duration duration = Duration.zero]) =>
    Future<void>.delayed(duration);
