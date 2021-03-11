// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocationData _$LocationDataFromJson(Map<String, dynamic> json) {
  return LocationData(
    (json['Latitude'] as num)?.toDouble(),
    (json['Longitude'] as num)?.toDouble(),
  )
    ..city = json['City'] as String
    ..postCode = json['PostCode'] as String
    ..country = json['Country'] as String
    ..address = json['Address'] as String;
}

Map<String, dynamic> _$LocationDataToJson(LocationData instance) =>
    <String, dynamic>{
      'Latitude': instance.latitude,
      'Longitude': instance.longitude,
      'City': instance.city,
      'PostCode': instance.postCode,
      'Country': instance.country,
      'Address': instance.address,
    };
