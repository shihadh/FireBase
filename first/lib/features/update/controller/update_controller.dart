import 'package:first/core/services/user_service.dart';
import 'package:first/data/model/user_model.dart';
import 'package:first/features/home/view/home.dart';
import 'package:flutter/material.dart';

class UpdateController extends ChangeNotifier{
  TextEditingController updateNamecontroller = TextEditingController();
  TextEditingController updatAgecontroller = TextEditingController();
  TextEditingController updatePlacecontroller = TextEditingController();
  UserService userService = UserService();

  void update(GlobalKey<FormState> key, BuildContext context, String id)async{
    if(key.currentState!.validate())
    {var datas = UserModel(
      username: updateNamecontroller.text.trim(), 
      age: updatAgecontroller.text.trim(), 
      place: updatePlacecontroller.text.trim());

    var (stat,error) = await userService.updateData(datas, id);
    if(error != null){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
    }
    if(stat == true){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("data Updated")));
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage(),));
      }
    }
    notifyListeners();
  }

  void delete(BuildContext context,String id)async{

    var (stat,error) = await userService.deleteData(id);
    if(error != null){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
      
    }
    if(stat == true){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("data deleted")));
      Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(),));
    }
    notifyListeners();

  }

}