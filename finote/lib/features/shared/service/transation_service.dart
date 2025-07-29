import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finote/features/AddTransaction/model/transation_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TransationService {

  Future<(List<TransationModel>?,String?)>getTransation()async{
    try{
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final snapshot = await FirebaseFirestore.instance.collection('profile').doc(uid).collection('Transation').get();
      
      final data = snapshot.docs.map((e)=>TransationModel.formJson(e.data(), e.id)).toList();

      return (data,null);
    }catch(e){
      return(null,e.toString());
    }
  }

  Future<(bool,String?)>addTransaction(TransationModel data)async{
    try{
      final uid = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance.collection('profile').doc(uid).collection("Transation").add(data.toJson());
      log(data.toJson().toString());
      return (true,null);
    }catch(e){
      return (false,e.toString());
    }
  }

  Future<(bool,String?)>deleteTransation(String id)async{
    try{
      final uid = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance.collection('profile').doc(uid).collection('Transation').doc(id).delete();
      return(true,null);
    }catch(e){
      return (false,e.toString());
    }
  }
}