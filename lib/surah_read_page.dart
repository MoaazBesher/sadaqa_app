import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'moshaf_page.dart';
import 'quran_utils.dart';

class SurahReadPage extends StatefulWidget {
  final Surah surah;
  final String? initialSearchQuery;
  final int? initialVerseIndex;

  const SurahReadPage({Key? key, required this.surah, this.initialSearchQuery, this.initialVerseIndex}) : super(key: key);

  @override
  _SurahReadPageState createState() => _SurahReadPageState();
}

class MatchItem {
  final int verseIndex;
  final int charIndex;
  final int matchLength;
  MatchItem({required this.verseIndex, required this.charIndex, required this.matchLength});
}

class _SurahReadPageState extends State<SurahReadPage> {
  bool _showSearchBox = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  
  final List<MatchItem> _matches = [];
  int _currentMatchIndex = 0;
  
  final ItemScrollController _itemScrollController = ItemScrollController();

  @override
  void initState() {
    super.initState();
    if (widget.initialSearchQuery != null && widget.initialSearchQuery!.trim().isNotEmpty) {
      _searchController.text = widget.initialSearchQuery!;
      _onSearchChanged(widget.initialSearchQuery!, initialSearch: true);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query, {bool initialSearch = false}) {
    setState(() {
      _searchQuery = query;
      _matches.clear();
      _currentMatchIndex = 0;
      
      if (query.trim().isNotEmpty) {
        RegExp regex = buildArabicSearchRegex(query.trim());
        for (int i = 0; i < widget.surah.verses.length; i++) {
          String text = widget.surah.verses[i].text;
          Iterable<Match> allMatches = regex.allMatches(text);
          for (Match match in allMatches) {
            _matches.add(MatchItem(verseIndex: i, charIndex: match.start, matchLength: match.end - match.start));
          }
        }
        
        if (_matches.isNotEmpty) {
          if (initialSearch && widget.initialVerseIndex != null) {
            int targetMatchIdx = _matches.indexWhere((m) => m.verseIndex == widget.initialVerseIndex);
            if (targetMatchIdx != -1) {
              _currentMatchIndex = targetMatchIdx;
            }
          }
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollToCurrentMatch();
          });
        }
      }
    });
  }

  void _scrollToCurrentMatch() {
    if (_matches.isEmpty) return;
    int verseIdx = _matches[_currentMatchIndex].verseIndex;
    int bismillahCount = (widget.surah.number != 1 && widget.surah.number != 9) ? 1 : 0;
    int listIndex = verseIdx + bismillahCount;
    
    if (_itemScrollController.isAttached) {
      _itemScrollController.scrollTo(
        index: listIndex,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOutCubic,
        alignment: 0.3,
      );
    }
  }

  void _nextMatch() {
    if (_matches.isEmpty) return;
    setState(() {
      _currentMatchIndex = (_currentMatchIndex + 1) % _matches.length;
    });
    _scrollToCurrentMatch();
  }

  void _prevMatch() {
    if (_matches.isEmpty) return;
    setState(() {
      _currentMatchIndex = (_currentMatchIndex - 1 + _matches.length) % _matches.length;
    });
    _scrollToCurrentMatch();
  }

  TextSpan _buildVerseSpan(int verseIndex, String text, int verseNumber) {
    String suffix = ' ($verseNumber) ';
    
    if (_searchQuery.isEmpty || _matches.isEmpty) {
      return TextSpan(text: text + suffix);
    }
    
    List<MatchItem> verseMatches = _matches.where((m) => m.verseIndex == verseIndex).toList();
    if (verseMatches.isEmpty) {
      return TextSpan(text: text + suffix);
    }
    
    List<TextSpan> spans = [];
    int currentIndex = 0;
    
    for (var match in verseMatches) {
      if (match.charIndex > currentIndex) {
        spans.add(TextSpan(text: text.substring(currentIndex, match.charIndex)));
      }
      
      bool isActive = _matches[_currentMatchIndex] == match;
      
      spans.add(TextSpan(
        text: text.substring(match.charIndex, match.charIndex + match.matchLength),
        style: TextStyle(
          backgroundColor: isActive ? Colors.orange : Colors.yellow.withOpacity(0.5),
          color: isActive ? Colors.white : Colors.black,
        ),
      ));
      currentIndex = match.charIndex + match.matchLength;
    }
    
    if (currentIndex < text.length) {
      spans.add(TextSpan(text: text.substring(currentIndex)));
    }
    
    spans.add(TextSpan(text: suffix));
    
    return TextSpan(children: spans);
  }

  @override
  Widget build(BuildContext context) {
    int bismillahCount = (widget.surah.number != 1 && widget.surah.number != 9) ? 1 : 0;
    int itemCount = bismillahCount + widget.surah.verses.length + 1; // +1 for the bottom SizedBox

    return Scaffold(
      backgroundColor: Color(0xFF121212),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(Icons.search, color: Colors.white70, size: 22),
                    onPressed: () {
                      setState(() {
                        _showSearchBox = !_showSearchBox;
                        if (!_showSearchBox) {
                          _searchController.clear();
                          _onSearchChanged("");
                        }
                      });
                    },
                  ),
                  SizedBox(width: 8),
                  IconButton(
                    icon: Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            
            if (_showSearchBox)
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Color(0xFF2A2A2A),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Color(0xFFFFD700).withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.keyboard_arrow_down, size: 20, color: Colors.white),
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(minWidth: 36, minHeight: 36),
                      onPressed: _nextMatch,
                    ),
                    IconButton(
                      icon: Icon(Icons.keyboard_arrow_up, size: 20, color: Colors.white),
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(minWidth: 36, minHeight: 36),
                      onPressed: _prevMatch,
                    ),
                    SizedBox(width: 8),
                    Text(
                      _matches.isEmpty ? "0/0" : "${_currentMatchIndex + 1}/${_matches.length}",
                      style: TextStyle(color: Colors.white70, fontSize: 12, fontFamily: 'Cairo'),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onChanged: _onSearchChanged,
                        style: TextStyle(color: Colors.white, fontSize: 14, fontFamily: 'Cairo'),
                        decoration: InputDecoration(
                          hintText: 'ابحث في السورة...',
                          hintStyle: TextStyle(color: Colors.grey[500], fontSize: 12),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 8),
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              ),

            Text(
              "سُورَةُ ${widget.surah.name}",
              style: TextStyle(
                color: Color(0xFFFFD700),
                fontSize: 32,
                fontFamily: 'Amiri',
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 6),
            Text(
              "ترتيبها ${widget.surah.number}  •  آياتها ${widget.surah.totalVerses}  •  ${widget.surah.type}",
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 14,
                fontFamily: 'Cairo',
              ),
            ),

            SizedBox(height: 20),

            Expanded(
              child: Listener(
                onPointerDown: (event) {
                  if (_matches.isNotEmpty && !_showSearchBox) {
                    setState(() {
                      _matches.clear();
                      _searchQuery = "";
                    });
                  }
                },
                child: ScrollablePositionedList.builder(
                  itemCount: itemCount,
                  itemScrollController: _itemScrollController,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemBuilder: (context, index) {
                    if (index == 0 && bismillahCount == 1) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 24.0, top: 10),
                        child: Text(
                          "بِسۡمِ ٱللَّهِ ٱلرَّحۡمَٰنِ ٱلرَّحِيمِ",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Amiri',
                            fontSize: 22,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      );
                    }
                    
                    int verseIndex = index - bismillahCount;
                    
                    if (verseIndex < widget.surah.verses.length) {
                      Verse verse = widget.surah.verses[verseIndex];
                      return Container(
                        padding: EdgeInsets.symmetric(vertical: 6),
                        child: Text.rich(
                          _buildVerseSpan(verseIndex, verse.text, verse.id),
                          textAlign: TextAlign.center,
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Amiri',
                            fontSize: 26,
                            height: 2.2,
                          ),
                        ),
                      );
                    }
                    
                    return SizedBox(height: 60);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
