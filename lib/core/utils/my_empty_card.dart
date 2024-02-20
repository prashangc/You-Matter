import 'package:flutter/material.dart';
import 'package:you_matter/core/theme/colors.dart';
import 'package:you_matter/core/theme/textstyle.dart';
import 'package:you_matter/core/utils/sizes.dart';

Widget myEmptyCard({
  required BuildContext context,
  required String emptyMsg,
  required String subTitle,
}) {
  return Container(
    padding: const EdgeInsets.all(12.0),
    decoration: BoxDecoration(
      color: ColorConstant.kWhite,
      borderRadius: const BorderRadius.all(
        Radius.circular(30.0),
      ),
    ),
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
          overflow: TextOverflow.clip,
          textAlign: TextAlign.center,
          style: kStyle12.copyWith(color: ColorConstant.kRed),
        ),
      ],
    ),
  );
}
