import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';


class ConnectivityService {
  static final ConnectivityService instance = ConnectivityService._();

  ConnectivityService._();

  Future<bool> checkConnection(BuildContext context) async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      showSnackbar(context, 'Great You are Online');
      return true;
    } else {
      showSnackbar(context, 'Please check your internet connection');
      return false;
    }
  }

  void showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}
