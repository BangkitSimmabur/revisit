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

part 'article.g.dart';

@JsonSerializable()
class Article {
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

  Article(
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

  factory Article.fromJson(Map<String, dynamic> json) =>
      _$ArticleFromJson(json);

  Map<String, dynamic> toJson() => _$ArticleToJson(this);
}

Article articleFromJson(dynamic map) {
  if (map == null) return null;

  var decoded;
  if (map is String)
    decoded = json.decode(map);
  else
    decoded = map;

  return _$ArticleFromJson(decoded);
}

List<Article> articlesFromJson(dynamic map) {
  if (map == null) return null;

  var decoded;
  if (map is String)
    decoded = json.decode(map);
  else
    decoded = map;

  return decoded
      .map<Article>((dynamic json) => _$ArticleFromJson(json))
      .toList();
}

@JsonSerializable()
class ArticleV2 {
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

  ArticleV2(
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

  factory ArticleV2.fromJson(Map<String, dynamic> json) =>
      _$ArticleV2FromJson(json);

  Map<String, dynamic> toJson() => _$ArticleV2ToJson(this);
}

ArticleV2 articleV2FromJson(dynamic map) {
  if (map == null) return null;

  var decoded;
  if (map is String)
    decoded = json.decode(map);
  else
    decoded = map;

  return _$ArticleV2FromJson(decoded);
}

List<ArticleV2> articlesV2FromJson(dynamic map) {
  if (map == null) return null;

  var decoded;
  if (map is String)
    decoded = json.decode(map);
  else
    decoded = map;

  return decoded
      .map<ArticleV2>((dynamic json) => _$ArticleV2FromJson(json))
      .toList();
}
