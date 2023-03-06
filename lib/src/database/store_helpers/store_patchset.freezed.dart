// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'store_patchset.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$StorePatchSet<T> {
  FirebaseStore<T> get store => throw _privateConstructorUsedError;
  Map<String, dynamic> get data => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $StorePatchSetCopyWith<T, StorePatchSet<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StorePatchSetCopyWith<T, $Res> {
  factory $StorePatchSetCopyWith(
          StorePatchSet<T> value, $Res Function(StorePatchSet<T>) then) =
      _$StorePatchSetCopyWithImpl<T, $Res, StorePatchSet<T>>;
  @useResult
  $Res call({FirebaseStore<T> store, Map<String, dynamic> data});
}

/// @nodoc
class _$StorePatchSetCopyWithImpl<T, $Res, $Val extends StorePatchSet<T>>
    implements $StorePatchSetCopyWith<T, $Res> {
  _$StorePatchSetCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? store = null,
    Object? data = null,
  }) {
    return _then(_value.copyWith(
      store: null == store
          ? _value.store
          : store // ignore: cast_nullable_to_non_nullable
              as FirebaseStore<T>,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_StorePatchSetCopyWith<T, $Res>
    implements $StorePatchSetCopyWith<T, $Res> {
  factory _$$_StorePatchSetCopyWith(
          _$_StorePatchSet<T> value, $Res Function(_$_StorePatchSet<T>) then) =
      __$$_StorePatchSetCopyWithImpl<T, $Res>;
  @override
  @useResult
  $Res call({FirebaseStore<T> store, Map<String, dynamic> data});
}

/// @nodoc
class __$$_StorePatchSetCopyWithImpl<T, $Res>
    extends _$StorePatchSetCopyWithImpl<T, $Res, _$_StorePatchSet<T>>
    implements _$$_StorePatchSetCopyWith<T, $Res> {
  __$$_StorePatchSetCopyWithImpl(
      _$_StorePatchSet<T> _value, $Res Function(_$_StorePatchSet<T>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? store = null,
    Object? data = null,
  }) {
    return _then(_$_StorePatchSet<T>(
      store: null == store
          ? _value.store
          : store // ignore: cast_nullable_to_non_nullable
              as FirebaseStore<T>,
      data: null == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc

class _$_StorePatchSet<T> extends _StorePatchSet<T> {
  const _$_StorePatchSet(
      {required this.store, required final Map<String, dynamic> data})
      : _data = data,
        super._();

  @override
  final FirebaseStore<T> store;
  final Map<String, dynamic> _data;
  @override
  Map<String, dynamic> get data {
    if (_data is EqualUnmodifiableMapView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_data);
  }

  @override
  String toString() {
    return 'StorePatchSet<$T>(store: $store, data: $data)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_StorePatchSet<T> &&
            (identical(other.store, store) || other.store == store) &&
            const DeepCollectionEquality().equals(other._data, _data));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, store, const DeepCollectionEquality().hash(_data));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_StorePatchSetCopyWith<T, _$_StorePatchSet<T>> get copyWith =>
      __$$_StorePatchSetCopyWithImpl<T, _$_StorePatchSet<T>>(this, _$identity);
}

abstract class _StorePatchSet<T> extends StorePatchSet<T> {
  const factory _StorePatchSet(
      {required final FirebaseStore<T> store,
      required final Map<String, dynamic> data}) = _$_StorePatchSet<T>;
  const _StorePatchSet._() : super._();

  @override
  FirebaseStore<T> get store;
  @override
  Map<String, dynamic> get data;
  @override
  @JsonKey(ignore: true)
  _$$_StorePatchSetCopyWith<T, _$_StorePatchSet<T>> get copyWith =>
      throw _privateConstructorUsedError;
}
