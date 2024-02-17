import 'package:flutter/material.dart';
import 'package:you_matter/core/theme/colors.dart';
import 'package:you_matter/core/theme/textstyle.dart';

class MySnackBar {
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> mySnackBarBtn(
      {required BuildContext context, required text, Color? bgColor}) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 2),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: kStyle12.copyWith(color: ColorConstant.kWhite),
          ),
        ],
      ),
      backgroundColor: bgColor ?? ColorConstant.kBlack,
    ));
  }
}

MySnackBar mySnackbar = MySnackBar();
