import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first/data/model/user_model.dart';

class UserService {

  Future<(bool?,String?)>addData(UserModel userdata)async{
    try{
    var data =  await FirebaseFirestore.instance.collection('user').add(userdata.tojson());
    log(data.id);
      log("susses");
      return (true,null);
    }catch(e){
      log(e.toString());
      return (false, e.toString());
    }
  }

  Future<(List<UserModel>?,String?)>fetchData()async{
   try{
    final snapshot = await FirebaseFirestore.instance.collection('user').get();
    final data = snapshot.docs.map((e)=>UserModel.fromjson(e.data(),e.id)).toList();
    log(data.toString());
    return (data,null);
   }catch(e){
    log(e.toString());
    throw Exception(e);
   }

  }

  Future<(bool?,String?)> updateData(UserModel data, String id)async{
    try{
      log(id);
      await FirebaseFirestore.instance.collection("user").doc(id).update(data.tojson());
      log("update susses");
      return (true,null);
    }catch(e){
      log(e.toString());
      return (false,e.toString());
    }
  }

  Future<(bool?,String?)>deleteData(String id)async{
    try{
      
      await FirebaseFirestore.instance.collection('user').doc(id).delete();
      log("deleted");
      return (true,null);
    }catch(e){
      log(e.toString());
      return (false,e.toString());
    }
  }
}