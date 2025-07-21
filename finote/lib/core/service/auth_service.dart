import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finote/core/errors/auth_errors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

AuthErrors authErrors = AuthErrors();
class AuthService {
  final firebase = FirebaseAuth.instance;
  bool first = false;
  Future<(User?,String?)>register(String email, String password)async{
    try{
     UserCredential result = await firebase.createUserWithEmailAndPassword(email: email, password: password);
     log(result.user.toString());
    return (result.user,null);
    }on FirebaseAuthException catch(e){
      log(e.code);
      return (null,authErrors.error(e.code));
    }
    catch(e){
      log(e.toString());
      return (null,e.toString());
    }   
  }

  Future<(User?,String?,bool)>login(String email , String password)async{
    try{
      UserCredential result = await firebase.signInWithEmailAndPassword(email: email, password: password);
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final doc = await FirebaseFirestore.instance.collection('profile').doc(uid).get(); // business name
      if(doc.exists){
        final data = doc.data();
        if(data?['name'] == '' && data?['currency'] == '' && data?['Gst_id'] == ''){
          first = true;
        }
      }else{
        first = true;
      }
      log(result.user.toString());
      return(result.user,null,first);
    }on FirebaseAuthException catch (e){
      log(e.code);
      return (null,authErrors.error(e.code),first);
    }
    catch(e){
      log(e.toString());
      return (null,e.toString(),first);
    }
  }
  
  Future<(User?,String?)>signWithgoogle()async{
    try{
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if(googleUser== null){
      log('Sign-in cancelled by user');
      return (null,'Sign-in cancelled by user');
    }
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken
      );
    final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      log(userCredential.user.toString());
    return(userCredential.user,null);

    }catch(e){
      log(e.toString());
      return (null,e.toString());
    }
  }

  



}