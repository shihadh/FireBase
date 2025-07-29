import 'dart:developer';

import 'package:finote/core/constants/color_const.dart';
import 'package:finote/core/constants/text_const.dart';
import 'package:finote/features/auth/view/register_page.dart';
import 'package:finote/features/shared/service/auth_service.dart';
import 'package:finote/features/shared/service/business_profile_service.dart';
import 'package:finote/features/business%20profile/model/business_profile_model.dart';
import 'package:flutter/material.dart';

class ProfileController extends ChangeNotifier {
  BusinessProfileModel? profile;
  String? error;
  AuthService authService = AuthService();
  BusinessProfileService businessProfileService = BusinessProfileService();
  void profileData() async {
    error = null;
    var (data, errors) = await businessProfileService.getProfile();
    if (errors != null) {
      error = errors;
      log(error.toString());
    }
    if (data != null) {
      profile = data;
      log(profile?.id ??"");
    }
    notifyListeners();
  }

  Future<void> logout(BuildContext context) async {
    error = null;
    var (satus, errors) = await authService.singOut();
    if (errors != null) {
      error = errors;
    }
    if (satus == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          elevation: 10,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          backgroundColor: ColorConst.success,
          content: Text(TextConst.signOutSucess),
        ),
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => RegisterPage()),
        (route) => false,
      );
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          elevation: 10,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          backgroundColor: ColorConst.danger,
          content: Text(TextConst.signOutUnSucess),
        ),
      );
    }
    notifyListeners();
  }
}
