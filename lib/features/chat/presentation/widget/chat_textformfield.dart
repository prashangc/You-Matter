import 'package:flutter/material.dart';
import 'package:you_matter/core/theme/colors.dart';
import 'package:you_matter/core/theme/textstyle.dart';

Widget chatTextForm(context) {
  return TextFormField(
    focusNode: FocusNode(),
    cursorColor: ColorConstant.kPrimary,
    style: kStyle12,
    onChanged: (String value) {},
    decoration: InputDecoration(
      suffixIcon: GestureDetector(
        onTap: () {},
        child: Container(
            decoration: BoxDecoration(
              color: ColorConstant.kPrimary,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(26.0),
                bottomRight: Radius.circular(26.0),
              ),
            ),
            child: true == true
                ? Icon(
                    Icons.arrow_upward_rounded,
                    size: 24,
                    color: ColorConstant.kWhite,
                  )
                : Container(
                    margin: const EdgeInsets.all(15.0),
                    width: 15.0,
                    height: 15.0,
                    child: CircularProgressIndicator(
                      color: ColorConstant.kWhite,
                      backgroundColor: ColorConstant.kGreen,
                      strokeWidth: 1.0,
                    ),
                  )),
      ),
      errorMaxLines: 2,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
      filled: true,
      fillColor: ColorConstant.backgroundColor,
      enabledBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(
          Radius.circular(26.0),
        ),
        borderSide: BorderSide(color: ColorConstant.kTransparent, width: 0.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(
          Radius.circular(26.0),
        ),
        borderSide: BorderSide(color: ColorConstant.kPrimary, width: 1.5),
      ),
      errorStyle: kStyle12.copyWith(color: ColorConstant.kRed),
      border: OutlineInputBorder(
        borderRadius: const BorderRadius.all(
          Radius.circular(26.0),
        ),
        borderSide: BorderSide(color: ColorConstant.kBlack, width: 1.5),
      ),
      hintText: 'Talk about your problem...',
      hintStyle: kStyle12,
    ),
  );
}
