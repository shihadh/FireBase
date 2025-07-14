import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  Future<(User?,String?)>register (String email, String password)async{
    try{
      log("message");
      UserCredential result = await auth.createUserWithEmailAndPassword(email: email, password: password);
    return (result.user,null);
    }on FirebaseAuthException catch(e){
      if(e.code == 'Weak-password'){
        log("The password provided is too weak.");
        return (null,"The password provided is too weak.");
      }else if(e.code =='email-already-in-use'){
        log('email alredy existed');
        return(null,'email alredy existed');
      }else{
        log('FirebaseAuth error: ${e.message}');
        return(null,e.message);
      }
    }
    catch(e){
      return (null,e.toString());
    }
  }

  Future<(User?,String?)>login(String email, String password)async{
    try{
      UserCredential result = await auth.signInWithEmailAndPassword(email: email, password: password);
      return (result.user,null);
    }on FirebaseAuthException catch (e){
      if(e.code == 'user-not-found'){
        log("user not found");
        return(null,"user not found");
      }else if(e.code == 'wrong-password'){
        log("wrong password");
        return(null,"wrong password");
      }
      else{
        log('error on login${e.message}');
        return(null,e.message);
      }
    }
    
    catch(e){
      throw Exception(e);
    }
  }

  Future<void>logout()async{
    await auth.signOut();
  }
}