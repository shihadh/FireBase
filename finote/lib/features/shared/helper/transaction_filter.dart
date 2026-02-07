import 'package:finote/features/AddTransaction/model/transation_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

List<TransationModel> filterByRange(
  List<TransationModel> all,
  DateTimeRange range,
) {

  return all.where((tx) {

    if (tx.date == null) return false;

    try {

      final parsedDate =
          DateFormat('dd-MM-yyyy').parse(tx.date!);

      return !parsedDate.isBefore(range.start) &&
             !parsedDate.isAfter(range.end);

    } catch (_) {
      return false;
    }

  }).toList();
}
