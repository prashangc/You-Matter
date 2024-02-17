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
                  child: timesnapshot.connectionState == ConnectionState.waiting
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : filteredTime != null && filteredTime.isNotEmpty
                          ? Wrap(
                              direction: Axis.horizontal,
                              alignment: WrapAlignment.start,
                              spacing: 10.0,
                              runSpacing: 10.0,
                              children: List.generate(
                                filteredTime.length,
                                (index) {
                                  final time = filteredTime[index]
                                      as Map<String, dynamic>;
                                  String? startTime = time['startTime'];
                                  String? endTime = time['endTime'];
                                  String? scheduleID = time['scheduleID'];
                                  bool isBooked = time['isBooked'] ?? false;
                                  return Container(
                                    width: maxWidth(context) / 2,
                                    decoration: BoxDecoration(
                                      color: ColorConstant.kWhite,
                                      boxShadow: [
                                        BoxShadow(
                                            color: ColorConstant.kGrey,
                                            offset: const Offset(3, 3))
                                      ],
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(30.0),
                                      ),
                                    ),
                                    child: StreamBuilder(
                                        stream:
                                            therapistController.getAllBookings(
                                                uid: FirebaseAuth
                                                    .instance.currentUser!.uid,
                                                therapistID: id!),
                                        builder: (context, bookingsnapshot) {
                                          bool isBookedAlready =
                                              bookingsnapshot.data?.data() !=
                                                  null;
                                          return bookingsnapshot
                                                      .connectionState ==
                                                  ConnectionState.waiting
                                              ? const CircularProgressIndicator()
                                              : Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      vertical: 12.0),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                          "${time['startTime']}-${time['endTime']}"),
                                                      isBookedAlready
                                                          ? Container()
                                                          : Container(
                                                              color: Colors.red,
                                                              child: Checkbox(
                                                                  visualDensity:
                                                                      const VisualDensity(
                                                                          horizontal:
                                                                              -4),
                                                                  value: selectedTime[
                                                                          'scheduleID'] ==
                                                                      scheduleID,
                                                                  onChanged:
                                                                      (value) {
                                                                    widget.onSelect(selectedTime =
                                                                        value ==
                                                                                true
                                                                            ? time
                                                                            : {});
                                                                    setState(
                                                                        () {
                                                                      selectedTime = value ==
                                                                              true
                                                                          ? time
                                                                          : {};
                                                                    });
                                                                  }),
                                                            ),
                                                    ],
                                                  ),
                                                );
                                        }),
                                  );
                                },
                              ),
                            )
                          // SizedBox(
                          //     child: ListView.builder(
                          //       shrinkWrap: true,
                          //       // scrollDirection: Axis.horizontal,
                          //       itemCount: filteredTime.length,
                          //       itemBuilder: (context, index) {
                          //         final time = filteredTime[index]
                          //             as Map<String, dynamic>;
                          //         String? startTime = time['startTime'];
                          //         String? endTime = time['endTime'];
                          //         String? scheduleID = time['scheduleID'];
                          //         return StreamBuilder(
                          //             stream:
                          //                 therapistController.getAllBookings(
                          //                     uid: FirebaseAuth
                          //                         .instance.currentUser!.uid,
                          //                     therapistID: id!),
                          //             builder: (context, bookingsnapshot) {
                          //               bool isBookedAlready =
                          //                   bookingsnapshot.data?.data() !=
                          //                       null;
                          //               return bookingsnapshot
                          //                           .connectionState ==
                          //                       ConnectionState.waiting
                          //                   ? const CircularProgressIndicator()
                          //                   : ListTile(
                          //                       leading: isBookedAlready
                          //                           ? null
                          //                           : Checkbox(
                          //                               value: selectedTime[
                          //                                       'scheduleID'] ==
                          //                                   scheduleID,
                          //                               onChanged: (value) {
                          //                                 widget.onSelect(
                          //                                     selectedTime =
                          //                                         value == true
                          //                                             ? time
                          //                                             : {});
                          //                                 setState(() {
                          //                                   selectedTime =
                          //                                       value == true
                          //                                           ? time
                          //                                           : {};
                          //                                 });
                          //                               }),
                          //                       title: Text(
                          //                         "${time['startTime']}-${time['endTime']}",
                          //                       ),
                          //                     );
                          //             });
                          //       },
                          //     ),
                          //   )

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
