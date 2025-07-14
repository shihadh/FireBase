import 'package:first/core/services/auth_service.dart';
import 'package:first/features/login/view/login.dart';
import 'package:flutter/material.dart';

class RegisterController extends ChangeNotifier{
  TextEditingController  emailController = TextEditingController();
  TextEditingController  passController = TextEditingController();
  AuthService authService =AuthService();
  String? errors;

  void check(GlobalKey<FormState> key, BuildContext context)async{
    if(key.currentState!.validate()){
    var (users,error) = await authService.register(emailController.text.trim(), passController.text.trim());

      if(error != null){
        errors =error;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error),));
      }
      if(users != null){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("sucess"),));

        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage(),));
      }
      notifyListeners();
    }

  }
}