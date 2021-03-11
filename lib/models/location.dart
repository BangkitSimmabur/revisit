import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'location.g.dart';

@JsonSerializable()
class LocationData {
  @JsonKey(name: 'Latitude')
  double latitude;
  @JsonKey(name: 'Longitude')
  double longitude;
  @JsonKey(name: 'City')
  String city;
  @JsonKey(name: 'PostCode')
  String postCode;
  @JsonKey(name: 'Country')
  String country;
  @JsonKey(name: 'Address')
  String address;

  LocationData(
      this.latitude,
      this.longitude,
      );

  LocationData.fromData(
      this.latitude,
      this.longitude, {
        this.city,
        this.country,
        this.address,
      });

  factory LocationData.fromJson(Map<String, dynamic> json) =>
      _$LocationDataFromJson(json);

  Map<String, dynamic> toJson() => _$LocationDataToJson(this);

  bool get isKorea {
    if (country == null || country.isEmpty) return false;

    if (country.toUpperCase().contains('korea'.toUpperCase())) return true;

    return false;
  }
}

LocationData locationFromJson(dynamic map) {
  if (map == null) return null;

  var decoded;
  if (map is String)
    decoded = json.decode(map);
  else
    decoded = map;

  return _$LocationDataFromJson(decoded);
}
