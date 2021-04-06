import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:revisit/models/user.dart';
import 'package:revisit/utility/date_utils.dart';

part 'comment.g.dart';

@JsonSerializable()
class Comments {
  @JsonKey(name: '_id')
  String id;
  @JsonKey(name: '_articleId')
  String articleId;
  @JsonKey(name: '_storyId')
  String storyId;
  @JsonKey(name: 'comments', fromJson: commentFromJson)
  Comment comments;

  Comments(
    this.id,
    this.comments,
  );

  factory Comments.fromJson(Map<String, dynamic> json) =>
      _$CommentsFromJson(json);

  Map<String, dynamic> toJson() => _$CommentsToJson(this);
}

List<Comments> commentsFromJson(dynamic map) {
  if (map == null) return null;

  var decoded;
  if (map is String)
    decoded = json.decode(map);
  else
    decoded = map;

  return decoded
      .map<Comments>((dynamic json) => _$CommentsFromJson(json))
      .toList();
}

@JsonSerializable()
class Comment {
  @JsonKey(
    name: 'createdAt',
    fromJson: DateUtils.convertDateAndIsoString,
    toJson: DateUtils.convertDateAndIsoString,
  )
  DateTime createdAt;
  @JsonKey(name: '_user', fromJson: userFromJson)
  User user;
  @JsonKey(name: 'comment')
  String comment;

  Comment(
    this.user,
    this.createdAt,
    this.comment,
  );

  factory Comment.fromJson(Map<String, dynamic> json) =>
      _$CommentFromJson(json);

  Map<String, dynamic> toJson() => _$CommentToJson(this);
}

Comment commentFromJson(dynamic map) {
  if (map == null) return null;

  var decoded;
  if (map is String)
    decoded = json.decode(map);
  else
    decoded = map;

  return _$CommentFromJson(decoded);
}
// comments": [
// {
// "comments": {
// "createdAt": "Date.now()",
// "_user": {
// "picture": {
// "imageId": "The objectId of this image that refers to imagekit",
// "imageName": "username_thenameofthisfile",
// "fullImage": "The url for fullwidth image",
// "thumbnailImage": "The url for thumbnailwidth image"
// },
// "isAdmin": true,
// "name": "Your Fullname",
// "username": "yourusername",
// "email": "youremail@mail.com",
// "_id": "The object id of user"
// },
// "comment": "komentarnya"
// },
// "_id": "the objectId of this comment",
// "_articleId": "the article objectid if this comment is on article, if no, it will show null",
// "_storyId": "the story objectid if this comment is on article, if no, it will show null"
// }
// ]
