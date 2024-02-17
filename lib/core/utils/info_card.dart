import 'package:flutter/material.dart';
import 'package:you_matter/core/theme/colors.dart';
import 'package:you_matter/core/theme/textstyle.dart';
import 'package:you_matter/core/utils/sizes.dart';

Widget infoCard({required context, required String text}) {
  return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
      width: maxWidth(context),
      decoration: BoxDecoration(
        color: ColorConstant.kWhite,
        boxShadow: [
          BoxShadow(color: ColorConstant.kGrey, offset: const Offset(3, 3))
        ],
        borderRadius: const BorderRadius.all(
          Radius.circular(30.0),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline_outlined,
              size: 17.0, color: ColorConstant.kRed),
          const SizedBox(width: 12.0),
          Expanded(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: kStyle12,
            ),
          ),
        ],
      ));
}
