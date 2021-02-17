import 'dart:async';

import 'package:meta/meta.dart';

import '../../common/transformer_sink.dart';
import '../../rest/models/stream_event.dart';
import '../auth_revoked_exception.dart';
import '../patch_on_null_error.dart';
import '../store.dart';
import '../store_event.dart';

@internal
class StoreValueEventTransformerSink<T>
    extends TransformerSink<StreamEvent, ValueEvent<T>> {
  final DataFromJsonCallback<T> dataFromJson;
  final PatchSetFactory<T> patchSetFactory;

  T? _currentValue;

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
        _currentValue = null;
        outSink.add(const ValueEvent.delete());
      } else {
        _currentValue = dataFromJson(data);
        outSink.add(ValueEvent.update(_currentValue!));
      }
    } else {
      outSink.add(ValueEvent.invalidPath(path));
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
      outSink.add(ValueEvent.update(_currentValue!));
    } else {
      outSink.add(ValueEvent.invalidPath(path));
    }
  }

  void _authRevoked() => addError(AuthRevokedException());
}

class StoreValueEventTransformer<T>
    implements StreamTransformer<StreamEvent, ValueEvent<T>> {
  final DataFromJsonCallback<T> dataFromJson;
  final PatchSetFactory<T> patchSetFactory;

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
