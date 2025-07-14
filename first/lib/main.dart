import 'package:firebase_core/firebase_core.dart';
import 'package:first/features/home/controller/home_controller.dart';
import 'package:first/features/login/controller/login_controller.dart';
import 'package:first/features/profile/controller/create_controller.dart';
import 'package:first/features/register/controller/register_controller.dart';
import 'package:first/features/register/view/register.dart';
import 'package:first/features/update/controller/update_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => RegisterController()),
        ChangeNotifierProvider(create: (context) => LoginController()),
        ChangeNotifierProvider(create: (context) => CreateController()),
        ChangeNotifierProvider(create: (context) => HomeController(),),
        ChangeNotifierProvider(create: (context) => UpdateController(),)
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: RegisterPage());
  }
}
