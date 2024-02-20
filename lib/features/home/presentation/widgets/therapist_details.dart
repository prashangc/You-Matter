import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:you_matter/core/theme/colors.dart';
import 'package:you_matter/core/theme/textstyle.dart';
import 'package:you_matter/core/utils/button.dart';
import 'package:you_matter/core/utils/confirmation_bottom_sheet.dart';
import 'package:you_matter/core/utils/info_card.dart';
import 'package:you_matter/core/utils/my_cached_network_image.dart';
import 'package:you_matter/core/utils/my_custom_appbar.dart';
import 'package:you_matter/core/utils/my_pop_up.dart';
import 'package:you_matter/core/utils/my_rating_bar.dart';
import 'package:you_matter/core/utils/sizes.dart';
import 'package:you_matter/features/home/controller/therapist_controller.dart';
import 'package:you_matter/features/home/presentation/widgets/therapist_timing.dart';

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
              ),
              sizedBox24(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'Booking Summary :',
                  style: kStyle14B,
                ),
              ),
              sizedBox24(),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20.0),
                padding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 20.0),
                decoration: BoxDecoration(
                  color: ColorConstant.kWhite,
                  boxShadow: [
                    BoxShadow(
                        color: ColorConstant.kGrey, offset: const Offset(3, 3))
                  ],
                  borderRadius: const BorderRadius.all(
                    Radius.circular(30.0),
                  ),
                ),
                child: Column(
                  children: [
                    myCard(
                      context: context,
                      title: 'Start Time',
                      value: startTime ?? 'N/A',
                      icon: Icons.timer_outlined,
                    ),
                    myCard(
                      context: context,
                      title: 'End Time',
                      value: endTime ?? 'N/A',
                      icon: Icons.timer_outlined,
                    ),
                    myCard(
                      context: context,
                      title: 'Date',
                      value:
                          '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}',
                      icon: Icons.timer_outlined,
                    ),
                    myCard(
                      context: context,
                      title: 'Price',
                      value: 'Free Consultation',
                      icon: Icons.attach_money_outlined,
                      showDivider: false,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.symmetric(
            horizontal: maxWidth(context) / 4, vertical: 15.0),
        height: 55,
        child: StreamBuilder(
            stream: therapistController.getAllBookings(
                uid: FirebaseAuth.instance.currentUser?.uid ?? "",
                therapistID: id),
            builder: (context, snapshot) {
              bool isBookedAlready = snapshot.data?.data() != null;
              return snapshot.connectionState == ConnectionState.waiting
                  ? Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: maxWidth(context) / 4),
                      child: const CircularProgressIndicator())
                  : isBookedAlready
                      ? infoCard(
                          context: context,
                          text: 'Already Booked',
                        )
                      : myButton(
                          context: context,
                          width: maxWidth(context),
                          height: 50.0,
                          text: 'Book',
                          myTap: () async {
                            if (selectedTime.isEmpty) {
                              popUpHelper.popUp(
                                  context: context,
                                  message: 'Please select a time first',
                                  type: 'error');
                            } else {
                              int? data = await confirmationBottomSheet(
                                  context: context,
                                  title: 'Confirm Booking',
                                  subTitle:
                                      'Are you sure you want to book this therapist ?');
                              if (data != null) {
                                therapistController.onTherapistBookingRequest(
                                    scheduleID: scheduleID,
                                    startTime: startTime!,
                                    endTime: endTime!,
                                    date: DateFormat("EEEE, MMM d")
                                        .format(DateTime.now()),
                                    username: FirebaseAuth
                                        .instance.currentUser!.displayName!,
                                    uid: FirebaseAuth.instance.currentUser!.uid,
                                    therapistID: id);
                              }
                            }
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

  Widget myCard({
    required context,
    required String title,
    required String value,
    required IconData icon,
    bool? showDivider,
  }) {
    return SizedBox(
      width: maxWidth(context),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 14.0,
                color: ColorConstant.kPrimary,
              ),
              sizedBox12(),
              Expanded(
                child: Row(
                  children: [
                    Text(
                      '$title : ',
                      style: kStyle14B,
                    ),
                    Text(
                      value,
                      style: kStyle14B.copyWith(
                          color: value == 'N/A'
                              ? Colors.red
                              : ColorConstant.kBlue),
                    ),
                  ],
                ),
              ),
            ],
          ),
          showDivider != null ? Container() : sizedBox24(),
          Container(
            color: ColorConstant.kBlack.withOpacity(0.1),
            height: showDivider != null ? 0.0 : 1.0,
          ),
          showDivider != null ? Container() : sizedBox24(),
        ],
      ),
    );
  }
}
