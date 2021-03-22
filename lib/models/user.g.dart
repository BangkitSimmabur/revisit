// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    json['name'] as String,
    json['email'] as String,
    json['profilePhotoUrl'] as String,
    json['username'] as String,
    json['isAdmin'] as String,
  )..id = json['_id'] as int;
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      '_id': instance.id,
      'username': instance.username,
      'name': instance.name,
      'email': instance.email,
      'isAdmin': instance.isAdmin,
      'profilePhotoUrl': instance.profilePhotoUrl,
    };
