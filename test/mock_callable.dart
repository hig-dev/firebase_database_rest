import 'package:mockito/mockito.dart';

abstract class Callable0<TR> {
  TR call();
}

abstract class Callable1<TR, T1> {
  TR call(T1 p1);
}

abstract class Callable2<TR, T1, T2> {
  TR call(T1 p1, T2 p2);
}

class MockCallable0<TR> extends Mock implements Callable0<TR> {
  MockCallable0() {
    if (TR.toString() != 'void') {
      throwOnMissingStub(this);
    }
  }
}

class MockCallable1<TR, T1> extends Mock implements Callable1<TR, T1> {
  MockCallable1() {
    if (TR.toString() != 'void') {
      throwOnMissingStub(this);
    }
  }
}

class MockCallable2<TR, T1, T2> extends Mock implements Callable2<TR, T1, T2> {
  MockCallable2() {
    if (TR.toString() != 'void') {
      throwOnMissingStub(this);
    }
  }
}
