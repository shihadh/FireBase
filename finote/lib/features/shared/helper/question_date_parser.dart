import 'package:flutter/material.dart';

DateTimeRange parseQuestionTime(String question) {

  final now = DateTime.now();
  final lower = question.toLowerCase();

  // -------- THIS MONTH --------
  if (lower.contains("this month")) {

    final start = DateTime(now.year, now.month, 1);
    final end = DateTime(now.year, now.month + 1, 0);

    return DateTimeRange(start: start, end: end);
  }

  // -------- LAST MONTH --------
  if (lower.contains("last month")) {

    final prevMonth =
        now.month == 1 ? 12 : now.month - 1;

    final year =
        now.month == 1 ? now.year - 1 : now.year;

    final start = DateTime(year, prevMonth, 1);
    final end = DateTime(year, prevMonth + 1, 0);

    return DateTimeRange(start: start, end: end);
  }

  // -------- THIS YEAR --------
  if (lower.contains("this year")) {

    final start = DateTime(now.year, 1, 1);
    final end = DateTime(now.year, 12, 31);

    return DateTimeRange(start: start, end: end);
  }

  // -------- DEFAULT FALLBACK --------
  final start = DateTime(now.year, now.month, 1);
  final end = DateTime(now.year, now.month + 1, 0);

  return DateTimeRange(start: start, end: end);
}
