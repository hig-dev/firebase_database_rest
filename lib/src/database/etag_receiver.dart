import 'package:freezed_annotation/freezed_annotation.dart';

class ETagReceiver {
  String? _eTag;

  // ignore: unnecessary_getters_setters
  String? get eTag => _eTag;

  @internal
  // ignore: unnecessary_getters_setters
  set eTag(String? eTag) => _eTag = eTag;

  @override
  String toString() => 'ETag: $eTag';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is ETagReceiver && eTag == other.eTag;
  }

  @override
  int get hashCode => runtimeType.hashCode ^ (eTag?.hashCode ?? 0);
}
