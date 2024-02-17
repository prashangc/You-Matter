import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:you_matter/core/theme/colors.dart';
import 'package:you_matter/core/theme/textstyle.dart';
import 'package:you_matter/core/utils/button.dart';
import 'package:you_matter/core/utils/my_cached_network_image.dart';
import 'package:you_matter/core/utils/my_custom_appbar.dart';
import 'package:you_matter/core/utils/my_rating_bar.dart';
import 'package:you_matter/core/utils/sizes.dart';
import 'package:you_matter/features/home/presentation/widgets/therapist_timing.dart';

import '../../../../services/firebase/firebase_query_handler.dart';
import '../../controller/therapist_controller.dart';

class TherapistDetailScreen extends StatefulWidget {
  final Map<String, dynamic>? data;
  const TherapistDetailScreen({super.key, required this.data});

  @override
  State<TherapistDetailScreen> createState() => _TherapistDetailScreenState();
}

class _TherapistDetailScreenState extends State<TherapistDetailScreen> {
  Map<String, dynamic> selectedTime = {};

  @override
  Widget build(BuildContext context) {
    String? startTime = selectedTime['startTime'];
    String? endTime = selectedTime['endTime'];
    String? scheduleID = selectedTime['scheduleID'];
    String id = widget.data?['uid'] ?? "";
    return Scaffold(
      backgroundColor: ColorConstant.backgroundColor,
      appBar: const MyCustomAppBar(
        title: "Therapist Details",
      ),
      extendBody: true,
      body: SafeArea(
        child: SizedBox(
          width: maxWidth(context),
          height: maxHeight(context),
          child: Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                therapistDetail(context),
                sizedBox24(),
                TherapistTiming(
                  data: widget.data,
                  onSelect: (selected) {
                    setState(() {
                      selectedTime = selected ?? {};
                    });
                  },
                )
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.symmetric(
            horizontal: maxWidth(context) / 4, vertical: 15.0),
        height: 55,
        child: StreamBuilder(
            stream: therapistController.getAllBookings(
                uid: FirebaseAuth.instance.currentUser!.uid, therapistID: id),
            builder: (context, snapshot) {
              bool isBookedAlready = snapshot.data?.data() != null;
              return snapshot.connectionState == ConnectionState.waiting
                  ? const CircularProgressIndicator()
                  : isBookedAlready
                      ? Center(
                          child: Text(
                          "Already Booked",
                          style: kStyle18B,
                        ))
                      : selectedTime.isEmpty
                          ? const SizedBox.shrink()
                          : myButton(
                              context: context,
                              width: maxWidth(context),
                              height: 50.0,
                              text: 'Book',
                              myTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return StatefulBuilder(
                                        builder: (context, setState) {
                                      return AlertDialog(
                                        title: const Text("Confirmation"),
                                        content: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(startTime ?? "Select Time"),
                                            Text(endTime ?? "Select Date"),
                                          ],
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text("Cancel"),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              if (endTime != null &&
                                                  startTime != null) {
                                                therapistController
                                                    .onTherapistBookingRequest(
                                                        scheduleID: scheduleID,
                                                        startTime: startTime,
                                                        endTime: endTime,
                                                        date: DateFormat(
                                                                "EEEE, MMM d")
                                                            .format(
                                                                DateTime.now()),
                                                        username: FirebaseAuth
                                                            .instance
                                                            .currentUser!
                                                            .displayName!,
                                                        uid: FirebaseAuth
                                                            .instance
                                                            .currentUser!
                                                            .uid,
                                                        therapistID: id);
                                                Navigator.pop(context);
                                              }
                                            },
                                            child: const Text("Request"),
                                          ),
                                        ],
                                      );
                                    });
                                  },
                                );
                              },
                            );
            }),
      ),
    );
  }

  Widget therapistDetail(context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
      width: maxWidth(context),
      color: ColorConstant.kPrimary.withOpacity(0.1),
      child: Column(
        children: [
          myInfo(
              context: context,
              title: "${widget.data?['username']}",
              subtitle: "${widget.data?['email']}",
              image: 'image')
        ],
      ),
    );
  }

  Widget myInfo({
    required context,
    required String title,
    required String subtitle,
    required String image,
  }) {
    return SizedBox(
      width: maxWidth(context),
      child: Row(
        children: [
          myCachedNetworkImageCircle(
            myHeight: 80.0,
            myWidth: 80.0,
            myImage: image,
          ),
          sizedBox24(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                sizedBox12(),
                Text(
                  title,
                  style: kStyle14B.copyWith(),
                ),
                sizedBox8(),
                Text(
                  subtitle,
                  style: kStyle12.copyWith(),
                ),
                sizedBox8(),
                myRatingBar(Random().nextInt(5) + 1, size: 14.0),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
