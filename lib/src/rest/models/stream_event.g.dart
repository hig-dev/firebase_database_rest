// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stream_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StreamEventPut _$$StreamEventPutFromJson(Map<String, dynamic> json) =>
    _$StreamEventPut(
      path: json['path'] as String,
      data: json['data'],
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$StreamEventPutToJson(_$StreamEventPut instance) =>
    <String, dynamic>{
      'path': instance.path,
      'data': instance.data,
      'runtimeType': instance.$type,
    };

_$StreamEventPatch _$$StreamEventPatchFromJson(Map<String, dynamic> json) =>
    _$StreamEventPatch(
      path: json['path'] as String,
      data: json['data'],
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$StreamEventPatchToJson(_$StreamEventPatch instance) =>
    <String, dynamic>{
      'path': instance.path,
      'data': instance.data,
      'runtimeType': instance.$type,
    };

_$StreamEventAuthRevoked _$$StreamEventAuthRevokedFromJson(
        Map<String, dynamic> json) =>
    _$StreamEventAuthRevoked(
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$StreamEventAuthRevokedToJson(
        _$StreamEventAuthRevoked instance) =>
    <String, dynamic>{
      'runtimeType': instance.$type,
    };
