// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'special_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SpecialModel _$SpecialModelFromJson(Map<String, dynamic> json) =>
    _SpecialModel(
      id: json['id'] as String,
      dishId: json['dishId'] as String,
      title: json['title'] as String,
      expiresAt: (json['expiresAt'] as num).toInt(),
    );

Map<String, dynamic> _$SpecialModelToJson(_SpecialModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'dishId': instance.dishId,
      'title': instance.title,
      'expiresAt': instance.expiresAt,
    };
