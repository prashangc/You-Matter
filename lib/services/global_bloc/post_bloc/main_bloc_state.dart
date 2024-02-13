import 'package:flutter/material.dart';

abstract class MainPostState {}

class MainBlocInitialState extends MainPostState {}

class LoadingState extends MainPostState {
  BuildContext? context;
  String? msg;
  LoadingState({this.msg, this.context});
}

class ConfirmationState extends MainPostState {
  BuildContext? context;
  String? msg;
  Function? func;
  ConfirmationState(
      {required this.msg, required this.context, required this.func});
}

class SuccessState extends MainPostState {
  BuildContext? context;
  String? msg;
  SuccessState({required this.msg, required this.context});
}

class ErrorState extends MainPostState {
  BuildContext? context;
  String? msg;
  List<String> listOfErrors;
  ErrorState(
      {required this.msg, required this.context, required this.listOfErrors});
}
