import 'package:first/features/login/constant/text_constant.dart';
import 'package:first/features/login/controller/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:first/core/constants/text_constant.dart';


class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final formkey =GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        title: Text(TextConstants.login),
      ),
      body: Center(
        child: Consumer<LoginController>(
          builder: (context, value, child) =>Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
               Form(
                key: formkey,
                child: Column(
                children: [
                   Row(
                  children: [
                    Text(APPTextConstant.email),
                  ],
                ),
                TextFormField(
                  validator: (val) {
                    if(val == null || val.isEmpty){
                      return 'Enter a email';
                    }
                    return null;
                  },
                  controller: value.emailController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: APPTextConstant.email,
                    errorBorder: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10))
                  ),
                ),
                Row(
                  children: [
                    Text(APPTextConstant.password),
                  ],
                ),
                TextFormField(
                  validator: (val) {
                    if(val == null || val.isEmpty){
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
                    disabledBorder: OutlineInputBorder()
                  ),
                ),
                ElevatedButton(onPressed: ()async{
                  value.check(formkey, context);
                }, child: Text(TextConstants.login))
                ],
               )),
               Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(onPressed: (){
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage(),));
                    }, child: Text(TextConstants.signUp,style: TextStyle(color: Colors.purple),))
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