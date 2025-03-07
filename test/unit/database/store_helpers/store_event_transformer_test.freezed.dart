// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'store_event_transformer_test.dart';

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
  String get data => throw _privateConstructorUsedError;

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
  $Res call({int id, String data});
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
    Object? data = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_TestModelCopyWith<$Res> implements $TestModelCopyWith<$Res> {
  factory _$$_TestModelCopyWith(
          _$_TestModel value, $Res Function(_$_TestModel) then) =
      __$$_TestModelCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String data});
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
    Object? data = null,
  }) {
    return _then(_$_TestModel(
      null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_TestModel implements _TestModel {
  const _$_TestModel(this.id, this.data);

  factory _$_TestModel.fromJson(Map<String, dynamic> json) =>
      _$$_TestModelFromJson(json);

  @override
  final int id;
  @override
  final String data;

  @override
  String toString() {
    return 'TestModel(id: $id, data: $data)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_TestModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.data, data) || other.data == data));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, data);

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

abstract class _TestModel implements TestModel {
  const factory _TestModel(final int id, final String data) = _$_TestModel;

  factory _TestModel.fromJson(Map<String, dynamic> json) =
      _$_TestModel.fromJson;

  @override
  int get id;
  @override
  String get data;
  @override
  @JsonKey(ignore: true)
  _$$_TestModelCopyWith<_$_TestModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$TestModelPatchSet {
  Map<String, dynamic> get data => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $TestModelPatchSetCopyWith<TestModelPatchSet> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TestModelPatchSetCopyWith<$Res> {
  factory $TestModelPatchSetCopyWith(
          TestModelPatchSet value, $Res Function(TestModelPatchSet) then) =
      _$TestModelPatchSetCopyWithImpl<$Res, TestModelPatchSet>;
  @useResult
  $Res call({Map<String, dynamic> data});
}

/// @nodoc
class _$TestModelPatchSetCopyWithImpl<$Res, $Val extends TestModelPatchSet>
    implements $TestModelPatchSetCopyWith<$Res> {
  _$TestModelPatchSetCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
  }) {
    return _then(_value.copyWith(
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_TestModelPatchSetCopyWith<$Res>
    implements $TestModelPatchSetCopyWith<$Res> {
  factory _$$_TestModelPatchSetCopyWith(_$_TestModelPatchSet value,
          $Res Function(_$_TestModelPatchSet) then) =
      __$$_TestModelPatchSetCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Map<String, dynamic> data});
}

/// @nodoc
class __$$_TestModelPatchSetCopyWithImpl<$Res>
    extends _$TestModelPatchSetCopyWithImpl<$Res, _$_TestModelPatchSet>
    implements _$$_TestModelPatchSetCopyWith<$Res> {
  __$$_TestModelPatchSetCopyWithImpl(
      _$_TestModelPatchSet _value, $Res Function(_$_TestModelPatchSet) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
  }) {
    return _then(_$_TestModelPatchSet(
      null == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc

class _$_TestModelPatchSet extends _TestModelPatchSet {
  const _$_TestModelPatchSet(final Map<String, dynamic> data)
      : _data = data,
        super._();

  final Map<String, dynamic> _data;
  @override
  Map<String, dynamic> get data {
    if (_data is EqualUnmodifiableMapView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_data);
  }

  @override
  String toString() {
    return 'TestModelPatchSet(data: $data)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_TestModelPatchSet &&
            const DeepCollectionEquality().equals(other._data, _data));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_data));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_TestModelPatchSetCopyWith<_$_TestModelPatchSet> get copyWith =>
      __$$_TestModelPatchSetCopyWithImpl<_$_TestModelPatchSet>(
          this, _$identity);
}

abstract class _TestModelPatchSet extends TestModelPatchSet {
  const factory _TestModelPatchSet(final Map<String, dynamic> data) =
      _$_TestModelPatchSet;
  const _TestModelPatchSet._() : super._();

  @override
  Map<String, dynamic> get data;
  @override
  @JsonKey(ignore: true)
  _$$_TestModelPatchSetCopyWith<_$_TestModelPatchSet> get copyWith =>
      throw _privateConstructorUsedError;
}
