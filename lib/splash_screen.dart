import 'package:flutter/material.dart';
import 'services/fcm_service.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(const Duration(milliseconds: 2000));
    // handlePendingNavigation تتحقق إذا في إشعار انتظر:
    //   ✅ في إشعار → تفتح HomePage ثم الصفحة المطلوبة
    //   ✅ مفيش إشعار → تفتح HomePage فقط
    FirebaseMessagingService.handlePendingNavigation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1E1E1E),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image.asset(
            //   'assets/images/app_icon.png',
            //   width: 120,
            //   height: 120,
            // ),
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Color(0xFFFFD700),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFFFFD700).withOpacity(0.5),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                Icons.mosque,
                color: Colors.black,
                size: 60,
              ),
            ),
            SizedBox(height: 30),
            // اسم التطبيق
            Text(
              'صدقة جارية',
              style: TextStyle(
                color: Color(0xFFFFD700),
                fontSize: 32,
                fontFamily: 'Thuluth',
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            // وصف صغير
            Text(
              'تطبيق إسلامي متكامل',
              style: TextStyle(
                color: Color(0xFFE0E0E0),
                fontSize: 16,
                fontFamily: 'Cairo',
              ),
            ),
          ],
        ),
      ),
    );
  }
}