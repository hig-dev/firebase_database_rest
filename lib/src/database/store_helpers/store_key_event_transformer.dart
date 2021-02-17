import 'dart:async';

import 'package:meta/meta.dart';

import '../../common/transformer_sink.dart';
import '../../rest/models/stream_event.dart';
import '../auth_revoked_exception.dart';
import '../store_event.dart';

@internal
class StoreKeyEventTransformerSink
    extends TransformerSink<StreamEvent, KeyEvent> {
  static final subPathRegexp = RegExp(r'^\/([^\/]+)$');

  StoreKeyEventTransformerSink(EventSink<KeyEvent> outSink) : super(outSink);

  @override
  void add(StreamEvent event) => event.when(
        put: _put,
        patch: _value,
        authRevoked: _authRevoked,
      );

  void _put(String path, dynamic data) {
    if (path == '/') {
      final map = data as Map<String, dynamic>?;
      outSink.add(KeyEvent.reset(map?.keys.toList() ?? const []));
    } else {
      _value(path, data);
    }
  }

  void _value(String path, dynamic data) {
    final match = subPathRegexp.firstMatch(path);
    if (match != null) {
      if (data == null) {
        outSink.add(KeyEvent.delete(match[1]!));
      } else {
        outSink.add(KeyEvent.update(match[1]!));
      }
    } else {
      outSink.add(KeyEvent.invalidPath(path));
    }
  }

  void _authRevoked() => addError(AuthRevokedException());
}

class StoreKeyEventTransformer
    implements StreamTransformer<StreamEvent, KeyEvent> {
  const StoreKeyEventTransformer();

  @override
  Stream<KeyEvent> bind(Stream<StreamEvent> stream) => Stream.eventTransformed(
        stream,
        (sink) => StoreKeyEventTransformerSink(sink),
      );

  @override
  StreamTransformer<RS, RT> cast<RS, RT>() =>
      StreamTransformer.castFrom<StreamEvent, KeyEvent, RS, RT>(this);
}
