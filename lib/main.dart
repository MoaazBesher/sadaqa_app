import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'home_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'splash_screen.dart';
// import 'morning_azkar_page.dart';
import 'package:firebase_database/firebase_database.dart';
import 'update_checker.dart';
import 'services/fcm_service.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp();
  await FirebaseMessagingService.init();

  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'صدقة جارية',    
      theme: ThemeData(
        primarySwatch: Colors.amber,
        fontFamily: 'Cairo', // الفونت الرئيسي
        useMaterial3: false, // إيقاف Material 3 للأداء
        scaffoldBackgroundColor: Color(0xFF121212),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Color(0xFFE0E0E0), fontFamily: 'Cairo'),
          bodyMedium: TextStyle(color: Color(0xFFE0E0E0), fontFamily: 'Cairo'),
          titleLarge: TextStyle(fontFamily: 'Thuluth'), // للعناوين الكبيرة
        ),
      ),
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
