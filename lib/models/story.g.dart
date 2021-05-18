// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Story _$StoryFromJson(Map<String, dynamic> json) {
  return Story(
    json['_id'] as String,
    json['title'] as String,
    json['text'] as String,
    userFromJson(json['_user']),
    locationFromJson(json['location']),
    json['createdAt'] as String,
    json['updateAt'] as String,
    (json['comments'] as List)?.map((e) => e as String)?.toList(),
    isPublishedFromJson(json['published']),
    pictureFromJson(json['picture']),
    likesFromJson(json['likes']),
    reportsFromJson(json['reports']),
  );
}

Map<String, dynamic> _$StoryToJson(Story instance) => <String, dynamic>{
      '_id': instance.id,
      'title': instance.title,
      'text': instance.text,
      '_user': instance.user,
      'location': instance.location,
      'createdAt': instance.createdAt,
      'updateAt': instance.updateAt,
      'published': instance.published,
      'picture': instance.picture,
      'likes': instance.likes,
      'reports': instance.reports,
      'comments': instance.comments,
    };

StoryV2 _$StoryV2FromJson(Map<String, dynamic> json) {
  return StoryV2(
    json['_id'] as String,
    json['title'] as String,
    json['text'] as String,
    userFromJson(json['_user']),
    locationFromJson(json['location']),
    json['createdAt'] as String,
    json['updateAt'] as String,
    commentsFromJson(json['comments']),
    isPublishedFromJson(json['published']),
    pictureFromJson(json['picture']),
    likesFromJson(json['likes']),
    reportsFromJson(json['reports']),
  );
}

Map<String, dynamic> _$StoryV2ToJson(StoryV2 instance) => <String, dynamic>{
      '_id': instance.id,
      'title': instance.title,
      'text': instance.text,
      '_user': instance.user,
      'location': instance.location,
      'createdAt': instance.createdAt,
      'updateAt': instance.updateAt,
      'published': instance.published,
      'picture': instance.picture,
      'comments': instance.comments,
      'likes': instance.likes,
      'reports': instance.reports,
    };
