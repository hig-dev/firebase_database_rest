import 'dart:async';

import 'package:meta/meta.dart';

@internal
abstract class TransformerSink<TSource, TDest> implements EventSink<TSource> {
  final EventSink<TDest> outSink;

  TransformerSink(this.outSink);

  @override
  void addError(Object error, [StackTrace? stackTrace]) =>
      outSink.addError(error, stackTrace);

  @override
  void close() => outSink.close();
}
