// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    json['Name'],
    json['Email'],
    json['ProfilePhotoUrl'],
    json['Username'],
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'Username': instance.username,
      'Name': instance.name,
      'Email': instance.email,
      'ProfilePhotoUrl': instance.profilePhotoUrl,
    };
