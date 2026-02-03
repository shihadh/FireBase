import 'dart:developer';
import 'package:finote/features/AddTransaction/controller/add_tansaction_controller.dart';
import 'package:finote/features/auth/controller/phone_verify_controller.dart';
import 'package:finote/features/auth/view/auth_gate.dart';
import 'package:finote/features/bottom%20navigation/controller/bottom_navigation_controller.dart';
import 'package:finote/features/business%20profile/controller/business_controller.dart';
import 'package:finote/features/auth/controller/login_controller.dart';
import 'package:finote/features/business%20profile/controller/update_business_controller.dart';
import 'package:finote/features/profile/controller/profile_controller.dart';
import 'package:finote/features/auth/controller/register_controller.dart';
import 'package:finote/features/shared/service/notification_service.dart';
import 'package:finote/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
    void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    // Initialize timezone
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Asia/Kolkata'));

    // Request permissions for iOS
  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );
  // Optional: handle background message
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Local notifications setup
  const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings settings = InitializationSettings(android: androidSettings);
  await flutterLocalNotificationsPlugin.initialize(
 settings: settings,
  onDidReceiveNotificationResponse: (NotificationResponse response) {
    // Handle notification tap here
    // For example, navigate to a page
    log('Notification tapped: ${response.payload}');  
  },
);
final notificationService = NotificationService(flutterLocalNotificationsPlugin);
// Schedule daily reminder at 9:00 AM
notificationService.scheduleDailyReminder(
  id: 1,
  title: "Finote Reminder",
  body: "Don't forget to add your transaction today!",
  hour: 9,
  minute: 0,
);

// Schedule 7-day inactivity reminder
notificationService.scheduleInactivityReminder(
  id: 2,
  title: "We miss you!",
  body: "You haven't logged in for 7 days. Come back and add your transactions!",
);

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => RegisterController(),),
      ChangeNotifierProvider(create: (context) => LoginController(),),
      ChangeNotifierProvider(create: (context) => BusinessController(),),
      ChangeNotifierProvider(create: (context) => BottomNavigationController(),),
      ChangeNotifierProvider(create: (context) => ProfileController(),),
      ChangeNotifierProvider(create: (context) => UpdateBusinessController(),),
      ChangeNotifierProvider(create: (context) => AddTansactionController(),),
      ChangeNotifierProvider(create: (context) => PhoneVerifyController(),),
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
      home:AuthGate(),
    );
  }
}

// Background handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  // Handle background message if needed
}
