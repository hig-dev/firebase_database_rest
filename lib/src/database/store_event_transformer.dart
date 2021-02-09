import 'dart:async';

import '../common/transformer_sink.dart';
import '../rest/models/stream_event.dart';
import 'auth_revoked_exception.dart';
import 'store_event.dart';

typedef DataFromJsonFn<T> = T Function(dynamic json);

typedef PatchSetFactory<T> = PatchSet<T> Function(Map<String, dynamic> data);

class StoreEventTransformerSink<T>
    extends TransformerSink<StreamEvent, StoreEvent<T>> {
  static final subPathRegexp = RegExp(r'^\/([^\/]+)$');

  final DataFromJsonFn<T> dataFromJson;
  final PatchSetFactory<T> patchSetFactory;

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
      _reset(data as Map<String, dynamic>?);
    } else {
      _update(path, data);
    }
  }

  void _reset(Map<String, dynamic>? data) => outSink.add(
        StoreEvent.reset(
          Map.fromEntries(
            (data ?? <String, dynamic>{})
                .entries
                .where((entry) => entry.value != null)
                .map(
                  (entry) => MapEntry(
                    entry.key,
                    dataFromJson(entry.value),
                  ),
                ),
          ),
        ),
      );

  void _update(String path, dynamic data) {
    final match = subPathRegexp.firstMatch(path);
    if (match != null) {
      if (data != null) {
        outSink.add(StoreEvent.put(match[1]!, dataFromJson(data)));
      } else {
        outSink.add(StoreEvent.delete(match[1]!));
      }
    } else {
      outSink.add(StoreEvent.invalidPath(path));
    }
  }

  void _patch(String path, dynamic data) {
    final match = subPathRegexp.firstMatch(path);
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

class StoreEventTransformer<T>
    implements StreamTransformer<StreamEvent, StoreEvent<T>> {
  final DataFromJsonFn<T> dataFromJson;
  final PatchSetFactory<T> patchSetFactory;

  const StoreEventTransformer({
    required this.dataFromJson,
    required this.patchSetFactory,
  });

  @override
  Stream<StoreEvent<T>> bind(Stream<StreamEvent> stream) =>
      Stream.eventTransformed(
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
