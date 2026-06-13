import 'package:flutter/material.dart';
import 'widgets/shared_drawer.dart';
import 'widgets/shared_footer.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MorningAzkarPage extends StatefulWidget {
  @override
  _MorningAzkarPageState createState() => _MorningAzkarPageState();
}

class _MorningAzkarPageState extends State<MorningAzkarPage> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  List<AzkarItem> _azkarList = [
    AzkarItem(
      text: "اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ ۚ لَا تَأْخُذُهُ سِنَةٌ وَلَا نَوْمٌ ۚ لَهُ مَا فِي السَّمَاوَاتِ وَمَا فِي الْأَرْضِ ۗ مَنْ ذَا الَّذِي يَشْفَعُ عِنْدَهُ إِلَّا بِإِذْنِهِ ۚ يَعْلَمُ مَا بَيْنَ أَيْدِيهِمْ وَمَا خَلْفَهُمْ ۖ وَلَا يُحِيطُونَ بِشَيْءٍ مِنْ عِلْمِهِ إِلَّا بِمَا شَاءَ ۚ وَسِعَ كُرْسِيُّهُ السَّمَاوَاتِ وَالْأَرْضِ ۖ وَلَا يَئُودُهُ حِفْظُهُمَا ۚ وَهُوَ الْعَلِيُّ الْعَظِيمُ",
      maxCount: 1,
    ),
    AzkarItem(
      text: "قُلۡ هُوَ ٱللَّهُ أَحَدٌ (1) ٱللَّهُ ٱلصَّمَدُ (2) لَمۡ يَلِدۡ وَلَمۡ يُولَدۡ (3) وَلَمۡ يَكُن لَّهُۥ كُفُوًا أَحَدُۢ (4)",
      maxCount: 3,
    ),
    AzkarItem(
      text: "قُلْ أَعُوذُ بِرَبِّ الْفَلَقِ* مِن شَرِّ مَا خَلَقَ* وَمِن شَرِّ غَاسِقٍ إِذَا وَقَبَ* وَمِن شَرِّ النَّفَّاثَاتِ فِي الْعُقَدِ* وَمِن شَرِّ حَاسِدٍ إِذَا حَسَد",
      maxCount: 3,
    ),
    AzkarItem(
      text: "قُلْ أَعُوذُ بِرَبِّ النَّاسِ* مَلِكِ النَّاسِ* إِلَٰهِ النَّاسِ* مِن شَرِّ الْوَسْوَاسِ الْخَنَّاسِ* الَّذِي يُوَسْوِسُ فِي صُدُورِ النَّاسِ* مِنَ الْجِنَّةِ وَالنَّاسِ",
      maxCount: 3,
    ),
    AzkarItem(
      text: "أَصْـبَحْنا وَأَصْـبَحَ المُـلْكُ لله وَالحَمدُ لله، لا إلهَ إلاّ اللّهُ وَحدَهُ لا شَريكَ لهُ، لهُ المُـلكُ ولهُ الحَمْـد، وهُوَ على كلّ شَيءٍ قدير، رَبِّ أسْـأَلُـكَ خَـيرَ ما في هـذا اليوم وَخَـيرَ ما بَعْـدَه، وَأَعـوذُ بِكَ مِنْ شَـرِّ ما في هـذا اليوم وَشَرِّ ما بَعْـدَه، رَبِّ أَعـوذُ بِكَ مِنَ الْكَسَـلِ وَسـوءِ الْكِـبَر، رَبِّ أَعـوذُ بِكَ مِنْ عَـذابٍ في النّـارِ وَعَـذابٍ في القَـبْر",
      maxCount: 1,
    ),
    AzkarItem(
      text: "اللَّهمَّ بِكَ أصبَحنا، وبِكَ أمسَينا، وبِكَ نحيا وبِكَ نموتُ وإليكَ المصير",
      maxCount: 1,
    ),
    AzkarItem(
      text: "اللهمَّ أَنْتَ رَبِّي لا إِلَهَ إلا أَنْتَ،خَلَقْتَنِي وَأَنَا عَبْدُكَ، وأَنَا عَلَى عَهْدِكَ ووعْدكَ مَا اسْتَطَعْتُ، أَعُوذُ بِكَ مِنْ شَرِّ مَا صَنَعْتُ،أَبُوءُ لَكَ بِنِعْمَتِكَ عَلَيَّ،وَأَبُوءُ لَكَ بِذَنْبِي،فَاغْفِرْ لِي،فَإِنَّهُ لا يَغْفِرُ الذُّنُوبَ إلا أَنْتَ",
      maxCount: 1,
    ),
    AzkarItem(
      text: "اللهم إني أصبحتُ أُشهدك، وأُشهد حملةَ عرشك، وملائكتك، وجميع خلقك، أنَّك أنت الله، لا إله إلا أنت، وأنَّ محمدًا عبدك ورسولك",
      maxCount: 4,
    ),
    AzkarItem(
      text: "اللهم ما أصبح بي من نعمةٍ فمنك وحدك، لا شريكَ لك، فلك الحمد، ولك الشُّكر",
      maxCount: 1,
    ),
    AzkarItem(
      text: "اللَّهمَّ عافِني في بدَني اللَّهمَّ عافِني في سمعي اللَّهمَّ عافِني في بصري لا إلهَ إلَّا أنت، اللَّهمَّ إنِّي أعوذُ بِكَ منَ الكُفْرِ والفقرِ اللَّهمَّ إنِّي أعوذُ بكَ من عذابِ القبرِ لا إلهَ إلَّا أنت",
      maxCount: 3,
    ),
    AzkarItem(
      text: "حَسْبِيَ اللَّهُ لا إِلَهَ إِلا هُوَ عَلَيْهِ تَوَكَّلْتُ وَهُوَ رَبُّ الْعَرْشِ الْعَظِيمِ",
      maxCount: 7,
    ),
    AzkarItem(
      text: "اللَّهُمَّ إِنِّي أَسْأَلُكَ الْعَافِيَةَ فِي الدُّنْيَا وَالآخِرَةِ، اللَّهُمَّ إِنِّي أَسْأَلُكَ الْعَفْوَ وَالْعَافِيَةَ فِي دِينِي وَدُنْيَايَ وَأَهْلِي وَمَالِي، اللَّهُمَّ استُرْ عَوْرَاتي، وآمِنْ رَوْعَاتي، اللَّهمَّ احْفَظْنِي مِنْ بَينِ يَدَيَّ، ومِنْ خَلْفي، وَعن يَميني، وعن شِمالي، ومِن فَوْقِي، وأعُوذُ بِعَظَمَتِكَ أنْ أُغْتَالَ مِنْ تَحتي",
      maxCount: 1,
    ),
    AzkarItem(
      text: "اللهم فاطر السموات والأرض، عالم الغيب والشهادة رب كل شيء ومليكه أشهد أن لا إله إلا أنت، أعوذ بك من شر نفسي وشر الشيطان وشركه، وأن أقترف على نفسي سوءً أو أجره إلى مسلم",
      maxCount: 1,
    ),
    AzkarItem(
      text: "بسم الله الذي لا يضر مع اسمه شيء في الأرض ولا في السماء وهو السميع العليم",
      maxCount: 3,
    ),
    AzkarItem(
      text: "رضيت بالله ربًا، وبالإسلام دينًا، وبمحمد رسولًا",
      maxCount: 3,
    ),
    AzkarItem(
      text: "يا حي يا قيوم، برحمتك أستغيث، أصلح لي شأني كله، ولا تكلني إلى نفسي طرفة عين\nأصبحنا وأصبح الملك لله رب العالمين\nاللهم اني اسألك خير هذا اليوم فتحه ونصره ونوره وبركته وهداه واعوذ بك من شر ما فيه وشر ما بعده",
      maxCount: 1,
    ),
    AzkarItem(
      text: "أَصبَحْنا على فِطرةِ الإسلامِ، وكَلِمةِ الإخلاصِ، ودِينِ نَبيِّنا محمَّدٍ صلَّى اللهُ عليه وسلَّمَ، وعلى مِلَّةِ أبِينا إبراهيمَ، حَنيفًا مُسلِمًا، وما كان مِنَ المُشرِكينَ",
      maxCount: 1,
    ),
    AzkarItem(
      text: "سبحان الله وبحمده",
      maxCount: 100,
    ),
    AzkarItem(
      text: "لا إلهَ إلاَّ اللَّه وحْدهُ لاَ شَرِيكَ لهُ، لَهُ المُلْكُ، ولَهُ الحمْدُ، وَهُو عَلَى كُلِّ شَيءٍ قَدِيرٌ",
      maxCount: 100,
    ),
    AzkarItem(
      text: "سُبحانَ اللهِ وبحَمْدِه عَدَدَ خَلْقِه، ورِضا نَفْسِه، وزِنةَ عَرْشِه، ومِدادَ كَلِماتِه",
      maxCount: 3,
    ),
    AzkarItem(
      text: "اللَّهُمَّ إِنِّي أَسْأَلُكَ عِلْمًا نَافِعًا، وَرِزْقًا طَيِّبًا، وَعَمَلًا مُتَقَبَّلًا",
      maxCount: 1,
    ),
    AzkarItem(
      text: "اللهم صل وسلم على نبينا محمد ﷺ",
      maxCount: 10,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _trackPageVisit();
    _loadCounters();
  }

  void _trackPageVisit() async {
    try {
      final morningAzkarVisitsRef = _database.child("page_visits/morning_azkar");
      await morningAzkarVisitsRef.get().then((snapshot) {
        int currentCount = 1;
        if (snapshot.exists) {
          final data = snapshot.value as Map<dynamic, dynamic>;
          currentCount = (data['count'] ?? 0) + 1;
        }
        morningAzkarVisitsRef.update({'count': currentCount});
      });
    } catch (error) {
      print("Error tracking page visit: $error");
    }
  }

  void _loadCounters() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      int savedTimestamp = prefs.getInt('morning_azkar_timestamp') ?? 0;
      int now = DateTime.now().millisecondsSinceEpoch;
      if (now - savedTimestamp > 21600000) {
        for (int i = 0; i < _azkarList.length; i++) {
          setState(() {
            _azkarList[i].currentCount = 0;
          });
          await prefs.remove('morning_azkar_$i');
        }
        await prefs.remove('morning_azkar_timestamp');
        return;
      }
      for (int i = 0; i < _azkarList.length; i++) {
        int savedCount = prefs.getInt('morning_azkar_$i') ?? 0;
        setState(() {
          _azkarList[i].currentCount = savedCount;
        });
      }
    } catch (error) {
      print("Error loading counters: $error");
    }
  }

  void _saveCounter(int index, int count) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('morning_azkar_$index', count);
      await prefs.setInt('morning_azkar_timestamp', DateTime.now().millisecondsSinceEpoch);
    } catch (error) {
      print("Error saving counter: $error");
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
        endDrawer: const SharedDrawer(activeSection: AppSection.morningAzkar),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Color(0xFF2D2D2D),
          title: Text(
            'أذكار الصباح',
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
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu_rounded, color: Color(0xFFFFD700)),
                onPressed: () => Scaffold.of(context).openEndDrawer(),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              // قائمة الأذكار
              _buildAzkarList(),
            ],
          ),
        ),
        bottomNavigationBar: const SharedFooter(),
      ),
    );
  }

  Widget _buildAzkarList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: _azkarList.length,
      itemBuilder: (context, index) {
        return _buildAzkarItem(_azkarList[index], index);
      },
    );
  }

  Widget _buildAzkarItem(AzkarItem azkar, int index) {
    bool isComplete = azkar.currentCount >= azkar.maxCount;
    return Opacity(
      opacity: isComplete ? 0.45 : 1.0,
      child: Container(
        margin: EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
          color: isComplete ? Color(0xFF1A1A1A) : Color(0xFF252525),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isComplete
                ? Color(0xFF2A5A2A)
                : Color(0xFFFFD700).withValues(alpha: 0.25),
            width: isComplete ? 1.5 : 1,
          ),
          boxShadow: isComplete
              ? []
              : [
                  BoxShadow(
                    color: Color(0xFFFFD700).withValues(alpha: 0.15),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              setState(() {
                if (azkar.currentCount < azkar.maxCount) {
                  azkar.currentCount++;
                  _saveCounter(index, azkar.currentCount);
                }
              });
            },
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      azkar.text,
                      style: TextStyle(
                        color: isComplete
                            ? Color(0xFF808080)
                            : Color(0xFFE0E0E0),
                        fontSize: 16,
                        fontFamily: 'Cairo',
                        height: 1.6,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  SizedBox(width: 15),
                  Container(
                    width: 70,
                    height: 50,
                    decoration: BoxDecoration(
                      color: isComplete
                          ? Color(0xFF1A3A1A)
                          : Color(0xFF444444),
                      borderRadius: BorderRadius.circular(10),
                      border: isComplete
                          ? Border.all(color: Color(0xFF2A5A2A), width: 1)
                          : null,
                    ),
                    child: Center(
                      child: Text(
                      '${azkar.currentCount} / ${azkar.maxCount}',
                      style: TextStyle(
                        color: isComplete
                            ? Color(0xFF4CAF50)
                            : Color(0xFFFFD700),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AzkarItem {
  final String text;
  final int maxCount;
  int currentCount;

  AzkarItem({
    required this.text,
    required this.maxCount,
    this.currentCount = 0,
  });
}