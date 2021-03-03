// coverage:ignore-file
import 'package:freezed_annotation/freezed_annotation.dart';

part 'stream_event.freezed.dart';
part 'stream_event.g.dart';

/// A generic stream event, returned by the server via SSE.
@freezed
class StreamEvent with _$StreamEvent {
  /// A put event, indicating data was created, updated or deleted.
  const factory StreamEvent.put({
    /// The sub path to the request were data was modified.
    required String path,

    /// The data that has been modified.
    required dynamic data,
  }) = StreamEventPut;

  /// A patch event, indicating data was patched.
  const factory StreamEvent.patch({
    /// The sub path to the request were data was modified.
    required String path,

    /// The patchset that was sent by the client to modify the server data.
    required dynamic data,
  }) = StreamEventPatch;

  /// An event sent by the server when the used idToken has expired.
  const factory StreamEvent.authRevoked() = StreamEventAuthRevoked;

  /// @nodoc
  factory StreamEvent.fromJson(Map<String, dynamic> json) =>
      _$StreamEventFromJson(json);
}
