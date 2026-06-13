import 'package:flutter/material.dart';

import '../home_page.dart';
import '../prayer_times_page.dart';
import '../sonan_page.dart';
import '../morning_azkar_page.dart';
import '../evening_azkar_page.dart';
import '../doaa_page.dart';
import '../quran_page.dart';
import '../moshaf_page.dart';
import '../masbaha_page.dart';

enum AppSection {
  home,
  prayerTimes,
  sonan,
  morningAzkar,
  eveningAzkar,
  doaa,
  quran,
  moshaf,
  masbaha,
}

class SharedDrawer extends StatelessWidget {
  final AppSection? activeSection;
  
  const SharedDrawer({Key? key, this.activeSection}) : super(key: key);

  Widget _buildDrawerItem(BuildContext context, String title, IconData icon, VoidCallback onTap, {bool isSelected = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: isSelected ? const Color(0x33FFD700) : Colors.transparent,
        border: isSelected ? Border.all(color: const Color(0xFFFFD700), width: 1) : null,
      ),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFFFFD700)),
        title: Text(
          title,
          style: TextStyle(
            color: const Color(0xFFFFD700),
            fontFamily: 'Cairo',
            fontSize: 15, // slightly smaller text to fit the new width
            fontWeight: isSelected ? FontWeight.w900 : FontWeight.bold,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        onTap: onTap,
      ),
    );
  }

  void _navigate(BuildContext context, Widget page, AppSection targetSection) {
    if (activeSection == targetSection) {
      Navigator.pop(context); // Close the drawer if already on this page
      return;
    }
    if (targetSection == AppSection.home) {
      Navigator.popUntil(context, (route) => route.isFirst);
      return;
    }

    Navigator.pop(context); // Close the drawer
    
    // Use push for all navigation to keep a history stack
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  @override
  Widget build(BuildContext context) {
    // Drawer direction is typically determined by Directionality.
    // We wrap it in RTL so it's guaranteed Arabic layout.
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SizedBox(
        width: 260, // Width is less than before (default is usually ~304)
        child: Drawer(
          backgroundColor: const Color(0xFF1E1E1E),
          child: Column(
            children: [
              Container(
                height: 180,
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF252525),
                      Color(0xFF1A1A1A),
                    ],
                  ),
                ),
                child: SafeArea(
                  bottom: false,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.mosque, color: Color(0xFFFFD700), size: 48),
                        SizedBox(height: 8),
                        Text(
                          'صدقة جارية',
                          style: TextStyle(
                            color: Color(0xFFFFD700),
                            fontSize: 26,
                            fontFamily: 'Thuluth',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    _buildDrawerItem(
                      context, 'أوقات الصلاة', Icons.access_time, 
                      () => _navigate(context, PrayerTimesPage(), AppSection.prayerTimes),
                      isSelected: activeSection == AppSection.prayerTimes,
                    ),
                    _buildDrawerItem(
                      context, 'السنن الرواتب', Icons.nightlight_round, 
                      () => _navigate(context, SonanRawatibPage(), AppSection.sonan),
                      isSelected: activeSection == AppSection.sonan,
                    ),
                    _buildDrawerItem(
                      context, 'أذكار الصباح', Icons.wb_sunny, 
                      () => _navigate(context, MorningAzkarPage(), AppSection.morningAzkar),
                      isSelected: activeSection == AppSection.morningAzkar,
                    ),          
                    _buildDrawerItem(
                      context, 'أذكار المساء', Icons.nights_stay, 
                      () => _navigate(context, EveningAzkarPage(), AppSection.eveningAzkar),
                      isSelected: activeSection == AppSection.eveningAzkar,
                    ),
                    _buildDrawerItem(
                      context, 'أدعية', Icons.emoji_people, 
                      () => _navigate(context, DoaaPage(), AppSection.doaa),
                      isSelected: activeSection == AppSection.doaa,
                    ),
                    _buildDrawerItem(
                      context, 'قرآن كريم (استماع)', Icons.headphones, 
                      () => _navigate(context, QuranPage(), AppSection.quran),
                      isSelected: activeSection == AppSection.quran,
                    ),
                    _buildDrawerItem(
                      context, 'المصحف (قراءة)', Icons.menu_book, 
                      () => _navigate(context, MoshafPage(), AppSection.moshaf),
                      isSelected: activeSection == AppSection.moshaf,
                    ),
                    _buildDrawerItem(
                      context, 'مسبحة', Icons.psychology, 
                      () => _navigate(context, MisbahaPage(), AppSection.masbaha),
                      isSelected: activeSection == AppSection.masbaha,
                    ),
                    Divider(
                      color: Color(0xFFFFD700).withOpacity(0.2),
                      height: 24,
                      thickness: 1,
                    ),
                    _buildDrawerItem(
                      context, 'الرئيسية', Icons.home, 
                      () => _navigate(context, HomePage(), AppSection.home),
                      isSelected: activeSection == AppSection.home,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
