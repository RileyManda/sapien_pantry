import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sapienpantry/controller/auth_controller.dart';
import 'package:sapienpantry/services/connectivity_service.dart';
import 'package:sapienpantry/view/onboarding_page.dart';
import 'package:sapienpantry/widgets/app_logo.dart';

import '../utils/shared_preferences.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  bool _connected = false;
  bool _isFirstRun = true; // default to true until checked

  @override
  void initState() {
    super.initState();
    checkIsFirstRun();
    checkInternetConnection();
  }
  Future<void> checkIsFirstRun() async {
    final isFirstRun = await SharedPreferencesHelper().isFirstRun();
    setState(() {
      _isFirstRun = isFirstRun;
    });
  }

  Future<void> checkInternetConnection() async {
    _connected = await ConnectivityService.instance.checkConnection(context);
    if (_connected) {
      if (_isFirstRun) {
        // navigate to welcome screen
        Get.offAll(() => const OnBoardingPage());
      } else {
        // navigate to login screen or dashboard depending on auth state
        Get.put(AuthController());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            AppLogo(),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: SizedBox(
                width: 50,
                child: LinearProgressIndicator(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
