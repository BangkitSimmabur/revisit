// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ispublished.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IsPublished _$IsPublishedFromJson(Map<String, dynamic> json) {
  return IsPublished(
    json['published'] as bool,
    json['blocked'] as bool,
    json['deleted'] as bool,
  );
}

Map<String, dynamic> _$IsPublishedToJson(IsPublished instance) =>
    <String, dynamic>{
      'published': instance.published,
      'blocked': instance.blocked,
      'deleted': instance.deleted,
    };
