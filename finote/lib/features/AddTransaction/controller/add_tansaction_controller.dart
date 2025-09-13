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

  bool isIncome = true;
  String? selectedCategory;

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
              style: TextButton.styleFrom(
                foregroundColor: ColorConst.black,
              ),
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

  /// Fetch all transactions and update filters
  Future<void> get() async {
    totalIncome = 0.0;
    totalExpense = 0.0;
    totalBalance = 0.0;

    var (data, errors) = await transationService.getTransation();

    if (errors != null) {
      error = errors;
    }

    if (data != null) {
      allTransactions = data;
      _updateYearRangeFromTransactions(); // update minYear & maxYear
      setMonth(selectedMonth, selectedYear); // apply current filter
    }

    notifyListeners();
  }

  /// Add a new transaction
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
      noteController.clear();
      selectedCategory = null;

      await get(); // refresh all transactions
    }

    loading = false;
    notifyListeners();
  }

  /// Delete a transaction by ID
  Future<void> delete(String id) async {
    status = false;
    error = null;

    var (stat, errors) = await transationService.deleteTransation(id);
    if (errors != null) {
      error = errors;
    }

    if (stat == true) {
      status = true;
      await get();
    }

    notifyListeners();
  }

  /// Update filter selection
  void updateSelectedDate(int month, int year) {
    selectedMonth = month;
    selectedYear = year;
    setMonth(month, year);
  }

  /// Set filtered month and recalculate totals
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
    notifyListeners();
  }

  /// Filter from allTransactions
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

  /// Update minYear & maxYear based on all transactions
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
}
