import 'package:finote/core/constants/asset_constants.dart';
import 'package:finote/core/constants/color_const.dart';
import 'package:finote/core/constants/text_const.dart';
import 'package:finote/features/auth/widgets/login/card_widget.dart';
import 'package:finote/features/auth/view/register_page.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConst.backgroundColor,
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 100,
                  width: 100,
                  child: Image.asset(
                    fit: BoxFit.cover,
                    AssetConstants.logo),
                ),
                const SizedBox(height: 20),

                const Text(
                  TextConst.signInTitle,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  TextConst.signInSubTitle,
                  style: TextStyle(fontSize: 14, color: ColorConst.blackopacity),
                ),
                const SizedBox(height: 30),

                CardWidget(formkey: _formKey),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(TextConst.createAccount),
                    GestureDetector(
                      onTap: () {
                        // Navigate to sign in
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => RegisterPage(),));
                      },
                      child: const Text(
                        TextConst.signup,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

 
}
