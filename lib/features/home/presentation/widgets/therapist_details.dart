import 'dart:math';

import 'package:flutter/material.dart';
import 'package:you_matter/core/theme/colors.dart';
import 'package:you_matter/core/theme/textstyle.dart';
import 'package:you_matter/core/utils/button.dart';
import 'package:you_matter/core/utils/my_cached_network_image.dart';
import 'package:you_matter/core/utils/my_custom_appbar.dart';
import 'package:you_matter/core/utils/my_rating_bar.dart';
import 'package:you_matter/core/utils/sizes.dart';

class TherapistDetailScreen extends StatelessWidget {
  final data;
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

  Widget therapistTimings(context) {
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
          const Text('therapistTimings'),
        ],
      ),
    );
  }
}
