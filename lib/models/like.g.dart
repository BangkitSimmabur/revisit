// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'like.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Like _$LikeFromJson(Map<String, dynamic> json) {
  return Like(
    json['_id'] as String,
    DateUtils.convertDateAndIsoString(json['createdAt']),
    json['_userLike'] as String,
  );
}

Map<String, dynamic> _$LikeToJson(Like instance) => <String, dynamic>{
      '_id': instance.id,
      'createdAt': DateUtils.convertDateAndIsoString(instance.createdAt),
      '_userLike': instance.userId,
    };
