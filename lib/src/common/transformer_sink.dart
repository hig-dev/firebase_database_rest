import 'dart:async';

import 'package:meta/meta.dart';

/// @nodoc
@internal
abstract class TransformerSink<TSource, TDest> implements EventSink<TSource> {
  /// @nodoc
  final EventSink<TDest> outSink;

  /// @nodoc
  TransformerSink(this.outSink);

  @override
  void addError(Object error, [StackTrace? stackTrace]) =>
      outSink.addError(error, stackTrace);

  @override
  void close() => outSink.close();
}
