import 'package:connected/connected.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

checkInternetConnection(context) async {
  try {
    bool connection = await NetworkService().isConnected;
    return connection;
  } catch (e) {
    if (kDebugMode) {
      print('Error - checking internet connection status');
    }
    return true;
  }
}

internetRestored(BuildContext context) async {
  try {
    NetworkService().listenConnectivity(
      (status) {
        String stringStatus = status.name;
        if (stringStatus == 'on') {}
      },
    );
  } catch (e) {
    if (kDebugMode) {
      print('Error - listening internet connection status');
    }
    return true;
  }
}
