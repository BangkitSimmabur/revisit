// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    json['_id'] as String,
    json['name'] as String,
    json['email'] as String,
    pictureFromJson(json['picture']),
    json['username'] as String,
    json['isAdmin'] as bool,
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      '_id': instance.id,
      'username': instance.username,
      'name': instance.name,
      'email': instance.email,
      'isAdmin': instance.isAdmin,
      'picture': instance.profilePicture?.toJson(),
    };
