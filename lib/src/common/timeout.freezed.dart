// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'timeout.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$Timeout {
  int get value => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int value) ms,
    required TResult Function(int value) s,
    required TResult Function(int value) min,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int value)? ms,
    TResult? Function(int value)? s,
    TResult? Function(int value)? min,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int value)? ms,
    TResult Function(int value)? s,
    TResult Function(int value)? min,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_TimeoutMs value) ms,
    required TResult Function(_TimeoutS value) s,
    required TResult Function(_TimeoutMin value) min,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_TimeoutMs value)? ms,
    TResult? Function(_TimeoutS value)? s,
    TResult? Function(_TimeoutMin value)? min,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_TimeoutMs value)? ms,
    TResult Function(_TimeoutS value)? s,
    TResult Function(_TimeoutMin value)? min,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $TimeoutCopyWith<Timeout> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TimeoutCopyWith<$Res> {
  factory $TimeoutCopyWith(Timeout value, $Res Function(Timeout) then) =
      _$TimeoutCopyWithImpl<$Res, Timeout>;
  @useResult
  $Res call({int value});
}

/// @nodoc
class _$TimeoutCopyWithImpl<$Res, $Val extends Timeout>
    implements $TimeoutCopyWith<$Res> {
  _$TimeoutCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? value = null,
  }) {
    return _then(_value.copyWith(
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_TimeoutMsCopyWith<$Res> implements $TimeoutCopyWith<$Res> {
  factory _$$_TimeoutMsCopyWith(
          _$_TimeoutMs value, $Res Function(_$_TimeoutMs) then) =
      __$$_TimeoutMsCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int value});
}

/// @nodoc
class __$$_TimeoutMsCopyWithImpl<$Res>
    extends _$TimeoutCopyWithImpl<$Res, _$_TimeoutMs>
    implements _$$_TimeoutMsCopyWith<$Res> {
  __$$_TimeoutMsCopyWithImpl(
      _$_TimeoutMs _value, $Res Function(_$_TimeoutMs) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? value = null,
  }) {
    return _then(_$_TimeoutMs(
      null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$_TimeoutMs extends _TimeoutMs {
  const _$_TimeoutMs(this.value)
      : assert(value > 0, 'value must be a positive integer'),
        assert(value <= 900000, 'value must be at most 15 min (900000 ms)'),
        super._();

  @override
  final int value;

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_TimeoutMs &&
            (identical(other.value, value) || other.value == value));
  }

  @override
  int get hashCode => Object.hash(runtimeType, value);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_TimeoutMsCopyWith<_$_TimeoutMs> get copyWith =>
      __$$_TimeoutMsCopyWithImpl<_$_TimeoutMs>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int value) ms,
    required TResult Function(int value) s,
    required TResult Function(int value) min,
  }) {
    return ms(value);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int value)? ms,
    TResult? Function(int value)? s,
    TResult? Function(int value)? min,
  }) {
    return ms?.call(value);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int value)? ms,
    TResult Function(int value)? s,
    TResult Function(int value)? min,
    required TResult orElse(),
  }) {
    if (ms != null) {
      return ms(value);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_TimeoutMs value) ms,
    required TResult Function(_TimeoutS value) s,
    required TResult Function(_TimeoutMin value) min,
  }) {
    return ms(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_TimeoutMs value)? ms,
    TResult? Function(_TimeoutS value)? s,
    TResult? Function(_TimeoutMin value)? min,
  }) {
    return ms?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_TimeoutMs value)? ms,
    TResult Function(_TimeoutS value)? s,
    TResult Function(_TimeoutMin value)? min,
    required TResult orElse(),
  }) {
    if (ms != null) {
      return ms(this);
    }
    return orElse();
  }
}

abstract class _TimeoutMs extends Timeout {
  const factory _TimeoutMs(final int value) = _$_TimeoutMs;
  const _TimeoutMs._() : super._();

  @override
  int get value;
  @override
  @JsonKey(ignore: true)
  _$$_TimeoutMsCopyWith<_$_TimeoutMs> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$_TimeoutSCopyWith<$Res> implements $TimeoutCopyWith<$Res> {
  factory _$$_TimeoutSCopyWith(
          _$_TimeoutS value, $Res Function(_$_TimeoutS) then) =
      __$$_TimeoutSCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int value});
}

/// @nodoc
class __$$_TimeoutSCopyWithImpl<$Res>
    extends _$TimeoutCopyWithImpl<$Res, _$_TimeoutS>
    implements _$$_TimeoutSCopyWith<$Res> {
  __$$_TimeoutSCopyWithImpl(
      _$_TimeoutS _value, $Res Function(_$_TimeoutS) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? value = null,
  }) {
    return _then(_$_TimeoutS(
      null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$_TimeoutS extends _TimeoutS {
  const _$_TimeoutS(this.value)
      : assert(value > 0, 'value must be a positive integer'),
        assert(value <= 900, 'value must be at most 15 min (900 s)'),
        super._();

  @override
  final int value;

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_TimeoutS &&
            (identical(other.value, value) || other.value == value));
  }

  @override
  int get hashCode => Object.hash(runtimeType, value);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_TimeoutSCopyWith<_$_TimeoutS> get copyWith =>
      __$$_TimeoutSCopyWithImpl<_$_TimeoutS>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int value) ms,
    required TResult Function(int value) s,
    required TResult Function(int value) min,
  }) {
    return s(value);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int value)? ms,
    TResult? Function(int value)? s,
    TResult? Function(int value)? min,
  }) {
    return s?.call(value);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int value)? ms,
    TResult Function(int value)? s,
    TResult Function(int value)? min,
    required TResult orElse(),
  }) {
    if (s != null) {
      return s(value);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_TimeoutMs value) ms,
    required TResult Function(_TimeoutS value) s,
    required TResult Function(_TimeoutMin value) min,
  }) {
    return s(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_TimeoutMs value)? ms,
    TResult? Function(_TimeoutS value)? s,
    TResult? Function(_TimeoutMin value)? min,
  }) {
    return s?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_TimeoutMs value)? ms,
    TResult Function(_TimeoutS value)? s,
    TResult Function(_TimeoutMin value)? min,
    required TResult orElse(),
  }) {
    if (s != null) {
      return s(this);
    }
    return orElse();
  }
}

abstract class _TimeoutS extends Timeout {
  const factory _TimeoutS(final int value) = _$_TimeoutS;
  const _TimeoutS._() : super._();

  @override
  int get value;
  @override
  @JsonKey(ignore: true)
  _$$_TimeoutSCopyWith<_$_TimeoutS> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$_TimeoutMinCopyWith<$Res> implements $TimeoutCopyWith<$Res> {
  factory _$$_TimeoutMinCopyWith(
          _$_TimeoutMin value, $Res Function(_$_TimeoutMin) then) =
      __$$_TimeoutMinCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int value});
}

/// @nodoc
class __$$_TimeoutMinCopyWithImpl<$Res>
    extends _$TimeoutCopyWithImpl<$Res, _$_TimeoutMin>
    implements _$$_TimeoutMinCopyWith<$Res> {
  __$$_TimeoutMinCopyWithImpl(
      _$_TimeoutMin _value, $Res Function(_$_TimeoutMin) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? value = null,
  }) {
    return _then(_$_TimeoutMin(
      null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$_TimeoutMin extends _TimeoutMin {
  const _$_TimeoutMin(this.value)
      : assert(value > 0, 'value must be a positive integer'),
        assert(value <= 15, 'value must be at most 15 min'),
        super._();

  @override
  final int value;

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_TimeoutMin &&
            (identical(other.value, value) || other.value == value));
  }

  @override
  int get hashCode => Object.hash(runtimeType, value);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_TimeoutMinCopyWith<_$_TimeoutMin> get copyWith =>
      __$$_TimeoutMinCopyWithImpl<_$_TimeoutMin>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int value) ms,
    required TResult Function(int value) s,
    required TResult Function(int value) min,
  }) {
    return min(value);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int value)? ms,
    TResult? Function(int value)? s,
    TResult? Function(int value)? min,
  }) {
    return min?.call(value);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int value)? ms,
    TResult Function(int value)? s,
    TResult Function(int value)? min,
    required TResult orElse(),
  }) {
    if (min != null) {
      return min(value);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_TimeoutMs value) ms,
    required TResult Function(_TimeoutS value) s,
    required TResult Function(_TimeoutMin value) min,
  }) {
    return min(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_TimeoutMs value)? ms,
    TResult? Function(_TimeoutS value)? s,
    TResult? Function(_TimeoutMin value)? min,
  }) {
    return min?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_TimeoutMs value)? ms,
    TResult Function(_TimeoutS value)? s,
    TResult Function(_TimeoutMin value)? min,
    required TResult orElse(),
  }) {
    if (min != null) {
      return min(this);
    }
    return orElse();
  }
}

abstract class _TimeoutMin extends Timeout {
  const factory _TimeoutMin(final int value) = _$_TimeoutMin;
  const _TimeoutMin._() : super._();

  @override
  int get value;
  @override
  @JsonKey(ignore: true)
  _$$_TimeoutMinCopyWith<_$_TimeoutMin> get copyWith =>
      throw _privateConstructorUsedError;
}
