import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:clipboard/clipboard.dart';
import 'package:url_launcher/url_launcher.dart';
import 'morning_azkar_page.dart';
import 'evening_azkar_page.dart'; 
import 'prayer_times_page.dart';
import 'masbaha_page.dart';
import 'sonan_page.dart';
import 'doaa_page.dart';
import 'quran_page.dart';
import 'moshaf_page.dart';
import 'update_checker.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      UpdateChecker.checkForUpdate(context);
    });

    _initializeFirebase();
  }

  String _dailyMessage = "جارِ التحميل ...";
  int _uniqueVisitors = 0;
  int _totalVisits = 0;
  TextEditingController _suggestionController = TextEditingController();

  void _initializeFirebase() async {
    await _setupVisitorTracking();
    _loadDailyMessage();
    _loadVisitorStats();
  }

  Future<void> _setupVisitorTracking() async {
    final prefs = await SharedPreferences.getInstance();
    String deviceId = prefs.getString('device_id') ?? 
        'device_${DateTime.now().millisecondsSinceEpoch}';
    
    if (prefs.getString('device_id') == null) {
      await prefs.setString('device_id', deviceId);
      
      // زيادة عدد الزوار الفريدين
      await _database.child('visits').child('unique_visitors').get().then((snapshot) {
        int currentUnique = snapshot.exists ? (snapshot.value as int) : 0;
        _database.child('visits').update({
          'unique_visitors': currentUnique + 1,
        });
      });
      
      // تسجيل الجهاز
      await _database.child('devices').child(deviceId).set({
        'firstVisit': DateTime.now().toIso8601String(),
      });
    }
    
    // زيادة عدد الزيارات الكلية
    await _database.child('visits').child('total_visits').get().then((snapshot) {
      int currentTotal = snapshot.exists ? (snapshot.value as int) : 0;
      _database.child('visits').update({
        'total_visits': currentTotal + 1,
      });
    });
  }

  void _loadDailyMessage() {
    _database.child('daily_content').onValue.listen((event) {
      final String message = event.snapshot.value?.toString() ?? 
          "تذكرة اليوم: الدعاء للموتى صدقة جارية";
      
      setState(() {
        _dailyMessage = message;
      });
    }, onError: (error) {
      setState(() {
        _dailyMessage = "تذكرة اليوم: الدعاء للموتى صدقة جارية";
      });
    });
  }

  void _loadVisitorStats() {
    _database.child('visits').onValue.listen((event) {
      if (event.snapshot.value != null) {
        final Map<dynamic, dynamic> data = 
            event.snapshot.value as Map<dynamic, dynamic>;
        
        setState(() {
          _uniqueVisitors = data['unique_visitors'] ?? 0;
          _totalVisits = data['total_visits'] ?? 0;
        });
      }
    });
  }

  void _copyLink() {
    FlutterClipboard.copy('https://sadaqa-mainpage.netlify.app/')
        .then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("تم نسخ الرابط!", style: TextStyle(fontFamily: 'Cairo')),
          backgroundColor: Colors.green,
        ),
      );
    });
  }

  void _shareLink() {
    Share.share(
      'صدقة جارية - تطبيق إسلامي متكامل\nhttps://sadaqa-mainpage.netlify.app/',
      subject: 'صدقة جارية',
    );
  }

  void _submitSuggestion() {
    String suggestionText = _suggestionController.text.trim();
    
    if (suggestionText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('الرجاء كتابة اقتراح قبل الإرسال!', style: TextStyle(fontFamily: 'Cairo')),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // إرسال الاقتراح لـ Firebase
    _database.child('suggestions').push().set({
      'text': suggestionText,
      'timestamp': DateTime.now().toIso8601String(),
      'device_id': 'flutter_app',
    }).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم إرسال الاقتراح بنجاح!', style: TextStyle(fontFamily: 'Cairo')),
          backgroundColor: Colors.green,
        ),
      );
      _suggestionController.clear();
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('فشل في إرسال الاقتراح!', style: TextStyle(fontFamily: 'Cairo')),
          backgroundColor: Colors.red,
        ),
      );
    });
  }

  void _launchDeveloperWebsite() async {
    final Uri url = Uri.parse('https://moaaz-testing.netlify.app/');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color(0xFF1E1E1E),
        title: Text(
          'صدقة جارية',
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
        elevation: 0,
      ),
      drawer: _buildDrawer(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1E1E1E),
              Color(0xFF121212),
            ],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    // معلومات الصدقة الجارية
                    _buildSiteInfo(),
                    SizedBox(height: 20),
                    
                    // تذكرة اليوم
                    _buildDailyMessage(),
                    SizedBox(height: 20),
                    
                    // أقسام الموقع
                    _buildSectionsInfo(),
                    SizedBox(height: 20),
                    
                    // مشاركة الرابط
                    _buildShareBox(),
                    SizedBox(height: 20),
                    
                    // الاقتراحات
                    _buildSuggestionSection(),
                    SizedBox(height: 20),
                    
                    // إحصائيات الزوار
                    _buildVisitorStats(),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            
            // الفوتر
            _buildProfessionalFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildSiteInfo() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF252525),
            Color(0xFF1A1A1A),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFFFD700).withOpacity(0.2),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: Color(0xFFFFD700).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [

          SizedBox(height: 16),
          Text(
            'الموقع صدقة جارية على روح:',
            style: TextStyle(
              color: Color(0xFFFFD700),
              fontWeight: FontWeight.bold,
              fontSize: 20,
              fontFamily: 'Cairo',
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          _buildMemorialName('محمد أحمد محمد أنور'),
          _buildMemorialName('محمد عزت حلمي البيبي'),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Color(0xFFFFD700).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Color(0xFFFFD700).withOpacity(0.3),
              ),
            ),
            child: Text(
              'نسألكم الدعاء لهم بالرحمة والمغفرة',
              style: TextStyle(
                color: Color(0xFFFFD700),
                fontWeight: FontWeight.bold,
                fontSize: 16,
                fontFamily: 'Cairo',
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMemorialName(String name) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.eco, color: Color(0xFFFFD700), size: 16),
          SizedBox(width: 8),
          Text(
            name,
            style: TextStyle(
              color: Color(0xFFFFD700),
              fontWeight: FontWeight.bold,
              fontSize: 18,
              fontFamily: 'Cairo',
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDailyMessage() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF252525),
            Color(0xFF1A1A1A),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFFFD700).withOpacity(0.15),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
        border: Border.all(
          color: Color(0xFFDFCA10).withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lightbulb_outline, color: Color(0xFFDFCA10), size: 24),
              SizedBox(width: 8),
              Text(
                'تذكرة اليوم',
                style: TextStyle(
                  color: Color(0xFFDFCA10),
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Color(0xFFDFCA10).withOpacity(0.1),
              ),
            ),
            child: Text(
              _dailyMessage,
              style: TextStyle(
                color: Color(0xFFE8E8E8),
                fontSize: 17,
                fontFamily: 'Cairo',
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionsInfo() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF252525),
            Color(0xFF1A1A1A),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFFFD700).withOpacity(0.15),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
        border: Border.all(
          color: Color(0xFFFFD700).withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'أقسام الموقع',
                style: TextStyle(
                  color: Color(0xFFFFD700),
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                ),
              ),
              SizedBox(width: 8),
              Icon(Icons.widgets, color: Color(0xFFFFD700), size: 24),
            ],
          ),
          SizedBox(height: 8),
          Text(
            'من خلال القائمة الجانبية ☰',
            style: TextStyle(
              color: Color(0xFFFFD700).withOpacity(0.8),
              fontWeight: FontWeight.w500,
              fontSize: 16,
              fontFamily: 'Cairo',
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          _buildSectionItem('أوقات الصلاة', Icons.access_time, 
              'أوقات الصلاة حسب موقعك الجغرافي، مع إشعارات قبل وأثناء وقت الصلاة'),
          _buildSectionItem('أذكار الصباح والمساء', Icons.wb_sunny, 
              'أذكار الصباح والمساء كاملة، مع عداد يزداد تلقائيًا عند النقر على الذكر'),
          _buildSectionItem('أدعية', Icons.emoji_people, 
              'مجموعة من الأدعية المأثورة من السنة النبوية'),
          _buildSectionItem('القرآن الكريم', Icons.book, 
              'تصفح واستمع للقرآن الكريم بأصوات متعددة'),
          _buildSectionItem('المصحف الإلكتروني', Icons.menu_book, 
              'تصفح جميع صفحات المصحف بسهولة للقراءة المباشرة'),
          _buildSectionItem('المسبحة الإلكترونية', Icons.psychology, 
              'يمكنك إضافة أي ذكر تريده، وتحديد عدد تكراره، ثم البدء في التسبيح'),
        ],
      ),
    );
  }

  Widget _buildSectionItem(String title, IconData icon, String description) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Color(0xFFFFD700).withOpacity(0.1),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: Color(0xFFFFD700),
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(icon, color: Color(0xFFFFD700), size: 20),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(
                    color: Color(0xFFE8E8E8),
                    fontSize: 14,
                    fontFamily: 'Cairo',
                    height: 1.5,
                  ),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShareBox() {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF252525),
            Color(0xFF1A1A1A),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFFFD700).withOpacity(0.15),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
        border: Border.all(
          color: Color(0xFFFFD700).withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.share, color: Color(0xFFFFD700), size: 24),
              SizedBox(width: 8),
              Text(
                'شارك مع الآخرين',
                style: TextStyle(
                  color: Color(0xFFFFD700),
                  fontSize: 20,
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Color(0xFFFFD700).withOpacity(0.1),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'https://sadaqa-mainpage.netlify.app/',
                    style: TextStyle(
                      color: Color(0xFFFFD700),
                      fontFamily: 'Cairo',
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 12),
                _buildIconButton(
                  Icons.copy,
                  _copyLink,
                  'نسخ الرابط',
                ),
                SizedBox(width: 8),
                _buildIconButton(
                  Icons.share,
                  _shareLink,
                  'مشاركة',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onPressed, String tooltip) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFFFD700),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFFFD700).withOpacity(0.3),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.black, size: 20),
        tooltip: tooltip,
        style: IconButton.styleFrom(
          padding: EdgeInsets.all(8),
        ),
      ),
    );
  }

  Widget _buildSuggestionSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF252525),
            Color(0xFF1A1A1A),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFFFD700).withOpacity(0.15),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
        border: Border.all(
          color: Color(0xFFFFD700).withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.feedback, color: Color(0xFFFFD700), size: 24),
              SizedBox(width: 8),
              Text(
                'اقتراحاتكم تهمنا',
                style: TextStyle(
                  color: Color(0xFFFFD700),
                  fontSize: 20,
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            'لإرسال اقتراح أو في حال واجهت أي مشكلة في الموقع، لا تتردد في التواصل.',
            style: TextStyle(
              color: Color(0xFFE8E8E8),
              fontSize: 16,
              fontFamily: 'Cairo',
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Color(0xFFFFD700).withOpacity(0.1),
              ),
            ),
            child: TextField(
              controller: _suggestionController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'اكتب اقتراحك هنا...',
                hintStyle: TextStyle(fontFamily: 'Cairo', color: Color(0xFF888888)),
                filled: true,
                fillColor: Colors.transparent,
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(16),
              ),
              style: TextStyle(
                color: Color(0xFFFFD700),
                fontFamily: 'Cairo',
              ),
            ),
          ),
          SizedBox(height: 16),
          Container(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _submitSuggestion,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.send, color: Colors.black, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'إرسال الاقتراح',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFFD700),
                foregroundColor: Colors.black,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
                shadowColor: Color(0xFFFFD700).withOpacity(0.3),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVisitorStats() {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF252525),
            Color(0xFF1A1A1A),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFFFD700).withOpacity(0.15),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
        border: Border.all(
          color: Color(0xFFFFD700).withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Text(
            'إحصائيات الموقع',
            style: TextStyle(
              color: Color(0xFFFFD700),
              fontSize: 20,
              fontFamily: 'Cairo',
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('الأجهزة', _uniqueVisitors, Icons.people_alt),
              Container(
                width: 1,
                height: 50,
                color: Color(0xFFFFD700).withOpacity(0.3),
              ),
              _buildStatItem('الزيارات', _totalVisits, Icons.analytics),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, int value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Color(0xFFFFD700), size: 28),
        SizedBox(height: 8),
        Text(
          value.toString(),
          style: TextStyle(
            color: Color(0xFFFFD700),
            fontFamily: 'Cairo',
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Color(0xFFFFD700).withOpacity(0.8),
            fontFamily: 'Cairo',
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildProfessionalFooter() {
    return Container(
      height: 70,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Color(0xFF121212),
        border: Border(
          top: BorderSide(
            color: Color(0xFFFFD700).withOpacity(0.2),
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
              color: Color(0xFF666666),
              fontSize: 14,
              fontFamily: 'Cairo',
            ),
          ),
          GestureDetector(
            onTap: _launchDeveloperWebsite,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Color(0xFF2a7ae2).withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: Color(0xFF2a7ae2).withOpacity(0.3),
                ),
              ),
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
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: Color(0xFF1E1E1E),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            height: 160,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF252525),
                  Color(0xFF1A1A1A),
                ],
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.mosque, color: Color(0xFFFFD700), size: 40),
                  SizedBox(height: 8),
                  Text(
                    'صدقة جارية',
                    style: TextStyle(
                      color: Color(0xFFFFD700),
                      fontSize: 28,
                      fontFamily: 'Thuluth',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          _buildDrawerItem('أوقات الصلاة', Icons.access_time, () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => PrayerTimesPage()));
          }),
          _buildDrawerItem('السنن الرواتب', Icons.nightlight_round, () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => SonanRawatibPage()));
          }),
          _buildDrawerItem('أذكار الصباح', Icons.wb_sunny, () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => MorningAzkarPage()));
          }),          
          _buildDrawerItem('أذكار المساء', Icons.nights_stay, () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => EveningAzkarPage()));
          }),
          _buildDrawerItem('أدعية', Icons.emoji_people, () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => DoaaPage()));
          }),
          _buildDrawerItem('قرآن كريم', Icons.book, () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => QuranPage()));
          }),
          _buildDrawerItem('المصحف', Icons.menu_book, () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => MoshafPage()));
          }),
          _buildDrawerItem('مسبحة', Icons.psychology, () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => MisbahaPage()));
          }),
          _buildDrawerItem('عن الموقع', Icons.info, () {
            Navigator.pop(context);
          }),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(String title, IconData icon, VoidCallback onTap) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: Icon(icon, color: Color(0xFFFFD700)),
        title: Text(
          title,
          style: TextStyle(
            color: Color(0xFFFFD700),
            fontFamily: 'Cairo',
            fontSize: 16,
          ),
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        tileColor: Color(0xFF252525).withOpacity(0.5),
      ),
    );
  }
}