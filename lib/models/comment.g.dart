// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Comments _$CommentsFromJson(Map<String, dynamic> json) {
  return Comments(
    json['_id'] as String,
    commentFromJson(json['comments']),
    json['_storyId'] as String,
    json['_articleId'] as String,
  );
}

Map<String, dynamic> _$CommentsToJson(Comments instance) => <String, dynamic>{
      '_id': instance.id,
      '_articleId': instance.articleId,
      '_storyId': instance.storyId,
      'comments': instance.comments,
    };

Comment _$CommentFromJson(Map<String, dynamic> json) {
  return Comment(
    userFromJson(json['_user']),
    json['createdAt'] as String,
    json['comment'] as String,
  );
}

Map<String, dynamic> _$CommentToJson(Comment instance) => <String, dynamic>{
      'createdAt': instance.createdAt,
      '_user': instance.user,
      'comment': instance.comment,
    };
