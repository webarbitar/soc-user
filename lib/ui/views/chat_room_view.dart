import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socspl/core/view_modal/user/user_view_model.dart';
import 'package:timeago/timeago.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/constance/style.dart';
import '../../core/modal/booking/booked_service_details_model.dart';
import '../../core/modal/messsage_model.dart';
import '../shared/ui_helpers.dart';

class ChatRoomView extends StatefulWidget {
  final BookedServiceDetailsModel? data;

  const ChatRoomView({Key? key, this.data}) : super(key: key);

  @override
  State<ChatRoomView> createState() => _ChatRoomViewState();
}

class _ChatRoomViewState extends State<ChatRoomView> {
  final TextEditingController _controller = TextEditingController();
  Query<Map<String, dynamic>>? fcmQuery;
  late String sessionId;

  @override
  void initState() {
    super.initState();
    initChatFireStore();
  }

  void initChatFireStore() {
    sessionId = "booking-${widget.data!.id}-${widget.data!.userId}";
    try {
      // FirebaseFirestore.instance.collection('service-booking/$sessionId/messages').doc().set({});
      fcmQuery = FirebaseFirestore.instance
          .collection('service-booking/$sessionId/messages')
          .orderBy('createdAt', descending: true)
          .limit(20);
    } catch (e, stackTrace) {
      debugPrintStack(stackTrace: stackTrace, label: e.toString());
      print('***');
      print('***');
      print('***');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat"),
        backgroundColor: Colors.white,
        elevation: 0.3,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(12),
            color: highlightColor,
            child: Row(
              children: [
                Container(
                  height: 50,
                  width: 50,
                  decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                  child: const Icon(
                    Icons.person_outline,
                  ),
                ),
                UIHelper.horizontalSpaceMedium,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      UIHelper.verticalSpaceSmall,
                      Text(
                        widget.data?.serviceProvider?.name ?? "Unknown Name",
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          fontFamily: "Montserrat",
                        ),
                      ),
                      UIHelper.verticalSpaceSmall,
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: buildListMsg(),
          ),
          Row(children: <Widget>[
            buildInput(),
          ])
        ],
      ),
    );
  }

  buildInput() {
    const outlineBorder = OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black54),
      borderRadius: BorderRadius.all(
        Radius.circular(50.0),
      ),
    );
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
        child: Theme(
          data: Theme.of(context).copyWith(primaryColor: Colors.white),
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: "Type a message",
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              suffixIcon: GestureDetector(
                onTap: () {
                  FirebaseFirestore.instance
                      .collection('service-booking/$sessionId/messages')
                      .doc()
                      .set({
                    "message": _controller.text,
                    "userType": "user",
                    "createdAt": FieldValue.serverTimestamp(),
                  });
                  _controller.clear();
                },
                child: const Icon(
                  Icons.send_rounded,
                  color: Colors.grey,
                  size: 22,
                ),
              ),
              isDense: true,
              border: outlineBorder,
              focusedBorder: outlineBorder,
              fillColor: Colors.white,
              filled: true,
            ),
          ),
        ),
      ),
    );
  }

  buildListMsg() {
    if (fcmQuery == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(
                Icons.chat,
                color: Colors.blue,
                size: 80,
              ),
              UIHelper.verticalSpaceSmall,
              Text(
                "Introducing chat",
                style: TextStyle(
                  fontFamily: "Montserrat",
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              UIHelper.verticalSpaceSmall,
              Text(
                "Keep your account safe. Never share personal or account information in this chat including phone numbers, pin and passcodes",
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    fontFamily: "Montserrat",
                    height: 1.4),
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      );
    }
    return StreamBuilder(
      stream: fcmQuery!.snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (!snapshot.hasData) {
          return SizedBox(
            height: MediaQuery.of(context).size.height,
            child: const Center(
              child: CircularProgressIndicator(
                color: Colors.red,
              ),
            ),
          );
        } else {
          var listMsg = snapshot.data?.docs ?? [];
          if (listMsg.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(
                      Icons.chat,
                      color: Colors.blue,
                      size: 80,
                    ),
                    UIHelper.verticalSpaceSmall,
                    Text(
                      "Introducing chat",
                      style: TextStyle(
                        fontFamily: "Montserrat",
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    UIHelper.verticalSpaceSmall,
                    Text(
                      "Keep your account safe. Never share personal or account information in this chat including phone numbers, pin and passcodes",
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          fontFamily: "Montserrat",
                          height: 1.4),
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(10.0),
            itemCount: snapshot.data!.docs.length,
            reverse: true,
            itemBuilder: (BuildContext context, int index) {
              print(snapshot.data!.docs[index].get('message'));
              return msgItem(
                index,
                MessageModel(
                  message: snapshot.data!.docs[index].get('message'),
                  userType: snapshot.data!.docs[index].get('userType'),
                  createdAt: snapshot.data!.docs[index].get('createdAt'),
                ),
              );
            },
          );
        }
      },
    );
  }

  msgItem(int index, MessageModel data) {
    return Container(
      padding: const EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
      child: Align(
        alignment: (data.userType == "user" ? Alignment.topRight : Alignment.topLeft),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: (data.userType == "user" ? Colors.blue[200] : Colors.grey.shade200),
              ),
              padding: const EdgeInsets.all(16),
              child: Text(
                data.message,
                style: const TextStyle(fontSize: 15),
              ),
            ),
            // Text(
            //   format(
            //     DateTime.fromMillisecondsSinceEpoch(data.createdAt.millisecondsSinceEpoch),
            //   ),
            //   style: const TextStyle(
            //     fontSize: 11,fontFamily: "Montserrat",
            //     fontWeight: FontWeight.w400,
            //   ),
            // )
          ],
        ),
      ),
    );
    //
    // return Container(
    //   alignment: Alignment.centerRight,
    //   margin: EdgeInsets.only(
    //     right: 1,
    //     top: 5,
    //     bottom: 5,
    //   ),
    //   decoration: BoxDecoration(
    //       color: Colors.white,
    //       border: Border.all(
    //         color: Colors.white,
    //       ),
    //       borderRadius: BorderRadius.all(Radius.circular(5))),
    //   child: Column(
    //     mainAxisAlignment: MainAxisAlignment.end,
    //     children: [
    //       Text(
    //         '${data.message}',
    //       ),
    //       Text(
    //         '${data.time}',
    //       ),
    //     ],
    //   ),
    // );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
