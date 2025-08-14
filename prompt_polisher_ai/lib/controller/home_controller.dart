import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:prompt_polisher_ai/service/api_service.dart';

class HomeController extends ChangeNotifier{

  TextEditingController promptController = TextEditingController();
  bool isloading = false;
  String result = "";
  String? error;
  ApiService apiService = ApiService();

  Future<void> polish(BuildContext context)async{
    isloading = true;
    notifyListeners();
    if(promptController.text.trim().isNotEmpty){
     var (data,errors) = await apiService.polishPrompt(promptController.text.trim());
     if(errors != null){
      error = errors;
     }
     if(data != null){
      result = data;
      log(result);
      

     }
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("enter a prompt")));
    }
    isloading = false;
    notifyListeners();
  }
}