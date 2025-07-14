import 'package:first/core/services/user_service.dart';
import 'package:first/data/model/user_model.dart';
import 'package:first/features/home/view/home.dart';
import 'package:flutter/material.dart';

class CreateController extends ChangeNotifier{
  
  TextEditingController namecontroller = TextEditingController();
  TextEditingController agecontroller = TextEditingController();
  TextEditingController placecontroller = TextEditingController();
  UserService userService = UserService();

   void add(GlobalKey<FormState>key, BuildContext context)async{
      if(key.currentState!.validate()){
        var data = UserModel(
        username: namecontroller.text.trim(), 
        age: agecontroller.text.trim(), 
        place: placecontroller.text.trim()
        );
      final (stat,error) = await userService.addData(data);
      if(error != null){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
      }
      if(stat == true){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("data stored")));
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage(),));
      }
      notifyListeners();

      }
   }
}