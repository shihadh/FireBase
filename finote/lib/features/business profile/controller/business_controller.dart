import 'package:flutter/material.dart';

class BusinessController extends ChangeNotifier{
    final TextEditingController businessNameController = TextEditingController();
  final TextEditingController gstController = TextEditingController();

  String selectedCurrency = '₹ Indian Rupee (INR)';

  void updateCurrency(String? newCurrency) {
    if (newCurrency != null) {
      selectedCurrency = newCurrency;
      notifyListeners();
    }
}
}