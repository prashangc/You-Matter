import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:you_matter/core/theme/colors.dart';

class MyToast {
  Future<dynamic> toast({required String msg, required BuildContext context}) {
    return Fluttertoast.showToast(
      textColor: ColorConstant.kWhite,
      backgroundColor: ColorConstant.kBlack,
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }
}

final myToast = MyToast();
