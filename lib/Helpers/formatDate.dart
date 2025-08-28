import 'dart:convert';
import 'dart:io';

import 'package:intl/intl.dart';

String formatDate({DateTime? date, String format = 'yyyy-MM-dd'}) {
  final DateTime finalDate = date ?? DateTime.now();
  return DateFormat(format).format(finalDate);
}


int minutesdifferent(String timeString) {
  final now = DateTime.now();

  // Split hours, minutes and AM/PM
  final parts = timeString.split(RegExp(r'[: ]'));
  int hour = int.parse(parts[0]);
  int minute = int.parse(parts[1]);
  String ampm = parts[2].toUpperCase();

  if (ampm == 'PM' && hour != 12) hour += 12;
  if (ampm == 'AM' && hour == 12) hour = 0;

  final targetMinutes = hour * 60 + minute;
  final nowMinutes = now.hour * 60 + now.minute;

  final diff = nowMinutes - targetMinutes; // Current - Scheduled
  return diff > 0 ? diff : 0;
}

String currentTime() {
  final now = DateTime.now();
  return DateFormat('hh:mm a').format(now);
}

String? encodeFile(File? file) {
  if (file == null) return null;
  final bytes = file.readAsBytesSync();
  return    base64Encode(bytes);
}