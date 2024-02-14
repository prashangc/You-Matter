import 'package:flutter/material.dart';
import 'package:you_matter/core/theme/colors.dart';
import 'package:you_matter/core/utils/sizes.dart';
import 'package:you_matter/features/chat/presentation/widget/chat_textformfield.dart';

Widget chatPage(context) {
  return Expanded(
    child: Container(
      width: maxWidth(context),
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
      decoration: BoxDecoration(
        color: ColorConstant.kWhite,
        boxShadow: [
          BoxShadow(color: ColorConstant.kGrey, offset: const Offset(3, 3))
        ],
        borderRadius: const BorderRadius.all(
          Radius.circular(30.0),
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  sizedBox8(),
                  const Text('data'),
                ],
              ),
            ),
          ),
          chatTextForm(context),
        ],
      ),
    ),
  );
}
