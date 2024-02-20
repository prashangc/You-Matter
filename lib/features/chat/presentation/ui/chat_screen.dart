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
import 'package:collection/collection.dart';
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
  final TextEditingController textEditingController = TextEditingController();
  String? myID = FirebaseAuth.instance.currentUser!.uid;
  @override
  void initState() {
    super.initState();
  }

  void remove(String chatID) async {}

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
              .collection('chats')
              .snapshots(),
          builder: (context, snapshot) {
            final bookings = snapshot.data?.docs.where((element) {
              bool containsMyID = (widget.isTherapist
                  ? (element.id.split(":").first == myID)
                  : (element.id.split(":").last == myID));

              bool isToday = element.data()['date'] ==
                  DateFormat("EEEE, MMM d").format(DateTime.now());
              return containsMyID && isToday;
            }).toList();
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              int? indexOfLatestBooking;
              Map<String, dynamic>? latestBooking;
              Map<String, dynamic>? chatWith;

              if (bookings == null || bookings.isEmpty) {
              } else {
                indexOfLatestBooking = findClosestTimeIndex(
                    bookings.map((e) => "${e.data()['startTime']}").toList());
                latestBooking =
                    bookings.elementAtOrNull(indexOfLatestBooking)?.data();
                final participants =
                    latestBooking?['participants'] as List<dynamic>;
                chatWith = participants
                        .firstWhereOrNull((element) => element['uid'] != myID)
                    as Map<String, dynamic>?;
              }
              String? endTime = latestBooking?['endTime'];
              final current = DateTime(
                  DateTime.now().year,
                  DateTime.now().month,
                  DateTime.now().day,
                  DateTime.now().hour,
                  DateTime.now().minute);
              bool appointMentEnds = endTime != null
                  ? current.isAfter(parseTimeString(endTime))
                  : true;
              // return Text(
              //     "$current::::${parseTimeString(endTime!)}:::${current.isAfter(parseTimeString(endTime))}");
              // return Text(
              //     "${endTime != null ? current.isAfter(parseTimeString(endTime)) : "DSDSDS"}");
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
                            appointMentEnds
                                ? const Center(
                                    child:
                                        Text("No appointments at the moment!!"),
                                  )
                                : Positioned(
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
                                            : therapistDetails(context,
                                                name:
                                                    "${chatWith?['username']}",
                                                email: "${chatWith?['email']}",
                                                booking: latestBooking),
                                        sizedBox16(),
                                        chatPage(context, latestBooking,
                                            textEditingController),
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
