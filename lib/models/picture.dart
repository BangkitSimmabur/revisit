import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'picture.g.dart';

@JsonSerializable(explicitToJson: true)
class Picture {
  @JsonKey(name: 'imageId')
  String id;
  @JsonKey(name: 'imageName')
  String imageName;
  @JsonKey(name: 'fullImage')
  String fullImage;
  @JsonKey(name: 'thumbnailImage')
  String thumbnailImage;

  Picture(
      this.id,
      this.imageName,
      this.fullImage,
      this.thumbnailImage,
      );

  factory Picture.fromJson(Map<String, dynamic> json) =>
      _$PictureFromJson(json);
  Map<String, dynamic> toJson() => _$PictureToJson(this);
}

Picture pictureFromJson(dynamic map) {
  if (map == null) return null;

  var decoded;
  if (map is String)
    decoded = json.decode(map);
  else
    decoded = map;

  return _$PictureFromJson(decoded);
}