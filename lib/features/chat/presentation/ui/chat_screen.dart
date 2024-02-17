import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:you_matter/core/theme/colors.dart';
import 'package:you_matter/core/utils/info_card.dart';
import 'package:you_matter/core/utils/sizes.dart';
import 'package:you_matter/core/utils/time_utils.dart';
import 'package:you_matter/features/chat/presentation/widget/chat_app_bar.dart';
import 'package:you_matter/features/chat/presentation/widget/chat_page.dart';
import 'package:you_matter/features/chat/presentation/widget/therapist_details.dart';

import '../../../../services/firebase/firebase_query_handler.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;
  final bool isTherapist;
  const ChatScreen({Key? key, required this.chatId, required this.isTherapist})
      : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textEditingController = TextEditingController();

  void _sendMessage() {
    String messageText = _textEditingController.text.trim();
    if (messageText.isNotEmpty) {
      FirebaseFirestore.instance
          .collection('chats')
          .doc(widget.chatId)
          .collection('messages')
          .add({
        'text': messageText,
        'createdAt': Timestamp.now(),
        // Add other fields like senderId, senderName, etc. if needed
      });
      _textEditingController.clear();
    }
  }

  String? myID = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: ColorConstant.kPrimary,
        automaticallyImplyLeading: false,
        toolbarHeight: 0.0,
      ),
      backgroundColor: ColorConstant.backgroundColor,
      body: StreamBuilder(
          stream: FirebaseQueryHelper.firebaseFireStore
              .collection('bookings')
              .snapshots(),
          builder: (context, snapshot) {
            final bookings = snapshot.data?.docs.where((element) {
              bool containsMyID = (widget.isTherapist
                  ? (element.id.split(":").first == myID)
                  : (element.id.split(":").last == myID));

              // bool isToday = element.data()['date'] ==
              //     DateFormat("EEEE, MMM d").format(DateTime.now());
              return containsMyID && true;
            }).toList();
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              int? indexOfLatestBooking;
              Map<String, dynamic>? latestBooking;
              if (bookings == null || bookings.isEmpty) {
              } else {
                indexOfLatestBooking = findClosestTimeIndex(
                    bookings.map((e) => "${e.data()['startTime']}").toList() ??
                        []);
                latestBooking =
                    bookings.elementAtOrNull(indexOfLatestBooking)?.data();
              }

              // return Text("${latestBooking?.length}");
              return SizedBox(
                  width: maxWidth(context),
                  height: maxHeight(context),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      chatAppBar(),
                      Expanded(
                        child: Stack(
                          children: [
                            Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      color: ColorConstant.kPrimary,
                                      borderRadius: const BorderRadius.only(
                                        bottomLeft: Radius.circular(20.0),
                                        bottomRight: Radius.circular(20.0),
                                      )),
                                  width: maxWidth(context),
                                  height: 50.0,
                                ),
                                Expanded(
                                  child: Container(
                                    width: maxWidth(context),
                                  ),
                                ),
                              ],
                            ),
                            Positioned(
                              top: 25.0,
                              bottom: 25.0,
                              left: 20.0,
                              right: 20.0,
                              child: Column(
                                children: [
                                  latestBooking == null
                                      ? infoCard(
                                          context: context,
                                          text:
                                              'Please book a therapist to consult via chat messages.')
                                      : therapistDetails(
                                          context,
                                          name:
                                              "${widget.isTherapist ? latestBooking['patient']['username'] : latestBooking['therapist']['username']}",
                                          email:
                                              "${widget.isTherapist ? latestBooking['patient']['email'] : latestBooking['therapist']['email']}",
                                        ),
                                  sizedBox16(),
                                  chatPage(context),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ));
            }
          }),
    );
  }
}
