// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Article _$ArticleFromJson(Map<String, dynamic> json) {
  return Article(
    json['text'] as String,
    json['title'] as String,
    json['_id'] as int,
    userFromJson(json['_user']),
    DateUtils.convertDateAndIsoString(json['createdAt']),
  )
    ..location = locationFromJson(json['location'])
    ..updateAt = DateUtils.convertDateAndIsoString(json['updateAt'])
    ..published = isPublishedFromJson(json['published'])
    ..reports = (json['reports'] as List)?.map((e) => e as int)?.toList();
}

Map<String, dynamic> _$ArticleToJson(Article instance) => <String, dynamic>{
      '_id': instance.id,
      'title': instance.title,
      'text': instance.text,
      '_user': instance.user,
      'location': instance.location,
      'createdAt': DateUtils.convertDateAndIsoString(instance.createdAt),
      'updateAt': DateUtils.convertDateAndIsoString(instance.updateAt),
      'published': instance.published,
      'reports': instance.reports,
    };
