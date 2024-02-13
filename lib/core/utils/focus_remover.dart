import 'package:flutter/material.dart';

void myFocusRemover(BuildContext context) {
  FocusScope.of(context).requestFocus(FocusNode());
}
