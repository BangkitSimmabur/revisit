import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:revisit/utility/date_utils.dart';

part 'like.g.dart';

@JsonSerializable()
class Like {
  @JsonKey(name: '_id')
  String id;
  @JsonKey(
    name: 'createdAt',
    fromJson: DateUtils.convertDateAndIsoString,
    toJson: DateUtils.convertDateAndIsoString,
  )
  DateTime createdAt;
  @JsonKey(name: '_userLike')
  String userId;
  Like(
      this.id,
      this.createdAt,
      this.userId,
      );

  factory Like.fromJson(Map<String, dynamic> json) =>
      _$LikeFromJson(json);

  Map<String, dynamic> toJson() => _$LikeToJson(this);
}

Like likeFromJson(dynamic map) {
  if (map == null) return null;

  var decoded;
  if (map is String)
    decoded = json.decode(map);
  else
    decoded = map;

  return _$LikeFromJson(decoded);
}

List<Like> likesFromJson(dynamic map) {
  if (map == null) return null;

  var decoded;
  if (map is String)
    decoded = json.decode(map);
  else
    decoded = map;

  return decoded
      .map<Like>((dynamic json) => _$LikeFromJson(json))
      .toList();
}