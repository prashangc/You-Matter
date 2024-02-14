import 'package:flutter/material.dart';
import 'package:you_matter/core/theme/colors.dart';
import 'package:you_matter/core/theme/textstyle.dart';
import 'package:you_matter/core/utils/my_cached_network_image.dart';
import 'package:you_matter/core/utils/sizes.dart';

Widget exploreCard(context) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12.0),
    decoration: BoxDecoration(
        color: ColorConstant.kPrimary,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30.0),
          bottomRight: Radius.circular(30.0),
        )),
    child: Column(
      children: [
        sizedBox16(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'You',
                  style: kStyle18B.copyWith(
                    color: ColorConstant.kWhite,
                    fontSize: 18.0,
                  ),
                ),
                Text(
                  'Matter',
                  style: kStyle18B.copyWith(
                    color: ColorConstant.kWhite,
                    fontSize: 24.0,
                  ),
                ),
              ],
            ),
            myCachedNetworkImageCircle(
              myWidth: 40.0,
              myHeight: 40.0,
              myImage: '',
            ),
          ],
        ),
        sizedBox16(),
        Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: ColorConstant.backgroundColor,
            borderRadius: const BorderRadius.all(
              Radius.circular(30.0),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.search,
                size: 16,
                color: ColorConstant.kBlack,
              ),
              sizedBox16(),
              Text(
                'Search here',
                style: kStyle12,
              ),
              sizedBox12(),
            ],
          ),
        ),
        sizedBox16(),
      ],
    ),
  );
}
