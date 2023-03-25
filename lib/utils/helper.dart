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


Color getLabelColorFromCat(String category) {
  final bytes = category.codeUnits;
  final sum = bytes.fold(0, (a, b) => a + b);
  final index = sum % labelColors.length;
  return labelColors[index];
}




// ignore: todo
//TODO: getItemCategory then group on pantry by category andf set a color to each cat


Color getItemColor(int timestamp) {
  final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
  return labelColors[date.weekday % labelColors.length];
}


// Color getNameColor(String category) {
//   final catName = DateTime.fromMillisecondsSinceEpoch(category);
//   return labelColors[catName.weekday % labelColors.length];
// }






