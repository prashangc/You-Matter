import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:you_matter/core/theme/colors.dart';
import 'package:you_matter/core/theme/textstyle.dart';
import 'package:you_matter/core/utils/sizes.dart';

import '../../../../core/utils/time_utils.dart';
import '../../../../services/firebase/firebase_query_handler.dart';

Widget therapistDetails(
  context, {
  String? name,
  String? email,
  String? imageUrl,
  required Map<String, dynamic> booking,
}) {
  String? startTime = booking['startTime'];
  String? endTime = booking['endTime'];
  bool isBetween = isTimeInRange(startTime, endTime);
  bool isBefore = isBeforeStartTime(startTime);
  bool isAfter = isAfterEndTime(endTime);
  return Container(
    padding: const EdgeInsets.all(12.0),
    decoration: BoxDecoration(
      color: ColorConstant.kWhite,
      boxShadow: [
        BoxShadow(color: ColorConstant.kGrey, offset: const Offset(3, 3))
      ],
      borderRadius: const BorderRadius.all(
        Radius.circular(30.0),
      ),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CircleAvatar(
          radius: 25,
          backgroundImage: AssetImage("assets/images/profile.png"),
        ),
        sizedBox16(),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name ?? "User",
                style: kStyle14B,
              ),
              Text(
                email ?? "N/A",
                style: kStyle12,
              ),
              Text(
                "Status: ${isBefore ? "Not Started yet" : isBetween ? "Active" : isAfter ? "End" : "--"}",
                style: kStyle12,
              ),
              StreamBuilder(
                  stream: FirebaseQueryHelper.firebaseFireStore
                      .collection('typing')
                      .doc("${booking['id']}")
                      .snapshots(),
                  builder: (context, snapshot) {
                    bool isTyping = snapshot.data?.data()?['isTyping'] == true;
                    bool isSender = snapshot.data?.data()?['senderID'] !=
                        FirebaseAuth.instance.currentUser?.uid;
                    bool isOurChat =
                        booking['id'] == snapshot.data?.data()?['chatID'];
                    return isTyping && isSender && isOurChat
                        ? const Text(
                            "Typing....",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.red,
                            ),
                          )
                        : const SizedBox.shrink();
                  }),
            ],
          ),
        ),
      ],
    ),
  );
}
