// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stream_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

StreamEvent _$StreamEventFromJson(Map<String, dynamic> json) {
  switch (json['runtimeType']) {
    case 'put':
      return StreamEventPut.fromJson(json);
    case 'patch':
      return StreamEventPatch.fromJson(json);
    case 'authRevoked':
      return StreamEventAuthRevoked.fromJson(json);

    default:
      throw CheckedFromJsonException(json, 'runtimeType', 'StreamEvent',
          'Invalid union type "${json['runtimeType']}"!');
  }
}

/// @nodoc
mixin _$StreamEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String path, dynamic data) put,
    required TResult Function(String path, dynamic data) patch,
    required TResult Function() authRevoked,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String path, dynamic data)? put,
    TResult? Function(String path, dynamic data)? patch,
    TResult? Function()? authRevoked,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String path, dynamic data)? put,
    TResult Function(String path, dynamic data)? patch,
    TResult Function()? authRevoked,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(StreamEventPut value) put,
    required TResult Function(StreamEventPatch value) patch,
    required TResult Function(StreamEventAuthRevoked value) authRevoked,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(StreamEventPut value)? put,
    TResult? Function(StreamEventPatch value)? patch,
    TResult? Function(StreamEventAuthRevoked value)? authRevoked,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StreamEventPut value)? put,
    TResult Function(StreamEventPatch value)? patch,
    TResult Function(StreamEventAuthRevoked value)? authRevoked,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StreamEventCopyWith<$Res> {
  factory $StreamEventCopyWith(
          StreamEvent value, $Res Function(StreamEvent) then) =
      _$StreamEventCopyWithImpl<$Res, StreamEvent>;
}

/// @nodoc
class _$StreamEventCopyWithImpl<$Res, $Val extends StreamEvent>
    implements $StreamEventCopyWith<$Res> {
  _$StreamEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$StreamEventPutCopyWith<$Res> {
  factory _$$StreamEventPutCopyWith(
          _$StreamEventPut value, $Res Function(_$StreamEventPut) then) =
      __$$StreamEventPutCopyWithImpl<$Res>;
  @useResult
  $Res call({String path, dynamic data});
}

/// @nodoc
class __$$StreamEventPutCopyWithImpl<$Res>
    extends _$StreamEventCopyWithImpl<$Res, _$StreamEventPut>
    implements _$$StreamEventPutCopyWith<$Res> {
  __$$StreamEventPutCopyWithImpl(
      _$StreamEventPut _value, $Res Function(_$StreamEventPut) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? path = null,
    Object? data = freezed,
  }) {
    return _then(_$StreamEventPut(
      path: null == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String,
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StreamEventPut implements StreamEventPut {
  const _$StreamEventPut(
      {required this.path, required this.data, final String? $type})
      : $type = $type ?? 'put';

  factory _$StreamEventPut.fromJson(Map<String, dynamic> json) =>
      _$$StreamEventPutFromJson(json);

  /// The sub path to the request were data was modified.
  @override
  final String path;

  /// The data that has been modified.
  @override
  final dynamic data;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'StreamEvent.put(path: $path, data: $data)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StreamEventPut &&
            (identical(other.path, path) || other.path == path) &&
            const DeepCollectionEquality().equals(other.data, data));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, path, const DeepCollectionEquality().hash(data));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$StreamEventPutCopyWith<_$StreamEventPut> get copyWith =>
      __$$StreamEventPutCopyWithImpl<_$StreamEventPut>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String path, dynamic data) put,
    required TResult Function(String path, dynamic data) patch,
    required TResult Function() authRevoked,
  }) {
    return put(path, data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String path, dynamic data)? put,
    TResult? Function(String path, dynamic data)? patch,
    TResult? Function()? authRevoked,
  }) {
    return put?.call(path, data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String path, dynamic data)? put,
    TResult Function(String path, dynamic data)? patch,
    TResult Function()? authRevoked,
    required TResult orElse(),
  }) {
    if (put != null) {
      return put(path, data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(StreamEventPut value) put,
    required TResult Function(StreamEventPatch value) patch,
    required TResult Function(StreamEventAuthRevoked value) authRevoked,
  }) {
    return put(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(StreamEventPut value)? put,
    TResult? Function(StreamEventPatch value)? patch,
    TResult? Function(StreamEventAuthRevoked value)? authRevoked,
  }) {
    return put?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StreamEventPut value)? put,
    TResult Function(StreamEventPatch value)? patch,
    TResult Function(StreamEventAuthRevoked value)? authRevoked,
    required TResult orElse(),
  }) {
    if (put != null) {
      return put(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$StreamEventPutToJson(
      this,
    );
  }
}

abstract class StreamEventPut implements StreamEvent {
  const factory StreamEventPut(
      {required final String path,
      required final dynamic data}) = _$StreamEventPut;

  factory StreamEventPut.fromJson(Map<String, dynamic> json) =
      _$StreamEventPut.fromJson;

  /// The sub path to the request were data was modified.
  String get path;

  /// The data that has been modified.
  dynamic get data;
  @JsonKey(ignore: true)
  _$$StreamEventPutCopyWith<_$StreamEventPut> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$StreamEventPatchCopyWith<$Res> {
  factory _$$StreamEventPatchCopyWith(
          _$StreamEventPatch value, $Res Function(_$StreamEventPatch) then) =
      __$$StreamEventPatchCopyWithImpl<$Res>;
  @useResult
  $Res call({String path, dynamic data});
}

/// @nodoc
class __$$StreamEventPatchCopyWithImpl<$Res>
    extends _$StreamEventCopyWithImpl<$Res, _$StreamEventPatch>
    implements _$$StreamEventPatchCopyWith<$Res> {
  __$$StreamEventPatchCopyWithImpl(
      _$StreamEventPatch _value, $Res Function(_$StreamEventPatch) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? path = null,
    Object? data = freezed,
  }) {
    return _then(_$StreamEventPatch(
      path: null == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String,
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StreamEventPatch implements StreamEventPatch {
  const _$StreamEventPatch(
      {required this.path, required this.data, final String? $type})
      : $type = $type ?? 'patch';

  factory _$StreamEventPatch.fromJson(Map<String, dynamic> json) =>
      _$$StreamEventPatchFromJson(json);

  /// The sub path to the request were data was modified.
  @override
  final String path;

  /// The patchset that was sent by the client to modify the server data.
  @override
  final dynamic data;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'StreamEvent.patch(path: $path, data: $data)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StreamEventPatch &&
            (identical(other.path, path) || other.path == path) &&
            const DeepCollectionEquality().equals(other.data, data));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, path, const DeepCollectionEquality().hash(data));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$StreamEventPatchCopyWith<_$StreamEventPatch> get copyWith =>
      __$$StreamEventPatchCopyWithImpl<_$StreamEventPatch>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String path, dynamic data) put,
    required TResult Function(String path, dynamic data) patch,
    required TResult Function() authRevoked,
  }) {
    return patch(path, data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String path, dynamic data)? put,
    TResult? Function(String path, dynamic data)? patch,
    TResult? Function()? authRevoked,
  }) {
    return patch?.call(path, data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String path, dynamic data)? put,
    TResult Function(String path, dynamic data)? patch,
    TResult Function()? authRevoked,
    required TResult orElse(),
  }) {
    if (patch != null) {
      return patch(path, data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(StreamEventPut value) put,
    required TResult Function(StreamEventPatch value) patch,
    required TResult Function(StreamEventAuthRevoked value) authRevoked,
  }) {
    return patch(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(StreamEventPut value)? put,
    TResult? Function(StreamEventPatch value)? patch,
    TResult? Function(StreamEventAuthRevoked value)? authRevoked,
  }) {
    return patch?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StreamEventPut value)? put,
    TResult Function(StreamEventPatch value)? patch,
    TResult Function(StreamEventAuthRevoked value)? authRevoked,
    required TResult orElse(),
  }) {
    if (patch != null) {
      return patch(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$StreamEventPatchToJson(
      this,
    );
  }
}

abstract class StreamEventPatch implements StreamEvent {
  const factory StreamEventPatch(
      {required final String path,
      required final dynamic data}) = _$StreamEventPatch;

  factory StreamEventPatch.fromJson(Map<String, dynamic> json) =
      _$StreamEventPatch.fromJson;

  /// The sub path to the request were data was modified.
  String get path;

  /// The patchset that was sent by the client to modify the server data.
  dynamic get data;
  @JsonKey(ignore: true)
  _$$StreamEventPatchCopyWith<_$StreamEventPatch> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$StreamEventAuthRevokedCopyWith<$Res> {
  factory _$$StreamEventAuthRevokedCopyWith(_$StreamEventAuthRevoked value,
          $Res Function(_$StreamEventAuthRevoked) then) =
      __$$StreamEventAuthRevokedCopyWithImpl<$Res>;
}

/// @nodoc
class __$$StreamEventAuthRevokedCopyWithImpl<$Res>
    extends _$StreamEventCopyWithImpl<$Res, _$StreamEventAuthRevoked>
    implements _$$StreamEventAuthRevokedCopyWith<$Res> {
  __$$StreamEventAuthRevokedCopyWithImpl(_$StreamEventAuthRevoked _value,
      $Res Function(_$StreamEventAuthRevoked) _then)
      : super(_value, _then);
}

/// @nodoc
@JsonSerializable()
class _$StreamEventAuthRevoked implements StreamEventAuthRevoked {
  const _$StreamEventAuthRevoked({final String? $type})
      : $type = $type ?? 'authRevoked';

  factory _$StreamEventAuthRevoked.fromJson(Map<String, dynamic> json) =>
      _$$StreamEventAuthRevokedFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'StreamEvent.authRevoked()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$StreamEventAuthRevoked);
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String path, dynamic data) put,
    required TResult Function(String path, dynamic data) patch,
    required TResult Function() authRevoked,
  }) {
    return authRevoked();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String path, dynamic data)? put,
    TResult? Function(String path, dynamic data)? patch,
    TResult? Function()? authRevoked,
  }) {
    return authRevoked?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String path, dynamic data)? put,
    TResult Function(String path, dynamic data)? patch,
    TResult Function()? authRevoked,
    required TResult orElse(),
  }) {
    if (authRevoked != null) {
      return authRevoked();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(StreamEventPut value) put,
    required TResult Function(StreamEventPatch value) patch,
    required TResult Function(StreamEventAuthRevoked value) authRevoked,
  }) {
    return authRevoked(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(StreamEventPut value)? put,
    TResult? Function(StreamEventPatch value)? patch,
    TResult? Function(StreamEventAuthRevoked value)? authRevoked,
  }) {
    return authRevoked?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StreamEventPut value)? put,
    TResult Function(StreamEventPatch value)? patch,
    TResult Function(StreamEventAuthRevoked value)? authRevoked,
    required TResult orElse(),
  }) {
    if (authRevoked != null) {
      return authRevoked(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$StreamEventAuthRevokedToJson(
      this,
    );
  }
}

abstract class StreamEventAuthRevoked implements StreamEvent {
  const factory StreamEventAuthRevoked() = _$StreamEventAuthRevoked;

  factory StreamEventAuthRevoked.fromJson(Map<String, dynamic> json) =
      _$StreamEventAuthRevoked.fromJson;
}
