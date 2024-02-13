import 'package:flutter/widgets.dart';

abstract class MainPostEvent {}

class LoadingEvent extends MainPostEvent {
  BuildContext? context;
  String? msg;
  LoadingEvent({required this.msg, required this.context});
}

class ConfirmationEvent extends MainPostEvent {
  BuildContext? context;
  String? msg;
  Function? func;
  ConfirmationEvent({
    required this.msg,
    required this.context,
    required this.func,
  });
}

class SuccessEvent extends MainPostEvent {
  BuildContext? context;
  String? msg;
  SuccessEvent({required this.msg, required this.context});
}

class ErrorEvent extends MainPostEvent {
  BuildContext? context;
  String? msg;
  List<String> listOfErrors;
  ErrorEvent(
      {required this.msg, required this.context, required this.listOfErrors});
}
