import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:revisit/models/comment.dart';
import 'package:revisit/models/ispublished.dart';
import 'package:revisit/models/like.dart';
import 'package:revisit/models/location.dart';
import 'package:revisit/models/picture.dart';
import 'package:revisit/models/report.dart';
import 'package:revisit/models/user.dart';
import 'package:revisit/utility/date_utils.dart';

part 'story.g.dart';

@JsonSerializable()
class Story {
  @JsonKey(name: '_id')
  String id;
  @JsonKey(name: 'title')
  String title;
  @JsonKey(name: 'text')
  String text;
  @JsonKey(name: '_user', fromJson: userFromJson)
  User user;
  @JsonKey(name: 'location', fromJson: locationFromJson)
  LocationData location;
  @JsonKey(
    name: 'createdAt',
    fromJson: DateUtils.convertDateAndIsoString,
    toJson: DateUtils.convertDateAndIsoString,
  )
  DateTime createdAt;
  @JsonKey(
    name: 'updateAt',
    fromJson: DateUtils.convertDateAndIsoString,
    toJson: DateUtils.convertDateAndIsoString,
  )
  DateTime updateAt;
  @JsonKey(name: 'published', fromJson: isPublishedFromJson)
  IsPublished published;
  @JsonKey(name: 'picture', fromJson: pictureFromJson)
  Picture picture;
  @JsonKey(name: 'likes', fromJson: likesFromJson)
  List<Like> likes;
  @JsonKey(name: 'reports', fromJson: reportsFromJson)
  List<Report> reports;
  @JsonKey(name: 'comments')
  List<String> comments;

  Story(
    this.id,
    this.title,
    this.text,
    this.user,
    this.location,
    this.createdAt,
    this.updateAt,
    this.comments,
    this.published,
    this.picture,
    this.likes,
    this.reports,
  );

  factory Story.fromJson(Map<String, dynamic> json) => _$StoryFromJson(json);

  Map<String, dynamic> toJson() => _$StoryToJson(this);
}

Story storyFromJson(dynamic map) {
  if (map == null) return null;

  var decoded;
  if (map is String)
    decoded = json.decode(map);
  else
    decoded = map;

  return _$StoryFromJson(decoded);
}

List<Story> storiesFromJson(dynamic map) {
  if (map == null) return null;

  var decoded;
  if (map is String)
    decoded = json.decode(map);
  else
    decoded = map;

  return decoded.map<Story>((dynamic json) => _$StoryFromJson(json)).toList();
}

@JsonSerializable()
class StoryV2 {
  @JsonKey(name: '_id')
  String id;
  @JsonKey(name: 'title')
  String title;
  @JsonKey(name: 'text')
  String text;
  @JsonKey(name: '_user', fromJson: userFromJson)
  User user;
  @JsonKey(name: 'location', fromJson: locationFromJson)
  LocationData location;
  @JsonKey(
    name: 'createdAt',
    fromJson: DateUtils.convertDateAndIsoString,
    toJson: DateUtils.convertDateAndIsoString,
  )
  DateTime createdAt;
  @JsonKey(
    name: 'updateAt',
    fromJson: DateUtils.convertDateAndIsoString,
    toJson: DateUtils.convertDateAndIsoString,
  )
  DateTime updateAt;
  @JsonKey(name: 'published', fromJson: isPublishedFromJson)
  IsPublished published;
  @JsonKey(name: 'picture', fromJson: pictureFromJson)
  Picture picture;
  @JsonKey(name: 'comments', fromJson: commentsFromJson)
  List<Comments> comments;
  @JsonKey(name: 'likes', fromJson: likesFromJson)
  List<Like> likes;
  @JsonKey(name: 'reports', fromJson: reportsFromJson)
  List<Report> reports;

  StoryV2(
    this.id,
    this.title,
    this.text,
    this.user,
    this.location,
    this.createdAt,
    this.updateAt,
    this.comments,
    this.published,
    this.picture,
    this.likes,
    this.reports,
  );

  factory StoryV2.fromJson(Map<String, dynamic> json) =>
      _$StoryV2FromJson(json);

  Map<String, dynamic> toJson() => _$StoryV2ToJson(this);
}

StoryV2 storyV2FromJson(dynamic map) {
  if (map == null) return null;

  var decoded;
  if (map is String)
    decoded = json.decode(map);
  else
    decoded = map;

  return _$StoryV2FromJson(decoded);
}

List<StoryV2> storiesV2FromJson(dynamic map) {
  if (map == null) return null;

  var decoded;
  if (map is String)
    decoded = json.decode(map);
  else
    decoded = map;

  return decoded
      .map<StoryV2>((dynamic json) => _$StoryV2FromJson(json))
      .toList();
}
