// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'store_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$StoreEvent<T> {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Map<String, T> data) reset,
    required TResult Function(String key, T value) put,
    required TResult Function(String key, int index, T value) arrayPut,
    required TResult Function(String key) delete,
    required TResult Function(String key, PatchSet<T> patchSet) patch,
    required TResult Function(String path) invalidPath,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Map<String, T> data)? reset,
    TResult? Function(String key, T value)? put,
    TResult? Function(String key, int index, T value)? arrayPut,
    TResult? Function(String key)? delete,
    TResult? Function(String key, PatchSet<T> patchSet)? patch,
    TResult? Function(String path)? invalidPath,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Map<String, T> data)? reset,
    TResult Function(String key, T value)? put,
    TResult Function(String key, int index, T value)? arrayPut,
    TResult Function(String key)? delete,
    TResult Function(String key, PatchSet<T> patchSet)? patch,
    TResult Function(String path)? invalidPath,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_StoreReset<T> value) reset,
    required TResult Function(_StorePut<T> value) put,
    required TResult Function(_StoreArrayPut<T> value) arrayPut,
    required TResult Function(_StoreDelete<T> value) delete,
    required TResult Function(_StorePatch<T> value) patch,
    required TResult Function(_StoreInvalidPath<T> value) invalidPath,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_StoreReset<T> value)? reset,
    TResult? Function(_StorePut<T> value)? put,
    TResult? Function(_StoreArrayPut<T> value)? arrayPut,
    TResult? Function(_StoreDelete<T> value)? delete,
    TResult? Function(_StorePatch<T> value)? patch,
    TResult? Function(_StoreInvalidPath<T> value)? invalidPath,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_StoreReset<T> value)? reset,
    TResult Function(_StorePut<T> value)? put,
    TResult Function(_StoreArrayPut<T> value)? arrayPut,
    TResult Function(_StoreDelete<T> value)? delete,
    TResult Function(_StorePatch<T> value)? patch,
    TResult Function(_StoreInvalidPath<T> value)? invalidPath,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StoreEventCopyWith<T, $Res> {
  factory $StoreEventCopyWith(
          StoreEvent<T> value, $Res Function(StoreEvent<T>) then) =
      _$StoreEventCopyWithImpl<T, $Res, StoreEvent<T>>;
}

/// @nodoc
class _$StoreEventCopyWithImpl<T, $Res, $Val extends StoreEvent<T>>
    implements $StoreEventCopyWith<T, $Res> {
  _$StoreEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$_StoreResetCopyWith<T, $Res> {
  factory _$$_StoreResetCopyWith(
          _$_StoreReset<T> value, $Res Function(_$_StoreReset<T>) then) =
      __$$_StoreResetCopyWithImpl<T, $Res>;
  @useResult
  $Res call({Map<String, T> data});
}

/// @nodoc
class __$$_StoreResetCopyWithImpl<T, $Res>
    extends _$StoreEventCopyWithImpl<T, $Res, _$_StoreReset<T>>
    implements _$$_StoreResetCopyWith<T, $Res> {
  __$$_StoreResetCopyWithImpl(
      _$_StoreReset<T> _value, $Res Function(_$_StoreReset<T>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
  }) {
    return _then(_$_StoreReset<T>(
      null == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, T>,
    ));
  }
}

/// @nodoc

class _$_StoreReset<T> implements _StoreReset<T> {
  const _$_StoreReset(final Map<String, T> data) : _data = data;

  /// The complete store state, with all current keys and values.
  final Map<String, T> _data;

  /// The complete store state, with all current keys and values.
  @override
  Map<String, T> get data {
    if (_data is EqualUnmodifiableMapView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_data);
  }

  @override
  String toString() {
    return 'StoreEvent<$T>.reset(data: $data)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_StoreReset<T> &&
            const DeepCollectionEquality().equals(other._data, _data));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_data));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_StoreResetCopyWith<T, _$_StoreReset<T>> get copyWith =>
      __$$_StoreResetCopyWithImpl<T, _$_StoreReset<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Map<String, T> data) reset,
    required TResult Function(String key, T value) put,
    required TResult Function(String key, int index, T value) arrayPut,
    required TResult Function(String key) delete,
    required TResult Function(String key, PatchSet<T> patchSet) patch,
    required TResult Function(String path) invalidPath,
  }) {
    return reset(data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Map<String, T> data)? reset,
    TResult? Function(String key, T value)? put,
    TResult? Function(String key, int index, T value)? arrayPut,
    TResult? Function(String key)? delete,
    TResult? Function(String key, PatchSet<T> patchSet)? patch,
    TResult? Function(String path)? invalidPath,
  }) {
    return reset?.call(data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Map<String, T> data)? reset,
    TResult Function(String key, T value)? put,
    TResult Function(String key, int index, T value)? arrayPut,
    TResult Function(String key)? delete,
    TResult Function(String key, PatchSet<T> patchSet)? patch,
    TResult Function(String path)? invalidPath,
    required TResult orElse(),
  }) {
    if (reset != null) {
      return reset(data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_StoreReset<T> value) reset,
    required TResult Function(_StorePut<T> value) put,
    required TResult Function(_StoreArrayPut<T> value) arrayPut,
    required TResult Function(_StoreDelete<T> value) delete,
    required TResult Function(_StorePatch<T> value) patch,
    required TResult Function(_StoreInvalidPath<T> value) invalidPath,
  }) {
    return reset(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_StoreReset<T> value)? reset,
    TResult? Function(_StorePut<T> value)? put,
    TResult? Function(_StoreArrayPut<T> value)? arrayPut,
    TResult? Function(_StoreDelete<T> value)? delete,
    TResult? Function(_StorePatch<T> value)? patch,
    TResult? Function(_StoreInvalidPath<T> value)? invalidPath,
  }) {
    return reset?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_StoreReset<T> value)? reset,
    TResult Function(_StorePut<T> value)? put,
    TResult Function(_StoreArrayPut<T> value)? arrayPut,
    TResult Function(_StoreDelete<T> value)? delete,
    TResult Function(_StorePatch<T> value)? patch,
    TResult Function(_StoreInvalidPath<T> value)? invalidPath,
    required TResult orElse(),
  }) {
    if (reset != null) {
      return reset(this);
    }
    return orElse();
  }
}

abstract class _StoreReset<T> implements StoreEvent<T> {
  const factory _StoreReset(final Map<String, T> data) = _$_StoreReset<T>;

  /// The complete store state, with all current keys and values.
  Map<String, T> get data;
  @JsonKey(ignore: true)
  _$$_StoreResetCopyWith<T, _$_StoreReset<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$_StorePutCopyWith<T, $Res> {
  factory _$$_StorePutCopyWith(
          _$_StorePut<T> value, $Res Function(_$_StorePut<T>) then) =
      __$$_StorePutCopyWithImpl<T, $Res>;
  @useResult
  $Res call({String key, T value});
}

/// @nodoc
class __$$_StorePutCopyWithImpl<T, $Res>
    extends _$StoreEventCopyWithImpl<T, $Res, _$_StorePut<T>>
    implements _$$_StorePutCopyWith<T, $Res> {
  __$$_StorePutCopyWithImpl(
      _$_StorePut<T> _value, $Res Function(_$_StorePut<T>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? key = null,
    Object? value = freezed,
  }) {
    return _then(_$_StorePut<T>(
      null == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      freezed == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as T,
    ));
  }
}

/// @nodoc

class _$_StorePut<T> implements _StorePut<T> {
  const _$_StorePut(this.key, this.value);

  /// The key of the data that has been updated.
  @override
  final String key;

  /// The updated data.
  @override
  final T value;

  @override
  String toString() {
    return 'StoreEvent<$T>.put(key: $key, value: $value)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_StorePut<T> &&
            (identical(other.key, key) || other.key == key) &&
            const DeepCollectionEquality().equals(other.value, value));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, key, const DeepCollectionEquality().hash(value));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_StorePutCopyWith<T, _$_StorePut<T>> get copyWith =>
      __$$_StorePutCopyWithImpl<T, _$_StorePut<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Map<String, T> data) reset,
    required TResult Function(String key, T value) put,
    required TResult Function(String key, int index, T value) arrayPut,
    required TResult Function(String key) delete,
    required TResult Function(String key, PatchSet<T> patchSet) patch,
    required TResult Function(String path) invalidPath,
  }) {
    return put(key, value);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Map<String, T> data)? reset,
    TResult? Function(String key, T value)? put,
    TResult? Function(String key, int index, T value)? arrayPut,
    TResult? Function(String key)? delete,
    TResult? Function(String key, PatchSet<T> patchSet)? patch,
    TResult? Function(String path)? invalidPath,
  }) {
    return put?.call(key, value);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Map<String, T> data)? reset,
    TResult Function(String key, T value)? put,
    TResult Function(String key, int index, T value)? arrayPut,
    TResult Function(String key)? delete,
    TResult Function(String key, PatchSet<T> patchSet)? patch,
    TResult Function(String path)? invalidPath,
    required TResult orElse(),
  }) {
    if (put != null) {
      return put(key, value);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_StoreReset<T> value) reset,
    required TResult Function(_StorePut<T> value) put,
    required TResult Function(_StoreArrayPut<T> value) arrayPut,
    required TResult Function(_StoreDelete<T> value) delete,
    required TResult Function(_StorePatch<T> value) patch,
    required TResult Function(_StoreInvalidPath<T> value) invalidPath,
  }) {
    return put(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_StoreReset<T> value)? reset,
    TResult? Function(_StorePut<T> value)? put,
    TResult? Function(_StoreArrayPut<T> value)? arrayPut,
    TResult? Function(_StoreDelete<T> value)? delete,
    TResult? Function(_StorePatch<T> value)? patch,
    TResult? Function(_StoreInvalidPath<T> value)? invalidPath,
  }) {
    return put?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_StoreReset<T> value)? reset,
    TResult Function(_StorePut<T> value)? put,
    TResult Function(_StoreArrayPut<T> value)? arrayPut,
    TResult Function(_StoreDelete<T> value)? delete,
    TResult Function(_StorePatch<T> value)? patch,
    TResult Function(_StoreInvalidPath<T> value)? invalidPath,
    required TResult orElse(),
  }) {
    if (put != null) {
      return put(this);
    }
    return orElse();
  }
}

abstract class _StorePut<T> implements StoreEvent<T> {
  const factory _StorePut(final String key, final T value) = _$_StorePut<T>;

  /// The key of the data that has been updated.
  String get key;

  /// The updated data.
  T get value;
  @JsonKey(ignore: true)
  _$$_StorePutCopyWith<T, _$_StorePut<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$_StoreArrayPutCopyWith<T, $Res> {
  factory _$$_StoreArrayPutCopyWith(
          _$_StoreArrayPut<T> value, $Res Function(_$_StoreArrayPut<T>) then) =
      __$$_StoreArrayPutCopyWithImpl<T, $Res>;
  @useResult
  $Res call({String key, int index, T value});
}

/// @nodoc
class __$$_StoreArrayPutCopyWithImpl<T, $Res>
    extends _$StoreEventCopyWithImpl<T, $Res, _$_StoreArrayPut<T>>
    implements _$$_StoreArrayPutCopyWith<T, $Res> {
  __$$_StoreArrayPutCopyWithImpl(
      _$_StoreArrayPut<T> _value, $Res Function(_$_StoreArrayPut<T>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? key = null,
    Object? index = null,
    Object? value = freezed,
  }) {
    return _then(_$_StoreArrayPut<T>(
      null == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      null == index
          ? _value.index
          : index // ignore: cast_nullable_to_non_nullable
              as int,
      freezed == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as T,
    ));
  }
}

/// @nodoc

class _$_StoreArrayPut<T> implements _StoreArrayPut<T> {
  const _$_StoreArrayPut(this.key, this.index, this.value);

  /// The key of the array that has been updated.
  @override
  final String key;

  /// The index of the array that has been updated.
  @override
  final int index;

  /// The updated data.
  @override
  final T value;

  @override
  String toString() {
    return 'StoreEvent<$T>.arrayPut(key: $key, index: $index, value: $value)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_StoreArrayPut<T> &&
            (identical(other.key, key) || other.key == key) &&
            (identical(other.index, index) || other.index == index) &&
            const DeepCollectionEquality().equals(other.value, value));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, key, index, const DeepCollectionEquality().hash(value));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_StoreArrayPutCopyWith<T, _$_StoreArrayPut<T>> get copyWith =>
      __$$_StoreArrayPutCopyWithImpl<T, _$_StoreArrayPut<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Map<String, T> data) reset,
    required TResult Function(String key, T value) put,
    required TResult Function(String key, int index, T value) arrayPut,
    required TResult Function(String key) delete,
    required TResult Function(String key, PatchSet<T> patchSet) patch,
    required TResult Function(String path) invalidPath,
  }) {
    return arrayPut(key, index, value);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Map<String, T> data)? reset,
    TResult? Function(String key, T value)? put,
    TResult? Function(String key, int index, T value)? arrayPut,
    TResult? Function(String key)? delete,
    TResult? Function(String key, PatchSet<T> patchSet)? patch,
    TResult? Function(String path)? invalidPath,
  }) {
    return arrayPut?.call(key, index, value);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Map<String, T> data)? reset,
    TResult Function(String key, T value)? put,
    TResult Function(String key, int index, T value)? arrayPut,
    TResult Function(String key)? delete,
    TResult Function(String key, PatchSet<T> patchSet)? patch,
    TResult Function(String path)? invalidPath,
    required TResult orElse(),
  }) {
    if (arrayPut != null) {
      return arrayPut(key, index, value);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_StoreReset<T> value) reset,
    required TResult Function(_StorePut<T> value) put,
    required TResult Function(_StoreArrayPut<T> value) arrayPut,
    required TResult Function(_StoreDelete<T> value) delete,
    required TResult Function(_StorePatch<T> value) patch,
    required TResult Function(_StoreInvalidPath<T> value) invalidPath,
  }) {
    return arrayPut(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_StoreReset<T> value)? reset,
    TResult? Function(_StorePut<T> value)? put,
    TResult? Function(_StoreArrayPut<T> value)? arrayPut,
    TResult? Function(_StoreDelete<T> value)? delete,
    TResult? Function(_StorePatch<T> value)? patch,
    TResult? Function(_StoreInvalidPath<T> value)? invalidPath,
  }) {
    return arrayPut?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_StoreReset<T> value)? reset,
    TResult Function(_StorePut<T> value)? put,
    TResult Function(_StoreArrayPut<T> value)? arrayPut,
    TResult Function(_StoreDelete<T> value)? delete,
    TResult Function(_StorePatch<T> value)? patch,
    TResult Function(_StoreInvalidPath<T> value)? invalidPath,
    required TResult orElse(),
  }) {
    if (arrayPut != null) {
      return arrayPut(this);
    }
    return orElse();
  }
}

abstract class _StoreArrayPut<T> implements StoreEvent<T> {
  const factory _StoreArrayPut(
      final String key, final int index, final T value) = _$_StoreArrayPut<T>;

  /// The key of the array that has been updated.
  String get key;

  /// The index of the array that has been updated.
  int get index;

  /// The updated data.
  T get value;
  @JsonKey(ignore: true)
  _$$_StoreArrayPutCopyWith<T, _$_StoreArrayPut<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$_StoreDeleteCopyWith<T, $Res> {
  factory _$$_StoreDeleteCopyWith(
          _$_StoreDelete<T> value, $Res Function(_$_StoreDelete<T>) then) =
      __$$_StoreDeleteCopyWithImpl<T, $Res>;
  @useResult
  $Res call({String key});
}

/// @nodoc
class __$$_StoreDeleteCopyWithImpl<T, $Res>
    extends _$StoreEventCopyWithImpl<T, $Res, _$_StoreDelete<T>>
    implements _$$_StoreDeleteCopyWith<T, $Res> {
  __$$_StoreDeleteCopyWithImpl(
      _$_StoreDelete<T> _value, $Res Function(_$_StoreDelete<T>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? key = null,
  }) {
    return _then(_$_StoreDelete<T>(
      null == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_StoreDelete<T> implements _StoreDelete<T> {
  const _$_StoreDelete(this.key);

  /// The key of the data that has been deleted.
  @override
  final String key;

  @override
  String toString() {
    return 'StoreEvent<$T>.delete(key: $key)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_StoreDelete<T> &&
            (identical(other.key, key) || other.key == key));
  }

  @override
  int get hashCode => Object.hash(runtimeType, key);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_StoreDeleteCopyWith<T, _$_StoreDelete<T>> get copyWith =>
      __$$_StoreDeleteCopyWithImpl<T, _$_StoreDelete<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Map<String, T> data) reset,
    required TResult Function(String key, T value) put,
    required TResult Function(String key, int index, T value) arrayPut,
    required TResult Function(String key) delete,
    required TResult Function(String key, PatchSet<T> patchSet) patch,
    required TResult Function(String path) invalidPath,
  }) {
    return delete(key);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Map<String, T> data)? reset,
    TResult? Function(String key, T value)? put,
    TResult? Function(String key, int index, T value)? arrayPut,
    TResult? Function(String key)? delete,
    TResult? Function(String key, PatchSet<T> patchSet)? patch,
    TResult? Function(String path)? invalidPath,
  }) {
    return delete?.call(key);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Map<String, T> data)? reset,
    TResult Function(String key, T value)? put,
    TResult Function(String key, int index, T value)? arrayPut,
    TResult Function(String key)? delete,
    TResult Function(String key, PatchSet<T> patchSet)? patch,
    TResult Function(String path)? invalidPath,
    required TResult orElse(),
  }) {
    if (delete != null) {
      return delete(key);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_StoreReset<T> value) reset,
    required TResult Function(_StorePut<T> value) put,
    required TResult Function(_StoreArrayPut<T> value) arrayPut,
    required TResult Function(_StoreDelete<T> value) delete,
    required TResult Function(_StorePatch<T> value) patch,
    required TResult Function(_StoreInvalidPath<T> value) invalidPath,
  }) {
    return delete(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_StoreReset<T> value)? reset,
    TResult? Function(_StorePut<T> value)? put,
    TResult? Function(_StoreArrayPut<T> value)? arrayPut,
    TResult? Function(_StoreDelete<T> value)? delete,
    TResult? Function(_StorePatch<T> value)? patch,
    TResult? Function(_StoreInvalidPath<T> value)? invalidPath,
  }) {
    return delete?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_StoreReset<T> value)? reset,
    TResult Function(_StorePut<T> value)? put,
    TResult Function(_StoreArrayPut<T> value)? arrayPut,
    TResult Function(_StoreDelete<T> value)? delete,
    TResult Function(_StorePatch<T> value)? patch,
    TResult Function(_StoreInvalidPath<T> value)? invalidPath,
    required TResult orElse(),
  }) {
    if (delete != null) {
      return delete(this);
    }
    return orElse();
  }
}

abstract class _StoreDelete<T> implements StoreEvent<T> {
  const factory _StoreDelete(final String key) = _$_StoreDelete<T>;

  /// The key of the data that has been deleted.
  String get key;
  @JsonKey(ignore: true)
  _$$_StoreDeleteCopyWith<T, _$_StoreDelete<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$_StorePatchCopyWith<T, $Res> {
  factory _$$_StorePatchCopyWith(
          _$_StorePatch<T> value, $Res Function(_$_StorePatch<T>) then) =
      __$$_StorePatchCopyWithImpl<T, $Res>;
  @useResult
  $Res call({String key, PatchSet<T> patchSet});
}

/// @nodoc
class __$$_StorePatchCopyWithImpl<T, $Res>
    extends _$StoreEventCopyWithImpl<T, $Res, _$_StorePatch<T>>
    implements _$$_StorePatchCopyWith<T, $Res> {
  __$$_StorePatchCopyWithImpl(
      _$_StorePatch<T> _value, $Res Function(_$_StorePatch<T>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? key = null,
    Object? patchSet = null,
  }) {
    return _then(_$_StorePatch<T>(
      null == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      null == patchSet
          ? _value.patchSet
          : patchSet // ignore: cast_nullable_to_non_nullable
              as PatchSet<T>,
    ));
  }
}

/// @nodoc

class _$_StorePatch<T> implements _StorePatch<T> {
  const _$_StorePatch(this.key, this.patchSet);

  /// The key of the data that has been patched.
  @override
  final String key;

  /// The patchSet set that can be applied to the current value.
  @override
  final PatchSet<T> patchSet;

  @override
  String toString() {
    return 'StoreEvent<$T>.patch(key: $key, patchSet: $patchSet)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_StorePatch<T> &&
            (identical(other.key, key) || other.key == key) &&
            (identical(other.patchSet, patchSet) ||
                other.patchSet == patchSet));
  }

  @override
  int get hashCode => Object.hash(runtimeType, key, patchSet);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_StorePatchCopyWith<T, _$_StorePatch<T>> get copyWith =>
      __$$_StorePatchCopyWithImpl<T, _$_StorePatch<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Map<String, T> data) reset,
    required TResult Function(String key, T value) put,
    required TResult Function(String key, int index, T value) arrayPut,
    required TResult Function(String key) delete,
    required TResult Function(String key, PatchSet<T> patchSet) patch,
    required TResult Function(String path) invalidPath,
  }) {
    return patch(key, patchSet);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Map<String, T> data)? reset,
    TResult? Function(String key, T value)? put,
    TResult? Function(String key, int index, T value)? arrayPut,
    TResult? Function(String key)? delete,
    TResult? Function(String key, PatchSet<T> patchSet)? patch,
    TResult? Function(String path)? invalidPath,
  }) {
    return patch?.call(key, patchSet);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Map<String, T> data)? reset,
    TResult Function(String key, T value)? put,
    TResult Function(String key, int index, T value)? arrayPut,
    TResult Function(String key)? delete,
    TResult Function(String key, PatchSet<T> patchSet)? patch,
    TResult Function(String path)? invalidPath,
    required TResult orElse(),
  }) {
    if (patch != null) {
      return patch(key, patchSet);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_StoreReset<T> value) reset,
    required TResult Function(_StorePut<T> value) put,
    required TResult Function(_StoreArrayPut<T> value) arrayPut,
    required TResult Function(_StoreDelete<T> value) delete,
    required TResult Function(_StorePatch<T> value) patch,
    required TResult Function(_StoreInvalidPath<T> value) invalidPath,
  }) {
    return patch(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_StoreReset<T> value)? reset,
    TResult? Function(_StorePut<T> value)? put,
    TResult? Function(_StoreArrayPut<T> value)? arrayPut,
    TResult? Function(_StoreDelete<T> value)? delete,
    TResult? Function(_StorePatch<T> value)? patch,
    TResult? Function(_StoreInvalidPath<T> value)? invalidPath,
  }) {
    return patch?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_StoreReset<T> value)? reset,
    TResult Function(_StorePut<T> value)? put,
    TResult Function(_StoreArrayPut<T> value)? arrayPut,
    TResult Function(_StoreDelete<T> value)? delete,
    TResult Function(_StorePatch<T> value)? patch,
    TResult Function(_StoreInvalidPath<T> value)? invalidPath,
    required TResult orElse(),
  }) {
    if (patch != null) {
      return patch(this);
    }
    return orElse();
  }
}

abstract class _StorePatch<T> implements StoreEvent<T> {
  const factory _StorePatch(final String key, final PatchSet<T> patchSet) =
      _$_StorePatch<T>;

  /// The key of the data that has been patched.
  String get key;

  /// The patchSet set that can be applied to the current value.
  PatchSet<T> get patchSet;
  @JsonKey(ignore: true)
  _$$_StorePatchCopyWith<T, _$_StorePatch<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$_StoreInvalidPathCopyWith<T, $Res> {
  factory _$$_StoreInvalidPathCopyWith(_$_StoreInvalidPath<T> value,
          $Res Function(_$_StoreInvalidPath<T>) then) =
      __$$_StoreInvalidPathCopyWithImpl<T, $Res>;
  @useResult
  $Res call({String path});
}

/// @nodoc
class __$$_StoreInvalidPathCopyWithImpl<T, $Res>
    extends _$StoreEventCopyWithImpl<T, $Res, _$_StoreInvalidPath<T>>
    implements _$$_StoreInvalidPathCopyWith<T, $Res> {
  __$$_StoreInvalidPathCopyWithImpl(_$_StoreInvalidPath<T> _value,
      $Res Function(_$_StoreInvalidPath<T>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? path = null,
  }) {
    return _then(_$_StoreInvalidPath<T>(
      null == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_StoreInvalidPath<T> implements _StoreInvalidPath<T> {
  const _$_StoreInvalidPath(this.path);

  /// The invalid subpath that was modified on the server.
  @override
  final String path;

  @override
  String toString() {
    return 'StoreEvent<$T>.invalidPath(path: $path)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_StoreInvalidPath<T> &&
            (identical(other.path, path) || other.path == path));
  }

  @override
  int get hashCode => Object.hash(runtimeType, path);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_StoreInvalidPathCopyWith<T, _$_StoreInvalidPath<T>> get copyWith =>
      __$$_StoreInvalidPathCopyWithImpl<T, _$_StoreInvalidPath<T>>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Map<String, T> data) reset,
    required TResult Function(String key, T value) put,
    required TResult Function(String key, int index, T value) arrayPut,
    required TResult Function(String key) delete,
    required TResult Function(String key, PatchSet<T> patchSet) patch,
    required TResult Function(String path) invalidPath,
  }) {
    return invalidPath(path);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Map<String, T> data)? reset,
    TResult? Function(String key, T value)? put,
    TResult? Function(String key, int index, T value)? arrayPut,
    TResult? Function(String key)? delete,
    TResult? Function(String key, PatchSet<T> patchSet)? patch,
    TResult? Function(String path)? invalidPath,
  }) {
    return invalidPath?.call(path);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Map<String, T> data)? reset,
    TResult Function(String key, T value)? put,
    TResult Function(String key, int index, T value)? arrayPut,
    TResult Function(String key)? delete,
    TResult Function(String key, PatchSet<T> patchSet)? patch,
    TResult Function(String path)? invalidPath,
    required TResult orElse(),
  }) {
    if (invalidPath != null) {
      return invalidPath(path);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_StoreReset<T> value) reset,
    required TResult Function(_StorePut<T> value) put,
    required TResult Function(_StoreArrayPut<T> value) arrayPut,
    required TResult Function(_StoreDelete<T> value) delete,
    required TResult Function(_StorePatch<T> value) patch,
    required TResult Function(_StoreInvalidPath<T> value) invalidPath,
  }) {
    return invalidPath(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_StoreReset<T> value)? reset,
    TResult? Function(_StorePut<T> value)? put,
    TResult? Function(_StoreArrayPut<T> value)? arrayPut,
    TResult? Function(_StoreDelete<T> value)? delete,
    TResult? Function(_StorePatch<T> value)? patch,
    TResult? Function(_StoreInvalidPath<T> value)? invalidPath,
  }) {
    return invalidPath?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_StoreReset<T> value)? reset,
    TResult Function(_StorePut<T> value)? put,
    TResult Function(_StoreArrayPut<T> value)? arrayPut,
    TResult Function(_StoreDelete<T> value)? delete,
    TResult Function(_StorePatch<T> value)? patch,
    TResult Function(_StoreInvalidPath<T> value)? invalidPath,
    required TResult orElse(),
  }) {
    if (invalidPath != null) {
      return invalidPath(this);
    }
    return orElse();
  }
}

abstract class _StoreInvalidPath<T> implements StoreEvent<T> {
  const factory _StoreInvalidPath(final String path) = _$_StoreInvalidPath<T>;

  /// The invalid subpath that was modified on the server.
  String get path;
  @JsonKey(ignore: true)
  _$$_StoreInvalidPathCopyWith<T, _$_StoreInvalidPath<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$KeyEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(List<String> keys) reset,
    required TResult Function(String key) update,
    required TResult Function(String key) delete,
    required TResult Function(String path) invalidPath,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(List<String> keys)? reset,
    TResult? Function(String key)? update,
    TResult? Function(String key)? delete,
    TResult? Function(String path)? invalidPath,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(List<String> keys)? reset,
    TResult Function(String key)? update,
    TResult Function(String key)? delete,
    TResult Function(String path)? invalidPath,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_KeyReset value) reset,
    required TResult Function(_KeyUpdate value) update,
    required TResult Function(_KeyDelete value) delete,
    required TResult Function(_KeyInvalidPath value) invalidPath,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_KeyReset value)? reset,
    TResult? Function(_KeyUpdate value)? update,
    TResult? Function(_KeyDelete value)? delete,
    TResult? Function(_KeyInvalidPath value)? invalidPath,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_KeyReset value)? reset,
    TResult Function(_KeyUpdate value)? update,
    TResult Function(_KeyDelete value)? delete,
    TResult Function(_KeyInvalidPath value)? invalidPath,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $KeyEventCopyWith<$Res> {
  factory $KeyEventCopyWith(KeyEvent value, $Res Function(KeyEvent) then) =
      _$KeyEventCopyWithImpl<$Res, KeyEvent>;
}

/// @nodoc
class _$KeyEventCopyWithImpl<$Res, $Val extends KeyEvent>
    implements $KeyEventCopyWith<$Res> {
  _$KeyEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$_KeyResetCopyWith<$Res> {
  factory _$$_KeyResetCopyWith(
          _$_KeyReset value, $Res Function(_$_KeyReset) then) =
      __$$_KeyResetCopyWithImpl<$Res>;
  @useResult
  $Res call({List<String> keys});
}

/// @nodoc
class __$$_KeyResetCopyWithImpl<$Res>
    extends _$KeyEventCopyWithImpl<$Res, _$_KeyReset>
    implements _$$_KeyResetCopyWith<$Res> {
  __$$_KeyResetCopyWithImpl(
      _$_KeyReset _value, $Res Function(_$_KeyReset) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? keys = null,
  }) {
    return _then(_$_KeyReset(
      null == keys
          ? _value._keys
          : keys // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc

class _$_KeyReset implements _KeyReset {
  const _$_KeyReset(final List<String> keys) : _keys = keys;

  /// A list with all keys that have data.
  final List<String> _keys;

  /// A list with all keys that have data.
  @override
  List<String> get keys {
    if (_keys is EqualUnmodifiableListView) return _keys;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_keys);
  }

  @override
  String toString() {
    return 'KeyEvent.reset(keys: $keys)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_KeyReset &&
            const DeepCollectionEquality().equals(other._keys, _keys));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_keys));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_KeyResetCopyWith<_$_KeyReset> get copyWith =>
      __$$_KeyResetCopyWithImpl<_$_KeyReset>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(List<String> keys) reset,
    required TResult Function(String key) update,
    required TResult Function(String key) delete,
    required TResult Function(String path) invalidPath,
  }) {
    return reset(keys);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(List<String> keys)? reset,
    TResult? Function(String key)? update,
    TResult? Function(String key)? delete,
    TResult? Function(String path)? invalidPath,
  }) {
    return reset?.call(keys);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(List<String> keys)? reset,
    TResult Function(String key)? update,
    TResult Function(String key)? delete,
    TResult Function(String path)? invalidPath,
    required TResult orElse(),
  }) {
    if (reset != null) {
      return reset(keys);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_KeyReset value) reset,
    required TResult Function(_KeyUpdate value) update,
    required TResult Function(_KeyDelete value) delete,
    required TResult Function(_KeyInvalidPath value) invalidPath,
  }) {
    return reset(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_KeyReset value)? reset,
    TResult? Function(_KeyUpdate value)? update,
    TResult? Function(_KeyDelete value)? delete,
    TResult? Function(_KeyInvalidPath value)? invalidPath,
  }) {
    return reset?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_KeyReset value)? reset,
    TResult Function(_KeyUpdate value)? update,
    TResult Function(_KeyDelete value)? delete,
    TResult Function(_KeyInvalidPath value)? invalidPath,
    required TResult orElse(),
  }) {
    if (reset != null) {
      return reset(this);
    }
    return orElse();
  }
}

abstract class _KeyReset implements KeyEvent {
  const factory _KeyReset(final List<String> keys) = _$_KeyReset;

  /// A list with all keys that have data.
  List<String> get keys;
  @JsonKey(ignore: true)
  _$$_KeyResetCopyWith<_$_KeyReset> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$_KeyUpdateCopyWith<$Res> {
  factory _$$_KeyUpdateCopyWith(
          _$_KeyUpdate value, $Res Function(_$_KeyUpdate) then) =
      __$$_KeyUpdateCopyWithImpl<$Res>;
  @useResult
  $Res call({String key});
}

/// @nodoc
class __$$_KeyUpdateCopyWithImpl<$Res>
    extends _$KeyEventCopyWithImpl<$Res, _$_KeyUpdate>
    implements _$$_KeyUpdateCopyWith<$Res> {
  __$$_KeyUpdateCopyWithImpl(
      _$_KeyUpdate _value, $Res Function(_$_KeyUpdate) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? key = null,
  }) {
    return _then(_$_KeyUpdate(
      null == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_KeyUpdate implements _KeyUpdate {
  const _$_KeyUpdate(this.key);

  /// The key of the entry that has been updated.
  @override
  final String key;

  @override
  String toString() {
    return 'KeyEvent.update(key: $key)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_KeyUpdate &&
            (identical(other.key, key) || other.key == key));
  }

  @override
  int get hashCode => Object.hash(runtimeType, key);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_KeyUpdateCopyWith<_$_KeyUpdate> get copyWith =>
      __$$_KeyUpdateCopyWithImpl<_$_KeyUpdate>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(List<String> keys) reset,
    required TResult Function(String key) update,
    required TResult Function(String key) delete,
    required TResult Function(String path) invalidPath,
  }) {
    return update(key);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(List<String> keys)? reset,
    TResult? Function(String key)? update,
    TResult? Function(String key)? delete,
    TResult? Function(String path)? invalidPath,
  }) {
    return update?.call(key);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(List<String> keys)? reset,
    TResult Function(String key)? update,
    TResult Function(String key)? delete,
    TResult Function(String path)? invalidPath,
    required TResult orElse(),
  }) {
    if (update != null) {
      return update(key);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_KeyReset value) reset,
    required TResult Function(_KeyUpdate value) update,
    required TResult Function(_KeyDelete value) delete,
    required TResult Function(_KeyInvalidPath value) invalidPath,
  }) {
    return update(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_KeyReset value)? reset,
    TResult? Function(_KeyUpdate value)? update,
    TResult? Function(_KeyDelete value)? delete,
    TResult? Function(_KeyInvalidPath value)? invalidPath,
  }) {
    return update?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_KeyReset value)? reset,
    TResult Function(_KeyUpdate value)? update,
    TResult Function(_KeyDelete value)? delete,
    TResult Function(_KeyInvalidPath value)? invalidPath,
    required TResult orElse(),
  }) {
    if (update != null) {
      return update(this);
    }
    return orElse();
  }
}

abstract class _KeyUpdate implements KeyEvent {
  const factory _KeyUpdate(final String key) = _$_KeyUpdate;

  /// The key of the entry that has been updated.
  String get key;
  @JsonKey(ignore: true)
  _$$_KeyUpdateCopyWith<_$_KeyUpdate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$_KeyDeleteCopyWith<$Res> {
  factory _$$_KeyDeleteCopyWith(
          _$_KeyDelete value, $Res Function(_$_KeyDelete) then) =
      __$$_KeyDeleteCopyWithImpl<$Res>;
  @useResult
  $Res call({String key});
}

/// @nodoc
class __$$_KeyDeleteCopyWithImpl<$Res>
    extends _$KeyEventCopyWithImpl<$Res, _$_KeyDelete>
    implements _$$_KeyDeleteCopyWith<$Res> {
  __$$_KeyDeleteCopyWithImpl(
      _$_KeyDelete _value, $Res Function(_$_KeyDelete) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? key = null,
  }) {
    return _then(_$_KeyDelete(
      null == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_KeyDelete implements _KeyDelete {
  const _$_KeyDelete(this.key);

  /// The key of the entry that has been deleted.
  @override
  final String key;

  @override
  String toString() {
    return 'KeyEvent.delete(key: $key)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_KeyDelete &&
            (identical(other.key, key) || other.key == key));
  }

  @override
  int get hashCode => Object.hash(runtimeType, key);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_KeyDeleteCopyWith<_$_KeyDelete> get copyWith =>
      __$$_KeyDeleteCopyWithImpl<_$_KeyDelete>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(List<String> keys) reset,
    required TResult Function(String key) update,
    required TResult Function(String key) delete,
    required TResult Function(String path) invalidPath,
  }) {
    return delete(key);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(List<String> keys)? reset,
    TResult? Function(String key)? update,
    TResult? Function(String key)? delete,
    TResult? Function(String path)? invalidPath,
  }) {
    return delete?.call(key);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(List<String> keys)? reset,
    TResult Function(String key)? update,
    TResult Function(String key)? delete,
    TResult Function(String path)? invalidPath,
    required TResult orElse(),
  }) {
    if (delete != null) {
      return delete(key);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_KeyReset value) reset,
    required TResult Function(_KeyUpdate value) update,
    required TResult Function(_KeyDelete value) delete,
    required TResult Function(_KeyInvalidPath value) invalidPath,
  }) {
    return delete(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_KeyReset value)? reset,
    TResult? Function(_KeyUpdate value)? update,
    TResult? Function(_KeyDelete value)? delete,
    TResult? Function(_KeyInvalidPath value)? invalidPath,
  }) {
    return delete?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_KeyReset value)? reset,
    TResult Function(_KeyUpdate value)? update,
    TResult Function(_KeyDelete value)? delete,
    TResult Function(_KeyInvalidPath value)? invalidPath,
    required TResult orElse(),
  }) {
    if (delete != null) {
      return delete(this);
    }
    return orElse();
  }
}

abstract class _KeyDelete implements KeyEvent {
  const factory _KeyDelete(final String key) = _$_KeyDelete;

  /// The key of the entry that has been deleted.
  String get key;
  @JsonKey(ignore: true)
  _$$_KeyDeleteCopyWith<_$_KeyDelete> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$_KeyInvalidPathCopyWith<$Res> {
  factory _$$_KeyInvalidPathCopyWith(
          _$_KeyInvalidPath value, $Res Function(_$_KeyInvalidPath) then) =
      __$$_KeyInvalidPathCopyWithImpl<$Res>;
  @useResult
  $Res call({String path});
}

/// @nodoc
class __$$_KeyInvalidPathCopyWithImpl<$Res>
    extends _$KeyEventCopyWithImpl<$Res, _$_KeyInvalidPath>
    implements _$$_KeyInvalidPathCopyWith<$Res> {
  __$$_KeyInvalidPathCopyWithImpl(
      _$_KeyInvalidPath _value, $Res Function(_$_KeyInvalidPath) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? path = null,
  }) {
    return _then(_$_KeyInvalidPath(
      null == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_KeyInvalidPath implements _KeyInvalidPath {
  const _$_KeyInvalidPath(this.path);

  /// The invalid subpath that was modified on the server.
  @override
  final String path;

  @override
  String toString() {
    return 'KeyEvent.invalidPath(path: $path)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_KeyInvalidPath &&
            (identical(other.path, path) || other.path == path));
  }

  @override
  int get hashCode => Object.hash(runtimeType, path);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_KeyInvalidPathCopyWith<_$_KeyInvalidPath> get copyWith =>
      __$$_KeyInvalidPathCopyWithImpl<_$_KeyInvalidPath>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(List<String> keys) reset,
    required TResult Function(String key) update,
    required TResult Function(String key) delete,
    required TResult Function(String path) invalidPath,
  }) {
    return invalidPath(path);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(List<String> keys)? reset,
    TResult? Function(String key)? update,
    TResult? Function(String key)? delete,
    TResult? Function(String path)? invalidPath,
  }) {
    return invalidPath?.call(path);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(List<String> keys)? reset,
    TResult Function(String key)? update,
    TResult Function(String key)? delete,
    TResult Function(String path)? invalidPath,
    required TResult orElse(),
  }) {
    if (invalidPath != null) {
      return invalidPath(path);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_KeyReset value) reset,
    required TResult Function(_KeyUpdate value) update,
    required TResult Function(_KeyDelete value) delete,
    required TResult Function(_KeyInvalidPath value) invalidPath,
  }) {
    return invalidPath(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_KeyReset value)? reset,
    TResult? Function(_KeyUpdate value)? update,
    TResult? Function(_KeyDelete value)? delete,
    TResult? Function(_KeyInvalidPath value)? invalidPath,
  }) {
    return invalidPath?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_KeyReset value)? reset,
    TResult Function(_KeyUpdate value)? update,
    TResult Function(_KeyDelete value)? delete,
    TResult Function(_KeyInvalidPath value)? invalidPath,
    required TResult orElse(),
  }) {
    if (invalidPath != null) {
      return invalidPath(this);
    }
    return orElse();
  }
}

abstract class _KeyInvalidPath implements KeyEvent {
  const factory _KeyInvalidPath(final String path) = _$_KeyInvalidPath;

  /// The invalid subpath that was modified on the server.
  String get path;
  @JsonKey(ignore: true)
  _$$_KeyInvalidPathCopyWith<_$_KeyInvalidPath> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ValueEvent<T> {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(T data) update,
    required TResult Function(PatchSet<T> patchSet) patch,
    required TResult Function() delete,
    required TResult Function(String path) invalidPath,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(T data)? update,
    TResult? Function(PatchSet<T> patchSet)? patch,
    TResult? Function()? delete,
    TResult? Function(String path)? invalidPath,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(T data)? update,
    TResult Function(PatchSet<T> patchSet)? patch,
    TResult Function()? delete,
    TResult Function(String path)? invalidPath,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ValueUpdate<T> value) update,
    required TResult Function(_ValuePatch<T> value) patch,
    required TResult Function(_ValueDelete<T> value) delete,
    required TResult Function(_ValueInvalidPath<T> value) invalidPath,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ValueUpdate<T> value)? update,
    TResult? Function(_ValuePatch<T> value)? patch,
    TResult? Function(_ValueDelete<T> value)? delete,
    TResult? Function(_ValueInvalidPath<T> value)? invalidPath,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ValueUpdate<T> value)? update,
    TResult Function(_ValuePatch<T> value)? patch,
    TResult Function(_ValueDelete<T> value)? delete,
    TResult Function(_ValueInvalidPath<T> value)? invalidPath,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ValueEventCopyWith<T, $Res> {
  factory $ValueEventCopyWith(
          ValueEvent<T> value, $Res Function(ValueEvent<T>) then) =
      _$ValueEventCopyWithImpl<T, $Res, ValueEvent<T>>;
}

/// @nodoc
class _$ValueEventCopyWithImpl<T, $Res, $Val extends ValueEvent<T>>
    implements $ValueEventCopyWith<T, $Res> {
  _$ValueEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$_ValueUpdateCopyWith<T, $Res> {
  factory _$$_ValueUpdateCopyWith(
          _$_ValueUpdate<T> value, $Res Function(_$_ValueUpdate<T>) then) =
      __$$_ValueUpdateCopyWithImpl<T, $Res>;
  @useResult
  $Res call({T data});
}

/// @nodoc
class __$$_ValueUpdateCopyWithImpl<T, $Res>
    extends _$ValueEventCopyWithImpl<T, $Res, _$_ValueUpdate<T>>
    implements _$$_ValueUpdateCopyWith<T, $Res> {
  __$$_ValueUpdateCopyWithImpl(
      _$_ValueUpdate<T> _value, $Res Function(_$_ValueUpdate<T>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = freezed,
  }) {
    return _then(_$_ValueUpdate<T>(
      freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as T,
    ));
  }
}

/// @nodoc

class _$_ValueUpdate<T> implements _ValueUpdate<T> {
  const _$_ValueUpdate(this.data);

  /// The current value of the entry.
  @override
  final T data;

  @override
  String toString() {
    return 'ValueEvent<$T>.update(data: $data)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ValueUpdate<T> &&
            const DeepCollectionEquality().equals(other.data, data));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(data));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ValueUpdateCopyWith<T, _$_ValueUpdate<T>> get copyWith =>
      __$$_ValueUpdateCopyWithImpl<T, _$_ValueUpdate<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(T data) update,
    required TResult Function(PatchSet<T> patchSet) patch,
    required TResult Function() delete,
    required TResult Function(String path) invalidPath,
  }) {
    return update(data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(T data)? update,
    TResult? Function(PatchSet<T> patchSet)? patch,
    TResult? Function()? delete,
    TResult? Function(String path)? invalidPath,
  }) {
    return update?.call(data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(T data)? update,
    TResult Function(PatchSet<T> patchSet)? patch,
    TResult Function()? delete,
    TResult Function(String path)? invalidPath,
    required TResult orElse(),
  }) {
    if (update != null) {
      return update(data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ValueUpdate<T> value) update,
    required TResult Function(_ValuePatch<T> value) patch,
    required TResult Function(_ValueDelete<T> value) delete,
    required TResult Function(_ValueInvalidPath<T> value) invalidPath,
  }) {
    return update(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ValueUpdate<T> value)? update,
    TResult? Function(_ValuePatch<T> value)? patch,
    TResult? Function(_ValueDelete<T> value)? delete,
    TResult? Function(_ValueInvalidPath<T> value)? invalidPath,
  }) {
    return update?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ValueUpdate<T> value)? update,
    TResult Function(_ValuePatch<T> value)? patch,
    TResult Function(_ValueDelete<T> value)? delete,
    TResult Function(_ValueInvalidPath<T> value)? invalidPath,
    required TResult orElse(),
  }) {
    if (update != null) {
      return update(this);
    }
    return orElse();
  }
}

abstract class _ValueUpdate<T> implements ValueEvent<T> {
  const factory _ValueUpdate(final T data) = _$_ValueUpdate<T>;

  /// The current value of the entry.
  T get data;
  @JsonKey(ignore: true)
  _$$_ValueUpdateCopyWith<T, _$_ValueUpdate<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$_ValuePatchCopyWith<T, $Res> {
  factory _$$_ValuePatchCopyWith(
          _$_ValuePatch<T> value, $Res Function(_$_ValuePatch<T>) then) =
      __$$_ValuePatchCopyWithImpl<T, $Res>;
  @useResult
  $Res call({PatchSet<T> patchSet});
}

/// @nodoc
class __$$_ValuePatchCopyWithImpl<T, $Res>
    extends _$ValueEventCopyWithImpl<T, $Res, _$_ValuePatch<T>>
    implements _$$_ValuePatchCopyWith<T, $Res> {
  __$$_ValuePatchCopyWithImpl(
      _$_ValuePatch<T> _value, $Res Function(_$_ValuePatch<T>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? patchSet = null,
  }) {
    return _then(_$_ValuePatch<T>(
      null == patchSet
          ? _value.patchSet
          : patchSet // ignore: cast_nullable_to_non_nullable
              as PatchSet<T>,
    ));
  }
}

/// @nodoc

class _$_ValuePatch<T> implements _ValuePatch<T> {
  const _$_ValuePatch(this.patchSet);

  /// The patchSet set that can be applied to the current value.
  @override
  final PatchSet<T> patchSet;

  @override
  String toString() {
    return 'ValueEvent<$T>.patch(patchSet: $patchSet)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ValuePatch<T> &&
            (identical(other.patchSet, patchSet) ||
                other.patchSet == patchSet));
  }

  @override
  int get hashCode => Object.hash(runtimeType, patchSet);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ValuePatchCopyWith<T, _$_ValuePatch<T>> get copyWith =>
      __$$_ValuePatchCopyWithImpl<T, _$_ValuePatch<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(T data) update,
    required TResult Function(PatchSet<T> patchSet) patch,
    required TResult Function() delete,
    required TResult Function(String path) invalidPath,
  }) {
    return patch(patchSet);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(T data)? update,
    TResult? Function(PatchSet<T> patchSet)? patch,
    TResult? Function()? delete,
    TResult? Function(String path)? invalidPath,
  }) {
    return patch?.call(patchSet);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(T data)? update,
    TResult Function(PatchSet<T> patchSet)? patch,
    TResult Function()? delete,
    TResult Function(String path)? invalidPath,
    required TResult orElse(),
  }) {
    if (patch != null) {
      return patch(patchSet);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ValueUpdate<T> value) update,
    required TResult Function(_ValuePatch<T> value) patch,
    required TResult Function(_ValueDelete<T> value) delete,
    required TResult Function(_ValueInvalidPath<T> value) invalidPath,
  }) {
    return patch(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ValueUpdate<T> value)? update,
    TResult? Function(_ValuePatch<T> value)? patch,
    TResult? Function(_ValueDelete<T> value)? delete,
    TResult? Function(_ValueInvalidPath<T> value)? invalidPath,
  }) {
    return patch?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ValueUpdate<T> value)? update,
    TResult Function(_ValuePatch<T> value)? patch,
    TResult Function(_ValueDelete<T> value)? delete,
    TResult Function(_ValueInvalidPath<T> value)? invalidPath,
    required TResult orElse(),
  }) {
    if (patch != null) {
      return patch(this);
    }
    return orElse();
  }
}

abstract class _ValuePatch<T> implements ValueEvent<T> {
  const factory _ValuePatch(final PatchSet<T> patchSet) = _$_ValuePatch<T>;

  /// The patchSet set that can be applied to the current value.
  PatchSet<T> get patchSet;
  @JsonKey(ignore: true)
  _$$_ValuePatchCopyWith<T, _$_ValuePatch<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$_ValueDeleteCopyWith<T, $Res> {
  factory _$$_ValueDeleteCopyWith(
          _$_ValueDelete<T> value, $Res Function(_$_ValueDelete<T>) then) =
      __$$_ValueDeleteCopyWithImpl<T, $Res>;
}

/// @nodoc
class __$$_ValueDeleteCopyWithImpl<T, $Res>
    extends _$ValueEventCopyWithImpl<T, $Res, _$_ValueDelete<T>>
    implements _$$_ValueDeleteCopyWith<T, $Res> {
  __$$_ValueDeleteCopyWithImpl(
      _$_ValueDelete<T> _value, $Res Function(_$_ValueDelete<T>) _then)
      : super(_value, _then);
}

/// @nodoc

class _$_ValueDelete<T> implements _ValueDelete<T> {
  const _$_ValueDelete();

  @override
  String toString() {
    return 'ValueEvent<$T>.delete()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$_ValueDelete<T>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(T data) update,
    required TResult Function(PatchSet<T> patchSet) patch,
    required TResult Function() delete,
    required TResult Function(String path) invalidPath,
  }) {
    return delete();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(T data)? update,
    TResult? Function(PatchSet<T> patchSet)? patch,
    TResult? Function()? delete,
    TResult? Function(String path)? invalidPath,
  }) {
    return delete?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(T data)? update,
    TResult Function(PatchSet<T> patchSet)? patch,
    TResult Function()? delete,
    TResult Function(String path)? invalidPath,
    required TResult orElse(),
  }) {
    if (delete != null) {
      return delete();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ValueUpdate<T> value) update,
    required TResult Function(_ValuePatch<T> value) patch,
    required TResult Function(_ValueDelete<T> value) delete,
    required TResult Function(_ValueInvalidPath<T> value) invalidPath,
  }) {
    return delete(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ValueUpdate<T> value)? update,
    TResult? Function(_ValuePatch<T> value)? patch,
    TResult? Function(_ValueDelete<T> value)? delete,
    TResult? Function(_ValueInvalidPath<T> value)? invalidPath,
  }) {
    return delete?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ValueUpdate<T> value)? update,
    TResult Function(_ValuePatch<T> value)? patch,
    TResult Function(_ValueDelete<T> value)? delete,
    TResult Function(_ValueInvalidPath<T> value)? invalidPath,
    required TResult orElse(),
  }) {
    if (delete != null) {
      return delete(this);
    }
    return orElse();
  }
}

abstract class _ValueDelete<T> implements ValueEvent<T> {
  const factory _ValueDelete() = _$_ValueDelete<T>;
}

/// @nodoc
abstract class _$$_ValueInvalidPathCopyWith<T, $Res> {
  factory _$$_ValueInvalidPathCopyWith(_$_ValueInvalidPath<T> value,
          $Res Function(_$_ValueInvalidPath<T>) then) =
      __$$_ValueInvalidPathCopyWithImpl<T, $Res>;
  @useResult
  $Res call({String path});
}

/// @nodoc
class __$$_ValueInvalidPathCopyWithImpl<T, $Res>
    extends _$ValueEventCopyWithImpl<T, $Res, _$_ValueInvalidPath<T>>
    implements _$$_ValueInvalidPathCopyWith<T, $Res> {
  __$$_ValueInvalidPathCopyWithImpl(_$_ValueInvalidPath<T> _value,
      $Res Function(_$_ValueInvalidPath<T>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? path = null,
  }) {
    return _then(_$_ValueInvalidPath<T>(
      null == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_ValueInvalidPath<T> implements _ValueInvalidPath<T> {
  const _$_ValueInvalidPath(this.path);

  /// The invalid subpath that was modified on the server.
  @override
  final String path;

  @override
  String toString() {
    return 'ValueEvent<$T>.invalidPath(path: $path)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ValueInvalidPath<T> &&
            (identical(other.path, path) || other.path == path));
  }

  @override
  int get hashCode => Object.hash(runtimeType, path);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ValueInvalidPathCopyWith<T, _$_ValueInvalidPath<T>> get copyWith =>
      __$$_ValueInvalidPathCopyWithImpl<T, _$_ValueInvalidPath<T>>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(T data) update,
    required TResult Function(PatchSet<T> patchSet) patch,
    required TResult Function() delete,
    required TResult Function(String path) invalidPath,
  }) {
    return invalidPath(path);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(T data)? update,
    TResult? Function(PatchSet<T> patchSet)? patch,
    TResult? Function()? delete,
    TResult? Function(String path)? invalidPath,
  }) {
    return invalidPath?.call(path);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(T data)? update,
    TResult Function(PatchSet<T> patchSet)? patch,
    TResult Function()? delete,
    TResult Function(String path)? invalidPath,
    required TResult orElse(),
  }) {
    if (invalidPath != null) {
      return invalidPath(path);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ValueUpdate<T> value) update,
    required TResult Function(_ValuePatch<T> value) patch,
    required TResult Function(_ValueDelete<T> value) delete,
    required TResult Function(_ValueInvalidPath<T> value) invalidPath,
  }) {
    return invalidPath(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ValueUpdate<T> value)? update,
    TResult? Function(_ValuePatch<T> value)? patch,
    TResult? Function(_ValueDelete<T> value)? delete,
    TResult? Function(_ValueInvalidPath<T> value)? invalidPath,
  }) {
    return invalidPath?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ValueUpdate<T> value)? update,
    TResult Function(_ValuePatch<T> value)? patch,
    TResult Function(_ValueDelete<T> value)? delete,
    TResult Function(_ValueInvalidPath<T> value)? invalidPath,
    required TResult orElse(),
  }) {
    if (invalidPath != null) {
      return invalidPath(this);
    }
    return orElse();
  }
}

abstract class _ValueInvalidPath<T> implements ValueEvent<T> {
  const factory _ValueInvalidPath(final String path) = _$_ValueInvalidPath<T>;

  /// The invalid subpath that was modified on the server.
  String get path;
  @JsonKey(ignore: true)
  _$$_ValueInvalidPathCopyWith<T, _$_ValueInvalidPath<T>> get copyWith =>
      throw _privateConstructorUsedError;
}
