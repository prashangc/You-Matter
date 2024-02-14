import 'package:flutter/material.dart';
import 'package:you_matter/core/theme/colors.dart';
import 'package:you_matter/core/theme/textstyle.dart';
import 'package:you_matter/core/utils/sizes.dart';

Widget chatAppBar() {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12.0),
    color: ColorConstant.kPrimary,
    child: Column(
      children: [
        sizedBox16(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '  Chat',
              style: kStyle18B.copyWith(
                color: ColorConstant.kWhite,
                fontSize: 24.0,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                  color: ColorConstant.kWhite.withOpacity(0.4),
                  borderRadius: const BorderRadius.all(Radius.circular(24.0))),
              child: Row(
                children: [
                  sizedBox2(),
                  Text(
                    'Notificaton',
                    style: kStyle12.copyWith(color: ColorConstant.kWhite),
                  ),
                  sizedBox12(),
                  CircleAvatar(
                    radius: 14.0,
                    backgroundColor: ColorConstant.kWhite.withOpacity(0.6),
                    child: const Icon(
                      Icons.notifications,
                      size: 15.0,
                    ),
                  ),
                  sizedBox2(),
                ],
              ),
            )
          ],
        ),
      ],
    ),
  );
}
