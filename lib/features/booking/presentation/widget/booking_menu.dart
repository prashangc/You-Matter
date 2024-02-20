import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:you_matter/core/theme/colors.dart';
import 'package:you_matter/core/theme/textstyle.dart';
import 'package:you_matter/core/utils/my_cached_network_image.dart';
import 'package:you_matter/core/utils/sizes.dart';
import 'package:you_matter/services/firebase/firebase_query_handler.dart';
import 'package:you_matter/services/state/state_bloc.dart';

Widget bookingMenu(context, StateHandlerBloc lengthBloc) {
  return Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      decoration: BoxDecoration(
        color: ColorConstant.kWhite,
        boxShadow: [
          BoxShadow(color: ColorConstant.kGrey, offset: const Offset(3, 3))
        ],
        borderRadius: const BorderRadius.all(
          Radius.circular(30.0),
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        physics: const BouncingScrollPhysics(),
        child: StreamBuilder(
            stream: FirebaseQueryHelper.firebaseFireStore
                .collection('bookings')
                .snapshots(),
            builder: (context, snapshot) {
              final bookings = snapshot.data?.docs
                  .where((element) =>
                      element.id.split(":").last ==
                      FirebaseAuth.instance.currentUser!.uid)
                  .toList();
              if (bookings != null) {
                lengthBloc.storeData(data: bookings.length);
              }

              return ListView.builder(
                  itemCount: bookings?.length ?? 0,
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(bottom: 12.0),
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (ctx, index) {
                    final booking = bookings?[index].data();
                    final requestedOn = booking?['requestedOn'] as Timestamp;
                    final patientID = booking?['patientId'] as String;
                    final status = booking?['status'] as String;
                    bool isRejected = status == "rejected";
                    bool isAccepted = status == "accepted";
                    bool isPending = status == "pending";
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12.0),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: ColorConstant.kGrey,
                              offset: const Offset(3, 3))
                        ],
                        color: ColorConstant.kWhite,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(8.0),
                        ),
                      ),
                      width: maxWidth(context),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          sizedBox8(),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Booking Date :',
                                      style: kStyle14,
                                    ),
                                    Text(
                                      DateFormat("EEEE, MMM d")
                                          .format(requestedOn.toDate()),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: kStyle14B,
                                    ),
                                  ],
                                ),
                                sizedBox2(),
                              ],
                            ),
                          ),
                          sizedBox2(),
                          sizedBox2(),
                          Divider(
                            color: ColorConstant.backgroundColor,
                          ),
                          sizedBox2(),
                          sizedBox2(),
                          Container(
                            margin: const EdgeInsets.only(bottom: 12.0),
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                myCachedNetworkImageCircle(
                                  myHeight: 60.0,
                                  myWidth: 60.0,
                                  myImage: '',
                                ),
                                const SizedBox(width: 12.0),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          "${booking?['therapist']['username']}",
                                          maxLines: 2,
                                          style: kStyle14B),
                                      sizedBox2(),
                                      sizedBox2(),
                                      Row(
                                        children: [
                                          Text(
                                            'Time :',
                                            style: kStyle12,
                                          ),
                                          Text(
                                            ' ${booking?['startTime']} - ${booking?['endTime']}',
                                            style: kStyle12B.copyWith(
                                              color: ColorConstant.kBlue,
                                            ),
                                          ),
                                        ],
                                      ),
                                      sizedBox2(),
                                      sizedBox2(),
                                      Row(
                                        children: [
                                          Text(
                                            'Payment status :',
                                            style: kStyle12,
                                          ),
                                          Text(
                                            ' No charge',
                                            style: kStyle12B.copyWith(
                                                color: ColorConstant.kGreen),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12.0),
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                            child: Column(
                              children: [
                                sizedBox2(),
                                Divider(
                                  color: ColorConstant.backgroundColor,
                                ),
                                sizedBox2(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Status: ',
                                          style: kStyle12B,
                                        ),
                                        Text(
                                          status.toUpperCase(),
                                          overflow: TextOverflow.ellipsis,
                                          style: kStyle12B.copyWith(
                                            color: isRejected
                                                ? Colors.red
                                                : isAccepted
                                                    ? Colors.green
                                                    : isPending
                                                        ? Colors.blue
                                                        : null,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                sizedBox12(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  });
            }),
      ),
    ),
  );
}
