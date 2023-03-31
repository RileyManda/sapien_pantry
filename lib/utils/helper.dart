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

Color getItemColor(int timestamp) {
  final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
  return labelColors[date.weekday % labelColors.length];
}
//
// String getCategoryName(String cat) {
//   final category = '';
//   return DateFormat('d MMM yyyy').format(category);
// }





