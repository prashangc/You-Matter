import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:you_matter/core/theme/colors.dart';
import 'package:you_matter/core/theme/textstyle.dart';
import 'package:you_matter/features/request/controller/request_controller.dart';

Widget chatTextForm(context, Map<String, dynamic>? chatWith,
    TextEditingController textEditingController) {
  return TextFormField(
    controller: textEditingController,
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
                ? InkWell(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      requestController.sendMessage(
                          chatID: chatWith?['id'],
                          senderID:
                              FirebaseAuth.instance.currentUser?.uid ?? "-",
                          content: textEditingController.text);

                      textEditingController.clear();
                    },
                    child: Icon(
                      Icons.arrow_upward_rounded,
                      size: 24,
                      color: ColorConstant.kWhite,
                    ),
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
