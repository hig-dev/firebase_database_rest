import 'dart:async';

import 'package:meta/meta.dart';

import '../../common/transformer_sink.dart';
import '../../rest/models/stream_event.dart';
import '../auth_revoked_exception.dart';
import '../store_event.dart';

/// @nodoc
@internal
class StoreKeyEventTransformerSink
    extends TransformerSink<StreamEvent, KeyEvent> {
  static final _subPathRegexp = RegExp(r'^\/([^\/]+)$');

  /// @nodoc
  StoreKeyEventTransformerSink(EventSink<KeyEvent> outSink) : super(outSink);

  @override
  void add(StreamEvent event) => event.when(
        put: _put,
        patch: _value,
        authRevoked: _authRevoked,
      );

  void _put(String path, dynamic data) {
    if (path == '/') {
      _reset(data);
    } else {
      _value(path, data);
    }
  }

  void _reset(dynamic data) {
    final map = data as Map<String, dynamic>?;
    final keys = map?.entries
        .where((entry) => entry.value != null)
        .map((entry) => entry.key)
        .toList();
    outSink.add(KeyEvent.reset(keys ?? const []));
  }

  void _value(String path, dynamic data) {
    final match = _subPathRegexp.firstMatch(path);
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

/// A stream transformer that converts a stream of [StreamEvent]s into a
/// stream of [KeyEvent]s, deserializing the received data and turing database
/// status updates into key updates.
///
/// **Note:** Typically, you would use [FirebaseStore.streamKeys] instead of
/// using this class directly.
class StoreKeyEventTransformer
    implements StreamTransformer<StreamEvent, KeyEvent> {
  /// Default constructor
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
