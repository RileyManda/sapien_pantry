import 'package:flutter/painting.dart';
import 'package:intl/intl.dart';
import 'package:sapienpantry/utils/constants.dart';

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

  // Generate a new color
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

//TODO: Code cleanup

// Color getLabelColorFromCat(String category) {
//   final bytes = category.codeUnits;
//   final sum = bytes.fold(0, (a, b) => a + b);
//   final index = sum % labelColors.length;
//   return labelColors[index];
// }
// Color getRandomColor() {
//   // Generate a random number between 0 and labelColors.length - 1
//   final randomIndex = Random().nextInt(labelColors.length);
//   // Get the color at the random index
//   final randomColor = labelColors[randomIndex];
//   return randomColor;
// }

Color getItemColor(int timestamp) {
  final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
  return labelColors[date.weekday % labelColors.length];
}





//
// String getCategoryName(String cat) {
//   final category = '';
//   return DateFormat('d MMM yyyy').format(category);
// }





