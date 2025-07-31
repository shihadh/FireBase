import 'dart:developer';

import 'package:finote/core/constants/text_const.dart';
import 'package:finote/features/shared/service/auth_service.dart';
import 'package:flutter/material.dart';

class PhoneVerifyController extends ChangeNotifier{

  final phoneController = TextEditingController();
  final otpController = TextEditingController();
  AuthService authService = AuthService();
  String? error;
  String? verification;
  bool stat = false;
  bool isSendingOtp = false;
  bool isVerifyingOtp = false;
  bool first = false;

  Future<void> sendOtp()async{
  isSendingOtp = true;
  notifyListeners();
    error = null;
    verification = null;
    var (status,errors,verifications) = await authService.phoneVerification("+91${phoneController.text.trim()}");
    if(errors != null){
      log("message");
      log(" --$errors");
      error = errors;
    }
    if(status == true){
      stat =true;
      if(verifications != null){
        log("message $verifications");
        verification = verifications;
      }
    }
  isSendingOtp = false;
    notifyListeners();
  }

  Future<void> verifyOtp()async{
  isVerifyingOtp = true;
  notifyListeners();
    error = null;
    log("very - $verification");
    var (status,errors,firstTime) = await authService.otpVerification(otpController.text.trim(), verification ?? TextConst.nonValue);
    if(errors != null){
      error = errors;
    }
    if(status == true){
      stat =true;
      first= firstTime;
      phoneController.clear();
      otpController.clear();
    }
  isVerifyingOtp = false;
    notifyListeners();
  }


}