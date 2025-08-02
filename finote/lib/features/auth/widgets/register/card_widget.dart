import 'package:finote/core/constants/asset_constants.dart';
import 'package:finote/core/constants/color_const.dart';
import 'package:finote/core/constants/text_const.dart';
import 'package:finote/features/auth/view/phone_verify.dart';
import 'package:finote/features/shared/widgets/auth_container_widget.dart';
import 'package:finote/features/auth/view/login.dart';
import 'package:finote/features/auth/controller/register_controller.dart';
import 'package:finote/features/shared/widgets/textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CardWidget extends StatelessWidget {
  final GlobalKey<FormState> formkey;
  const CardWidget({super.key, required this.formkey});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: formkey,
          child: Consumer<RegisterController>(
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
                const SizedBox(height: 16),
                FormFieldWidget(
                  controller: value.confirmPasswordController,
                  hint: TextConst.comformPassfield,
                  keyboardType: TextInputType.text,
                  icon: Icons.lock_outline,
                  obscureText: true,
                  validator: (val) => val != value.passwordController.text
                      ? TextConst.matchPass
                      : null,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    AuthContainerWidget(
                      path: AssetConstants.google,
                      function: () async{
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
                        // phone verify
                        Navigator.push(context, MaterialPageRoute(builder: (context) => PhoneVerifyPage(),));

                      },
                      ),
                  ],
                ),
                const SizedBox(height: 20),

                Row(
                  children: [
                    Checkbox(
                      side: BorderSide(color: ColorConst.black),
                      activeColor: ColorConst.transparent,
                      checkColor: ColorConst.success,
                      value: value.agreeTerms,
                      onChanged: (val) => value.checkbox(val!),
                    ),
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          children: [
                            const TextSpan(text: TextConst.privacy1),
                            TextSpan(
                              text: TextConst.privacy2,
                              style: const TextStyle(
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const TextSpan(text: TextConst.privacy3),
                            TextSpan(
                              text: TextConst.privacy4,
                              style: const TextStyle(
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: ()async{
                      if (!value.agreeTerms) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            backgroundColor: ColorConst.danger,
                            content: Text(
                              TextConst.checkPrivacy,
                            ),
                          ),
                        );
                        return;
                      }

                     await value.register(formkey, context);
                      
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
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            backgroundColor: ColorConst.success,
                            content: Text(TextConst.signUpSuccess),
                          ),
                        );
                       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage(),));
                        return;
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorConst.grey,
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
                      TextConst.signup,
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
