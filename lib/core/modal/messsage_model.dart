import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  String message;
  String userType;
  Timestamp? createdAt;

  MessageModel({required this.message, required this.userType, required this.createdAt});

  MessageModel.fromJson(Map<String, dynamic> data)
      : message = data["message"],
        userType = data["userType"],
        createdAt = data["createdAt"];

  Map<String, dynamic> toMap() {
    return {
      "message": message,
      "userType": userType,
      "createdAt": createdAt,
    };
  }
}
