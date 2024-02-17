import 'package:flutter/material.dart';
import 'package:you_matter/core/theme/colors.dart';
import 'package:you_matter/core/theme/textstyle.dart';
import 'package:you_matter/core/utils/sizes.dart';

Widget myRadioButton(
    {required String title,
    required int index,
    required ValueChanged<int> onChanged}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      sizedBox16(),
      Expanded(
        child: Text(
          title,
          style:
              kStyle12.copyWith(color: ColorConstant.kPrimary, fontSize: 12.0),
        ),
      ),
      Radio(
        activeColor: ColorConstant.kPrimary,
        value: index,
        groupValue: index,
        onChanged: (value) {
          onChanged(value!);
        },
      ),
    ],
  );
}
