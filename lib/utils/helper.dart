import 'package:flutter/painting.dart';
import 'package:intl/intl.dart';
import 'package:sapienpantry/controller/pantry_controller.dart';
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





