import 'package:flutter/material.dart';

pushTo({required BuildContext context, required Widget screen}) =>
    Navigator.push(context, MaterialPageRoute(builder: (c) => screen));
