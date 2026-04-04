import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import '../morning_azkar_page.dart';
import '../evening_azkar_page.dart';
import '../prayer_times_page.dart';
import '../masbaha_page.dart';
import '../sonan_page.dart';
import '../doaa_page.dart';
import '../quran_page.dart';
import '../moshaf_page.dart';
import '../home_page.dart';

/// المفتاح العام للـ Navigator — يُستخدم في MaterialApp
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

/// ───────────────────────────────────────────────
/// لما التطبيق يُفتح من إشعار وهو مغلق تماماً،
/// بنخزن اسم الصفحة هنا ونفتحها بعد ما الـ SplashScreen تخلص
/// ───────────────────────────────────────────────
String? pendingNotificationScreen;

class FirebaseMessagingService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static const String _screenKey = 'screen';
  static const String _paramsKey = 'params';

  // ─── Background Handler ──────────────────────────────────────────────────
  // ⚠️ هذه الدالة تشتغل في isolate منفصل تماماً عن الـ UI
  // لا يجوز هنا عمل navigator أو أي عملية UI
  // دورها فقط: استقبال الإشعار وحفظه إذا لزم (SharedPreferences مثلاً)
  @pragma('vm:entry-point')
  static Future<void> backgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp();
    // لا تفعل أي navigator هنا — مستحيل من background isolate
    debugPrint('📩 Background received: ${message.notification?.title}');
  }

  // ─── init ────────────────────────────────────────────────────────────────
  static Future<void> init() async {
    FirebaseMessaging.onBackgroundMessage(backgroundHandler);

    // طلب الإذن
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // الـ Token
    final token = await _messaging.getToken();
    debugPrint('🔥 FCM TOKEN = $token');
    _messaging.onTokenRefresh.listen((t) => debugPrint('♻️ NEW TOKEN = $t'));

    // تهيئة الإشعارات المحلية
    await _initLocalNotifications();

    // ── Foreground: التطبيق مفتوح → عرض إشعار محلي فقط ──────────────────
    FirebaseMessaging.onMessage.listen((message) {
      debugPrint('📩 Foreground: ${message.notification?.title}');
      if (message.notification != null) {
        _showLocalNotification(
          message.notification!.title ?? '',
          message.notification!.body ?? '',
          message.data,
        );
      }
    });

    // ── Background → Foreground: المستخدم ضغط على الإشعار ──────────────────
    // هنا التطبيق كان شغال في الخلفية والمستخدم فتحه عبر الإشعار
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      debugPrint('🚀 onMessageOpenedApp: ${message.data}');
      // Navigator موجود بالفعل → نفتح الصفحة مباشرة
      _openScreenFromData(message.data);
    });

    // ── Terminated → Open: التطبيق كان مغلق تماماً ──────────────────────────
    // هنا Navigator مش موجود بعد → نخزن الصفحة ونفتحها من SplashScreen
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      debugPrint('📱 Opened from terminated: ${initialMessage.data}');
      pendingNotificationScreen = initialMessage.data[_screenKey];
    }
  }

  // ─── فتح الصفحة المطلوبة مباشرة (عندما يكون Navigator موجوداً) ───────────
  static void _openScreenFromData(Map<String, dynamic> data) {
    final screen = data[_screenKey] as String?;
    if (screen == null || screen.isEmpty) {
      _goHome();
      return;
    }
    _navigateToScreen(screen);
  }

  // ─── Navigation بعد SplashScreen ─────────────────────────────────────────
  /// تُستدعى من SplashScreen بعد انتهاء التأخير
  /// إذا في pending screen → تفتح الـ HomePage ثم الصفحة المطلوبة
  /// إذا لا → تفتح الـ HomePage فقط
  static void handlePendingNavigation() {
    final screen = pendingNotificationScreen;
    pendingNotificationScreen = null; // امسح بعد الاستهلاك

    if (screen == null || screen.isEmpty) {
      _goHome();
      return;
    }

    // افتح HomePage أولاً كـ root ثم الصفحة المطلوبة فوقها
    if (navigatorKey.currentContext == null) {
      debugPrint('⚠️ handlePendingNavigation: context not ready');
      return;
    }

    // مسح كل الـ stack وفتح HomePage كـ root
    navigatorKey.currentState!.pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => HomePage()),
      (route) => false,
    );

    // بعد ما HomePage تتعرض، افتح الصفحة المطلوبة فوقيها
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _navigateToScreen(screen);
    });
  }

  // ─── Navigation مباشر (onMessageOpenedApp) ───────────────────────────────
  static void _navigateToScreen(String screen) {
    final ctx = navigatorKey.currentContext;
    if (ctx == null) {
      debugPrint('⚠️ _navigateToScreen: context null, screen=$screen');
      return;
    }

    // امسح كل اللي فوق الأول وافتح HomePage
    Navigator.of(ctx).popUntil((route) => route.isFirst);

    final Widget? page = _buildPage(screen);
    if (page == null) {
      // screen غير معروف → ابقى على HomePage
      return;
    }

    Navigator.of(ctx).push(
      MaterialPageRoute(
        builder: (_) => page,
        settings: RouteSettings(name: screen),
      ),
    );
  }

  static Widget? _buildPage(String screen) {
    switch (screen) {
      case 'prayer_times':   return PrayerTimesPage();
      case 'morning_azkar':  return MorningAzkarPage();
      case 'evening_azkar':  return EveningAzkarPage();
      case 'misbaha':        return MisbahaPage();
      case 'sonan':          return SonanRawatibPage();
      case 'doaa':           return DoaaPage();
      case 'quran':          return QuranPage();
      case 'moshaf':         return MoshafPage();
      default:               return null;
    }
  }

  static void _goHome() {
    final ctx = navigatorKey.currentContext;
    if (ctx == null) return;
    Navigator.of(ctx).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => HomePage()),
      (route) => false,
    );
  }

  // ─── Local Notifications ─────────────────────────────────────────────────
  static Future<void> _initLocalNotifications() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    await _localNotifications.initialize(
      const InitializationSettings(android: androidSettings),
      onDidReceiveNotificationResponse: (response) {
        if (response.payload == null) return;
        try {
          final data = jsonDecode(response.payload!) as Map<String, dynamic>;
          final screen = data[_screenKey] as String?;
          if (screen != null) _navigateToScreen(screen);
        } catch (e) {
          debugPrint('❌ payload parse error: $e');
        }
      },
    );

    const channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      importance: Importance.max,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  static Future<void> _showLocalNotification(
    String title,
    String body,
    Map<String, dynamic> data,
  ) async {
    const androidDetails = AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    final payload = jsonEncode({
      _screenKey: data[_screenKey],
      _paramsKey: data[_paramsKey],
    });

    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch % 100000,
      title,
      body,
      const NotificationDetails(android: androidDetails),
      payload: payload,
    );
  }
}