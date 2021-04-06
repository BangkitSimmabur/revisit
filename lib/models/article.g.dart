// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Article _$ArticleFromJson(Map<String, dynamic> json) {
  return Article(
    json['_id'] as String,
    json['title'] as String,
    json['text'] as String,
    userFromJson(json['_user']),
    locationFromJson(json['location']),
    DateUtils.convertDateAndIsoString(json['createdAt']),
    DateUtils.convertDateAndIsoString(json['updateAt']),
    (json['comments'] as List)?.map((e) => e as String)?.toList(),
    isPublishedFromJson(json['published']),
    pictureFromJson(json['picture']),
    likesFromJson(json['likes']),
    reportsFromJson(json['reports']),
  );
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
      'picture': instance.picture,
      'likes': instance.likes,
      'reports': instance.reports,
      'comments': instance.comments,
    };

ArticleV2 _$ArticleV2FromJson(Map<String, dynamic> json) {
  return ArticleV2(
    json['_id'] as String,
    json['title'] as String,
    json['text'] as String,
    userFromJson(json['_user']),
    locationFromJson(json['location']),
    DateUtils.convertDateAndIsoString(json['createdAt']),
    DateUtils.convertDateAndIsoString(json['updateAt']),
    commentsFromJson(json['comments']),
    isPublishedFromJson(json['published']),
    pictureFromJson(json['picture']),
    likesFromJson(json['likes']),
    reportsFromJson(json['reports']),
  );
}

Map<String, dynamic> _$ArticleV2ToJson(ArticleV2 instance) => <String, dynamic>{
      '_id': instance.id,
      'title': instance.title,
      'text': instance.text,
      '_user': instance.user,
      'location': instance.location,
      'createdAt': DateUtils.convertDateAndIsoString(instance.createdAt),
      'updateAt': DateUtils.convertDateAndIsoString(instance.updateAt),
      'published': instance.published,
      'picture': instance.picture,
      'comments': instance.comments,
      'likes': instance.likes,
      'reports': instance.reports,
    };
