import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:prompt_polisher_ai/controller/home_controller.dart';
import 'package:prompt_polisher_ai/firebase_options.dart';
import 'package:prompt_polisher_ai/view/home.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(ChangeNotifierProvider(create: (context) => HomeController(),child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
