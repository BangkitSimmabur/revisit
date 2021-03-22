import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:revisit/models/ispublished.dart';
import 'package:revisit/models/location.dart';
import 'package:revisit/models/user.dart';
import 'package:revisit/utility/date_utils.dart';

part 'article.g.dart';

@JsonSerializable()
class Article {
  @JsonKey(name: '_id')
  int id;
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
  @JsonKey(name: 'reports')
  List<int> reports;

  Article(
      this.text,
      this.title,
      this.id,
      this.user,
      this.createdAt,
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