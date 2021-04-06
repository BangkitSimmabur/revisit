import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:revisit/utility/date_utils.dart';

part 'report.g.dart';

@JsonSerializable()
class Report {
  @JsonKey(name: '_id')
  String id;
  @JsonKey(
    name: 'createdAt',
    fromJson: DateUtils.convertDateAndIsoString,
    toJson: DateUtils.convertDateAndIsoString,
  )
  DateTime createdAt;
  @JsonKey(name: '_userReport')
  String userId;
  Report(
      this.id,
      this.createdAt,
      this.userId,
      );

  factory Report.fromJson(Map<String, dynamic> json) =>
      _$ReportFromJson(json);

  Map<String, dynamic> toJson() => _$ReportToJson(this);
}

Report reportFromJson(dynamic map) {
  if (map == null) return null;

  var decoded;
  if (map is String)
    decoded = json.decode(map);
  else
    decoded = map;

  return _$ReportFromJson(decoded);
}

List<Report> reportsFromJson(dynamic map) {
  if (map == null) return null;

  var decoded;
  if (map is String)
    decoded = json.decode(map);
  else
    decoded = map;

  return decoded
      .map<Report>((dynamic json) => _$ReportFromJson(json))
      .toList();
}