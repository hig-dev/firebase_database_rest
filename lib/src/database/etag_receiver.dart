import 'package:freezed_annotation/freezed_annotation.dart';

import '../../firebase_database_rest.dart';

/// A helper class to obtain ETags from [FirebaseStore] requests.
class ETagReceiver {
  String? _eTag;

  /// The [eTag] that was returned by the server
  ///
  /// This value is initially `null`, until set by the [FirebaseStore] after a
  /// request. If the request succeeds, the receivers eTag should contain the
  /// value and never be `null`.
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

    return other is ETagReceiver && _eTag == other._eTag;
  }

  @override
  int get hashCode => runtimeType.hashCode ^ _eTag.hashCode;
}
