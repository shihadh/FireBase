import 'package:finote/features/business%20profile/controller/business_controller.dart';
import 'package:finote/features/business%20profile/view/business_profile_page.dart';
import 'package:finote/features/login/controller/login_controller.dart';
import 'package:finote/features/register/controller/register_controller.dart';
import 'package:finote/features/register/view/register_page.dart';
import 'package:finote/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => RegisterController(),),
      ChangeNotifierProvider(create: (context) => LoginController(),),
      ChangeNotifierProvider(create: (context) => BusinessController(),),
    ],
    child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BusinessProfilePage(),
    );
  }
}