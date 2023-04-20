import 'dart:math';
import 'package:flutter/material.dart';

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
