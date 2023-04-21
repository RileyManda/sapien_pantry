import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({Key? key}) : super(key: key);

  Widget _buildLogoImage() {
    return SizedBox(
      height: 100,
      child: Lottie.asset(
        "assets/fruits.json",
        fit: BoxFit.contain,
        height: double.infinity,
        width: double.infinity,
        alignment: Alignment.center,
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children:  [
        SizedBox(
          height: 50,
        ),
        _buildLogoImage(),
        SizedBox(
          height: 10,
        ),
        Text(
          'SapienPantry',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 10,
        )
      ],
    );
  }


}
