import 'package:finote/core/constants/color_const.dart';
import 'package:finote/core/service/auth_service.dart';
import 'package:flutter/material.dart';

class LoginController extends ChangeNotifier{

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String? error;
  bool loading = false;
  bool stats = false;
  bool firstTime = false;
  AuthService authService = AuthService();

  void login(GlobalKey<FormState> formKey, BuildContext context) async {
    if (formKey.currentState!.validate()) {
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
      }
      await Future.delayed(Duration(seconds: 1));
      loading=false;
      notifyListeners();
    }
    
  }

  void googleSign(BuildContext context) async {
    var (data, errors) = await authService.signWithgoogle();
    if (errors != null) {
      error = errors;
    }
    if(data != null){
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