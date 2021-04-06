import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:revisit/models/picture.dart';

part 'user.g.dart';

@JsonSerializable(explicitToJson: true)
class User {
  @JsonKey(name: '_id')
  String id;
  @JsonKey(name: 'username')
  String username;
  @JsonKey(name: 'name')
  String name;
  @JsonKey(name: 'email')
  String email;
  @JsonKey(name: 'isAdmin')
  bool isAdmin;
  @JsonKey(name: 'picture', fromJson: pictureFromJson)
  Picture profilePicture;

  User(this.id, this.name, this.email, this.profilePicture, this.username,
      this.isAdmin);

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
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
