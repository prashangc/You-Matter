import 'package:flutter/material.dart';
import 'package:you_matter/core/theme/colors.dart';
import 'package:you_matter/core/theme/textstyle.dart';
import 'package:you_matter/core/utils/sizes.dart';

Widget therapistDetails(
  context, {
  String? name,
  String? email,
  String? imageUrl,
}) {
  return Container(
    padding: const EdgeInsets.all(12.0),
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CircleAvatar(
          radius: 25,
          backgroundImage: AssetImage("assets/images/profile.png"),
        ),
        sizedBox16(),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name ?? "User",
                style: kStyle14B,
              ),
              Text(
                email ?? "N/A",
                style: kStyle12,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
