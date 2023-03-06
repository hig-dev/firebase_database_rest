// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db_exception.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Exception _$$_ExceptionFromJson(Map<String, dynamic> json) => _$_Exception(
      statusCode: json['statusCode'] as int? ?? 400,
      error: json['error'] as String?,
    );

Map<String, dynamic> _$$_ExceptionToJson(_$_Exception instance) =>
    <String, dynamic>{
      'statusCode': instance.statusCode,
      'error': instance.error,
    };
