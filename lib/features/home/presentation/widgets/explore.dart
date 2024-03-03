import 'package:flutter/material.dart';
import 'package:you_matter/core/route/route.dart';
import 'package:you_matter/core/theme/colors.dart';
import 'package:you_matter/core/theme/textstyle.dart';
import 'package:you_matter/core/utils/my_cached_network_image.dart';
import 'package:you_matter/core/utils/sizes.dart';
import 'package:you_matter/features/dashboard/controller/dashboard_controller.dart';
import 'package:you_matter/features/search/presentation/ui/search_page.dart';

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
                    fontSize: 18.0,
                  ),
                ),
                Text(
                  'Matter',
                  style: kStyle18B.copyWith(
                    fontSize: 24.0,
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                dashboardController.baseBloc.storeData(data: 3);
              },
              child: myCachedNetworkImageCircle(
                myWidth: 40.0,
                myHeight: 40.0,
                myImage: '',
              ),
            ),
          ],
        ),
        sizedBox16(),
        GestureDetector(
          onTap: () => pushTo(context: context, screen: const SearchPage()),
          child: Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: ColorConstant.kWhite,
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
                  'Find therapist',
                  style: kStyle12,
                ),
                sizedBox12(),
              ],
            ),
          ),
        ),
        sizedBox16(),
      ],
    ),
  );
}
