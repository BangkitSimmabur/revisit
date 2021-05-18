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
    this.storyId,
    this.articleId,
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
  )
  String createdAt;
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
