import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// Everything related to teh snackbar that we are showing throughout the app

enum SnackBarTypes {
  custom,
  error,
  warning,
  success,
  info,
  //If any type added here, don't forget to add corresponding _backgroundColor
  // in showSnackBar
}

void showSnackBar({
  String title = '',
  required String message,
  SnackBarTypes? type,
  Color? backgroundColor,
  Color? textColor,
}) {
  //Setting Colors based on type
  final textColorToUse =
      type == SnackBarTypes.custom ? textColor : Colors.white;
  final backgroundColorToUse = type == null
      ? Colors.green
      : type == SnackBarTypes.custom
          ? backgroundColor
          : type == SnackBarTypes.error
              ? Colors.red
              : type == SnackBarTypes.warning
                  ? Colors.amber
                  : type == SnackBarTypes.info
                      ? Colors.blue
                      : Colors.green;

  // if (type == SnackBarTypes.Error) {
  //   clearFocus();
  //   printLog(
  //     "\nTitle\t - $title\nMessage\t - $message",
  //     tag: SitedeckStrings.tagSnackbarError,
  //   );
  // }

  final finalMessage =
      "$title${title.isEmpty || message.isEmpty ? '' : ': '}$message";
  // Maybe remove `Fluttertoast.cancel();` if it gives issues
  Fluttertoast.cancel();
  Fluttertoast.showToast(
    msg: finalMessage,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: backgroundColorToUse,
    textColor: textColorToUse,
    fontSize: 16.0,
  );
}
