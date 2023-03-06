// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'db_exception.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

DbException _$DbExceptionFromJson(Map<String, dynamic> json) {
  return _Exception.fromJson(json);
}

/// @nodoc
mixin _$DbException {
  /// The HTTP status code returned by the request
  int get statusCode => throw _privateConstructorUsedError;

  /// An optional error message, if the firebase servers provided one.
  String? get error => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DbExceptionCopyWith<DbException> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DbExceptionCopyWith<$Res> {
  factory $DbExceptionCopyWith(
          DbException value, $Res Function(DbException) then) =
      _$DbExceptionCopyWithImpl<$Res, DbException>;
  @useResult
  $Res call({int statusCode, String? error});
}

/// @nodoc
class _$DbExceptionCopyWithImpl<$Res, $Val extends DbException>
    implements $DbExceptionCopyWith<$Res> {
  _$DbExceptionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? statusCode = null,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      statusCode: null == statusCode
          ? _value.statusCode
          : statusCode // ignore: cast_nullable_to_non_nullable
              as int,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ExceptionCopyWith<$Res>
    implements $DbExceptionCopyWith<$Res> {
  factory _$$_ExceptionCopyWith(
          _$_Exception value, $Res Function(_$_Exception) then) =
      __$$_ExceptionCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int statusCode, String? error});
}

/// @nodoc
class __$$_ExceptionCopyWithImpl<$Res>
    extends _$DbExceptionCopyWithImpl<$Res, _$_Exception>
    implements _$$_ExceptionCopyWith<$Res> {
  __$$_ExceptionCopyWithImpl(
      _$_Exception _value, $Res Function(_$_Exception) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? statusCode = null,
    Object? error = freezed,
  }) {
    return _then(_$_Exception(
      statusCode: null == statusCode
          ? _value.statusCode
          : statusCode // ignore: cast_nullable_to_non_nullable
              as int,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Exception extends _Exception {
  const _$_Exception({this.statusCode = 400, this.error}) : super._();

  factory _$_Exception.fromJson(Map<String, dynamic> json) =>
      _$$_ExceptionFromJson(json);

  /// The HTTP status code returned by the request
  @override
  @JsonKey()
  final int statusCode;

  /// An optional error message, if the firebase servers provided one.
  @override
  final String? error;

  @override
  String toString() {
    return 'DbException(statusCode: $statusCode, error: $error)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Exception &&
            (identical(other.statusCode, statusCode) ||
                other.statusCode == statusCode) &&
            (identical(other.error, error) || other.error == error));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, statusCode, error);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ExceptionCopyWith<_$_Exception> get copyWith =>
      __$$_ExceptionCopyWithImpl<_$_Exception>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ExceptionToJson(
      this,
    );
  }
}

abstract class _Exception extends DbException {
  const factory _Exception({final int statusCode, final String? error}) =
      _$_Exception;
  const _Exception._() : super._();

  factory _Exception.fromJson(Map<String, dynamic> json) =
      _$_Exception.fromJson;

  @override

  /// The HTTP status code returned by the request
  int get statusCode;
  @override

  /// An optional error message, if the firebase servers provided one.
  String? get error;
  @override
  @JsonKey(ignore: true)
  _$$_ExceptionCopyWith<_$_Exception> get copyWith =>
      throw _privateConstructorUsedError;
}
