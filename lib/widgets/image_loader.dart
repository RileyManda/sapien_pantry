import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ImageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Screen'),
      ),
      body: Center(
        child: Lottie.asset("assets/welcomeanim.json"),
      ),
    );
  }
}
