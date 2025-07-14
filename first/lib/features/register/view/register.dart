import 'package:first/core/constants/text_constant.dart';
import 'package:first/features/login/view/login.dart';
import 'package:first/features/register/constant/text_constants.dart';
import 'package:first/features/register/controller/register_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});
  @override
  Widget build(BuildContext context) {
    final formkey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(title: Text(TextConstant.register)),
      body: Center(
        child: Consumer<RegisterController>(
          builder: (context, value, child) => Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Form(
                  key: formkey,
                  child: Column(
                    children: [
                      Row(children: [Text(APPTextConstant.email)]),
                      TextFormField(
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return 'Enter a email';
                          }
                          return null;
                        },
                        controller: value.emailController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: APPTextConstant.email,
                          errorBorder: OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      Row(children: [Text(APPTextConstant.password)]),
                      TextFormField(
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return 'Enter a passsword';
                          }
                          return null;
                        },
                        controller: value.passController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          errorBorder: OutlineInputBorder(),
                          hintText: APPTextConstant.password,
                          enabledBorder: OutlineInputBorder(),
                          disabledBorder: OutlineInputBorder(),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          value.check(formkey, context);
                        },
                        child: Text(TextConstant.register),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(onPressed: (){
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage(),));
                    }, child: Text(TextConstant.signIn,style: TextStyle(color: Colors.purple),))
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
