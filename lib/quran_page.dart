import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'quran/elmenshawy_page.dart';
import 'quran/abdulbasit_page.dart';
import 'quran/aliJaber_page.dart';
import 'quran/elafasy_page.dart';
import 'quran/elghamdy_page.dart';
import 'quran/alkatami_page.dart';
import 'quran/elsodes_page.dart';
import 'quran/khaledJalel_page.dart';
import 'quran/maher_page.dart';
import 'quran/yasser_page.dart';
import 'quran/islamSobhy_page.dart';
import 'quran/daghestani_page.dart';
import 'quran/elhosary_page.dart';
import 'quran/fares_page.dart';
class QuranPage extends StatefulWidget {
  @override
  _QuranPageState createState() => _QuranPageState();
}

class _QuranPageState extends State<QuranPage> {
  final List<Map<String, String>> sheikhs = [
    {'name': 'محمد صديق المنشاوي', 'path': 'elmenshawy'},
    {'name': 'عبدالباسط عبدالصمد', 'path': 'abdelbaset'},
    {'name': 'علي جابر', 'path': 'alijaber'},
    {'name': 'مشاري بن راشد العفاسي', 'path': 'elafasi'},
    {'name': 'سعد الغامدي', 'path': 'elghamdy'},
    {'name': 'ناصر القطامي', 'path': 'elkatami'},
    {'name': 'عبد الرحمن السديس', 'path': 'elsodes'},
    {'name': 'خالد الجليل', 'path': 'khaledjalel'},
    {'name': 'ماهر المعيقلي', 'path': 'maher'},
    {'name': 'ياسر الدوسري', 'path': 'yasser'},
    {'name': 'إسلام صبحي', 'path': 'islamSobhy'},
    {'name': 'زكي داغستاني', 'path': 'daghestani'},
    {'name': 'محمود خليل الحصري', 'path': 'elhosary'},
    {'name': 'فارس عباد', 'path': 'fares'},
  ];

  List<Map<String, String>> filteredSheikhs = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredSheikhs = List.from(sheikhs);
    searchController.addListener(_filterSheikhs);
  }

  void _filterSheikhs() {
    final query = _normalizeText(searchController.text);
    setState(() {
      if (query.isEmpty) {
        filteredSheikhs = List.from(sheikhs);
      } else {
        filteredSheikhs = sheikhs.where((sheikh) {
          final name = _normalizeText(sheikh['name']!);
          return name.contains(query);
        }).toList();
      }
    });
  }

  String _normalizeText(String text) {
    return text
        .replaceAll(RegExp(r'[إأآا]'), 'ا')
        .replaceAll('ى', 'ي')
        .toLowerCase();
  }

  void _openSheikhPage(String path) {
  if (path == 'elmenshawy') {
    Navigator.push(context, MaterialPageRoute(builder: (context) => ElmenshawyPage()));
  }
  if (path == 'abdelbaset') {
    Navigator.push(context, MaterialPageRoute(builder: (context) => AbdulbasitPage()));
  }
  if (path == 'alijaber') {
    Navigator.push(context, MaterialPageRoute(builder: (context) => AlijaberPage()));
  }
  if (path == 'elafasi') {
    Navigator.push(context, MaterialPageRoute(builder: (context) => ElafasyPage()));
  }
  if (path == 'elghamdy') {
    Navigator.push(context, MaterialPageRoute(builder: (context) => elghamdy_page()));
  }
  if (path == 'elkatami') {
    Navigator.push(context, MaterialPageRoute(builder: (context) => ElkatamiPage()));
  }
  if (path == 'elsodes') {
    Navigator.push(context, MaterialPageRoute(builder: (context) => ElsodesPage()));
  }
  if (path == 'khaledjalel') {
    Navigator.push(context, MaterialPageRoute(builder: (context) => KhaledjalelPage()));
  }
  if (path == 'maher') {
    Navigator.push(context, MaterialPageRoute(builder: (context) => MaherPage()));
  }
  if (path == 'yasser') {
    Navigator.push(context, MaterialPageRoute(builder: (context) => YasserPage()));
  }
  if (path == 'islamSobhy') {
    Navigator.push(context, MaterialPageRoute(builder: (context) => IslamsobhyPage()));
  }
  if (path == 'daghestani') {
    Navigator.push(context, MaterialPageRoute(builder: (context) => DaghestaniPage()));
  }
  if (path == 'elhosary') {
    Navigator.push(context, MaterialPageRoute(builder: (context) => ElhosaryPage()));
  }
  if (path == 'fares') {
    Navigator.push(context, MaterialPageRoute(builder: (context) => FaresPage()));
  }
  print('فتح صفحة الشيخ: $path');
    // Navigator.push(context, MaterialPageRoute(builder: (context) => SheikhPage(path: path)));
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
      backgroundColor: Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Color(0xFF1E1E1E),
        title: Text(
          'قرآن كريم',
          style: TextStyle(
            color: Color(0xFFFFD700),
            fontSize: 28,
            fontFamily: 'Thuluth',
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFFFFD700)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        iconTheme: IconThemeData(
          color: Color(0xFFFFD700),
          size: 30,
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // شريط البحث
            _buildSearchBar(),
            SizedBox(height: 20),
            
            // قائمة الشيوخ
            _buildSheikhList(),
            
            SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: _buildProfessionalFooter(),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      margin: EdgeInsets.symmetric(vertical: 20),
      child: TextField(
        controller: searchController,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          hintText: 'ابحث عن شيخ...',
          hintStyle: TextStyle(
            color: Colors.grey[400],
            fontSize: 18,
            fontFamily: 'Cairo',
          ),
          filled: true,
          fillColor: Color(0xFF252525),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(
              color: Color(0xFFFFD700),
              width: 2,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(
              color: Color(0xFFFFD700),
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(
              color: Color(0xFFFFD700),
              width: 2,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontFamily: 'Cairo',
        ),
      ),
    );
  }

Widget _buildSheikhList() {
  return Container(
    width: MediaQuery.of(context).size.width * 0.9,
    child: Column(
      children: filteredSheikhs.map((sheikh) {
        return Container(
          margin: EdgeInsets.only(bottom: 15),
          decoration: BoxDecoration(
            color: Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Color(0xFFFFD700).withOpacity(0.3)),
            boxShadow: [
              BoxShadow(
                color: Color(0xFFFFD700).withOpacity(0.2),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _openSheikhPage(sheikh['path']!),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                child: Stack(
                  children: [
                    // شريط ذهبي علوي
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 3,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFFFFD700).withOpacity(0.8),
                              Color(0xFFFFD700).withOpacity(0.3),
                            ],
                          ),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    // النص فقط في المنتصف
                    Center(
                      child: Text(
                        sheikh['name']!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: 'Cairo',
                          height: 1.6,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
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

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}