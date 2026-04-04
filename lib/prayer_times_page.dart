import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';


class PrayerTimesPage extends StatefulWidget {
  @override
  _PrayerTimesPageState createState() => _PrayerTimesPageState();
}

class _PrayerTimesPageState extends State<PrayerTimesPage> with WidgetsBindingObserver {
  Map<String, String> _prayerTimes = {
    'الفجر': '--:--',
    'الظهر': '--:--', 
    'العصر': '--:--',
    'المغرب': '--:--',
    'العشاء': '--:--',
  };

  String _nextPrayerName = 'جاري التحميل...';
  String _countdownText = '00:00:00';
  String _hijriDate = 'جاري التحميل...';
  Timer? _timer;
  bool _isActive = true;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializePrayerTimes();
  }

  @override
  void dispose() {
    _timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      _isActive = false;
      _timer?.cancel();
    } else if (state == AppLifecycleState.resumed) {
      _isActive = true;
      if (mounted) {
        _calculateNextPrayer();
      }
    }
  }

  void _initializePrayerTimes() {
    _fetchPrayerTimes();
  }

  Future<void> _fetchPrayerTimes() async {
    try {
      setState(() {
        _isLoading = true;
      });

      // استخدام API Aladhan للحصول على مواقيت الصلاة حسب الموقع
      final response = await http.get(
        Uri.parse('http://api.aladhan.com/v1/timingsByCity?city=Cairo&country=Egypt&method=5')
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final timings = data['data']['timings'];
        final hijri = data['data']['date']['hijri'];
        
        if (mounted) {
          setState(() {
            _prayerTimes = {
              'الفجر': _formatTime(timings['Fajr']),
              'الظهر': _formatTime(timings['Dhuhr']),
              'العصر': _formatTime(timings['Asr']),
              'المغرب': _formatTime(timings['Maghrib']),
              'العشاء': _formatTime(timings['Isha']),
            };
            _hijriDate = '${hijri['day']} ${hijri['month']['ar']} ${hijri['year']} هـ';
            _isLoading = false;
          });
          _calculateNextPrayer();
        }
      } else {
        _setDefaultTimes();
      }
    } catch (e) {
      print('خطأ في جلب مواقيت الصلاة: $e');
      _setDefaultTimes();
    }
  }

  void _setDefaultTimes() {
    // مواقيت افتراضية في حالة فشل الاتصال
    if (mounted) {
      setState(() {
        _prayerTimes = {
          'الفجر': '05:30 ص',
          'الظهر': '12:15 م', 
          'العصر': '03:45 م',
          'المغرب': '06:00 م',
          'العشاء': '07:30 م',
        };
        _hijriDate = 'تاريخ غير متوفر';
        _isLoading = false;
      });
      _calculateNextPrayer();
    }
  }

  String _formatTime(String apiTime) {
    try {
      final parts = apiTime.split(':');
      int hour = int.parse(parts[0]);
      final minute = parts[1];
      
      String period = 'ص';
      if (hour >= 12) {
        period = 'م';
        if (hour > 12) hour -= 12;
      }
      if (hour == 0) hour = 12;
      
      return '$hour:$minute $period';
    } catch (e) {
      return apiTime;
    }
  }

  void _calculateNextPrayer() {
    if (!_isActive || !mounted || _isLoading) return;

    final now = DateTime.now();
    final currentMinutes = now.hour * 60 + now.minute;
    
    String? nextPrayer;
    int? nextPrayerMinutes;

    final prayerOrder = ['الفجر', 'الظهر', 'العصر', 'المغرب', 'العشاء'];
    
    for (final prayer in prayerOrder) {
      final prayerTime = _prayerTimes[prayer]!;
      final prayerMinutes = _timeToMinutes(prayerTime);
      
      if (prayerMinutes > currentMinutes) {
        nextPrayer = prayer;
        nextPrayerMinutes = prayerMinutes;
        break;
      }
    }

    if (nextPrayer == null) {
      nextPrayer = 'الفجر';
      nextPrayerMinutes = _timeToMinutes(_prayerTimes['الفجر']!) + 24 * 60;
    }

    if (mounted) {
      setState(() {
        _nextPrayerName = nextPrayer!;
      });
    }

    _startCountdown(nextPrayerMinutes! - currentMinutes);
  }

  int _timeToMinutes(String time) {
    try {
      final parts = time.split(' ');
      final timeParts = parts[0].split(':');
      int hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);
      
      if (parts.length > 1) {
        if (parts[1] == 'م' && hour != 12) {
          hour += 12;
        } else if (parts[1] == 'ص' && hour == 12) {
          hour = 0;
        }
      }
      
      return hour * 60 + minute;
    } catch (e) {
      return 0;
    }
  }

  void _startCountdown(int totalMinutes) {
    _timer?.cancel();
    
    if (!_isActive || !mounted) return;

    int remainingSeconds = totalMinutes * 60;
    
    void updateTimer() {
      if (!_isActive || !mounted) {
        _timer?.cancel();
        return;
      }
      
      final hours = remainingSeconds ~/ 3600;
      final minutes = (remainingSeconds % 3600) ~/ 60;
      final seconds = remainingSeconds % 60;
      
      final newTime = '${hours.toString().padLeft(2, '0')}:'
                     '${minutes.toString().padLeft(2, '0')}:'
                     '${seconds.toString().padLeft(2, '0')}';
      
      if (_countdownText != newTime) {
        if (mounted) {
          setState(() {
            _countdownText = newTime;
          });
        }
      }
      
      if (remainingSeconds > 0) {
        remainingSeconds--;
        _timer = Timer(const Duration(seconds: 1), updateTimer);
      } else {
        _calculateNextPrayer();
      }
    }
    
    updateTimer();
  }

  void _onPrayerTimeTap(String prayerName) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF252525),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            '🕌 $prayerName',
            style: const TextStyle(
              color: Color(0xFFFFD700),
              fontFamily: 'Cairo',
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          content: Text(
            'حان وقت صلاة $prayerName\ ',
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'Cairo',
              fontSize: 16,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          actions: [
            Center(
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFD700),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                ),
                child: const Text(
                  'حسناً',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _launchDeveloperWebsite() async {
    final Uri url = Uri.parse('https://moaaz-testing.netlify.app/');
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: _isLoading 
                  ? _buildLoading()
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          _buildNextPrayerBox(),
                          const SizedBox(height: 30),
                          _buildPrayerList(),
                        ],
                      ),
                    ),
            ),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: const Color(0xFFFFD700)),
          const SizedBox(height: 20),
          Text(
            'جاري تحميل مواقيت الصلاة...',
            style: TextStyle(
              color: const Color(0xFFFFD700),
              fontSize: 18,
              fontFamily: 'Cairo',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFFFFD700).withOpacity(0.3),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Color(0xFFFFD700),
              size: 28,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'مواعيد الصلاة',
              style: TextStyle(
                fontSize: 28,
                color: const Color(0xFFFFD700),
                fontFamily: 'Thuluth',
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          // مساحة فارغة للمحافظة على التوازن
          const SizedBox(width: 56),
        ],
      ),
    );
  }

  Widget _buildNextPrayerBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF252525),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFD700).withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // التاريخ الهجري في الأعلى
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFFFFD700).withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Text(
              _hijriDate,
              style: const TextStyle(
                color: Color(0xFFFFD700),
                fontSize: 16,
                fontFamily: 'Cairo',
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'الصلاة القادمة:',
            style: TextStyle(
              color: Color(0xFFFFD700),
              fontSize: 18,
              fontFamily: 'Cairo',
            ),
          ),
          const SizedBox(height: 10),
          Text(
            _nextPrayerName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontFamily: 'Cairo',
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          const Divider(color: Color(0xFFFFD700)),
          const SizedBox(height: 10),
          const Text(
            'الوقت المتبقي:',
            style: TextStyle(
              color: Color(0xFFFFD700),
              fontSize: 16,
              fontFamily: 'Cairo',
            ),
          ),
          const SizedBox(height: 5),
          Text(
            _countdownText,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontFamily: 'Cairo',
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrayerList() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF252525),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFD700).withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'مواعيد الصلاة',
            style: TextStyle(
              color: Color(0xFFFFD700),
              fontSize: 22,
              fontFamily: 'Cairo',
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          ..._prayerTimes.entries.map((entry) => _buildPrayerItem(entry.key, entry.value)),
        ],
      ),
    );
  }

  Widget _buildPrayerItem(String prayerName, String prayerTime) {
    return GestureDetector(
      onTap: () => _onPrayerTimeTap(prayerName),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFFD700).withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              prayerTime,
              style: const TextStyle(
                color: Color(0xFFFFD700),
                fontSize: 18,
                fontFamily: 'Cairo',
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              prayerName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontFamily: 'Cairo',
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF121212),
        border: Border(
          top: BorderSide(
            color: const Color(0xFF252525),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Designed and developed by ',
            style: TextStyle(
              color: const Color(0xFF555555),
              fontSize: 14,
              fontFamily: 'Cairo',
            ),
          ),
          GestureDetector(
            onTap: _launchDeveloperWebsite,
            child: Text(
              'Moaaz Ashraf',
              style: TextStyle(
                color: const Color(0xFF2a7ae2),
                fontSize: 14,
                fontWeight: FontWeight.w600,
                fontFamily: 'Cairo',
                decoration: TextDecoration.underline,
                decorationColor: const Color(0xFF2a7ae2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}