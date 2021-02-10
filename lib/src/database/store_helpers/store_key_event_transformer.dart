import 'dart:async';

import 'package:meta/meta.dart';

import '../../common/transformer_sink.dart';
import '../../rest/models/stream_event.dart';
import '../auth_revoked_exception.dart';
import '../store_event.dart';

@internal
class StoreKeyEventTransformerSink
    extends TransformerSink<StreamEvent, DataEvent<String>> {
  static final subPathRegexp = RegExp(r'^\/([^\/]+)$');

  StoreKeyEventTransformerSink(EventSink<DataEvent<String>> outSink)
      : super(outSink);

  @override
  void add(StreamEvent event) => event.when(
        put: (path, dynamic _) => _put(path),
        patch: (path, dynamic _) => _value(path),
        authRevoked: _authRevoked,
      );

  void _put(String path) {
    if (path == '/') {
      outSink.add(const DataEvent.clear());
    } else {
      _value(path);
    }
  }

  void _value(String path) {
    final match = subPathRegexp.firstMatch(path);
    if (match != null) {
      outSink.add(DataEvent.value(match[1]!));
    } else {
      outSink.add(DataEvent.invalidPath(path));
    }
  }

  void _authRevoked() => addError(AuthRevokedException());
}

class StoreKeyEventTransformer
    implements StreamTransformer<StreamEvent, DataEvent<String>> {
  const StoreKeyEventTransformer();

  @override
  Stream<DataEvent<String>> bind(Stream<StreamEvent> stream) =>
      Stream.eventTransformed(
        stream,
        (sink) => StoreKeyEventTransformerSink(sink),
      );

  @override
  StreamTransformer<RS, RT> cast<RS, RT>() =>
      StreamTransformer.castFrom<StreamEvent, DataEvent<String>, RS, RT>(this);
}
