// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'server_sent_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$ServerSentEvent {
  /// The event type of this SSE. Defaults to `message`, if not set.
  String get event => throw _privateConstructorUsedError;

  /// The data that was sent by the server. Can be an empty string.
  String get data => throw _privateConstructorUsedError;

  /// An optional ID of the last event.
  ///
  /// Can be used to resume a stream if supported by the server. See
  /// [EventSourceClientX.stream].
  String? get lastEventId => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ServerSentEventCopyWith<ServerSentEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ServerSentEventCopyWith<$Res> {
  factory $ServerSentEventCopyWith(
          ServerSentEvent value, $Res Function(ServerSentEvent) then) =
      _$ServerSentEventCopyWithImpl<$Res, ServerSentEvent>;
  @useResult
  $Res call({String event, String data, String? lastEventId});
}

/// @nodoc
class _$ServerSentEventCopyWithImpl<$Res, $Val extends ServerSentEvent>
    implements $ServerSentEventCopyWith<$Res> {
  _$ServerSentEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? event = null,
    Object? data = null,
    Object? lastEventId = freezed,
  }) {
    return _then(_value.copyWith(
      event: null == event
          ? _value.event
          : event // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as String,
      lastEventId: freezed == lastEventId
          ? _value.lastEventId
          : lastEventId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ServerSentEventCopyWith<$Res>
    implements $ServerSentEventCopyWith<$Res> {
  factory _$$_ServerSentEventCopyWith(
          _$_ServerSentEvent value, $Res Function(_$_ServerSentEvent) then) =
      __$$_ServerSentEventCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String event, String data, String? lastEventId});
}

/// @nodoc
class __$$_ServerSentEventCopyWithImpl<$Res>
    extends _$ServerSentEventCopyWithImpl<$Res, _$_ServerSentEvent>
    implements _$$_ServerSentEventCopyWith<$Res> {
  __$$_ServerSentEventCopyWithImpl(
      _$_ServerSentEvent _value, $Res Function(_$_ServerSentEvent) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? event = null,
    Object? data = null,
    Object? lastEventId = freezed,
  }) {
    return _then(_$_ServerSentEvent(
      event: null == event
          ? _value.event
          : event // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as String,
      lastEventId: freezed == lastEventId
          ? _value.lastEventId
          : lastEventId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$_ServerSentEvent implements _ServerSentEvent {
  const _$_ServerSentEvent(
      {this.event = 'message', required this.data, this.lastEventId});

  /// The event type of this SSE. Defaults to `message`, if not set.
  @override
  @JsonKey()
  final String event;

  /// The data that was sent by the server. Can be an empty string.
  @override
  final String data;

  /// An optional ID of the last event.
  ///
  /// Can be used to resume a stream if supported by the server. See
  /// [EventSourceClientX.stream].
  @override
  final String? lastEventId;

  @override
  String toString() {
    return 'ServerSentEvent(event: $event, data: $data, lastEventId: $lastEventId)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ServerSentEvent &&
            (identical(other.event, event) || other.event == event) &&
            (identical(other.data, data) || other.data == data) &&
            (identical(other.lastEventId, lastEventId) ||
                other.lastEventId == lastEventId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, event, data, lastEventId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ServerSentEventCopyWith<_$_ServerSentEvent> get copyWith =>
      __$$_ServerSentEventCopyWithImpl<_$_ServerSentEvent>(this, _$identity);
}

abstract class _ServerSentEvent implements ServerSentEvent {
  const factory _ServerSentEvent(
      {final String event,
      required final String data,
      final String? lastEventId}) = _$_ServerSentEvent;

  @override

  /// The event type of this SSE. Defaults to `message`, if not set.
  String get event;
  @override

  /// The data that was sent by the server. Can be an empty string.
  String get data;
  @override

  /// An optional ID of the last event.
  ///
  /// Can be used to resume a stream if supported by the server. See
  /// [EventSourceClientX.stream].
  String? get lastEventId;
  @override
  @JsonKey(ignore: true)
  _$$_ServerSentEventCopyWith<_$_ServerSentEvent> get copyWith =>
      throw _privateConstructorUsedError;
}
