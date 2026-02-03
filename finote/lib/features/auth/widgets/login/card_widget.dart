import 'package:finote/core/constants/asset_constants.dart';
import 'package:finote/core/constants/color_const.dart';
import 'package:finote/core/constants/text_const.dart';
import 'package:finote/features/auth/view/phone_verify.dart';
import 'package:finote/features/shared/widgets/auth_container_widget.dart';
import 'package:finote/features/bottom%20navigation/view/bottom_navigation.dart';
import 'package:finote/features/business%20profile/view/business_profile_page.dart';
import 'package:finote/features/auth/controller/login_controller.dart';
import 'package:finote/features/shared/widgets/textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CardWidget extends StatelessWidget {
  final GlobalKey<FormState> formkey;
  const CardWidget({super.key, required this.formkey});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: ColorConst.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: formkey,
          child: Consumer<LoginController>(
            builder: (context, value, child) => Column(
              children: [
                const SizedBox(height: 16),
                FormFieldWidget(
                  controller: value.emailController,
                  hint: TextConst.emailfield,
                  icon: Icons.email_outlined,
                  obscureText: false,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return TextConst.emailIsEmpty;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                FormFieldWidget(
                  controller: value.passwordController,
                  hint: TextConst.passfield,
                  icon: Icons.lock_outline,
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  validator: (value) => value != null && value.length < 6
                      ? TextConst.passIsEmpty
                      : null,
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    AuthContainerWidget(
                      path: AssetConstants.google,
                      function: () async {
                        value.googleSign(context);
                        await Future.delayed(Duration(seconds: 3));
                        if (value.error != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              backgroundColor: ColorConst.danger,
                              content: Text(value.error.toString()),
                            ),
                          );
                        }
                      },
                    ),
                    AuthContainerWidget(
                      path: AssetConstants.facebook,
                      function: () {
                        // facebook auth
                      },
                    ),
                    AuthContainerWidget(
                      path: AssetConstants.phone,
                      function: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => PhoneVerifyPage(),));
                        // phone verify
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async{
                      

                     await value.login(formkey, context);

                      if (value.error != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            backgroundColor: ColorConst.danger,
                            content: Text(value.error.toString()),
                          ),
                        );
                        return;
                      }
                      if(value.stats == true){
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            elevation: 10,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            backgroundColor: ColorConst.success,
                            content: Text(TextConst.signInSuccess),
                          ),
                        );
                        if(value.firstTime == true){
                       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BusinessProfilePage(),)); // create business profile

                        }else{
                       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainBottomNavScreen(),)); // to home

                        }
                        return;
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorConst.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                    ),
                    iconAlignment: IconAlignment.end,
                    icon: Icon(
                      Icons.arrow_forward_sharp,
                      color: ColorConst.white,
                    ),
                    label: value.loading==true? CircularProgressIndicator(color: ColorConst.white,): Text(
                      TextConst.signin,
                      style: TextStyle(fontSize: 16, color: ColorConst.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
