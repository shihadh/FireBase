import 'dart:developer';

import 'package:finote/core/constants/color_const.dart';
import 'package:finote/features/bottom%20navigation/view/bottom_navigation.dart';
import 'package:finote/features/shared/service/auth_service.dart';
import 'package:finote/features/business%20profile/view/business_profile_page.dart';
import 'package:flutter/material.dart';

class LoginController extends ChangeNotifier{

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String? error;
  bool loading = false;
  bool stats = false;
  bool firstTime = false;
  AuthService authService = AuthService();

  Future<void> login(GlobalKey<FormState> formKey, BuildContext context) async {
    if (formKey.currentState!.validate()) {
      error=null;
      loading =true;
      notifyListeners();
      var (data, errors,first) = await authService.login(
        emailController.text.trim(),
        passwordController.text.trim(),
      );
      if (errors != null) {
        error = errors;
      }
      if(data != null){
        stats = true;
        firstTime = first;
        emailController.clear();
        passwordController.clear();
      }
      loading=false;
      notifyListeners();
    }
    
  }

  void googleSign(BuildContext context) async {
      error=null;
    var (data, errors,first) = await authService.signWithgoogle();
    if (errors != null) {
      error = errors;
    }
    if(data != null){
        stats = true;
        if(first == true){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BusinessProfilePage(),));
      }
      if(first== false){
        log("message");
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>MainBottomNavScreen(),));

      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          backgroundColor: ColorConst.success,
          content: Text('logged with google'),
        ),
      );
    }
      notifyListeners();
  }
}