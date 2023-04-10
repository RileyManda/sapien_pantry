import 'package:flutter/painting.dart';
import 'package:intl/intl.dart';
import 'package:sapienpantry/utils/constants.dart';

import '../model/pantry.dart';

int getDateTimestamp(DateTime dateTime) {
  return DateTime(dateTime.year, dateTime.month, dateTime.day)
      .millisecondsSinceEpoch;
}

String getFormattedDate(int timestamp) {
  final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
  return DateFormat('d MMM yyyy').format(date);
}

Color getLabelColor(int timestamp) {
  final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
  return labelColors[date.weekday % labelColors.length];
}

Color getLabelColorFromText(String text) {
  final bytes = text.codeUnits;
  final sum = bytes.fold(0, (a, b) => a + b);
  final index = sum % labelColors.length;
  return labelColors[index];
}
int lastColorIndex = -1;
List<int> usedColorIndices = [];
Map<String, Color> categoryColors = {};

Color getCatColorForCategory(String category) {
  // Check if color has already been generated for this category
  if (categoryColors.containsKey(category)) {
    return categoryColors[category]!;
  }
  // Color has not been generated for this category, so generate a new one
  final bytes = category.codeUnits;
  final sum = bytes.fold(0, (a, b) => a + b);
  int index = sum % labelColors.length;
  while (usedColorIndices.contains(index)) {
    index = (index + 1) % labelColors.length;
  }

  // Mark index as used and update lastColorIndex
  usedColorIndices.add(index);
  lastColorIndex = index;

  // Store the color for this category
  final color = labelColors[index];
  categoryColors[category] = color;
  return color;
}



String getCategoryName(String categoryId) {
  return "Category $categoryId";
}


Color getItemColor(int timestamp) {
  final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
  return labelColors[date.weekday % labelColors.length];
}



