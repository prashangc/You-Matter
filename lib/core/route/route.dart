import 'package:flutter/material.dart';

pushTo({required BuildContext context, required Widget screen}) =>
    Navigator.push(context, MaterialPageRoute(builder: (c) => screen));
pushAndRemoveUpto({required BuildContext context, required Widget screen}) =>
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (c) => screen),
        (Route<dynamic> route) => false);
