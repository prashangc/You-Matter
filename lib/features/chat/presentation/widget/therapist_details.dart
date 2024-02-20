import 'package:flutter/material.dart';
import 'package:you_matter/core/theme/colors.dart';
import 'package:you_matter/core/theme/textstyle.dart';
import 'package:you_matter/core/utils/my_cached_network_image.dart';
import 'package:you_matter/core/utils/sizes.dart';

import '../../../../core/utils/time_utils.dart';

Widget therapistDetails(
  context, {
  String? name,
  String? email,
  String? imageUrl,
  required Map<String, dynamic> booking,
}) {
  String? startTime = booking['startTime'];
  String? endTime = booking['endTime'];
  bool isBetween = isTimeInRange(startTime, endTime);
  bool isBefore = isBeforeStartTime(startTime);
  bool isAfter = isAfterEndTime(endTime);
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
        CircleAvatar(
          radius: 25,
          child: myCachedNetworkImageCircle(
              myWidth: 45.0, myHeight: 45.0, myImage: imageUrl ?? ''),
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
              Row(
                children: [
                  Text(
                    "Status: ",
                    style: kStyle12,
                  ),
                  Text(
                    isBefore
                        ? "Not Started yet"
                        : isBetween
                            ? "Active"
                            : isAfter
                                ? "Ended"
                                : "--",
                    style: kStyle12B.copyWith(
                      color: isBefore
                          ? ColorConstant.kBlue
                          : isBetween
                              ? ColorConstant.kGreen
                              : isAfter
                                  ? ColorConstant.kRed
                                  : ColorConstant.kBlack,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
