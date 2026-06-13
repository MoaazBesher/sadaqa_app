import 'dart:convert';
import 'package:home_widget/home_widget.dart';
import 'package:http/http.dart' as http;

class WidgetService {
  static const String _prayerTimesKey = 'prayer_times';
  static const String _dailyMessageKey = 'daily_message';
  static const String _nextPrayerKey = 'next_prayer';
  static const String _nextPrayerTimeKey = 'next_prayer_time';
  static const String _countdownKey = 'countdown';

  static const String _prayerTimesProvider = 'PrayerTimesWidgetProvider';
  static const String _dailyMessageProvider = 'DailyMessageWidgetProvider';

  static Future<void> updateDailyMessageWidget(String message) async {
    await HomeWidget.saveWidgetData<String>(_dailyMessageKey, message);
    await HomeWidget.updateWidget(androidName: _dailyMessageProvider);
  }

  static Future<void> updatePrayerTimesWidget() async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://api.aladhan.com/v1/timingsByCity?city=Cairo&country=Egypt&method=5'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final timings = data['data']['timings'];
        final hijri = data['data']['date']['hijri'];

        final prayerNames = ['الفجر', 'الظهر', 'العصر', 'المغرب', 'العشاء'];
        final apiKeys = ['Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];

        Map<String, String> prayerMap = {};
        for (int i = 0; i < prayerNames.length; i++) {
          prayerMap[prayerNames[i]] = timings[apiKeys[i]]?.toString() ?? '';
        }

        final nextPrayerInfo = _getNextPrayer(prayerMap);
        final prayerTimesText = _formatPrayerTimes(prayerMap);

        await HomeWidget.saveWidgetData<String>(
            _prayerTimesKey, prayerTimesText);
        await HomeWidget.saveWidgetData<String>(
            _nextPrayerKey, nextPrayerInfo['name']!);
        await HomeWidget.saveWidgetData<String>(
            _nextPrayerTimeKey, nextPrayerInfo['time']!);
        await HomeWidget.saveWidgetData<String>(
            _countdownKey, nextPrayerInfo['countdown']!);
      } else {
        _saveDefaultData();
      }
    } catch (e) {
      _saveDefaultData();
    }

    await HomeWidget.updateWidget(androidName: _prayerTimesProvider);
  }

  static Map<String, String> _getNextPrayer(Map<String, String> prayerMap) {
    final now = DateTime.now();
    final currentMinutes = now.hour * 60 + now.minute;

    final prayerOrder = ['الفجر', 'الظهر', 'العصر', 'المغرب', 'العشاء'];
    final apiKeys = ['Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];

    String? nextPrayer;
    int? nextPrayerMinutes;
    String? nextPrayerTimeStr;

    for (int i = 0; i < prayerOrder.length; i++) {
      final timeStr = prayerMap[prayerOrder[i]]!;
      final parts = timeStr.split(':');
      if (parts.length == 2) {
        final minutes = int.parse(parts[0]) * 60 + int.parse(parts[1]);
        if (minutes > currentMinutes) {
          nextPrayer = prayerOrder[i];
          nextPrayerMinutes = minutes;
          nextPrayerTimeStr = _formatTime(timeStr);
          break;
        }
      }
    }

    if (nextPrayer == null) {
      nextPrayer = 'الفجر';
      final fajrParts = prayerMap['الفجر']!.split(':');
      nextPrayerMinutes =
          (int.parse(fajrParts[0]) * 60 + int.parse(fajrParts[1])) + 24 * 60;
      nextPrayerTimeStr = _formatTime(prayerMap['الفجر']!);
    }

    final diff = nextPrayerMinutes! - currentMinutes;
    final hours = diff ~/ 60;
    final minutes = diff % 60;

    String countdown;
    if (hours > 0) {
      countdown = 'متبقي $hours ساعة و $minutes دقيقة';
    } else {
      countdown = 'متبقي $minutes دقيقة';
    }

    return {
      'name': nextPrayer ?? 'العشاء',
      'time': nextPrayerTimeStr ?? '--:--',
      'countdown': countdown,
    };
  }

  static String _formatPrayerTimes(Map<String, String> prayerMap) {
    final prayerOrder = ['الفجر', 'الظهر', 'العصر', 'المغرب', 'العشاء'];
    final buffer = StringBuffer();

    for (final prayer in prayerOrder) {
      final formatted = _formatTime(prayerMap[prayer] ?? '');
      buffer.writeln('$prayer  $formatted');
    }

    return buffer.toString().trim();
  }

  static String _formatTime(String apiTime) {
    final parts = apiTime.split(':');
    if (parts.length < 2) return apiTime;

    int hour = int.parse(parts[0]);
    final minute = parts[1];
    String period = 'ص';

    if (hour >= 12) {
      period = 'م';
      if (hour > 12) hour -= 12;
    }
    if (hour == 0) hour = 12;

    return '$hour:$minute $period';
  }

  static Future<void> _saveDefaultData() async {
    await HomeWidget.saveWidgetData<String>(_prayerTimesKey,
        'الفجر    5:12 ص\nالظهر    11:53 م\nالعصر    3:29 م\nالمغرب    6:00 م\nالعشاء    7:30 م');
    await HomeWidget.saveWidgetData<String>(_nextPrayerKey, 'العصر');
    await HomeWidget.saveWidgetData<String>(_nextPrayerTimeKey, '3:29 م');
    await HomeWidget.saveWidgetData<String>(_countdownKey, 'متبقي 3 ساعات');
  }
}
