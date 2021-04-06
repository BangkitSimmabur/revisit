// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'picture.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Picture _$PictureFromJson(Map<String, dynamic> json) {
  return Picture(
    json['imageId'] as String,
    json['imageName'] as String,
    json['fullImage'] as String,
    json['thumbnailImage'] as String,
  );
}

Map<String, dynamic> _$PictureToJson(Picture instance) => <String, dynamic>{
      'imageId': instance.id,
      'imageName': instance.imageName,
      'fullImage': instance.fullImage,
      'thumbnailImage': instance.thumbnailImage,
    };
