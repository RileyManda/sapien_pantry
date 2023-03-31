import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

import 'messages.dart';

class ConnectivityService {
  static final ConnectivityService instance = ConnectivityService._();

  ConnectivityService._();

  Future<bool> checkConnection(BuildContext context) async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      showIsConnected(context,'Great You are Online');
      return true;

    } else {
      showErrorMessage(context, 'Please check your internet connection');
      return false;
    }
  }




}
