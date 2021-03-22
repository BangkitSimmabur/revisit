import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable(explicitToJson: true)
class User {
  @JsonKey(name: '_id')
  int id;
  @JsonKey(name: 'username')
  String username;
  @JsonKey(name: 'name')
  String name;
  @JsonKey(name: 'email')
  String email;
  @JsonKey(name: 'isAdmin')
  String isAdmin;
  @JsonKey(name: 'profilePhotoUrl')
  String profilePhotoUrl;

  User(this.name, this.email, this.profilePhotoUrl, this.username, this.isAdmin);

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

User userFromJson(dynamic map) {
  if (map == null) return null;

  var decoded;
  if (map is String)
    decoded = json.decode(map);
  else
    decoded = map;

  return _$UserFromJson(decoded);
}
