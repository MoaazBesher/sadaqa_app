import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:url_launcher/url_launcher.dart';

class MisbahaPage extends StatefulWidget {
  @override
  _MisbahaPageState createState() => _MisbahaPageState();
}

class _MisbahaPageState extends State<MisbahaPage> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  
  List<DhikrItem> _customDhikrList = [];
  List<DhikrItem> _prayerDhikrList = [
    DhikrItem(
      text: "سبحان الله",
      maxCount: 33,
      currentCount: 0,
    ),
    DhikrItem(
      text: "الحمد لله",
      maxCount: 33,
      currentCount: 0,
    ),
    DhikrItem(
      text: "الله أكبر",
      maxCount: 34,
      currentCount: 0,
    ),
  ];

  final TextEditingController _dhikrTextController = TextEditingController();
  final TextEditingController _dhikrCountController = TextEditingController();

  bool _showPrayerDhikr = false;

  @override
  void initState() {
    super.initState();
    _trackPageVisit();
    _loadCustomDhikr();
    _loadPrayerDhikr();
  }

  void _trackPageVisit() async {
    try {
      final misbahaVisitsRef = _database.child("page_visits/misbaha");
      await misbahaVisitsRef.get().then((snapshot) {
        int currentCount = 1;
        if (snapshot.exists) {
          final data = snapshot.value as Map<dynamic, dynamic>;
          currentCount = (data['count'] ?? 0) + 1;
        }
        misbahaVisitsRef.update({'count': currentCount});
      });
    } catch (error) {
      print("Error tracking page visit: $error");
    }
  }

  void _loadCustomDhikr() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedCount = prefs.getInt('custom_dhikr_count') ?? 0;
      
      List<DhikrItem> loadedDhikr = [];
      for (int i = 0; i < savedCount; i++) {
        final text = prefs.getString('custom_dhikr_${i}_text') ?? '';
        final maxCount = prefs.getInt('custom_dhikr_${i}_max') ?? 0;
        final currentCount = prefs.getInt('custom_dhikr_${i}_current') ?? 0;
        
        if (text.isNotEmpty) {
          loadedDhikr.add(DhikrItem(
            text: text,
            maxCount: maxCount,
            currentCount: currentCount,
          ));
        }
      }
      
      setState(() {
        _customDhikrList = loadedDhikr;
      });
    } catch (error) {
      print("Error loading custom dhikr: $error");
    }
  }

  void _loadPrayerDhikr() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      for (int i = 0; i < _prayerDhikrList.length; i++) {
        final currentCount = prefs.getInt('prayer_dhikr_$i') ?? 0;
        setState(() {
          _prayerDhikrList[i].currentCount = currentCount;
        });
      }
    } catch (error) {
      print("Error loading prayer dhikr: $error");
    }
  }

  void _saveCustomDhikr() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('custom_dhikr_count', _customDhikrList.length);
      
      for (int i = 0; i < _customDhikrList.length; i++) {
        await prefs.setString('custom_dhikr_${i}_text', _customDhikrList[i].text);
        await prefs.setInt('custom_dhikr_${i}_max', _customDhikrList[i].maxCount);
        await prefs.setInt('custom_dhikr_${i}_current', _customDhikrList[i].currentCount);
      }
    } catch (error) {
      print("Error saving custom dhikr: $error");
    }
  }

  void _savePrayerDhikr(int index, int count) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('prayer_dhikr_$index', count);
    } catch (error) {
      print("Error saving prayer dhikr: $error");
    }
  }

  void _addCustomDhikr() {
    final text = _dhikrTextController.text.trim();
    final count = int.tryParse(_dhikrCountController.text) ?? 0;

    if (text.isEmpty) {
      _showSnackBar('يرجى إدخال الذكر أولاً');
      return;
    }

    if (count <= 0) {
      _showSnackBar('يرجى إدخال عدد صحيح');
      return;
    }

    setState(() {
      _customDhikrList.add(DhikrItem(
        text: text,
        maxCount: count,
        currentCount: 0,
      ));
    });

    _dhikrTextController.clear();
    _dhikrCountController.clear();
    _saveCustomDhikr();
    
    _showSnackBar('تم إضافة الذكر بنجاح');
  }

  void _resetAllCounters() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF252525),
          title: Text(
            'إعادة جميع العدادات',
            style: TextStyle(
              color: Color(0xFFFFD700),
              fontFamily: 'Cairo',
            ),
            textAlign: TextAlign.center,
          ),
          content: Text(
            'هل تريد إعادة جميع العدادات إلى الصفر؟',
            style: TextStyle(
              color: Color(0xFFE0E0E0),
              fontFamily: 'Cairo',
            ),
            textAlign: TextAlign.center,
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'إلغاء',
                      style: TextStyle(
                        color: Color(0xFFFFD700),
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      _resetCounters();
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'تأكيد',
                      style: TextStyle(
                        color: Colors.red,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void _resetCounters() {
    setState(() {
      // إعادة عدادات الأذكار المخصصة
      for (var dhikr in _customDhikrList) {
        dhikr.currentCount = 0;
      }
      
      // إعادة عدادات أذكار بعد الصلاة
      for (var dhikr in _prayerDhikrList) {
        dhikr.currentCount = 0;
      }
    });
    
    _saveCustomDhikr();
    for (int i = 0; i < _prayerDhikrList.length; i++) {
      _savePrayerDhikr(i, 0);
    }
    
    _showSnackBar('تم إعادة جميع العدادات');
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(fontFamily: 'Cairo'),
        ),
        backgroundColor: Color(0xFFFFD700),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _launchDeveloperWebsite() async {
    final Uri url = Uri.parse('https://moaaz-testing.netlify.app/');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF2D2D2D),
          title: Text(
            'المسبحة',
            style: TextStyle(
              color: Color(0xFFFFD700),
              fontSize: 28,
              fontFamily: 'Thuluth',
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          iconTheme: IconThemeData(
            color: Color(0xFFFFD700),
            size: 30,
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: _resetAllCounters,
              tooltip: 'إعادة العدادات',
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              // قسم إضافة الأذكار المخصصة
              _buildAddDhikrSection(),
              SizedBox(height: 20),
              
              // قسم أذكار بعد الصلاة
              _buildPrayerDhikrSection(),
              SizedBox(height: 20),
              
              // قسم الأذكار المخصصة
              if (_customDhikrList.isNotEmpty) ...[
                _buildCustomDhikrSection(),
                SizedBox(height: 20),
              ],
              
              SizedBox(height: 80),
            ],
          ),
        ),
        bottomNavigationBar: _buildProfessionalFooter(),
      ),
    );
  }

  Widget _buildAddDhikrSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF252525),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFFFD700).withOpacity(0.2),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'إضافة ذكر مخصص',
            style: TextStyle(
              color: Color(0xFFFFD700),
              fontSize: 20,
              fontFamily: 'Cairo',
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 15),
          TextField(
            controller: _dhikrTextController,
            decoration: InputDecoration(
              hintText: 'أدخل الذكر',
              hintStyle: TextStyle(fontFamily: 'Cairo'),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Color(0xFFFFD700)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Color(0xFFFFD700)),
              ),
              filled: true,
              fillColor: Color(0xFF333333),
            ),
            style: TextStyle(color: Colors.white, fontFamily: 'Cairo'),
            textAlign: TextAlign.right,
          ),
          SizedBox(height: 10),
          TextField(
            controller: _dhikrCountController,
            decoration: InputDecoration(
              hintText: 'أدخل العدد',
              hintStyle: TextStyle(fontFamily: 'Cairo'),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Color(0xFFFFD700)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Color(0xFFFFD700)),
              ),
              filled: true,
              fillColor: Color(0xFF333333),
            ),
            style: TextStyle(color: Colors.white, fontFamily: 'Cairo'),
            textAlign: TextAlign.right,
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 15),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFFFFD700).withOpacity(0.4),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: _addCustomDhikr,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFFD700),
                foregroundColor: Colors.black,
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add, size: 24),
                  SizedBox(width: 8),
                  Text(
                    'إضافة ذكر',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrayerDhikrSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF252525),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFFFD700).withOpacity(0.2),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _showPrayerDhikr = !_showPrayerDhikr;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'أذكار بعد الصلاة',
                  style: TextStyle(
                    color: Color(0xFFFFD700),
                    fontSize: 20,
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 10),
                Icon(
                  _showPrayerDhikr ? Icons.expand_less : Icons.expand_more,
                  color: Color(0xFFFFD700),
                ),
              ],
            ),
          ),
          if (_showPrayerDhikr) ...[
            SizedBox(height: 15),
            ..._prayerDhikrList.asMap().entries.map((entry) {
              final index = entry.key;
              final dhikr = entry.value;
              return _buildDhikrItem(dhikr, index, isPrayerDhikr: true);
            }).toList(),
          ],
        ],
      ),
    );
  }

  Widget _buildCustomDhikrSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF252525),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFFFD700).withOpacity(0.2),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'أذكاري المخصصة',
            style: TextStyle(
              color: Color(0xFFFFD700),
              fontSize: 20,
              fontFamily: 'Cairo',
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 15),
          ..._customDhikrList.asMap().entries.map((entry) {
            final index = entry.key;
            final dhikr = entry.value;
            return _buildDhikrItem(dhikr, index, isPrayerDhikr: false);
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildDhikrItem(DhikrItem dhikr, int index, {bool isPrayerDhikr = false}) {
    final progress = dhikr.maxCount > 0 ? dhikr.currentCount / dhikr.maxCount : 0;
    
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFFFD700).withOpacity(0.3)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {
              if (dhikr.currentCount < dhikr.maxCount) {
                dhikr.currentCount++;
                if (isPrayerDhikr) {
                  _savePrayerDhikr(index, dhikr.currentCount);
                } else {
                  _saveCustomDhikr();
                }
              }
            });
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Stack(
              children: [
                // شريط التقدم
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: LinearProgressIndicator(
                    value: progress.toDouble(), // التحويل الصريح إلى double
                    backgroundColor: Color(0xFF444444),
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFFD700)),
                    minHeight: 3,
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // النص
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Text(
                          dhikr.text,
                          style: TextStyle(
                            color: Color(0xFFE0E0E0),
                            fontSize: 16,
                            fontFamily: 'Cairo',
                            height: 1.6,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ),
                    
                    // العداد
                    SizedBox(width: 15),
                    Container(
                      width: 70,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Color(0xFF444444),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFFFFD700).withOpacity(0.3),
                            blurRadius: 4,
                            spreadRadius: 0.5,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          '${dhikr.currentCount} / ${dhikr.maxCount}',
                          style: TextStyle(
                            color: Color(0xFFFFD700),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Cairo',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfessionalFooter() {
    return Container(
      height: 70,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: Color(0xFF121212),
        border: Border(
          top: BorderSide(
            color: Color(0xFF252525),
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
              color: Color(0xFF555555),
              fontSize: 14,
              fontFamily: 'Cairo',
            ),
          ),
          GestureDetector(
            onTap: _launchDeveloperWebsite,
            child: Text(
              'Moaaz Ashraf',
              style: TextStyle(
                color: Color(0xFF2a7ae2),
                fontSize: 14,
                fontWeight: FontWeight.w600,
                fontFamily: 'Cairo',
                decoration: TextDecoration.underline,
                decorationColor: Color(0xFF2a7ae2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DhikrItem {
  final String text;
  final int maxCount;
  int currentCount;

  DhikrItem({
    required this.text,
    required this.maxCount,
    this.currentCount = 0,
  });
}