import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'ispublished.g.dart';

@JsonSerializable()
class IsPublished {
  @JsonKey(name: 'published')
  bool published;
  @JsonKey(name: 'blocked')
  bool blocked;
  @JsonKey(name: 'deleted')
  bool deleted;

  IsPublished(
      this.published,
      this.blocked,
      this.deleted,
      );

  factory IsPublished.fromJson(Map<String, dynamic> json) =>
      _$IsPublishedFromJson(json);

  Map<String, dynamic> toJson() => _$IsPublishedToJson(this);
}

IsPublished isPublishedFromJson(dynamic map) {
  if (map == null) return null;

  var decoded;
  if (map is String)
    decoded = json.decode(map);
  else
    decoded = map;

  return _$IsPublishedFromJson(decoded);
}
