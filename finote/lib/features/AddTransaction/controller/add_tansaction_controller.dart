import 'dart:developer';

import 'package:finote/features/AddTransaction/model/transation_model.dart';
import 'package:finote/features/shared/service/transation_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddTansactionController extends ChangeNotifier {
  final amountController = TextEditingController();
  final dateController = TextEditingController();
  final noteController = TextEditingController();
  TransationService transationService = TransationService();
  List<TransationModel> transations = [];
  double totalIncome= 0.0;
  double totalExpense= 0.0;
  double totalBalance= 0.0;
  String? error;
  bool loading = false;
  bool status= false;
  bool isFetched = false;

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
    );
    if (picked != null) {
      // that helps you convert DateTime objects into human-readable text

      dateController.text = DateFormat('dd-MM-yyyy').format(picked);
      notifyListeners();
    }
  }

  Future<void>get()async{

    // if (isFetched) return;
    totalIncome = 0.0;
    totalExpense = 0.0;
    totalBalance = 0.0;
    var (data, errors) = await transationService.getTransation();
    if(errors != null){
      error= errors;
    }
    if(data != null){
      transations = data;
      for(var item in data){
        if(item.type == 'income'){
          int amount = int.parse("${item.amount}");
          totalIncome +=amount;
        }else if(item.type == 'expence'){
          int amount = int.parse("${item.amount}");
          totalExpense +=amount;
        }
      }
      totalBalance = totalIncome - totalExpense;
      log(totalBalance.toString());

    }
    // isFetched = true;
    notifyListeners();
  }

  Future<void> add(BuildContext context) async {
    // Save logic here
    if (amountController.text.isEmpty ||
        dateController.text.isEmpty ||
        selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all required fields")),
      );
      status = false;
      return;
    }
    loading =true;
    error =null;
    notifyListeners();
    final data = TransationModel(
      amount: amountController.text.trim(),
      category: selectedCategory,
      date: dateController.text.trim(),
      type: isIncome ? "income" : 'expence',
      note: noteController.text.trim(),
    );

    var (stats, errors) = await transationService.addTransaction(data);
    if (errors != null) {
      error = errors;
    }
    if(stats == true){
      status =true;
      amountController.clear();
      dateController.clear();
      noteController.clear();
      selectedCategory=null;
    }
    loading= false;
    // await get();
    notifyListeners();
  }

  Future<void>delete(String id)async{
    status= false;
    error= null;
    var (stat,errors) = await transationService.deleteTransation(id);
    if(errors != null){
      error = errors;
    }
    if(stat == true){
      status = true;
    }
    notifyListeners();
  }
  
}
