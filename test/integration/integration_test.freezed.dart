// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'integration_test.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

TestModel _$TestModelFromJson(Map<String, dynamic> json) {
  return _TestModel.fromJson(json);
}

/// @nodoc
mixin _$TestModel {
  int get id => throw _privateConstructorUsedError;
  String? get data => throw _privateConstructorUsedError;
  bool get extra => throw _privateConstructorUsedError;
  FirebaseTimestamp? get timestamp => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TestModelCopyWith<TestModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TestModelCopyWith<$Res> {
  factory $TestModelCopyWith(TestModel value, $Res Function(TestModel) then) =
      _$TestModelCopyWithImpl<$Res, TestModel>;
  @useResult
  $Res call({int id, String? data, bool extra, FirebaseTimestamp? timestamp});

  $FirebaseTimestampCopyWith<$Res>? get timestamp;
}

/// @nodoc
class _$TestModelCopyWithImpl<$Res, $Val extends TestModel>
    implements $TestModelCopyWith<$Res> {
  _$TestModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? data = freezed,
    Object? extra = null,
    Object? timestamp = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as String?,
      extra: null == extra
          ? _value.extra
          : extra // ignore: cast_nullable_to_non_nullable
              as bool,
      timestamp: freezed == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as FirebaseTimestamp?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $FirebaseTimestampCopyWith<$Res>? get timestamp {
    if (_value.timestamp == null) {
      return null;
    }

    return $FirebaseTimestampCopyWith<$Res>(_value.timestamp!, (value) {
      return _then(_value.copyWith(timestamp: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_TestModelCopyWith<$Res> implements $TestModelCopyWith<$Res> {
  factory _$$_TestModelCopyWith(
          _$_TestModel value, $Res Function(_$_TestModel) then) =
      __$$_TestModelCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String? data, bool extra, FirebaseTimestamp? timestamp});

  @override
  $FirebaseTimestampCopyWith<$Res>? get timestamp;
}

/// @nodoc
class __$$_TestModelCopyWithImpl<$Res>
    extends _$TestModelCopyWithImpl<$Res, _$_TestModel>
    implements _$$_TestModelCopyWith<$Res> {
  __$$_TestModelCopyWithImpl(
      _$_TestModel _value, $Res Function(_$_TestModel) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? data = freezed,
    Object? extra = null,
    Object? timestamp = freezed,
  }) {
    return _then(_$_TestModel(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as String?,
      extra: null == extra
          ? _value.extra
          : extra // ignore: cast_nullable_to_non_nullable
              as bool,
      timestamp: freezed == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as FirebaseTimestamp?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_TestModel extends _TestModel {
  const _$_TestModel(
      {required this.id, this.data, this.extra = false, this.timestamp})
      : super._();

  factory _$_TestModel.fromJson(Map<String, dynamic> json) =>
      _$$_TestModelFromJson(json);

  @override
  final int id;
  @override
  final String? data;
  @override
  @JsonKey()
  final bool extra;
  @override
  final FirebaseTimestamp? timestamp;

  @override
  String toString() {
    return 'TestModel(id: $id, data: $data, extra: $extra, timestamp: $timestamp)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_TestModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.data, data) || other.data == data) &&
            (identical(other.extra, extra) || other.extra == extra) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, data, extra, timestamp);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_TestModelCopyWith<_$_TestModel> get copyWith =>
      __$$_TestModelCopyWithImpl<_$_TestModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_TestModelToJson(
      this,
    );
  }
}

abstract class _TestModel extends TestModel {
  const factory _TestModel(
      {required final int id,
      final String? data,
      final bool extra,
      final FirebaseTimestamp? timestamp}) = _$_TestModel;
  const _TestModel._() : super._();

  factory _TestModel.fromJson(Map<String, dynamic> json) =
      _$_TestModel.fromJson;

  @override
  int get id;
  @override
  String? get data;
  @override
  bool get extra;
  @override
  FirebaseTimestamp? get timestamp;
  @override
  @JsonKey(ignore: true)
  _$$_TestModelCopyWith<_$_TestModel> get copyWith =>
      throw _privateConstructorUsedError;
}
