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

import '../../../../services/firebase/firebase_query_handler.dart';
import '../../controller/therapist_controller.dart';

class TherapistDetailScreen extends StatelessWidget {
  final Map<String, dynamic>? data;
  const TherapistDetailScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
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
                therapistTimings(context),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.symmetric(
            horizontal: maxWidth(context) / 4, vertical: 15.0),
        height: 55,
        child: myButton(
          context: context,
          width: maxWidth(context),
          height: 50.0,
          text: 'Book',
          myTap: () {},
        ),
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
              title: "${data?['username']}",
              subtitle: "${data?['email']}",
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

  Widget therapistTimings(
    context,
  ) {
    String? id = data?['uid'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Schedule Timings :',
            style: kStyle14B,
          ),
          sizedBox16(),
          StreamBuilder(
              stream: FirebaseQueryHelper.firebaseFireStore
                  .collection('time')
                  .doc(data?['uid'])
                  .snapshots(),
              builder: (context, snapshot) {
                final times = snapshot.data?.data()?['times'] as List<dynamic>?;
                final filteredTime = times?.where((element) {
                  final item = element as Map<String, dynamic>;
                  bool isToday = item['createdOn'] ==
                      DateFormat("EEEE, MMM d").format(DateTime.now());
                  return isToday;
                }).toList();
                return Container(
                  child: snapshot.connectionState == ConnectionState.waiting
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : filteredTime != null && filteredTime.isNotEmpty
                          ? ListView.builder(
                              shrinkWrap: true,
                              itemCount: filteredTime.length,
                              itemBuilder: (context, index) {
                                final time = filteredTime[index];
                                String? startTime = time['startTime'];
                                String? endTime = time['endTime'];
                                String? scheduleID = time['scheduleID'];
                                return ListTile(
                                  leading: const Icon(Icons.schedule_rounded),
                                  title: Text(
                                    "${time['startTime']}-${time['endTime']}",
                                  ),
                                  trailing: StreamBuilder(
                                      stream:
                                          therapistController.getAllBookings(
                                              uid: FirebaseAuth
                                                  .instance.currentUser!.uid,
                                              therapistID: id!),
                                      builder: (context, snapshot) {
                                        bool isBookedAlready =
                                            snapshot.data?.data() != null;
                                        return snapshot.connectionState ==
                                                ConnectionState.waiting
                                            ? const CircularProgressIndicator()
                                            : TextButton(
                                                onPressed: isBookedAlready
                                                    ? () {}
                                                    : () {
                                                        showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return StatefulBuilder(
                                                                builder: (context,
                                                                    setState) {
                                                              return AlertDialog(
                                                                title: const Text(
                                                                    "Confirmation"),
                                                                content: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: [
                                                                    InkWell(
                                                                      onTap:
                                                                          () async {
                                                                        startTime =
                                                                            null;
                                                                        setState(
                                                                            () {});
                                                                        final time = await showTimePicker(
                                                                            context:
                                                                                context,
                                                                            initialTime:
                                                                                TimeOfDay.now());
                                                                        startTime =
                                                                            time?.format(context);
                                                                        setState(
                                                                            () {});
                                                                      },
                                                                      child: Text(
                                                                          startTime ??
                                                                              "Select Time"),
                                                                    ),
                                                                    InkWell(
                                                                      onTap:
                                                                          () async {
                                                                        endTime =
                                                                            null;
                                                                        final date = await showDatePicker(
                                                                            context:
                                                                                context,
                                                                            firstDate:
                                                                                DateTime.now().subtract(const Duration(days: 1)),
                                                                            lastDate: DateTime.now().add(const Duration(days: 2)));
                                                                        setState(
                                                                            () {
                                                                          endTime =
                                                                              DateFormat("EEEE, MMM d").format(date!);
                                                                        });
                                                                      },
                                                                      child: Text(
                                                                          endTime ??
                                                                              "Select Date"),
                                                                    ),
                                                                  ],
                                                                ),
                                                                actions: [
                                                                  TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.pop(
                                                                          context);
                                                                      startTime =
                                                                          null;
                                                                      endTime =
                                                                          null;
                                                                      setState(
                                                                          () {});
                                                                    },
                                                                    child: const Text(
                                                                        "Cancel"),
                                                                  ),
                                                                  TextButton(
                                                                    onPressed:
                                                                        () async {
                                                                      if (endTime !=
                                                                              null &&
                                                                          startTime !=
                                                                              null) {
                                                                        therapistController.onTherapistBookingRequest(
                                                                            scheduleID:
                                                                                scheduleID,
                                                                            startTime:
                                                                                startTime!,
                                                                            endTime:
                                                                                endTime!,
                                                                            username:
                                                                                FirebaseAuth.instance.currentUser!.displayName!,
                                                                            uid: FirebaseAuth.instance.currentUser!.uid,
                                                                            therapistID: id);
                                                                        Navigator.pop(
                                                                            context);
                                                                      }
                                                                    },
                                                                    child: const Text(
                                                                        "Request"),
                                                                  ),
                                                                ],
                                                              );
                                                            });
                                                          },
                                                        );
                                                      },
                                                child: StreamBuilder(
                                                    stream: therapistController
                                                        .getAllBookings(
                                                            uid: FirebaseAuth
                                                                .instance
                                                                .currentUser!
                                                                .uid,
                                                            therapistID: id),
                                                    builder:
                                                        (context, snapshot) {
                                                      bool isBookedAlready = snapshot
                                                                  .data
                                                                  ?.data() !=
                                                              null &&
                                                          snapshot.data
                                                                      ?.data()?[
                                                                  'scheduleID'] ==
                                                              scheduleID;
                                                      return isBookedAlready
                                                          ? Text("Booked",
                                                              style: kStyle18)
                                                          : const SizedBox
                                                              .shrink();
                                                    }),
                                              );
                                      }),
                                );
                              },
                            )
                          : const Center(
                              child: Text("No Times"),
                            ),
                );
              })
        ],
      ),
    );
  }
}
