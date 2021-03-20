// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocationData _$LocationDataFromJson(Map<String, dynamic> json) {
  return LocationData(
    (json['x'] as num)?.toDouble(),
    (json['y'] as num)?.toDouble(),
    json['address'] as String,
  );
}

Map<String, dynamic> _$LocationDataToJson(LocationData instance) =>
    <String, dynamic>{
      'x': instance.latitude,
      'y': instance.longitude,
      'address': instance.address,
    };
