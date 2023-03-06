// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'integration_test.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_TestModel _$$_TestModelFromJson(Map<String, dynamic> json) => _$_TestModel(
      id: json['id'] as int,
      data: json['data'] as String?,
      extra: json['extra'] as bool? ?? false,
      timestamp: json['timestamp'] == null
          ? null
          : FirebaseTimestamp.fromJson(json['timestamp']),
    );

Map<String, dynamic> _$$_TestModelToJson(_$_TestModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'data': instance.data,
      'extra': instance.extra,
      'timestamp': instance.timestamp,
    };
