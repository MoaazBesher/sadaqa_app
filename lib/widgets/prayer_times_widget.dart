import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PrayerTimesWidget extends StatefulWidget {
  @override
  _PrayerTimesWidgetState createState() => _PrayerTimesWidgetState();
}

class _PrayerTimesWidgetState extends State<PrayerTimesWidget> {
  Map<String, String> _prayerTimes = {
    'الفجر': '--:--',
    'الظهر': '--:--',
    'العصر': '--:--',
    'المغرب': '--:--',
    'العشاء': '--:--',
  };

  String _nextPrayerName = '';
  String _countdownText = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPrayerTimes();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _fetchPrayerTimes() async {
    try {
      final response = await http.get(
        Uri.parse('http://api.aladhan.com/v1/timingsByCity?city=Cairo&country=Egypt&method=5')
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final timings = data['data']['timings'];

        if (mounted) {
          setState(() {
            _prayerTimes = {
              'الفجر': _formatTime(timings['Fajr']),
              'الظهر': _formatTime(timings['Dhuhr']),
              'العصر': _formatTime(timings['Asr']),
              'المغرب': _formatTime(timings['Maghrib']),
              'العشاء': _formatTime(timings['Isha']),
            };
            _isLoading = false;
          });
          _findNextPrayer();
        }
      } else {
        _setDefault();
      }
    } catch (e) {
      _setDefault();
    }
  }

  void _setDefault() {
    if (mounted) {
      setState(() {
        _prayerTimes = {
          'الفجر': '05:30 ص',
          'الظهر': '12:15 م',
          'العصر': '03:45 م',
          'المغرب': '06:00 م',
          'العشاء': '07:30 م',
        };
        _isLoading = false;
      });
      _findNextPrayer();
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

  void _findNextPrayer() {
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

    final diff = nextPrayerMinutes! - currentMinutes;
    final hours = diff ~/ 60;
    final minutes = diff % 60;

    if (mounted) {
      setState(() {
        _nextPrayerName = nextPrayer!;
        _countdownText = '$hoursh ${minutes}m';
      });
    }
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

  Widget _buildGlassContainer({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.12),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildGlassContainer(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.access_time, color: Color(0xFFFFD700), size: 18),
                SizedBox(width: 6),
                Text(
                  'مواقيت الصلاة',
                  style: TextStyle(
                    color: Color(0xFFFFD700),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            if (_isLoading)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Color(0xFFFFD700)),
                  strokeWidth: 2,
                ),
              )
            else
              Column(
                children: [
                  ..._prayerTimes.entries.map((entry) {
                    final isNext = entry.key == _nextPrayerName;
                    return Container(
                      margin: EdgeInsets.only(bottom: 6),
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: isNext
                            ? Color(0xFFFFD700).withOpacity(0.15)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        border: isNext
                            ? Border.all(color: Color(0xFFFFD700).withOpacity(0.3))
                            : null,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            entry.value,
                            style: TextStyle(
                              color: isNext ? Color(0xFFFFD700) : Colors.white70,
                              fontSize: 14,
                              fontFamily: 'Cairo',
                              fontWeight: isNext ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                          Text(
                            entry.key,
                            style: TextStyle(
                              color: isNext ? Color(0xFFFFD700) : Colors.white70,
                              fontSize: 14,
                              fontFamily: 'Cairo',
                              fontWeight: isNext ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  if (_nextPrayerName.isNotEmpty) ...[
                    SizedBox(height: 8),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Color(0xFFFFD700).withOpacity(0.08),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        'متبقي على $_nextPrayerName $_countdownText',
                        style: TextStyle(
                          color: Color(0xFFFFD700).withOpacity(0.8),
                          fontSize: 12,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ),
                  ],
                ],
              ),
          ],
        ),
      ),
    );
  }
}
