import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controller/auth_controller.dart';

class SharedPreferencesHelper {
  static const _keyIsFirstRun = 'is_first_run';
  Future<bool> isFirstRun() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirstRun = prefs.getBool(_keyIsFirstRun);
    if (isFirstRun == null) {
      // first time running the app
      await prefs.setBool(_keyIsFirstRun, false);
      return true;
    } else {
      Get.put(AuthController());
      // not the first time running the app
      return false;
    }
  }
}
