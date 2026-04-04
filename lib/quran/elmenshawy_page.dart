import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:just_audio/just_audio.dart';

class ElmenshawyPage extends StatefulWidget {
  @override
  _ElmenshawyPageState createState() => _ElmenshawyPageState();
}

class _ElmenshawyPageState extends State<ElmenshawyPage> {
  final List<Map<String, String>> surahs = [
    {'name': 'الفاتحة', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/001.mp3'},
    {'name': 'البقرة', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/002.mp3'},
    {'name': 'آل عمران', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/003.mp3'},
    {'name': 'النساء', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/004.mp3'},
    {'name': 'المائدة', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/005.mp3'},
    {'name': 'الأنعام', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/006.mp3'},
    {'name': 'الأعراف', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/007.mp3'},
    {'name': 'الأنفال', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/008.mp3'},
    {'name': 'التوبة', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/009.mp3'},
    {'name': 'يونس', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/010.mp3'},
    {'name': 'هود', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/011.mp3'},
    {'name': 'يوسف', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/012.mp3'},
    {'name': 'الرعد', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/013.mp3'},
    {'name': 'إبراهيم', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/014.mp3'},
    {'name': 'الحجر', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/015.mp3'},
    {'name': 'النحل', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/016.mp3'},
    {'name': 'الإسراء', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/017.mp3'},
    {'name': 'الكهف', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/018.mp3'},
    {'name': 'مريم', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/019.mp3'},
    {'name': 'طه', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/020.mp3'},
    {'name': 'الأنبياء', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/021.mp3'},
    {'name': 'الحج', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/022.mp3'},
    {'name': 'المؤمنون', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/023.mp3'},
    {'name': 'النور', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/024.mp3'},
    {'name': 'الفرقان', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/025.mp3'},
    {'name': 'الشعراء', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/026.mp3'},
    {'name': 'النمل', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/027.mp3'},
    {'name': 'القصص', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/028.mp3'},
    {'name': 'العنكبوت', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/029.mp3'},
    {'name': 'الروم', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/030.mp3'},
    {'name': 'لقمان', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/031.mp3'},
    {'name': 'السجدة', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/032.mp3'},
    {'name': 'الأحزاب', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/033.mp3'},
    {'name': 'سبأ', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/034.mp3'},
    {'name': 'فاطر', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/035.mp3'},
    {'name': 'يس', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/036.mp3'},
    {'name': 'الصافات', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/037.mp3'},
    {'name': 'ص', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/038.mp3'},
    {'name': 'الزمر', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/039.mp3'},
    {'name': 'غافر', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/040.mp3'},
    {'name': 'فصلت', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/041.mp3'},
    {'name': 'الشورى', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/042.mp3'},
    {'name': 'الزخرف', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/043.mp3'},
    {'name': 'الدخان', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/044.mp3'},
    {'name': 'الجاثية', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/045.mp3'},
    {'name': 'الأحقاف', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/046.mp3'},
    {'name': 'محمد', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/047.mp3'},
    {'name': 'الفتح', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/048.mp3'},
    {'name': 'الحجرات', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/049.mp3'},
    {'name': 'ق', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/050.mp3'},
    {'name': 'الذاريات', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/051.mp3'},
    {'name': 'الطور', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/052.mp3'},
    {'name': 'النجم', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/053.mp3'},
    {'name': 'القمر', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/054.mp3'},
    {'name': 'الرحمن', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/055.mp3'},
    {'name': 'الواقعة', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/056.mp3'},
    {'name': 'الحديد', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/057.mp3'},
    {'name': 'المجادلة', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/058.mp3'},
    {'name': 'الحشر', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/059.mp3'},
    {'name': 'الممتحنة', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/060.mp3'},
    {'name': 'الصف', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/061.mp3'},
    {'name': 'الجمعة', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/062.mp3'},
    {'name': 'المنافقون', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/063.mp3'},
    {'name': 'التغابن', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/064.mp3'},
    {'name': 'الطلاق', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/065.mp3'},
    {'name': 'التحريم', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/066.mp3'},
    {'name': 'الملك', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/067.mp3'},
    {'name': 'القلم', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/068.mp3'},
    {'name': 'الحاقة', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/069.mp3'},
    {'name': 'المعارج', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/070.mp3'},
    {'name': 'نوح', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/071.mp3'},
    {'name': 'الجن', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/072.mp3'},
    {'name': 'المزمل', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/073.mp3'},
    {'name': 'المدثر', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/074.mp3'},
    {'name': 'القيامة', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/075.mp3'},
    {'name': 'الإنسان', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/076.mp3'},
    {'name': 'المرسلات', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/077.mp3'},
    {'name': 'النبأ', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/078.mp3'},
    {'name': 'النازعات', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/079.mp3'},
    {'name': 'عبس', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/080.mp3'},
    {'name': 'التكوير', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/081.mp3'},
    {'name': 'الانفطار', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/082.mp3'},
    {'name': 'المطففين', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/083.mp3'},
    {'name': 'الانشقاق', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/084.mp3'},
    {'name': 'البروج', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/085.mp3'},
    {'name': 'الطارق', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/086.mp3'},
    {'name': 'الأعلى', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/087.mp3'},
    {'name': 'الغاشية', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/088.mp3'},
    {'name': 'الفجر', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/089.mp3'},
    {'name': 'البلد', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/090.mp3'},
    {'name': 'الشمس', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/091.mp3'},
    {'name': 'الليل', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/092.mp3'},
    {'name': 'الضحى', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/093.mp3'},
    {'name': 'الشرح', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/094.mp3'},
    {'name': 'التين', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/095.mp3'},
    {'name': 'العلق', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/096.mp3'},
    {'name': 'القدر', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/097.mp3'},
    {'name': 'البينة', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/098.mp3'},
    {'name': 'الزلزلة', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/099.mp3'},
    {'name': 'العاديات', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/100.mp3'},
    {'name': 'القارعة', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/101.mp3'},
    {'name': 'التكاثر', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/102.mp3'},
    {'name': 'العصر', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/103.mp3'},
    {'name': 'الهمزة', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/104.mp3'},
    {'name': 'الفيل', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/105.mp3'},
    {'name': 'قريش', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/106.mp3'},
    {'name': 'الماعون', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/107.mp3'},
    {'name': 'الكوثر', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/108.mp3'},
    {'name': 'الكافرون', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/109.mp3'},
    {'name': 'النصر', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/110.mp3'},
    {'name': 'المسد', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/111.mp3'},
    {'name': 'الإخلاص', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/112.mp3'},
    {'name': 'الفلق', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/113.mp3'},
    {'name': 'الناس', 'url': 'https://download.tvquran.com/download/TvQuran.com__Al-Minshawi-Mojawad/114.mp3'},
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
      final Uri url = Uri.parse('https://surahquran.com/mp3/Al-Minshawi/116.html');
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
          'المنشاوي',
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