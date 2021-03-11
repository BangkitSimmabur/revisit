import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';

import 'location.dart';

part 'user.g.dart';

@JsonSerializable(explicitToJson: true)
class User {
  @JsonKey(name: 'Username')
  String username;
  @JsonKey(name: 'Name')
  String name;
  @JsonKey(name: 'Email')
  String email;
  @JsonKey(name: 'ProfilePhotoUrl')
  String profilePhotoUrl;

  User(this.name, this.email, this.profilePhotoUrl, this.username);

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
