import 'package:finote/features/AddTransaction/controller/add_tansaction_controller.dart';
import 'package:finote/features/AddTransaction/view/add_transaction_page.dart';
import 'package:finote/features/bottom%20navigation/controller/bottom_navigation_controller.dart';
import 'package:finote/features/business%20profile/controller/business_controller.dart';
import 'package:finote/features/auth/controller/login_controller.dart';
import 'package:finote/features/business%20profile/controller/update_business_controller.dart';
import 'package:finote/features/profile/controller/profile_controller.dart';
import 'package:finote/features/auth/controller/register_controller.dart';
import 'package:finote/features/auth/view/register_page.dart';
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
      ChangeNotifierProvider(create: (context) => BottomNavigationController(),),
      ChangeNotifierProvider(create: (context) => ProfileController(),),
      ChangeNotifierProvider(create: (context) => UpdateBusinessController(),),
      ChangeNotifierProvider(create: (context) => AddTansactionController(),),
    ],
    child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // theme:ThemeData(useMaterial3: true),
      debugShowCheckedModeBanner: false,
      home:RegisterPage(),
    );
  }
}