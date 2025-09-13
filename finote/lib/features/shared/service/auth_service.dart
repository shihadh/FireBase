import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finote/core/errors/auth_errors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

AuthErrors authErrors = AuthErrors();

class AuthService {
  final firebase = FirebaseAuth.instance;
  bool first = false;
  Future<(User?, String?)> register(String email, String password) async {
    try {
      UserCredential result = await firebase.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      log(result.user.toString());
      return (result.user, null);
    } on FirebaseAuthException catch (e) {
      log(e.code);
      return (null, authErrors.error(e.code));
    } catch (e) {
      log(e.toString());
      return (null, e.toString());
    }
  }

  Future<(User?, String?, bool)> login(String email, String password) async {
    try {
      UserCredential result = await firebase.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final doc = await FirebaseFirestore.instance
          .collection('profile')
          .doc(uid)
          .get();

      if (doc.exists) {
        final data = doc.data();
        if (data?['name'] == '' &&
            data?['currency'] == '' &&
            data?['Gst_id'] == '') {
          first = true;
          log("first time");
        }
      } else {
        log('first time');
        first = true;
      }
      log(result.user.toString());
      return (result.user, null, first);
    } on FirebaseAuthException catch (e) {
      log(e.code);
      return (null, authErrors.error(e.code), first);
    } catch (e) {
      log(e.toString());
      return (null, e.toString(), first);
    }
  }

  Future<(User?, String?, bool)> signWithgoogle() async {
    try {
      await GoogleSignIn().disconnect().catchError((_){
        return GoogleSignIn().signOut();
      });
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        log('Sign-in cancelled by user');
        return (null, 'Sign-in cancelled by user', first);
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final userCredential = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );
      final uid = userCredential.user!.uid;

      final doc = await FirebaseFirestore.instance
          .collection('profile')
          .doc(uid)
          .get();
      if (!doc.exists ||
          (doc.data()?['name'] == '' &&
              doc.data()?['currency'] == '' &&
              doc.data()?['Gst_id'] == '')) {
        first = true;
        log('First time login');
      }
      log(userCredential.user.toString());
      return (userCredential.user, null, first);
    } catch (e) {
      log(e.toString());
      return (null, e.toString(), first);
    }
  }

  Future<(bool,String?,String?)>phoneVerification(String phoneNumber)async{
    try{
      final completer = Completer<(bool, String?, String?)>();
      String? error;
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential)async{
          await FirebaseAuth.instance.signInWithCredential(credential);
          completer.complete((true,null,null));
        }, 
        verificationFailed: (FirebaseAuthException e){
          error = e.code == 'invalid-phone-number' ? 'The provided phone number is not valid.': e.message;
    
        error = e.code.toString();
        completer.complete((false,error,null));
        },
        codeSent: (String verificationId, int? resendToken)async{
          log("service $verificationId");
          completer.complete((true,null,verificationId));
        },
        codeAutoRetrievalTimeout: (String verificationId){}
        );

        return completer.future;
    }catch(e){
      return (false,e.toString(),null);
    }
  }

  Future<(bool,String?,bool)>otpVerification(String otp, String verificationId)async{
    try{
      final credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: otp);
      final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      final uid = userCredential.user?.uid;
      if (uid == null) {
      return (true, "User ID not found",first);
    }

    final doc = await FirebaseFirestore.instance
        .collection('profile')
        .doc(uid)
        .get();

    if (!doc.exists ||
        (doc.data()?['name'] == '' &&
         doc.data()?['currency'] == '' &&
         doc.data()?['Gst_id'] == '')) {
      first = true;
      log('First time login');
    }
      log(credential.toString());
      return (true,null,first);
    }catch(e){
      log(e.toString());
      return (false,e.toString(),first);
    }
  }
  Future<(bool?, String?)> singOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      log('sign out success');

      return (true, null);
    } catch (e) {
      log(e.toString());
      return (false, e.toString());
    }
  }
}
