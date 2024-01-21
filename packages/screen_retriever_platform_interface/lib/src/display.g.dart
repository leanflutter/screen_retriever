// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: require_trailing_commas

part of 'display.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Display _$DisplayFromJson(Map<String, dynamic> json) => Display(
      id: json['id'] as num,
      name: json['name'] as String?,
      size:
          const _SizeConverter().fromJson(json['size'] as Map<String, dynamic>),
      visiblePosition: _$JsonConverterFromJson<Map<String, dynamic>, Offset>(
          json['visiblePosition'], const _OffsetConverter().fromJson),
      visibleSize: _$JsonConverterFromJson<Map<String, dynamic>, Size>(
          json['visibleSize'], const _SizeConverter().fromJson),
      scaleFactor: json['scaleFactor'] as num?,
    );

Map<String, dynamic> _$DisplayToJson(Display instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'size': const _SizeConverter().toJson(instance.size),
      'visiblePosition': _$JsonConverterToJson<Map<String, dynamic>, Offset>(
          instance.visiblePosition, const _OffsetConverter().toJson),
      'visibleSize': _$JsonConverterToJson<Map<String, dynamic>, Size>(
          instance.visibleSize, const _SizeConverter().toJson),
      'scaleFactor': instance.scaleFactor,
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);
