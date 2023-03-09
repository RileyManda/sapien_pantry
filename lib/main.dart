import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sapienpantry/controller/item_controller.dart';
import 'package:sapienpantry/firebase_options.dart';
import 'package:sapienpantry/utils/constants.dart';
import 'package:sapienpantry/view/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.android);
  Get.put(ItemController());
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Item List',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: kPrimayColor,
          iconTheme: const IconThemeData(color: kPrimayColor),
          appBarTheme: const AppBarTheme(
            centerTitle: true,
          )),
      home: const Splash(),
    );
  }
}
