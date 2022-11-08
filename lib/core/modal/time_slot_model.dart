import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeSlotModel {
  int id;
  int categoryId;
  DateTime timeSlot;
  DateTime createdAt;
  DateTime updatedAt;

  TimeSlotModel({
    required this.id,
    required this.categoryId,
    required this.timeSlot,
    required this.createdAt,
    required this.updatedAt,
  });

  TimeSlotModel.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        categoryId = json["category_id"],
        timeSlot =
            DateTime.parse("${DateTime.now().toString().split(" ")[0]} ${json["time_slot"]}"),
        createdAt = DateTime.parse(json["created_at"]),
        updatedAt = DateTime.parse(json["updated_at"]);

  static List<TimeSlotModel> fromJsonList(List json) {
    if (json.isNotEmpty) {
      return json.map((e) => TimeSlotModel.fromJson(e)).toList();
    }
    return [];
  }
}
