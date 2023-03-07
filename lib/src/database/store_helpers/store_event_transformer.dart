import 'dart:async';

import 'package:meta/meta.dart';

import '../../common/transformer_sink.dart';
import '../../rest/models/stream_event.dart';
import '../auth_revoked_exception.dart';
import '../store.dart';
import '../store_event.dart';
import 'map_transform.dart';

/// @nodoc
@internal
class StoreEventTransformerSink<T> extends TransformerSink<StreamEvent, StoreEvent<T>>
    with MapTransform<T> {
  static final _subPathRegexp = RegExp(r'^\/([^\/]+)$');
  static final _subPathWithIndexRegexp = RegExp(r'^\/([^\/]+)\/(0|[1-9][0-9]*)$');

  /// @nodoc
  final DataFromJsonCallback<T> dataFromJson;

  /// @nodoc
  final PatchSetFactory<T> patchSetFactory;

  /// @nodoc
  StoreEventTransformerSink({
    required EventSink<StoreEvent<T>> outSink,
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
      _reset(data);
    } else {
      _update(path, data);
    }
  }

  void _reset(dynamic data) => outSink.add(
        StoreEvent.reset(mapTransform(data, dataFromJson)),
      );

  void _update(String path, dynamic data) {
    final match = _subPathRegexp.firstMatch(path);
    if (match != null) {
      if (data != null) {
        outSink.add(StoreEvent.put(match[1]!, dataFromJson(data)));
      } else {
        outSink.add(StoreEvent.delete(match[1]!));
      }
    } else {
      final withIndexMatch = _subPathWithIndexRegexp.firstMatch(path);
      if (withIndexMatch != null) {
        if (data != null) {
          outSink.add(StoreEvent.arrayPut(
              withIndexMatch[1]!, int.parse(withIndexMatch[2]!), dataFromJson(data)));
        } else {
          // Deleting an array value at index is not supported
          outSink.add(StoreEvent.invalidPath(path));
        }
      } else {
        outSink.add(StoreEvent.invalidPath(path));
      }
    }
  }

  void _patch(String path, dynamic data) {
    final match = _subPathRegexp.firstMatch(path);
    if (match != null) {
      outSink.add(StoreEvent.patch(
        match[1]!,
        patchSetFactory(
          data as Map<String, dynamic>? ?? const <String, dynamic>{},
        ),
      ));
    } else {
      outSink.add(StoreEvent.invalidPath(path));
    }
  }

  void _authRevoked() => addError(AuthRevokedException());
}

/// A stream transformer that converts a stream of [StreamEvent]s into a
/// stream of [StoreEvent]s, deserializing the received data and turing database
/// status updates into data updates.
///
/// **Note:** Typically, you would use [FirebaseStore.streamAll] instead of
/// using this class directly.
class StoreEventTransformer<T> implements StreamTransformer<StreamEvent, StoreEvent<T>> {
  /// A callback that can convert the received JSON data to [T]
  final DataFromJsonCallback<T> dataFromJson;

  /// A callback that can generate [PatchSet] instances for patch events
  final PatchSetFactory<T> patchSetFactory;

  /// Default constructor
  const StoreEventTransformer({
    required this.dataFromJson,
    required this.patchSetFactory,
  });

  @override
  Stream<StoreEvent<T>> bind(Stream<StreamEvent> stream) => Stream.eventTransformed(
        stream,
        (sink) => StoreEventTransformerSink(
          outSink: sink,
          dataFromJson: dataFromJson,
          patchSetFactory: patchSetFactory,
        ),
      );

  @override
  StreamTransformer<RS, RT> cast<RS, RT>() =>
      StreamTransformer.castFrom<StreamEvent, StoreEvent<T>, RS, RT>(this);
}
