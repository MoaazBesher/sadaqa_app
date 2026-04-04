import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:clipboard/clipboard.dart';

class UpdateChecker {
  static bool _isUpdateAppInitialized = false;

  static Future<void> checkForUpdate(BuildContext context) async {
    try {
      if (!_isUpdateAppInitialized) {
        final updateApp = await Firebase.initializeApp(
          name: 'update_app',
          options: const FirebaseOptions(
            apiKey: "AIzaSyCBD69DesZAHSjAg5AjiBIBpog-ZJyyXYs",
            authDomain: "study-sources.firebaseapp.com",
            projectId: "study-sources",
            storageBucket: "study-sources.firebasestorage.app",
            messagingSenderId: "241479336412",
            appId: "1:241479336412:web:630bf88750531faf7ecf19",
          ),
        );
        _isUpdateAppInitialized = true;
        debugPrint('Application update_app initialized successfully.');
      } else {
         debugPrint('Application update_app already initialized.');
      }

      final updateApp = Firebase.app('update_app');
      final firestore = FirebaseFirestore.instanceFor(app: updateApp);

      final doc = await firestore
          .collection('apps')
          .doc('aSKYC6DH3WWBB4pATDSM')
          .get();

      if (!doc.exists) {
        debugPrint('Document does not exist.');
        return;
      }

      final data = doc.data()!;
      final latestVersion = data['version'] ?? '';
      final downloadLink =  'https://sadaqa-mainpage.netlify.app/downloadpage/';
      final shortDesc = data['shortDesc'] ?? '';

      const currentVersion = '1.2.0';

      debugPrint('Current Version: $currentVersion, Latest Version: $latestVersion');
      debugPrint('Download Link: $downloadLink');

      if (latestVersion != currentVersion) {
        _showUpdateDialog(context, latestVersion, downloadLink, shortDesc);
      }
    } catch (e) {
      debugPrint('Error checking update: $e');
    }
  }

  static void _showUpdateDialog(
      BuildContext context, String version, String link, String desc) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (BuildContext dialogContext) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          backgroundColor: Color(0xFF252525),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Color(0xFFFFD700), width: 2),
          ),
          title: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFF1E1E1E),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.system_update, color: Color(0xFFFFD700), size: 28),
                SizedBox(width: 12),
                Text(
                  'تحديث جديد متاح',
                  style: TextStyle(
                    color: Color(0xFFFFD700),
                    fontSize: 22,
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          content: Container(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'الإصدار $version متاح الآن',
                  style: TextStyle(
                    color: Color(0xFFFFD700),
                    fontSize: 18,
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Color(0xFF1E1E1E),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Color(0xFFFFD700).withOpacity(0.3)),
                  ),
                  child: Text(
                    desc,
                    style: TextStyle(
                      color: Color(0xFFE0E0E0),
                      fontSize: 16,
                      fontFamily: 'Cairo',
                      height: 1.5,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
                SizedBox(height: 16),
                if (link.isNotEmpty)
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Color(0xFF1E1E1E),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Color(0xFFFFD700).withOpacity(0.5)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.link, color: Color(0xFFFFD700), size: 16),
                            SizedBox(width: 8),
                            Text(
                              'رابط التحديث:',
                              style: TextStyle(
                                color: Color(0xFFFFD700),
                                fontSize: 14,
                                fontFamily: 'Cairo',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 6),
                        Text(
                          link,
                          style: TextStyle(
                            color: Color(0xFFE0E0E0),
                            fontSize: 12,
                            fontFamily: 'Cairo',
                          ),
                          textAlign: TextAlign.right,
                        ),
                        SizedBox(height: 8),
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Color(0xFF2A2A2A),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.info, color: Color(0xFFFFD700), size: 14),
                              SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  _getLinkTypeInfo(link),
                                  style: TextStyle(
                                    color: Color(0xFFFFD700),
                                    fontSize: 12,
                                    fontFamily: 'Cairo',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.info, color: Color(0xFFFFD700), size: 18),
                    SizedBox(width: 8),
                    Text(
                      'نوصي بالتحديث للحصول على أفضل تجربة',
                      style: TextStyle(
                        color: Color(0xFFFFD700),
                        fontSize: 14,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Color(0xFF1E1E1E),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(14),
                  bottomRight: Radius.circular(14),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // زر لاحقاً
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF444444),
                      foregroundColor: Color(0xFFE0E0E0),
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'لاحقاً',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  
                  // زر تحميل
                  ElevatedButton(
                    onPressed: () async {
                      _handleDownload(dialogContext, link);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFFD700),
                      foregroundColor: Colors.black,
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'تحميل',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _getLinkTypeInfo(String link) {
    if (link.toLowerCase().contains('play.google.com')) {
      return 'سيتم فتح متجر Google Play';
    } else if (link.toLowerCase().contains('apk') || 
               link.toLowerCase().contains('direct') ||
               link.toLowerCase().contains('download')) {
      return 'سيتم تحميل ملف APK مباشر - تأكد من السماح بتثبيت التطبيقات من مصادر غير معروفة';
    } else if (link.toLowerCase().startsWith('http')) {
      return 'سيتم فتح صفحة الويب في المتصفح';
    } else {
      return 'رابط غير معروف - قد يحتاج إلى إعدادات خاصة';
    }
  }

  static Future<void> _handleDownload(BuildContext dialogContext, String link) async {
    if (link.isEmpty) {
      _showErrorDialog(dialogContext, 'رابط التحميل غير متوفر');
      return;
    }

    try {
      debugPrint('محاولة فتح الرابط: $link');
      
      // تنظيف الرابط وإصلاحه إذا needed
      String cleanedLink = _cleanLink(link);
      debugPrint('الرابط بعد التنظيف: $cleanedLink');
      
      final Uri uri = Uri.parse(cleanedLink);
      
      // نحاول نفتح الرابط مباشرة بدون canLaunchUrl
      // لأن canLaunchUrl ممكن مايشتغلش مع بعض أنواع الروابط
      bool launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      
      debugPrint('تم فتح الرابط: $launched');
      
      if (launched) {
        // لو اشتغل، نقفل الديالوج
        Navigator.of(dialogContext).pop();
      } else {
        // لو ماشتغلش، نعرض رسالة مساعدة
        _showLinkHelpDialog(dialogContext, cleanedLink);
      }
    } catch (e) {
      debugPrint('خطأ في فتح الرابط: $e');
      _showErrorDialog(dialogContext, 'حدث خطأ: ${e.toString()}');
    }
  }

  static String _cleanLink(String link) {
    // إزالة المسافات البيضاء
    String cleaned = link.trim();
    
    // التأكد من أن الرابط يبدأ بـ http:// أو https://
    if (!cleaned.toLowerCase().startsWith('http://') && 
        !cleaned.toLowerCase().startsWith('https://')) {
      cleaned = 'https://$cleaned';
    }
    
    return cleaned;
  }

  static void _showLinkHelpDialog(BuildContext context, String link) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          backgroundColor: Color(0xFF252525),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Color(0xFFFFD700), width: 2),
          ),
          title: Row(
            children: [
              Icon(Icons.help, color: Color(0xFFFFD700)),
              SizedBox(width: 8),
              Text(
                'مساعدة في فتح الرابط',
                style: TextStyle(
                  color: Color(0xFFFFD700),
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'تعذر فتح الرابط تلقائياً. يمكنك:',
                style: TextStyle(
                  color: Color(0xFFE0E0E0),
                  fontFamily: 'Cairo',
                ),
              ),
              SizedBox(height: 12),
              Text(
                '1. نسخ الرابط وفتحه يدوياً',
                style: TextStyle(
                  color: Color(0xFFFFD700),
                  fontFamily: 'Cairo',
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: SelectableText(
                  link,
                  style: TextStyle(
                    color: Color(0xFFFFD700),
                    fontFamily: 'Cairo',
                    fontSize: 12,
                  ),
                ),
              ),
              SizedBox(height: 12),
              Text(
                '2. التأكد من إعدادات الأمان للسماح بتثبيت التطبيقات',
                style: TextStyle(
                  color: Color(0xFFFFD700),
                  fontFamily: 'Cairo',
                  fontSize: 14,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text(
                'إلغاء',
                style: TextStyle(
                  color: Color(0xFFE0E0E0),
                  fontFamily: 'Cairo',
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                await FlutterClipboard.copy(link);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('تم نسخ الرابط!', style: TextStyle(fontFamily: 'Cairo')),
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.of(dialogContext).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFFD700),
                foregroundColor: Colors.black,
              ),
              child: Text(
                'نسخ الرابط',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          backgroundColor: Color(0xFF252525),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.red, width: 2),
          ),
          title: Row(
            children: [
              Icon(Icons.error, color: Colors.red),
              SizedBox(width: 8),
              Text(
                'خطأ',
                style: TextStyle(
                  color: Colors.red,
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Text(
            message,
            style: TextStyle(
              color: Color(0xFFE0E0E0),
              fontFamily: 'Cairo',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                'حسناً',
                style: TextStyle(
                  color: Color(0xFFFFD700),
                  fontFamily: 'Cairo',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}