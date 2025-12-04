import 'dart:developer';

import 'package:finote/features/history/utils/pdf_utils.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:finote/core/constants/color_const.dart';
import 'package:finote/features/AddTransaction/model/transation_model.dart';
import 'package:finote/features/shared/service/transation_service.dart';
import 'package:intl/intl.dart';

class AddTansactionController extends ChangeNotifier {
  final amountController = TextEditingController();
  final dateController = TextEditingController();
  final noteController = TextEditingController();

  final TransationService transationService = TransationService();

  List<TransationModel> transations = [];       // Filtered list for UI
  List<TransationModel> allTransactions = [];   // Complete history

  double totalIncome = 0.0;
  double totalExpense = 0.0;
  double totalBalance = 0.0;

  int selectedMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;

  int minYear = DateTime.now().year;
  int maxYear = DateTime.now().year;

  String? error;
  bool loading = false;
  bool status = false;
  bool download = true;

  bool isIncome = true;
  String? selectedCategory;

  bool _hasFetchedOnce = false;

  List<String> categories = ['Food', 'Transport', 'Bills', 'Salary', 'Others'];

  void setTransactionType(bool income) {
    isIncome = income;
    notifyListeners();
  }

  void setCategory(String? value) {
    selectedCategory = value;
    notifyListeners();
  }

  Future<void> pickDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: ColorConst.black,
              onPrimary: ColorConst.backgroundColor,
              onSurface: ColorConst.blackopacity,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: ColorConst.black),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      dateController.text = DateFormat('dd-MM-yyyy').format(picked);
      notifyListeners();
    }
  }

  /// Fetch all transactions only once unless forced
  Future<void> get({bool forceRefresh = false}) async {
    if (_hasFetchedOnce && !forceRefresh) return;

    totalIncome = 0.0;
    totalExpense = 0.0;
    totalBalance = 0.0;

    var (data, errors) = await transationService.getTransation();

    if (errors != null) {
      error = errors;
      notifyListeners();
      return;
    }

    if (data != null) {
      allTransactions = data;
      _updateYearRangeFromTransactions();
      _hasFetchedOnce = true;
      setMonth(selectedMonth, selectedYear);
    }

    notifyListeners();
  }

  ///  Add a new transaction and refresh
  Future<void> add(BuildContext context) async {
    if (amountController.text.isEmpty ||
        dateController.text.isEmpty ||
        selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all required fields")),
      );
      status = false;
      return;
    }

    loading = true;
    error = null;
    notifyListeners();

    final data = TransationModel(
      amount: amountController.text.trim(),
      category: selectedCategory,
      date: dateController.text.trim(),
      type: isIncome ? "income" : "expence",
      note: noteController.text.trim(),
    );

    var (stats, errors) = await transationService.addTransaction(data);
    if (errors != null) {
      error = errors;
    }

    if (stats == true) {
      status = true;
      amountController.clear();
      dateController.clear();
      selectedCategory = null;

      _hasFetchedOnce = false;
      await get(forceRefresh: true); // refresh after add

      //added funtion on the save button
      //analytics function
      final analytics = FirebaseAnalytics.instance;

      if (noteController.text.trim().isNotEmpty) {
        await analytics.logEvent(
          name: "note_used",
          parameters: {
            "length": noteController.text.trim().length,
          },
        );
      } else {
        await analytics.logEvent(
          name: "note_skipped",
        );
      }
      noteController.clear();
    }

    loading = false;
    notifyListeners();
  }

  ///  Delete a transaction and refresh
  Future<void> delete(String id) async {
    status = false;
    error = null;

    var (stat, errors) = await transationService.deleteTransation(id);
    if (errors != null) {
      error = errors;
    }

    if (stat == true) {
      status = true;
      _hasFetchedOnce = false;
      await get(forceRefresh: true); // refresh after delete
    }

    notifyListeners();
  }

  ///  Update filter selection
  void updateSelectedDate(int month, int year) {
    selectedMonth = month;
    selectedYear = year;
    setMonth(month, year);
  }

  ///  Set filtered month and recalculate totals
  void setMonth(int month, int year) {
    transations = _filterByMonth(month, year);

    totalIncome = 0.0;
    totalExpense = 0.0;

    for (var item in transations) {
      final amount = double.tryParse(item.amount ?? '0') ?? 0.0;
      if (item.type == 'income') {
        totalIncome += amount;
      } else if (item.type == 'expence') {
        totalExpense += amount;
      }
    }

    totalBalance = totalIncome - totalExpense;

    // Notify whether PDF button should show
    download = transations.isNotEmpty;

    notifyListeners();
  }

  ///  Filter transactions by month/year
  List<TransationModel> _filterByMonth(int month, int year) {
    return allTransactions.where((item) {
      try {
        final parsedDate = DateFormat('dd-MM-yyyy').parse(item.date ?? '');
        return parsedDate.month == month && parsedDate.year == year;
      } catch (_) {
        return false;
      }
    }).toList();
  }

  ///  Update available year range based on data
  void _updateYearRangeFromTransactions() {
    if (allTransactions.isEmpty) {
      minYear = DateTime.now().year;
      maxYear = DateTime.now().year;
      return;
    }

    final years = allTransactions.map((e) {
      try {
        return DateFormat('dd-MM-yyyy').parse(e.date ?? '').year;
      } catch (_) {
        return DateTime.now().year;
      }
    }).toList();

    minYear = years.reduce((a, b) => a < b ? a : b);
    maxYear = years.reduce((a, b) => a > b ? a : b);
  }

  ///  Export to PDF
  Future<void> exportFilteredToPDF() async {
    await PDFUtils.exportTransactionsToPDF(
      transactions: transations,
      month: selectedMonth,
      year: selectedYear,
    );
  }
}
