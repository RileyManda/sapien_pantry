import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sapienpantry/controller/auth_controller.dart';
import 'package:sapienpantry/controller/pantry_controller.dart';

const pPrimaryColor = Colors.sapientheme;
const shoppingColor = Colors.sapienshoptheme;
// const pPrimaryColor = Color(0xFF265C7E);

final firebaseAuth = FirebaseAuth.instance;
final firestore = FirebaseFirestore.instance;
final authController = AuthController.instance;
final pantryController = PantryController.instance;

final RegExp regExForEmail = RegExp(
    r"^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))$");
final RegExp regExForName = RegExp(r'^[A-Za-z ]+$');
final Random _random = Random();

Color generateUniqueColor(Set<Color> usedColors) {
  // Generate a random hue value between 0 and 360
  final hue = _random.nextInt(360).toDouble();
  // Set the saturation and value to a fixed value
  final saturation = 1.0;
  final value = 0.8;
  // Convert the HSV values to an RGB color
  final rgbColor = HSVColor.fromAHSV(1.0, hue, saturation, value).toColor();
  // Check if the color has already been used
  if (usedColors.contains(rgbColor)) {
    // If it has, generate a new color recursively
    return generateUniqueColor(usedColors);
  } else {
    // If it hasn't, add the color to the set of used colors and return it
    usedColors.add(rgbColor);
    return rgbColor;
  }
}

final Set<Color> usedColors = {};
final List<Color> labelColors = List.generate(
  6, (index) => generateUniqueColor(usedColors),
);

const buttonColors = [
  Colors.sapientheme,
  Colors.orangeAccent,
  Colors.redAccent,
];
