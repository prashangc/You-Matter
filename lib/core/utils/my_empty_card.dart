import 'package:flutter/material.dart';
import 'package:you_matter/core/theme/colors.dart';
import 'package:you_matter/core/theme/textstyle.dart';
import 'package:you_matter/core/utils/sizes.dart';

Widget myEmptyCard({
  required BuildContext context,
  required String emptyMsg,
  required String subTitle,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      sizedBox32(),
      Expanded(
        child: Image.asset(
          'assets/error/error.png',
        ),
      ),
      sizedBox2(),
      SizedBox(
        width: maxWidth(context) / 2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.refresh_outlined,
              color: ColorConstant.kPrimary,
              size: 30.0,
            ),
            sizedBox12(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  emptyMsg,
                  style: kStyle14B.copyWith(
                    color: ColorConstant.kPrimary,
                  ),
                ),
              ],
            ),
            sizedBox2(),
            Text(
              subTitle,
              overflow: TextOverflow.ellipsis,
              style: kStyle12.copyWith(color: ColorConstant.kRed),
            ),
          ],
        ),
      ),
    ],
  );
}
