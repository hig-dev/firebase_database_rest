import 'dart:async';

import 'package:meta/meta.dart';

import '../../common/transformer_sink.dart';
import '../../rest/models/stream_event.dart';
import '../auth_revoked_exception.dart';
import '../store.dart';
import '../store_event.dart';

/// @nodoc
@internal
class StoreValueEventTransformerSink<T>
    extends TransformerSink<StreamEvent, ValueEvent<T>> {
  /// @nodoc
  final DataFromJsonCallback<T> dataFromJson;

  /// @nodoc
  final PatchSetFactory<T> patchSetFactory;

  /// @nodoc
  StoreValueEventTransformerSink({
    required EventSink<ValueEvent<T>> outSink,
    required this.dataFromJson,
    required this.patchSetFactory,
  }) : super(outSink);

  @override
  void add(StreamEvent event) => event.when(
        put: _put,
        patch: _patch,
        authRevoked: _authRevoked,
      );

  void _put(String path, dynamic data) {
    if (path == '/') {
      if (data == null) {
        outSink.add(const ValueEvent.delete());
      } else {
        outSink.add(ValueEvent.update(dataFromJson(data)));
      }
    } else {
      outSink.add(ValueEvent.invalidPath(path));
    }
  }

  void _patch(String path, dynamic data) {
    if (path == '/') {
      final patch = patchSetFactory(data as Map<String, dynamic>);
      outSink.add(ValueEvent.patch(patch));
    } else {
      outSink.add(ValueEvent.invalidPath(path));
    }
  }

  void _authRevoked() => addError(AuthRevokedException());
}

/// A stream transformer that converts a stream of [StreamEvent]s into a
/// stream of [ValueEvent]s, deserializing the received data and turing database
/// status updates into data updates.
///
/// **Note:** Typically, you would use [FirebaseStore.streamEntry] instead of
/// using this class directly.
class StoreValueEventTransformer<T>
    implements StreamTransformer<StreamEvent, ValueEvent<T>> {
  /// A callback that can convert the received JSON data to [T]
  final DataFromJsonCallback<T> dataFromJson;

  /// A callback that can generate [PatchSet] instances for patch events
  final PatchSetFactory<T> patchSetFactory;

  /// Default constructor
  const StoreValueEventTransformer({
    required this.dataFromJson,
    required this.patchSetFactory,
  });

  @override
  Stream<ValueEvent<T>> bind(Stream<StreamEvent> stream) =>
      Stream.eventTransformed(
        stream,
        (sink) => StoreValueEventTransformerSink<T>(
          outSink: sink,
          dataFromJson: dataFromJson,
          patchSetFactory: patchSetFactory,
        ),
      );

  @override
  StreamTransformer<RS, RT> cast<RS, RT>() =>
      StreamTransformer.castFrom<StreamEvent, ValueEvent<T>, RS, RT>(this);
}
