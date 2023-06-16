import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traveler/core/constants/appTheme.dart';
import 'package:traveler/core/services/sharedPreferences.dart';
import 'package:traveler/models/NotificationModel.dart';
import 'package:traveler/routes.dart';
import 'package:traveler/view/screens/company_screens/trip_screens/report_screen.dart';

Future<void> backgroundMessage(RemoteMessage event) async {
  print('Handling a background message ${event.messageId}');
  // Handle your background message here
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await initialServices();
  FirebaseMessaging.onBackgroundMessage(backgroundMessage);

  // Handle when the app is opened from a terminated state
  FirebaseMessaging.instance.getInitialMessage().then((message) {
    if (message != null) {
      Get.to(ReportScreen(
        notificationModel: NotificationModel.fromJson(message.data),
      ));
    }
  });

  // Handle when the app is opened from a background state
  FirebaseMessaging.onMessageOpenedApp.listen((message) {
    Get.to(ReportScreen(
      notificationModel: NotificationModel.fromJson(message.data),
    ));
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Traveler-المسافر',
      debugShowCheckedModeBanner: false,
      theme: arabicTheme,
      getPages: pages,
    );
  }
}
