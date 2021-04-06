// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Report _$ReportFromJson(Map<String, dynamic> json) {
  return Report(
    json['_id'] as String,
    DateUtils.convertDateAndIsoString(json['createdAt']),
    json['_userReport'] as String,
  );
}

Map<String, dynamic> _$ReportToJson(Report instance) => <String, dynamic>{
      '_id': instance.id,
      'createdAt': DateUtils.convertDateAndIsoString(instance.createdAt),
      '_userReport': instance.userId,
    };
