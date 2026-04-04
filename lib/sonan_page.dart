import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:url_launcher/url_launcher.dart';

class SonanRawatibPage extends StatefulWidget {
  @override
  _SonanRawatibPageState createState() => _SonanRawatibPageState();
}

class _SonanRawatibPageState extends State<SonanRawatibPage> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  List<PrayerItem> _prayerList = [
    PrayerItem(
      name: "الفجر",
      beforeRakats: "2 ركعة",
      afterRakats: "لا يوجد",
      isExpanded: false,
    ),
    PrayerItem(
      name: "الظهر",
      beforeRakats: "2 + 2 ركعة",
      afterRakats: "2 ركعة",
      isExpanded: false,
    ),
    PrayerItem(
      name: "العصر",
      beforeRakats: "لا يوجد",
      afterRakats: "لا يوجد",
      isExpanded: false,
    ),
    PrayerItem(
      name: "المغرب",
      beforeRakats: "لا يوجد",
      afterRakats: "2 ركعة",
      isExpanded: false,
    ),
    PrayerItem(
      name: "العشاء",
      beforeRakats: "لا يوجد",
      afterRakats: "2 ركعة",
      isExpanded: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _trackPageVisit();
  }

  void _trackPageVisit() async {
    try {
      final sonanVisitsRef = _database.child("page_visits/sonan_rawatib");
      await sonanVisitsRef.get().then((snapshot) {
        int currentCount = 1;
        if (snapshot.exists) {
          final data = snapshot.value as Map<dynamic, dynamic>;
          currentCount = (data['count'] ?? 0) + 1;
        }
        sonanVisitsRef.update({'count': currentCount});
      });
    } catch (error) {
      print("Error tracking page visit: $error");
    }
  }

  void _toggleExpansion(int index) {
    setState(() {
      _prayerList[index].isExpanded = !_prayerList[index].isExpanded;
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
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF2D2D2D),
          title: Text(
            'السنن الرواتب',
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
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              SizedBox(height: 20),
              
              // قائمة السنن الرواتب
              _buildPrayerList(),
              
              SizedBox(height: 80),
            ],
          ),
        ),
        bottomNavigationBar: _buildProfessionalFooter(),
      ),
    );
  }

  Widget _buildPrayerList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: _prayerList.length,
      itemBuilder: (context, index) {
        return _buildPrayerItem(_prayerList[index], index);
      },
    );
  }

  Widget _buildPrayerItem(PrayerItem prayer, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _toggleExpansion(index),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                // العنوان
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      prayer.name,
                      style: TextStyle(
                        color: Color(0xFFFFD700),
                        fontSize: 20,
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(
                      prayer.isExpanded ? Icons.expand_less : Icons.expand_more,
                      color: Color(0xFFFFD700),
                      size: 24,
                    ),
                  ],
                ),
                
                // المحتوى (يظهر عند التوسيع)
                if (prayer.isExpanded) ...[
                  SizedBox(height: 15),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Color(0xFF1E1E1E),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Color(0xFFFFD700).withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      children: [
                        _buildPrayerDetailRow(
                          "الركعات القبلية",
                          prayer.beforeRakats,
                        ),
                        SizedBox(height: 10),
                        _buildPrayerDetailRow(
                          "الركعات البعدية",
                          prayer.afterRakats,
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPrayerDetailRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Color(0xFFE0E0E0),
            fontSize: 16,
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
          child: Text(
            value,
            style: TextStyle(
              color: Color(0xFFFFD700),
              fontSize: 14,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo',
            ),
          ),
        ),
      ],
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

class PrayerItem {
  final String name;
  final String beforeRakats;
  final String afterRakats;
  bool isExpanded;

  PrayerItem({
    required this.name,
    required this.beforeRakats,
    required this.afterRakats,
    this.isExpanded = false,
  });
}