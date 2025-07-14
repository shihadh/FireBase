import 'package:first/core/services/user_service.dart';
import 'package:first/data/model/user_model.dart';
import 'package:flutter/material.dart';

class HomeController extends ChangeNotifier{
  List<UserModel>userData =[];
  UserService userService =UserService();
  String? error;

  void getData()async{
    final (data, errors) = await userService.fetchData();
    if(errors != null){
      error =errors;
    }
    else if(data != null){
      userData=data;
      
    }
    notifyListeners();
  }
}