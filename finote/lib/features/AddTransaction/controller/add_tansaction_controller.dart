import 'dart:developer';
import 'dart:io';

import 'package:finote/features/history/utils/pdf_utils.dart';
import 'package:finote/features/shared/service/ai_insight_service.dart';
import 'package:finote/features/shared/service/receipt_ocr_service.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:finote/core/constants/color_const.dart';
import 'package:finote/features/AddTransaction/model/transation_model.dart';
import 'package:finote/features/shared/service/transation_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class AddTansactionController extends ChangeNotifier {
  final amountController = TextEditingController();
  final dateController = TextEditingController();
  final noteController = TextEditingController();

  final TransationService transationService = TransationService();
  final ReceiptOCRService receiptOCRService = ReceiptOCRService();
  final AIInsightService aiService = AIInsightService();

  //ai insight
  String? previousMonthAIInsight;
  bool isGeneratingInsight = false;


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

  //for extract text
  bool isScanningReceipt = false;
  String? scannedRawText;


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

  download = transations.isNotEmpty;

  //  AI Trigger
  generatePreviousMonthAIInsight();

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

  //for ai insight

  Map<String, dynamic> _calculatePreviousMonthData() {

  final now = DateTime.now();
  final prevMonth = now.month == 1 ? 12 : now.month - 1;
  final prevYear = now.month == 1 ? now.year - 1 : now.year;

  final prevTransactions = _filterByMonth(prevMonth, prevYear);

  double income = 0;
  double expense = 0;

  Map<String, double> categoryTotals = {};

  for (var tx in prevTransactions) {

    final amount = double.tryParse(tx.amount ?? '0') ?? 0;

    if (tx.type == 'income') {
      income += amount;
    } else {
      expense += amount;

      if (tx.category != null) {
        categoryTotals[tx.category!] =
            (categoryTotals[tx.category!] ?? 0) + amount;
      }
    }
  }

  String topCategory = "None";

  if (categoryTotals.isNotEmpty) {
    topCategory = categoryTotals.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }

  double currentExpense = totalExpense;

  double changePercent = 0;

  if (expense > 0) {
    changePercent = ((currentExpense - expense) / expense) * 100;
  }

  return {
    "income": income,
    "expense": expense,
    "topCategory": topCategory,
    "changePercent": changePercent,
  };
}

Future<void> generatePreviousMonthAIInsight() async {

  if (allTransactions.isEmpty) return;

  final data = _calculatePreviousMonthData();

  isGeneratingInsight = true;
  notifyListeners();

  try {

    previousMonthAIInsight = await aiService.generateInsight(
      income: data["income"],
      expense: data["expense"],
      topCategory: data["topCategory"],
      changePercent: data["changePercent"],
    );

  } catch (e) {
    log("AI Insight Error: $e");
  }

  isGeneratingInsight = false;
  notifyListeners();
}



  // file picker for extract text
  Future<File?> pickReceiptImage(ImageSource source) async {
  final picker = ImagePicker();
  final image = await picker.pickImage(
    source: source,
    imageQuality: 85,
  );

  if (image == null) return null;
  return File(image.path);
}

Future<void> scanReceipt(ImageSource source) async {
  final image = await pickReceiptImage(source);
  if (image == null) return;

  isScanningReceipt = true;
  notifyListeners();

  try {
    final text = await receiptOCRService.scanText(image);
    scannedRawText = text;

    _autoFillFromReceipt(text);
  } catch (e) {
    log("OCR Error: $e");
  }

  isScanningReceipt = false;
  notifyListeners();
}

void _autoFillFromReceipt(String text) {
  final lowerText = text.toLowerCase();

// ---------------- AMOUNT ----------------

// Match TOTAL, GRAND TOTAL, or Subtotal with optional colon/space
final totalRegex = RegExp(
  r'(total|grand total|subtotal)[:\s]*([0-9]+[.,][0-9]{2})',
  caseSensitive: false,
);

// Find all matches
final matches = totalRegex.allMatches(text);

// Pick the last one (usually TOTAL is last on receipt)
if (matches.isNotEmpty) {
  final match = matches.last;
  amountController.text = match.group(2)!.replaceAll(',', '');
} else {
  // fallback: pick the largest number in the receipt
  final numRegex = RegExp(r'([0-9]+[.,][0-9]{2})');
  final allNumbers = numRegex.allMatches(text).map((e) => double.tryParse(e.group(1)!.replaceAll(',', '')) ?? 0).toList();
  if (allNumbers.isNotEmpty) {
    amountController.text = allNumbers.reduce((a, b) => a > b ? a : b).toStringAsFixed(2);
  }
}


  // ---------------- DATE ----------------

  // Format 1 → 23-04-2024 or 23/04/2024
  final numericDateRegex = RegExp(r'\d{2}[\/\-]\d{2}[\/\-]\d{4}');
  final numericMatch = numericDateRegex.firstMatch(text);

  if (numericMatch != null) {
    try {
      final parsed =
          DateFormat('dd-MM-yyyy').parse(numericMatch.group(0)!);
      dateController.text =
          DateFormat('dd-MM-yyyy').format(parsed);
    } catch (_) {}
  }

  // Format 2 → April 23, 2024
  // Matches: Feb 1 2026 OR Feb 1, 2026 OR February 1 2026
final textDateRegex = RegExp(
  r'(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec|January|February|March|April|May|June|July|August|September|October|November|December)\s+\d{1,2},?\s+\d{4}',
  caseSensitive: false,
);

final textMatch = textDateRegex.firstMatch(text.trim());

if (textMatch != null) {
  final matched = textMatch.group(0)!;
  DateTime? parsed;

  // Try parsing full month
  try {
    parsed = DateFormat('MMMM d, yyyy').parse(matched);
  } catch (_) {
    // Try abbreviated month
    try {
      parsed = DateFormat('MMM d, yyyy').parse(matched);
    } catch (_) {
      // Try without comma
      try {
        parsed = DateFormat('MMMM d yyyy').parse(matched);
      } catch (_) {
        try {
          parsed = DateFormat('MMM d yyyy').parse(matched);
        } catch (_) {}
      }
    }
  }

  if (parsed != null) {
    dateController.text = DateFormat('dd-MM-yyyy').format(parsed);
  }
}




  // ---------------- NOTE / MERCHANT ----------------
  final lines = text.split('\n');
  for (final line in lines) {
    if (line.length > 3 && !RegExp(r'\d').hasMatch(line)) {
      noteController.text = line.trim();
      break;
    }
  }

  // ---------------- CATEGORY ----------------
  if (lowerText.contains('swiggy') ||
      lowerText.contains('zomato') ||
      lowerText.contains('restaurant') ||
      lowerText.contains('cafe') ||
      lowerText.contains('food')) {
    selectedCategory = 'Food';
  } 
  else if (lowerText.contains('uber') ||
      lowerText.contains('ola') ||
      lowerText.contains('fuel') ||
      lowerText.contains('petrol') ||
      lowerText.contains('diesel')) {
    selectedCategory = 'Transport';
  } 
  else if (lowerText.contains('electricity') ||
      lowerText.contains('water') ||
      lowerText.contains('bill') ||
      lowerText.contains('internet') ||
      lowerText.contains('mobile')) {
    selectedCategory = 'Bills';
  } 
  else if (lowerText.contains('salary') ||
      lowerText.contains('credited') ||
      lowerText.contains('credit')) {
    selectedCategory = 'Salary';
    isIncome = true;
  } 
  else {
    selectedCategory = 'Others';
  }

  // Default to expense unless salary detected
  if (selectedCategory != 'Salary') {
    isIncome = false;
  }

  notifyListeners();
}



}
