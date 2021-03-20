import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'location.g.dart';

@JsonSerializable()
class LocationData {
  @JsonKey(name: 'x')
  double latitude;
  @JsonKey(name: 'y')
  double longitude;
  @JsonKey(name: 'address')
  String address;

  LocationData(
    this.latitude,
    this.longitude,
    this.address,
  );

  factory LocationData.fromJson(Map<String, dynamic> json) =>
      _$LocationDataFromJson(json);

  Map<String, dynamic> toJson() => _$LocationDataToJson(this);
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
