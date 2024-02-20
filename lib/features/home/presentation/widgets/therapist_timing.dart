import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:you_matter/core/theme/colors.dart';
import 'package:you_matter/core/theme/textstyle.dart';
import 'package:you_matter/core/utils/my_empty_card.dart';
import 'package:you_matter/core/utils/my_snackbar.dart';
import 'package:you_matter/core/utils/sizes.dart';
import 'package:you_matter/features/home/controller/therapist_controller.dart';
import 'package:you_matter/services/firebase/firebase_query_handler.dart';

class TherapistTiming extends StatefulWidget {
  final Map<String, dynamic>? data;
  final Function(Map<String, dynamic>? selected) onSelect;
  const TherapistTiming({super.key, this.data, required this.onSelect});

  @override
  State<TherapistTiming> createState() => _TherapistTimingState();
}

class _TherapistTimingState extends State<TherapistTiming> {
  Map<String, dynamic>? get data => widget.data;
  Map<String, dynamic> selectedTime = {};
  String? myScheduleID;
  @override
  Widget build(BuildContext context) {
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
              builder: (context, timesnapshot) {
                final times =
                    timesnapshot.data?.data()?['times'] as List<dynamic>?;
                final filteredTime = times?.where((element) {
                  final item = element as Map<String, dynamic>;
                  bool isToday = item['createdOn'] ==
                      DateFormat("EEEE, MMM d").format(DateTime.now());
                  return isToday;
                }).toList();
                return Container(
                    child: timesnapshot.connectionState ==
                            ConnectionState.waiting
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : filteredTime != null && filteredTime.isNotEmpty
                            ? SizedBox(
                                height: 50.0,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  padding: EdgeInsets.zero,
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: filteredTime.length,
                                  itemBuilder: (c, index) {
                                    final time = filteredTime[index]
                                        as Map<String, dynamic>;
                                    String? startTime = time['startTime'];
                                    String? endTime = time['endTime'];
                                    String? scheduleID = time['scheduleID'];
                                    bool isBooked = time['isBooked'] ?? false;
                                    return GestureDetector(
                                      onTap: () {
                                        if (isBooked) {
                                          mySnackbar.mySnackBarBtn(
                                              bgColor: ColorConstant.kRed,
                                              text: 'Timing occupied',
                                              context: context);
                                        } else {
                                          widget.onSelect(selectedTime = time);
                                          setState(() {
                                            selectedTime = time;
                                            myScheduleID = scheduleID;
                                          });
                                        }
                                      },
                                      child: Container(
                                        margin:
                                            const EdgeInsets.only(right: 12.0),
                                        decoration: BoxDecoration(
                                            color: isBooked
                                                ? ColorConstant.kError
                                                    .withOpacity(0.8)
                                                : ColorConstant.kWhite,
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(30.0),
                                            ),
                                            border: Border.all(
                                                width: 1.0,
                                                color:
                                                    myScheduleID == scheduleID
                                                        ? ColorConstant.kPrimary
                                                        : ColorConstant
                                                            .kTransparent)),
                                        child: StreamBuilder(
                                            stream: therapistController
                                                .getAllBookings(
                                                    uid: FirebaseAuth.instance
                                                        .currentUser!.uid,
                                                    therapistID: id!),
                                            builder:
                                                (context, bookingsnapshot) {
                                              bool isBookedAlready =
                                                  bookingsnapshot.data
                                                          ?.data() !=
                                                      null;
                                              return bookingsnapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting
                                                  ? const CircularProgressIndicator()
                                                  : Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 12.0,
                                                          horizontal: 12.0),
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            "${time['startTime']} - ${time['endTime']}",
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                          // isBookedAlready
                                                          //     ? Container()
                                                          //     : Container(
                                                          //         margin:
                                                          //             const EdgeInsets
                                                          //                 .only(
                                                          //                 left:
                                                          //                     12.0),
                                                          //         child: Checkbox(
                                                          //             visualDensity:
                                                          //                 const VisualDensity(
                                                          //                     horizontal:
                                                          //                         -4),
                                                          //             value: selectedTime[
                                                          //                     'scheduleID'] ==
                                                          //                 scheduleID,
                                                          //             onChanged:
                                                          //                 (value) {
                                                          //               widget.onSelect(selectedTime =
                                                          //                   value ==
                                                          //                           true
                                                          //                       ? time
                                                          //                       : {});
                                                          //               setState(
                                                          //                   () {
                                                          //                 selectedTime = value ==
                                                          //                         true
                                                          //                     ? time
                                                          //                     : {};
                                                          //               });
                                                          //             }),
                                                          //       ),
                                                        ],
                                                      ),
                                                    );
                                            }),
                                      ),
                                    );
                                  },
                                ),
                              )
                            : myEmptyCard(
                                context: context,
                                emptyMsg: "No timings",
                                subTitle:
                                    "Dr. ${widget.data?['username']} haven't set any schedule",
                              ));
              })
        ],
      ),
    );
  }
}
