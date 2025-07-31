import 'package:finote/core/constants/color_const.dart';
import 'package:finote/core/constants/text_const.dart';
import 'package:finote/features/auth/controller/phone_verify_controller.dart';
import 'package:finote/features/auth/widgets/phone%20verify/container_widget.dart';
import 'package:finote/features/bottom%20navigation/view/bottom_navigation.dart';
import 'package:finote/features/business%20profile/view/business_profile_page.dart';
import 'package:finote/features/shared/widgets/bold_text_widget.dart';
import 'package:finote/features/shared/widgets/normal_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PhoneVerifyPage extends StatelessWidget {
  const PhoneVerifyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final phoneFormKey = GlobalKey<FormState>();
    final otpFormKey = GlobalKey<FormState>();
    final provider = Provider.of<PhoneVerifyController>(context);

    return Scaffold(
      backgroundColor: ColorConst.backgroundColor,
      appBar: AppBar(backgroundColor:ColorConst.backgroundColor,),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: ListView(
            children: [
              Column(
              children: [
                ContainerWidget(),
                const SizedBox(height: 24),
                BoldTextWidget(title: TextConst.phoneTitle, size: 24),
                NormalTextWidget(
                  title: TextConst.phoneSubTitle,
                  size: 14,
                  color: ColorConst.blackopacity,
                ),
                const SizedBox(height: 24),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        Form(
                          key: phoneFormKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              BoldTextWidget(
                                title: TextConst.phoneNumber,
                                size: 15,
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: provider.phoneController,
                                keyboardType: TextInputType.phone,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Phone number is required';
                                  } else if (value.length < 10) {
                                    return 'Enter valid phone number';
                                  }
                                  return null;
                                },
                                decoration: inputDecoration(
                                  TextConst.phoneNumberField,
                                ),
                              ),
                              const SizedBox(height: 24),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        if (phoneFormKey.currentState!
                                            .validate()) {
                                          await provider.sendOtp();
            
                                          if (provider.error != null) {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                behavior:
                                                    SnackBarBehavior.floating,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.all(
                                                    Radius.circular(10),
                                                  ),
                                                ),
                                                backgroundColor:
                                                    ColorConst.danger,
                                                content: Text(
                                                  provider.error.toString(),
                                                ),
                                              ),
                                            );
                                            return;
                                          }
                                          if (provider.stat == true) {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                elevation: 10,
                                                behavior:
                                                    SnackBarBehavior.floating,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.all(
                                                    Radius.circular(10),
                                                  ),
                                                ),
                                                backgroundColor:
                                                    ColorConst.success,
                                                content: Text(
                                                  TextConst.sendSucess,
                                                ),
                                              ),
                                            );
                                          }
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: ColorConst.black,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 16,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                      child:provider.isSendingOtp == true ? CircularProgressIndicator(color: ColorConst.white,): NormalTextWidget(
                                        title:  TextConst.sendOtp,
                                        color: ColorConst.white,
                                        size: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        Form(
                          key: otpFormKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              BoldTextWidget(title: TextConst.otp, size: 15),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: provider.otpController,
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'OTP is required';
                                  } else if (value.length < 6) {
                                    return 'Enter valid 6-digit OTP';
                                  }
                                  return null;
                                },
                                decoration: inputDecoration(TextConst.otpField),
                              ),
                              const SizedBox(height: 24),
                              ElevatedButton(
                                onPressed: () async{
                                  if (otpFormKey.currentState!.validate()){
                                    await provider.verifyOtp();
                                    if (provider.error != null) {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                behavior:
                                                    SnackBarBehavior.floating,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.all(
                                                    Radius.circular(10),
                                                  ),
                                                ),
                                                backgroundColor:
                                                    ColorConst.danger,
                                                content: Text(
                                                  provider.error.toString(),
                                                ),
                                              ),
                                            );
                                            return;
                                          }
                                          if (provider.stat == true) {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                elevation: 10,
                                                behavior:
                                                    SnackBarBehavior.floating,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.all(
                                                    Radius.circular(10),
                                                  ),
                                                ),
                                                backgroundColor:
                                                    ColorConst.success,
                                                content: Text(
                                                  TextConst.verified,
                                                ),
                                              ),
                                            );
                                            if(provider.first == true){
                                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BusinessProfilePage(),));

                                            }else{
                                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainBottomNavScreen(),));
                                            }
                                          }
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ColorConst.black,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child:provider.isVerifyingOtp == true ? CircularProgressIndicator(color: ColorConst.white,): NormalTextWidget(
                                  title: TextConst.verify,
                                  color: ColorConst.white,
                                  size: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            ]
          ),
        ),
      ),
    );
  }

  InputDecoration inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: ColorConst.greyopacity,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }
}
