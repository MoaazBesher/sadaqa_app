import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:just_audio/just_audio.dart';

class DaghestaniPage extends StatefulWidget {
  @override
  _DaghestaniPageState createState() => _DaghestaniPageState();
}

class _DaghestaniPageState extends State<DaghestaniPage> {
  final List<Map<String, String>> surahs = [
    {'name': 'الفاتحة', 'url': 'https://server9.mp3quran.net/zaki/001.mp3'},
    {'name': 'البقرة', 'url': 'https://server9.mp3quran.net/zaki/002.mp3'},
    {'name': 'آل عمران', 'url': 'https://server9.mp3quran.net/zaki/003.mp3'},
    {'name': 'النساء', 'url': 'https://server9.mp3quran.net/zaki/004.mp3'},
    {'name': 'المائدة', 'url': 'https://server9.mp3quran.net/zaki/005.mp3'},
    {'name': 'الأنعام', 'url': 'https://server9.mp3quran.net/zaki/006.mp3'},
    {'name': 'الأعراف', 'url': 'https://server9.mp3quran.net/zaki/007.mp3'},
    {'name': 'الأنفال', 'url': 'https://server9.mp3quran.net/zaki/008.mp3'},
    {'name': 'التوبة', 'url': 'https://server9.mp3quran.net/zaki/009.mp3'},
    {'name': 'يونس', 'url': 'https://server9.mp3quran.net/zaki/010.mp3'},
    {'name': 'هود', 'url': 'https://server9.mp3quran.net/zaki/011.mp3'},
    {'name': 'يوسف', 'url': 'https://server9.mp3quran.net/zaki/012.mp3'},
    {'name': 'الرعد', 'url': 'https://server9.mp3quran.net/zaki/013.mp3'},
    {'name': 'إبراهيم', 'url': 'https://server9.mp3quran.net/zaki/014.mp3'},
    {'name': 'الحجر', 'url': 'https://server9.mp3quran.net/zaki/015.mp3'},
    {'name': 'النحل', 'url': 'https://server9.mp3quran.net/zaki/016.mp3'},
    {'name': 'الإسراء', 'url': 'https://server9.mp3quran.net/zaki/017.mp3'},
    {'name': 'الكهف', 'url': 'https://server9.mp3quran.net/zaki/018.mp3'},
    {'name': 'مريم', 'url': 'https://server9.mp3quran.net/zaki/019.mp3'},
    {'name': 'طه', 'url': 'https://server9.mp3quran.net/zaki/020.mp3'},
    {'name': 'الأنبياء', 'url': 'https://server9.mp3quran.net/zaki/021.mp3'},
    {'name': 'الحج', 'url': 'https://server9.mp3quran.net/zaki/022.mp3'},
    {'name': 'المؤمنون', 'url': 'https://server9.mp3quran.net/zaki/023.mp3'},
    {'name': 'النور', 'url': 'https://server9.mp3quran.net/zaki/024.mp3'},
    {'name': 'الفرقان', 'url': 'https://server9.mp3quran.net/zaki/025.mp3'},
    {'name': 'الشعراء', 'url': 'https://server9.mp3quran.net/zaki/026.mp3'},
    {'name': 'النمل', 'url': 'https://server9.mp3quran.net/zaki/027.mp3'},
    {'name': 'القصص', 'url': 'https://server9.mp3quran.net/zaki/028.mp3'},
    {'name': 'العنكبوت', 'url': 'https://server9.mp3quran.net/zaki/029.mp3'},
    {'name': 'الروم', 'url': 'https://server9.mp3quran.net/zaki/030.mp3'},
    {'name': 'لقمان', 'url': 'https://server9.mp3quran.net/zaki/031.mp3'},
    {'name': 'السجدة', 'url': 'https://server9.mp3quran.net/zaki/032.mp3'},
    {'name': 'الأحزاب', 'url': 'https://server9.mp3quran.net/zaki/033.mp3'},
    {'name': 'سبأ', 'url': 'https://server9.mp3quran.net/zaki/034.mp3'},
    {'name': 'فاطر', 'url': 'https://server9.mp3quran.net/zaki/035.mp3'},
    {'name': 'يس', 'url': 'https://server9.mp3quran.net/zaki/036.mp3'},
    {'name': 'الصافات', 'url': 'https://server9.mp3quran.net/zaki/037.mp3'},
    {'name': 'ص', 'url': 'https://server9.mp3quran.net/zaki/038.mp3'},
    {'name': 'الزمر', 'url': 'https://server9.mp3quran.net/zaki/039.mp3'},
    {'name': 'غافر', 'url': 'https://server9.mp3quran.net/zaki/040.mp3'},
    {'name': 'فصلت', 'url': 'https://server9.mp3quran.net/zaki/041.mp3'},
    {'name': 'الشورى', 'url': 'https://server9.mp3quran.net/zaki/042.mp3'},
    {'name': 'الزخرف', 'url': 'https://server9.mp3quran.net/zaki/043.mp3'},
    {'name': 'الدخان', 'url': 'https://server9.mp3quran.net/zaki/044.mp3'},
    {'name': 'الجاثية', 'url': 'https://server9.mp3quran.net/zaki/045.mp3'},
    {'name': 'الأحقاف', 'url': 'https://server9.mp3quran.net/zaki/046.mp3'},
    {'name': 'محمد', 'url': 'https://server9.mp3quran.net/zaki/047.mp3'},
    {'name': 'الفتح', 'url': 'https://server9.mp3quran.net/zaki/048.mp3'},
    {'name': 'الحجرات', 'url': 'https://server9.mp3quran.net/zaki/049.mp3'},
    {'name': 'ق', 'url': 'https://server9.mp3quran.net/zaki/050.mp3'},
    {'name': 'الذاريات', 'url': 'https://server9.mp3quran.net/zaki/051.mp3'},
    {'name': 'الطور', 'url': 'https://server9.mp3quran.net/zaki/052.mp3'},
    {'name': 'النجم', 'url': 'https://server9.mp3quran.net/zaki/053.mp3'},
    {'name': 'القمر', 'url': 'https://server9.mp3quran.net/zaki/054.mp3'},
    {'name': 'الرحمن', 'url': 'https://server9.mp3quran.net/zaki/055.mp3'},
    {'name': 'الواقعة', 'url': 'https://server9.mp3quran.net/zaki/056.mp3'},
    {'name': 'الحديد', 'url': 'https://server9.mp3quran.net/zaki/057.mp3'},
    {'name': 'المجادلة', 'url': 'https://server9.mp3quran.net/zaki/058.mp3'},
    {'name': 'الحشر', 'url': 'https://server9.mp3quran.net/zaki/059.mp3'},
    {'name': 'الممتحنة', 'url': 'https://server9.mp3quran.net/zaki/060.mp3'},
    {'name': 'الصف', 'url': 'https://server9.mp3quran.net/zaki/061.mp3'},
    {'name': 'الجمعة', 'url': 'https://server9.mp3quran.net/zaki/062.mp3'},
    {'name': 'المنافقون', 'url': 'https://server9.mp3quran.net/zaki/063.mp3'},
    {'name': 'التغابن', 'url': 'https://server9.mp3quran.net/zaki/064.mp3'},
    {'name': 'الطلاق', 'url': 'https://server9.mp3quran.net/zaki/065.mp3'},
    {'name': 'التحريم', 'url': 'https://server9.mp3quran.net/zaki/066.mp3'},
    {'name': 'الملك', 'url': 'https://server9.mp3quran.net/zaki/067.mp3'},
    {'name': 'القلم', 'url': 'https://server9.mp3quran.net/zaki/068.mp3'},
    {'name': 'الحاقة', 'url': 'https://server9.mp3quran.net/zaki/069.mp3'},
    {'name': 'المعارج', 'url': 'https://server9.mp3quran.net/zaki/070.mp3'},
    {'name': 'نوح', 'url': 'https://server9.mp3quran.net/zaki/071.mp3'},
    {'name': 'الجن', 'url': 'https://server9.mp3quran.net/zaki/072.mp3'},
    {'name': 'المزمل', 'url': 'https://server9.mp3quran.net/zaki/073.mp3'},
    {'name': 'المدثر', 'url': 'https://server9.mp3quran.net/zaki/074.mp3'},
    {'name': 'القيامة', 'url': 'https://server9.mp3quran.net/zaki/075.mp3'},
    {'name': 'الإنسان', 'url': 'https://server9.mp3quran.net/zaki/076.mp3'},
    {'name': 'المرسلات', 'url': 'https://server9.mp3quran.net/zaki/077.mp3'},
    {'name': 'النبأ', 'url': 'https://server9.mp3quran.net/zaki/078.mp3'},
    {'name': 'النازعات', 'url': 'https://server9.mp3quran.net/zaki/079.mp3'},
    {'name': 'عبس', 'url': 'https://server9.mp3quran.net/zaki/080.mp3'},
    {'name': 'التكوير', 'url': 'https://server9.mp3quran.net/zaki/081.mp3'},
    {'name': 'الانفطار', 'url': 'https://server9.mp3quran.net/zaki/082.mp3'},
    {'name': 'المطففين', 'url': 'https://server9.mp3quran.net/zaki/083.mp3'},
    {'name': 'الانشقاق', 'url': 'https://server9.mp3quran.net/zaki/084.mp3'},
    {'name': 'البروج', 'url': 'https://server9.mp3quran.net/zaki/085.mp3'},
    {'name': 'الطارق', 'url': 'https://server9.mp3quran.net/zaki/086.mp3'},
    {'name': 'الأعلى', 'url': 'https://server9.mp3quran.net/zaki/087.mp3'},
    {'name': 'الغاشية', 'url': 'https://server9.mp3quran.net/zaki/088.mp3'},
    {'name': 'الفجر', 'url': 'https://server9.mp3quran.net/zaki/089.mp3'},
    {'name': 'البلد', 'url': 'https://server9.mp3quran.net/zaki/090.mp3'},
    {'name': 'الشمس', 'url': 'https://server9.mp3quran.net/zaki/091.mp3'},
    {'name': 'الليل', 'url': 'https://server9.mp3quran.net/zaki/092.mp3'},
    {'name': 'الضحى', 'url': 'https://server9.mp3quran.net/zaki/093.mp3'},
    {'name': 'الشرح', 'url': 'https://server9.mp3quran.net/zaki/094.mp3'},
    {'name': 'التين', 'url': 'https://server9.mp3quran.net/zaki/095.mp3'},
    {'name': 'العلق', 'url': 'https://server9.mp3quran.net/zaki/096.mp3'},
    {'name': 'القدر', 'url': 'https://server9.mp3quran.net/zaki/097.mp3'},
    {'name': 'البينة', 'url': 'https://server9.mp3quran.net/zaki/098.mp3'},
    {'name': 'الزلزلة', 'url': 'https://server9.mp3quran.net/zaki/099.mp3'},
    {'name': 'العاديات', 'url': 'https://server9.mp3quran.net/zaki/100.mp3'},
    {'name': 'القارعة', 'url': 'https://server9.mp3quran.net/zaki/101.mp3'},
    {'name': 'التكاثر', 'url': 'https://server9.mp3quran.net/zaki/102.mp3'},
    {'name': 'العصر', 'url': 'https://server9.mp3quran.net/zaki/103.mp3'},
    {'name': 'الهمزة', 'url': 'https://server9.mp3quran.net/zaki/104.mp3'},
    {'name': 'الفيل', 'url': 'https://server9.mp3quran.net/zaki/105.mp3'},
    {'name': 'قريش', 'url': 'https://server9.mp3quran.net/zaki/106.mp3'},
    {'name': 'الماعون', 'url': 'https://server9.mp3quran.net/zaki/107.mp3'},
    {'name': 'الكوثر', 'url': 'https://server9.mp3quran.net/zaki/108.mp3'},
    {'name': 'الكافرون', 'url': 'https://server9.mp3quran.net/zaki/109.mp3'},
    {'name': 'النصر', 'url': 'https://server9.mp3quran.net/zaki/110.mp3'},
    {'name': 'المسد', 'url': 'https://server9.mp3quran.net/zaki/111.mp3'},
    {'name': 'الإخلاص', 'url': 'https://server9.mp3quran.net/zaki/112.mp3'},
    {'name': 'الفلق', 'url': 'https://server9.mp3quran.net/zaki/113.mp3'},
    {'name': 'الناس', 'url': 'https://server9.mp3quran.net/zaki/114.mp3'},
  ];

  List<Map<String, String>> filteredSurahs = [];
  TextEditingController searchController = TextEditingController();
  final AudioPlayer _audioPlayer = AudioPlayer();
  
  String? currentPlayingUrl;
  int? currentPlayingIndex;
  bool _isDisposed = false;
  bool _isLoading = false;
  PlayerState _playerState = PlayerState(false, ProcessingState.idle);
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();
    filteredSurahs = List.from(surahs);
    searchController.addListener(_filterSurahs);
    
    _setupAudioPlayer();
  }

  void _setupAudioPlayer() {
    // إعداد إعدادات الصوت المحسنة
    _audioPlayer.setLoopMode(LoopMode.off);
    
    _audioPlayer.playerStateStream.listen((playerState) {
      if (!_isDisposed && mounted) {
        setState(() {
          _playerState = playerState;
          _isLoading = playerState.processingState == ProcessingState.loading ||
                      playerState.processingState == ProcessingState.buffering;
        });

        // معالجة اكتمال التشغيل
        if (playerState.processingState == ProcessingState.completed) {
          _handlePlaybackCompletion();
        }
      }
    }, onError: (e) {
      print('Player state error: $e');
      _handleAudioError('خطأ في حالة المشغل');
    });

    _audioPlayer.durationStream.listen((duration) {
      if (!_isDisposed && mounted) {
        setState(() {
          _duration = duration ?? Duration.zero;
        });
      }
    }, onError: (e) {
      print('Duration error: $e');
    });

    _audioPlayer.positionStream.listen((position) {
      if (!_isDisposed && mounted) {
        setState(() {
          _position = position;
        });
      }
    }, onError: (e) {
      print('Position error: $e');
    });

    // معالجة أخطاء التشغيل
    _audioPlayer.playbackEventStream.listen((event) {},
        onError: (e) {
          print('Playback error: $e');
          _handleAudioError('خطأ في تشغيل الصوت');
        });
  }

  void _handlePlaybackCompletion() {
    // إعادة تعيين الحالة عند اكتمال التشغيل
    if (!_isDisposed && mounted) {
      setState(() {
        _position = Duration.zero;
        _isLoading = false;
      });
    }
  }

  void _handleAudioError(String message) {
    if (!_isDisposed && mounted) {
      setState(() {
        _isLoading = false;
      });
      _showSnackBar(message);
      
      // إعادة تعيين حالة التشغيل بعد الخطأ
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && !_isDisposed) {
          setState(() {
            currentPlayingUrl = null;
            currentPlayingIndex = null;
          });
        }
      });
    }
  }

  void _filterSurahs() {
    final query = _normalizeText(searchController.text);
    setState(() {
      if (query.isEmpty) {
        filteredSurahs = List.from(surahs);
      } else {
        filteredSurahs = surahs.where((surah) {
          final name = _normalizeText(surah['name']!);
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

  Future<void> _playSurah(int index) async {
    try {
      final surah = filteredSurahs[index];
      
      // إذا كانت نفس السورة المشغلة حالياً
      if (currentPlayingUrl == surah['url']) {
        if (_playerState.playing) {
          await _audioPlayer.pause();
        } else {
          await _audioPlayer.play();
        }
        return;
      }
      
      // إذا كانت سورة مختلفة
      setState(() {
        _isLoading = true;
        currentPlayingUrl = surah['url'];
        currentPlayingIndex = index;
      });
      
      // إيقاف أي تشغيل سابق بطريقة آمنة
      try {
        await _audioPlayer.stop();
      } catch (e) {
        print('Error stopping previous audio: $e');
      }
      
      // إضافة تأخير بسيط للسماح بإيقاف التشغيل السابق
      await Future.delayed(Duration(milliseconds: 100));
      
      // تحميل وتشغيل السورة الجديدة
      await _audioPlayer.setUrl(surah['url']!);
      await _audioPlayer.play();
      
    } catch (e) {
      print('Error playing audio: $e');
      _handleAudioError('خطأ في تشغيل السورة');
      
      // محاولة إعادة التعيين
      await _resetAudioPlayer();
    }
  }

  Future<void> _resetAudioPlayer() async {
    try {
      await _audioPlayer.stop();
      await _audioPlayer.setUrl(''); // إعادة تعيين المصدر
    } catch (e) {
      print('Error resetting audio player: $e');
    }
  }

  void _playNext() {
    if (currentPlayingIndex != null && currentPlayingIndex! < filteredSurahs.length - 1) {
      _playSurah(currentPlayingIndex! + 1);
    } else {
      _showSnackBar('لا توجد سورة تالية');
    }
  }

  void _playPrevious() {
    if (currentPlayingIndex != null && currentPlayingIndex! > 0) {
      _playSurah(currentPlayingIndex! - 1);
    } else {
      _showSnackBar('لا توجد سورة سابقة');
    }
  }

  Future<void> _stopAudio() async {
    try {
      await _audioPlayer.stop();
      if (!_isDisposed && mounted) {
        setState(() {
          currentPlayingUrl = null;
          currentPlayingIndex = null;
          _isLoading = false;
          _position = Duration.zero;
        });
      }
    } catch (e) {
      print('Error stopping audio: $e');
      _handleAudioError('خطأ في إيقاف الصوت');
    }
  }

  void _seekAudio(double value) {
    try {
      final newPosition = Duration(seconds: value.toInt());
      _audioPlayer.seek(newPosition);
    } catch (e) {
      print('Error seeking audio: $e');
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    
    if (duration.inHours > 0) {
      final hours = twoDigits(duration.inHours);
      return '$hours:$minutes:$seconds';
    } else {
      return '$minutes:$seconds';
    }
  }

  void _launchDownloadPage() async {
    try {
      final Uri url = Uri.parse('https://torrent.mp3quran.net/download.php?id=8c84f0c286fe0b3df77d51c612b33e7250e87d8d&f=Zaki+Daghistani+%28Updated%29.torrent');
      if (!await launchUrl(url)) {
        _showSnackBar('تعذر فتح رابط التحميل');
      }
    } catch (e) {
      print('Error launching download page: $e');
      _showSnackBar('خطأ في فتح رابط التحميل');
    }
  }

  void _launchDeveloperWebsite() async {
    try {
      final Uri url = Uri.parse('https://moaaz-testing.netlify.app/');
      if (!await launchUrl(url)) {
        _showSnackBar('تعذر فتح موقع المطور');
      }
    } catch (e) {
      print('Error launching developer website: $e');
      _showSnackBar('خطأ في فتح موقع المطور');
    }
  }

  void _showSnackBar(String message) {
    if (!_isDisposed && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: TextStyle(fontFamily: 'Cairo'),
            textAlign: TextAlign.center,
          ),
          backgroundColor: Color(0xFFFFD700),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Color(0xFF1E1E1E),
        title: Text(
          'زكي داغستاني',
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
          onPressed: () async {
            await _stopAudio();
            if (mounted) {
              Navigator.of(context).pop();
            }
          },
        ),
        iconTheme: IconThemeData(
          color: Color(0xFFFFD700),
          size: 30,
        ),
      ),
      body: Column(
        children: [
          // مشغل الصوت (ثابت في الأعلى)
          if (currentPlayingUrl != null) _buildAudioPlayer(),
          
          // المحتوى الرئيسي
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  // شريط البحث
                  _buildSearchBar(),
                  SizedBox(height: 20),
                  
                  // زر التحميل
                  _buildDownloadButton(),
                  SizedBox(height: 20),
                  
                  // قائمة السور
                  _buildSurahList(),
                  
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildProfessionalFooter(),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: TextField(
        controller: searchController,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          hintText: 'ابحث عن سورة...',
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

  Widget _buildAudioPlayer() {
    final isPlaying = _playerState.playing;
    final isBuffering = _isLoading;

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF252525),
        border: Border(
          bottom: BorderSide(color: Color(0xFFFFD700).withOpacity(0.3)),
        ),
      ),
      child: Column(
        children: [
          // اسم السورة المشغلة مع مؤشر التحميل
          if (currentPlayingIndex != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isBuffering)
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFFD700)),
                    ),
                  ),
                if (isBuffering) SizedBox(width: 10),
                Expanded(
                  child: Text(
                    filteredSurahs[currentPlayingIndex!]['name']!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFFFD700),
                      fontSize: 18,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          SizedBox(height: 15),
          
          // شريط التقدم والوقت
          Row(
            children: [
              Text(
                _formatDuration(_position),
                style: TextStyle(
                  color: Color(0xFFFFD700),
                  fontSize: 12,
                  fontFamily: 'Cairo',
                ),
              ),
              Expanded(
                child: Slider(
                  value: _position.inSeconds.toDouble(),
                  min: 0,
                  max: _duration.inSeconds.toDouble().clamp(1, double.infinity),
                  onChanged: _seekAudio,
                  activeColor: Color(0xFFFFD700),
                  inactiveColor: Colors.grey[600],
                ),
              ),
              Text(
                _formatDuration(_duration),
                style: TextStyle(
                  color: Color(0xFFFFD700),
                  fontSize: 12,
                  fontFamily: 'Cairo',
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          
          // أزرار التحكم
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: _playPrevious,
                icon: Icon(Icons.skip_previous, color: Color(0xFFFFD700), size: 30),
                style: IconButton.styleFrom(
                  backgroundColor: Color(0xFF1E1E1E),
                  padding: EdgeInsets.all(8),
                ),
              ),
              SizedBox(width: 15),
              IconButton(
                onPressed: _stopAudio,
                icon: Icon(Icons.stop, color: Color(0xFFFFD700), size: 30),
                style: IconButton.styleFrom(
                  backgroundColor: Color(0xFF1E1E1E),
                  padding: EdgeInsets.all(8),
                ),
              ),
              SizedBox(width: 15),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFF1E1E1E),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: isBuffering ? null : () {
                    if (isPlaying) {
                      _audioPlayer.pause();
                    } else {
                      _audioPlayer.play();
                    }
                  },
                  icon: isBuffering
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFFD700)),
                          ),
                        )
                      : Icon(
                          isPlaying ? Icons.pause : Icons.play_arrow,
                          color: Color(0xFFFFD700),
                          size: 30,
                        ),
                  style: IconButton.styleFrom(
                    backgroundColor: Color(0xFF1E1E1E),
                    padding: EdgeInsets.all(12),
                  ),
                ),
              ),
              SizedBox(width: 15),
              IconButton(
                onPressed: _playNext,
                icon: Icon(Icons.skip_next, color: Color(0xFFFFD700), size: 30),
                style: IconButton.styleFrom(
                  backgroundColor: Color(0xFF1E1E1E),
                  padding: EdgeInsets.all(8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDownloadButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFFFD700).withOpacity(0.5),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Color(0xFFFFD700),
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: _launchDownloadPage,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(15),
            child: Center(
              child: Text(
                'تحميل القرآن الكريم كاملاً',
                style: TextStyle(
                  color: Color(0xFF252525),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSurahList() {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 2.5,
      ),
      itemCount: filteredSurahs.length,
      itemBuilder: (context, index) {
        final surah = filteredSurahs[index];
        final isCurrent = currentPlayingUrl == surah['url'];
        final isThisPlaying = isCurrent && _playerState.playing;
        final isThisLoading = isCurrent && _isLoading;

        return Container(
          decoration: BoxDecoration(
            color: isCurrent ? Color(0xFFFFD700).withOpacity(0.1) : Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isCurrent ? Color(0xFFFFD700) : Color(0xFFFFD700).withOpacity(0.3),
              width: isCurrent ? 2 : 1,
            ),
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
              onTap: () => _playSurah(index),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: EdgeInsets.all(12),
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
                    // المحتوى
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (isThisLoading) ...[
                          SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFFD700)),
                            ),
                          ),
                          SizedBox(width: 8),
                        ] else if (isThisPlaying) ...[
                          Icon(
                            Icons.equalizer,
                            color: Color(0xFFFFD700),
                            size: 16,
                          ),
                          SizedBox(width: 8),
                        ],
                        Expanded(
                          child: Text(
                            surah['name']!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: isCurrent ? Color(0xFFFFD700) : Colors.white,
                              fontSize: 16,
                              fontFamily: 'Cairo',
                              height: 1.6,
                              fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
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
      },
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
    _isDisposed = true;
    
    // إيقاف الصوت أولاً بطريقة آمنة
    try {
      _audioPlayer.stop();
    } catch (e) {
      print('Error stopping audio on dispose: $e');
    }
    
    // التخلص من المشغل
    _audioPlayer.dispose();
    
    // التخلص من المتحكم
    searchController.dispose();
    
    super.dispose();
  }
}