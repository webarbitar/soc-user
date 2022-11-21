import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  int bookingId;
  int senderId;
  int receiverId;
  String message;
  String userType;
  bool read;
  bool delivered;
  String messageBy;
  Timestamp? createdAt;

  MessageModel(
      {required this.bookingId,
      required this.senderId,
      required this.receiverId,
      this.read = false,
      this.delivered = false,
      required this.messageBy,
      required this.message,
      required this.userType,
      required this.createdAt});

  MessageModel.fromJson(Map<String, dynamic> data)
      : bookingId = data["bookingId"],
        senderId = data["senderId"],
        receiverId = data["receiverId"],
        read = data["read"],
        delivered = data["delivered"],
        messageBy = data["messageBy"],
        message = data["message"],
        userType = data["userType"],
        createdAt = data["createdAt"];

  static List<MessageModel> parseFCMList(List<QueryDocumentSnapshot<Map<String, dynamic>>> json) {
    if (json.isNotEmpty) {
      return json.map((data) => MessageModel.fromJson(data.data())).toList();
    }
    return [];
  }

  Map<String, dynamic> toMap() {
    return {
      "message": message,
      "userType": userType,
      "createdAt": createdAt,
    };
  }

// "bookingId": widget.data!.id,
// "senderId": widget.data!.userId,
// "receiverId": widget.data!.serviceProviderId,
// "message": _controller.text,
// "userType": "user",
// 'read': false,
// "messageBy": "New Message",
// "createdAt": FieldValue.serverTimestamp()
}
