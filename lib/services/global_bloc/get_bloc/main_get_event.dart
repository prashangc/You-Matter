import 'package:flutter/material.dart';

abstract class MainGetEvent {}

class MainGetLoadingEvent extends MainGetEvent {
  BuildContext context;
  String endpoint;
  String emptyMsg;
  MainGetLoadingEvent({
    required this.endpoint,
    required this.context,
    required this.emptyMsg,
  });
}

class MainGetSuccessEvent extends MainGetEvent {
  dynamic resp;
  MainGetSuccessEvent({this.resp});
}

class MainGetErrorEvent extends MainGetEvent {}

class MainGetRequestTimeoutEvent extends MainGetEvent {}

class MainGetNoInternetEvent extends MainGetEvent {}

class MainGetEmptyEvent extends MainGetEvent {}

class MainGetRefreshEvent extends MainGetEvent {}
