import 'dart:math';

import 'package:flutter/material.dart';
import 'package:you_matter/core/route/route.dart';
import 'package:you_matter/core/theme/colors.dart';
import 'package:you_matter/core/theme/textstyle.dart';
import 'package:you_matter/core/utils/grid_view_delegate.dart';
import 'package:you_matter/core/utils/my_cached_network_image.dart';
import 'package:you_matter/core/utils/my_rating_bar.dart';
import 'package:you_matter/core/utils/sizes.dart';
import 'package:you_matter/features/home/presentation/widgets/therapist_details.dart';
import 'package:you_matter/services/firebase/firebase_query_handler.dart';

Widget therapistCard(context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Find Therapist',
          style: kStyle14B,
        ),
        sizedBox16(),
        StreamBuilder(
            stream: FirebaseQueryHelper.getCollectionsAsStream(
                collectionPath: "users"),
            builder: (context, snapshot) {
              final therapist = snapshot.data?.docs
                  .where((element) => element.data()['isTherapist'] == true);
              return snapshot.connectionState == ConnectionState.waiting
                  ? const Center(child: CircularProgressIndicator())
                  : GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
                              crossAxisCount: 2,
                              height: 200,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10),
                      itemCount: therapist?.length,
                      itemBuilder: (BuildContext ctx, index) {
                        final item = snapshot.data?.docs[index].data();
                        String? url = item?['photoUrl'];
                        String? id = item?['uid'];
                        return GestureDetector(
                          onTap: () {
                            pushTo(
                                context: context,
                                screen: TherapistDetailScreen(data: item));
                          },
                          child: Container(
                            width: maxWidth(context),
                            decoration: BoxDecoration(
                                color: ColorConstant.kWhite,
                                boxShadow: [
                                  BoxShadow(
                                      color: ColorConstant.kGrey,
                                      offset: const Offset(3, 3))
                                ],
                                borderRadius: BorderRadius.circular(15)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: myCachedNetworkImage(
                                    myWidth: maxWidth(context),
                                    myHeight: maxHeight(context),
                                    myImage: '',
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(12.0),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 5.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${item?['username']}",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: kStyle14B,
                                      ),
                                      myRatingBar(Random().nextInt(5) + 1,
                                          size: 12.0),
                                      sizedBox2(),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.email_outlined,
                                            size: 12.0,
                                          ),
                                          const SizedBox(
                                            width: 5.0,
                                          ),
                                          Flexible(
                                            child: Text(
                                              "${item?['email']}",
                                              overflow: TextOverflow.ellipsis,
                                              style: kStyle12B.copyWith(
                                                color: ColorConstant.kBlue,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      // StreamBuilder(
                                      //     stream:
                                      //         therapistController.getAllBookings(
                                      //             uid: FirebaseAuth
                                      //                 .instance.currentUser!.uid,
                                      //             therapistID: id!),
                                      //     builder: (context, snapshot) {
                                      //       bool isBookedAlready =
                                      //           snapshot.data?.data() != null;
                                      //       return TextButton(
                                      //         onPressed: isBookedAlready
                                      //             ? () {}
                                      //             : () {
                                      //                 showDialog(
                                      //                   context: context,
                                      //                   builder: (context) {
                                      //                     return StatefulBuilder(
                                      //                         builder: (context,
                                      //                             setState) {
                                      //                       return AlertDialog(
                                      //                         title: const Text(
                                      //                             "Select date and time"),
                                      //                         content: Column(
                                      //                           crossAxisAlignment:
                                      //                               CrossAxisAlignment
                                      //                                   .start,
                                      //                           mainAxisSize:
                                      //                               MainAxisSize
                                      //                                   .min,
                                      //                           children: [
                                      //                             InkWell(
                                      //                               onTap:
                                      //                                   () async {
                                      //                                 selectedTime =
                                      //                                     null;
                                      //                                 setState(
                                      //                                     () {});
                                      //                                 final time = await showTimePicker(
                                      //                                     context:
                                      //                                         context,
                                      //                                     initialTime:
                                      //                                         TimeOfDay
                                      //                                             .now());
                                      //                                 selectedTime =
                                      //                                     time?.format(
                                      //                                         context);
                                      //                                 setState(
                                      //                                     () {});
                                      //                               },
                                      //                               child: Text(
                                      //                                   selectedTime ??
                                      //                                       "Select Time"),
                                      //                             ),
                                      //                             InkWell(
                                      //                               onTap:
                                      //                                   () async {
                                      //                                 selectedDate =
                                      //                                     null;
                                      //                                 final date = await showDatePicker(
                                      //                                     context:
                                      //                                         context,
                                      //                                     firstDate: DateTime
                                      //                                             .now()
                                      //                                         .subtract(const Duration(
                                      //                                             days:
                                      //                                                 1)),
                                      //                                     lastDate: DateTime
                                      //                                             .now()
                                      //                                         .add(const Duration(
                                      //                                             days: 2)));
                                      //                                 setState(() {
                                      //                                   selectedDate = DateFormat(
                                      //                                           "EEEE, MMM d")
                                      //                                       .format(
                                      //                                           date!);
                                      //                                 });
                                      //                               },
                                      //                               child: Text(
                                      //                                   selectedDate ??
                                      //                                       "Select Date"),
                                      //                             ),
                                      //                           ],
                                      //                         ),
                                      //                         actions: [
                                      //                           TextButton(
                                      //                             onPressed: () {
                                      //                               Navigator.pop(
                                      //                                   context);
                                      //                               selectedTime =
                                      //                                   null;
                                      //                               selectedDate =
                                      //                                   null;
                                      //                               setState(() {});
                                      //                             },
                                      //                             child: const Text(
                                      //                                 "Cancel"),
                                      //                           ),
                                      //                           TextButton(
                                      //                             onPressed:
                                      //                                 () async {
                                      //                               if (selectedDate !=
                                      //                                       null &&
                                      //                                   selectedTime !=
                                      //                                       null) {
                                      //                                 await therapistController
                                      //                                     .onTherapistBookingRequest(
                                      //                                         time:
                                      //                                             selectedTime!,
                                      //                                         date:
                                      //                                             selectedDate!,
                                      //                                         username: FirebaseAuth
                                      //                                             .instance
                                      //                                             .currentUser!
                                      //                                             .displayName!,
                                      //                                         uid: FirebaseAuth
                                      //                                             .instance
                                      //                                             .currentUser!
                                      //                                             .uid,
                                      //                                         therapistID:
                                      //                                             id)
                                      //                                     .then((value) =>
                                      //                                         Navigator.pop(
                                      //                                             context));
                                      //                               }
                                      //                             },
                                      //                             child: const Text(
                                      //                                 "Request"),
                                      //                           ),
                                      //                         ],
                                      //                       );
                                      //                     });
                                      //                   },
                                      //                 );
                                      //               },
                                      //         child: StreamBuilder(
                                      //             stream: therapistController
                                      //                 .getAllBookings(
                                      //                     uid: FirebaseAuth.instance
                                      //                         .currentUser!.uid,
                                      //                     therapistID: id),
                                      //             builder: (context, snapshot) {
                                      //               bool isBookedAlready =
                                      //                   snapshot.data?.data() !=
                                      //                       null;
                                      //               return isBookedAlready
                                      //                   ? Text("Booked",
                                      //                       style: kStyle18)
                                      //                   : const Text("Book");
                                      //             }),
                                      //       );
                                      //     }),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      });
            }),
      ],
    ),
  );
}
