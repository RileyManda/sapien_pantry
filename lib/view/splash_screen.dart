import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sapienpantry/controller/auth_controller.dart';
import 'package:sapienpantry/services/connectivity_service.dart';
import 'package:sapienpantry/widgets/app_logo.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  bool _connected = false;

  @override
  void initState() {
    super.initState();
    checkInternetConnection();
  }

  Future<void> checkInternetConnection() async {
    _connected = await ConnectivityService.instance.checkConnection(context);
    if (_connected) {
      Get.put(AuthController());
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
