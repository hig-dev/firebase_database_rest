// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'timestamp.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$FirebaseTimestamp {
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(DateTime value) $default, {
    required TResult Function() server,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(DateTime value)? $default, {
    TResult? Function()? server,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(DateTime value)? $default, {
    TResult Function()? server,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_FirebaseTimestamp value) $default, {
    required TResult Function(_Server value) server,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_FirebaseTimestamp value)? $default, {
    TResult? Function(_Server value)? server,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_FirebaseTimestamp value)? $default, {
    TResult Function(_Server value)? server,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FirebaseTimestampCopyWith<$Res> {
  factory $FirebaseTimestampCopyWith(
          FirebaseTimestamp value, $Res Function(FirebaseTimestamp) then) =
      _$FirebaseTimestampCopyWithImpl<$Res, FirebaseTimestamp>;
}

/// @nodoc
class _$FirebaseTimestampCopyWithImpl<$Res, $Val extends FirebaseTimestamp>
    implements $FirebaseTimestampCopyWith<$Res> {
  _$FirebaseTimestampCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$_FirebaseTimestampCopyWith<$Res> {
  factory _$$_FirebaseTimestampCopyWith(_$_FirebaseTimestamp value,
          $Res Function(_$_FirebaseTimestamp) then) =
      __$$_FirebaseTimestampCopyWithImpl<$Res>;
  @useResult
  $Res call({DateTime value});
}

/// @nodoc
class __$$_FirebaseTimestampCopyWithImpl<$Res>
    extends _$FirebaseTimestampCopyWithImpl<$Res, _$_FirebaseTimestamp>
    implements _$$_FirebaseTimestampCopyWith<$Res> {
  __$$_FirebaseTimestampCopyWithImpl(
      _$_FirebaseTimestamp _value, $Res Function(_$_FirebaseTimestamp) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? value = null,
  }) {
    return _then(_$_FirebaseTimestamp(
      null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

class _$_FirebaseTimestamp extends _FirebaseTimestamp {
  const _$_FirebaseTimestamp(this.value) : super._();

  /// The datetime value to be used.
  @override
  final DateTime value;

  @override
  String toString() {
    return 'FirebaseTimestamp(value: $value)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_FirebaseTimestamp &&
            (identical(other.value, value) || other.value == value));
  }

  @override
  int get hashCode => Object.hash(runtimeType, value);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_FirebaseTimestampCopyWith<_$_FirebaseTimestamp> get copyWith =>
      __$$_FirebaseTimestampCopyWithImpl<_$_FirebaseTimestamp>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(DateTime value) $default, {
    required TResult Function() server,
  }) {
    return $default(value);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(DateTime value)? $default, {
    TResult? Function()? server,
  }) {
    return $default?.call(value);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(DateTime value)? $default, {
    TResult Function()? server,
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(value);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_FirebaseTimestamp value) $default, {
    required TResult Function(_Server value) server,
  }) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_FirebaseTimestamp value)? $default, {
    TResult? Function(_Server value)? server,
  }) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_FirebaseTimestamp value)? $default, {
    TResult Function(_Server value)? server,
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }
}

abstract class _FirebaseTimestamp extends FirebaseTimestamp {
  const factory _FirebaseTimestamp(final DateTime value) = _$_FirebaseTimestamp;
  const _FirebaseTimestamp._() : super._();

  /// The datetime value to be used.
  DateTime get value;
  @JsonKey(ignore: true)
  _$$_FirebaseTimestampCopyWith<_$_FirebaseTimestamp> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$_ServerCopyWith<$Res> {
  factory _$$_ServerCopyWith(_$_Server value, $Res Function(_$_Server) then) =
      __$$_ServerCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_ServerCopyWithImpl<$Res>
    extends _$FirebaseTimestampCopyWithImpl<$Res, _$_Server>
    implements _$$_ServerCopyWith<$Res> {
  __$$_ServerCopyWithImpl(_$_Server _value, $Res Function(_$_Server) _then)
      : super(_value, _then);
}

/// @nodoc

class _$_Server extends _Server {
  const _$_Server() : super._();

  @override
  String toString() {
    return 'FirebaseTimestamp.server()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$_Server);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(DateTime value) $default, {
    required TResult Function() server,
  }) {
    return server();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(DateTime value)? $default, {
    TResult? Function()? server,
  }) {
    return server?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(DateTime value)? $default, {
    TResult Function()? server,
    required TResult orElse(),
  }) {
    if (server != null) {
      return server();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_FirebaseTimestamp value) $default, {
    required TResult Function(_Server value) server,
  }) {
    return server(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_FirebaseTimestamp value)? $default, {
    TResult? Function(_Server value)? server,
  }) {
    return server?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_FirebaseTimestamp value)? $default, {
    TResult Function(_Server value)? server,
    required TResult orElse(),
  }) {
    if (server != null) {
      return server(this);
    }
    return orElse();
  }
}

abstract class _Server extends FirebaseTimestamp {
  const factory _Server() = _$_Server;
  const _Server._() : super._();
}
