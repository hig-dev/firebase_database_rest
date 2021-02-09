import 'dart:async';

import '../common/transformer_sink.dart';
import '../rest/models/stream_event.dart';
import 'auth_revoked_exception.dart';
import 'patch_on_null_error.dart';
import 'store_event.dart';

typedef DataFromJsonFn<T> = T Function(dynamic json);

typedef PatchSetFactory<T> = PatchSet<T> Function(Map<String, dynamic> data);

class StoreValueEventTransformerSink<T>
    extends TransformerSink<StreamEvent, DataEvent<T>> {
  final DataFromJsonFn<T> dataFromJson;
  final PatchSetFactory<T> patchSetFactory;

  T? _currentValue;

  StoreValueEventTransformerSink({
    required EventSink<DataEvent<T>> outSink,
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
      _currentValue = dataFromJson(data);
      outSink.add(DataEvent.value(_currentValue!));
    } else {
      outSink.add(DataEvent.invalidPath(path));
    }
  }

  void _patch(String path, dynamic data) {
    if (path == '/') {
      if (_currentValue == null) {
        outSink.addError(PatchOnNullError());
        return;
      }
      final patch = patchSetFactory(data as Map<String, dynamic>);
      _currentValue = patch.apply(_currentValue!);
      outSink.add(DataEvent.value(_currentValue!));
    } else {
      outSink.add(DataEvent.invalidPath(path));
    }
  }

  void _authRevoked() => addError(AuthRevokedException());
}

class StoreValueEventTransformer<T>
    implements StreamTransformer<StreamEvent, DataEvent<T>> {
  final DataFromJsonFn<T> dataFromJson;
  final PatchSetFactory<T> patchSetFactory;

  const StoreValueEventTransformer({
    required this.dataFromJson,
    required this.patchSetFactory,
  });

  @override
  Stream<DataEvent<T>> bind(Stream<StreamEvent> stream) =>
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
      StreamTransformer.castFrom<StreamEvent, DataEvent<T>, RS, RT>(this);
}
