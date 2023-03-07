// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'db_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$DbResponse {
  /// The data that was returned by the server.
  dynamic get data => throw _privateConstructorUsedError;

  /// An optional ETag of the data, if it was requested.
  String? get eTag => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $DbResponseCopyWith<DbResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DbResponseCopyWith<$Res> {
  factory $DbResponseCopyWith(
          DbResponse value, $Res Function(DbResponse) then) =
      _$DbResponseCopyWithImpl<$Res, DbResponse>;
  @useResult
  $Res call({dynamic data, String? eTag});
}

/// @nodoc
class _$DbResponseCopyWithImpl<$Res, $Val extends DbResponse>
    implements $DbResponseCopyWith<$Res> {
  _$DbResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = freezed,
    Object? eTag = freezed,
  }) {
    return _then(_value.copyWith(
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as dynamic,
      eTag: freezed == eTag
          ? _value.eTag
          : eTag // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_DbResponseCopyWith<$Res>
    implements $DbResponseCopyWith<$Res> {
  factory _$$_DbResponseCopyWith(
          _$_DbResponse value, $Res Function(_$_DbResponse) then) =
      __$$_DbResponseCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({dynamic data, String? eTag});
}

/// @nodoc
class __$$_DbResponseCopyWithImpl<$Res>
    extends _$DbResponseCopyWithImpl<$Res, _$_DbResponse>
    implements _$$_DbResponseCopyWith<$Res> {
  __$$_DbResponseCopyWithImpl(
      _$_DbResponse _value, $Res Function(_$_DbResponse) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = freezed,
    Object? eTag = freezed,
  }) {
    return _then(_$_DbResponse(
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as dynamic,
      eTag: freezed == eTag
          ? _value.eTag
          : eTag // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$_DbResponse implements _DbResponse {
  const _$_DbResponse({required this.data, this.eTag});

  /// The data that was returned by the server.
  @override
  final dynamic data;

  /// An optional ETag of the data, if it was requested.
  @override
  final String? eTag;

  @override
  String toString() {
    return 'DbResponse(data: $data, eTag: $eTag)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_DbResponse &&
            const DeepCollectionEquality().equals(other.data, data) &&
            (identical(other.eTag, eTag) || other.eTag == eTag));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(data), eTag);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_DbResponseCopyWith<_$_DbResponse> get copyWith =>
      __$$_DbResponseCopyWithImpl<_$_DbResponse>(this, _$identity);
}

abstract class _DbResponse implements DbResponse {
  const factory _DbResponse({required final dynamic data, final String? eTag}) =
      _$_DbResponse;

  @override

  /// The data that was returned by the server.
  dynamic get data;
  @override

  /// An optional ETag of the data, if it was requested.
  String? get eTag;
  @override
  @JsonKey(ignore: true)
  _$$_DbResponseCopyWith<_$_DbResponse> get copyWith =>
      throw _privateConstructorUsedError;
}
