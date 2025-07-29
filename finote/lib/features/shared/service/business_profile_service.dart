import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finote/features/business%20profile/model/business_profile_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BusinessProfileService {


  Future<(bool?, String?)> addProfile(BusinessProfileModel model) async {
  try {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection('profile')
        .doc(uid)
        .set(model.toJson());

    log("success");
    return (true, null);
  } catch (e) {
    log(e.toString());
    return (false, e.toString());
  }
}


  Future<(BusinessProfileModel?, String?)> getProfile() async {
  try {
    
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final snapshot = await FirebaseFirestore.instance
        .collection('profile')
        .doc(uid)
        .get();
    if (snapshot.exists) {
      final data = BusinessProfileModel.fromJson(snapshot.data()!, snapshot.id);
      log(snapshot.id);
      return (data, null);
    } else {
      return (null, "Profile not found");
    }
  } catch (e) {
    log(e.toString());
    return (null, e.toString());
  }
}

Future<(bool,String?)>update(BusinessProfileModel data, String id)async{
  log(id.toString());
  try{
    await FirebaseFirestore.instance.collection('profile').doc(id).update(data.toJson());
    log("update susses");
    return (true,null);
  }catch(e){
    return (false,e.toString());
  }
}



}