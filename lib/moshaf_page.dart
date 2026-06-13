import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'widgets/shared_drawer.dart';
import 'widgets/shared_footer.dart';
import 'package:flutter/services.dart';
import 'surah_read_page.dart';
import 'quran_utils.dart';

class MoshafPage extends StatefulWidget {
  @override
  _MoshafPageState createState() => _MoshafPageState();
}

class SearchResult {
  final Surah surah;
  final Verse? matchedVerse;

  SearchResult({required this.surah, this.matchedVerse});
}

class _MoshafPageState extends State<MoshafPage> {
  List<Surah> _surahs = [];
  List<SearchResult> _searchResults = [];
  bool _isLoading = true;
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _loadQuranData();
  }

  Future<void> _loadQuranData() async {
    try {
      final String jsonString =
          await rootBundle.loadString('assets/quran.json');
      final List<dynamic> jsonResponse = json.decode(jsonString);

      final List<Surah> loadedSurahs = jsonResponse.map((surahJson) {
        final List<dynamic> versesJson = surahJson['verses'] ?? [];
        final content =
            versesJson.map((v) => '${v["text"]} (${v["id"]})').join(' ');
        
        final verses = versesJson
            .map((v) => Verse(id: int.parse(v['id'].toString()), text: v['text'].toString()))
            .toList();

        return Surah(
          name: surahJson['name'].toString(),
          number: int.parse(surahJson['id'].toString()),
          content: content,
          type: surahJson['type'].toString() == 'meccan' ? 'مكية' : 'مدنية',
          totalVerses: int.parse(surahJson['total_verses'].toString()),
          verses: verses,
        );
      }).toList();

      setState(() {
        _surahs = loadedSurahs;
        _searchResults = _surahs.map((s) => SearchResult(surah: s)).toList();
        _isLoading = false;
      });
    } catch (e) {
      print("Error loading Quran data: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _filterSurahs(String query) {
    _searchQuery = query;
    setState(() {
      if (query.trim().isEmpty) {
        _searchResults = _surahs.map((s) => SearchResult(surah: s)).toList();
      } else {
        _searchResults = [];
        RegExp regex = buildArabicSearchRegex(query.trim());
        for (var surah in _surahs) {
          if (regex.hasMatch(surah.name)) {
            _searchResults.add(SearchResult(surah: surah));
          }
          for (var verse in surah.verses) {
            if (regex.hasMatch(verse.text)) {
              _searchResults.add(SearchResult(surah: surah, matchedVerse: verse));
            }
          }
        }
      }
    });
  }

  Widget _buildSnippet(String text, String query) {
    if (query.trim().isEmpty) return Text(text);

    RegExp regex = buildArabicSearchRegex(query.trim());
    Match? match = regex.firstMatch(text);
    if (match == null) return Text(text);

    int startMatch = match.start;
    int endMatch = match.end;

    int start = max(0, startMatch - 30);
    int end = min(text.length, endMatch + 30);

    String prefix = start > 0 ? "..." : "";
    String suffix = end < text.length ? "..." : "";

    String part1 = text.substring(start, startMatch);
    String part2 = text.substring(startMatch, endMatch);
    String part3 = text.substring(endMatch, end);

    return RichText(
      textAlign: TextAlign.center,
      textDirection: TextDirection.rtl,
      text: TextSpan(
        style: TextStyle(
            color: Colors.grey[400], fontFamily: 'Amiri', fontSize: 18),
        children: [
          TextSpan(text: prefix + part1),
          TextSpan(
              text: part2,
              style: TextStyle(
                  backgroundColor: Colors.yellow.withOpacity(0.5),
                  color: Colors.white)),
          TextSpan(text: part3 + suffix),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const SharedDrawer(activeSection: AppSection.moshaf),
      backgroundColor: Color(0xFF121212),
      appBar: AppBar(
          automaticallyImplyLeading: false,
        backgroundColor: Color(0xFF1E1E1E),
        title: Text(
          'المصحف الشريف',
          style: TextStyle(
            color: Color(0xFFFFD700),
            fontSize: 28,
            fontFamily: 'Thuluth',
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
                    actions: [
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu_rounded, color: Color(0xFFFFD700)),
                onPressed: () => Scaffold.of(context).openEndDrawer(),
              ),
            ),
          ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFFD700)),
              ),
            )
          : Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 20),
                    child: TextField(
                      onChanged: _filterSurahs,
                      decoration: InputDecoration(
                        hintText: 'ابحث باسم السورة أو الآية...',
                        hintStyle: TextStyle(
                            color: Colors.grey[400], fontFamily: 'Cairo'),
                        filled: true,
                        fillColor: Color(0xFF1E1E1E),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide:
                              BorderSide(color: Color(0xFFFFD700), width: 1.0),
                        ),
                        prefixIcon:
                            Icon(Icons.search, color: Color(0xFFFFD700)),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                      ),
                      style:
                          TextStyle(color: Colors.white, fontFamily: 'Cairo'),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  Expanded(
                    child: _searchResults.isEmpty
                        ? Center(
                            child: Text(
                            "لم يتم العثور على نتائج",
                            style: TextStyle(
                                color: Colors.white70,
                                fontFamily: 'Cairo',
                                fontSize: 18),
                          ))
                        : ListView.builder(
                            physics: BouncingScrollPhysics(),
                            itemCount: _searchResults.length,
                            itemBuilder: (context, index) {
                              final result = _searchResults[index];
                              final surah = result.surah;
                              final isAyahMatch = result.matchedVerse != null;

                              return Container(
                                margin: EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                  color: Color(0xFF1A1A1A),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isAyahMatch ? Colors.white.withOpacity(0.02) : Colors.white.withOpacity(0.05),
                                    width: 1,
                                  ),
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(12),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              SurahReadPage(
                                                surah: surah,
                                                initialSearchQuery: isAyahMatch ? _searchQuery : null,
                                                initialVerseIndex: isAyahMatch ? surah.verses.indexOf(result.matchedVerse!) : null,
                                              ),
                                        ),
                                      );
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 16, horizontal: 16),
                                      child: isAyahMatch
                                          ? Column(
                                              crossAxisAlignment: CrossAxisAlignment.stretch,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      "آية ${result.matchedVerse!.id}",
                                                      style: TextStyle(color: Color(0xFFFFD700), fontSize: 13, fontFamily: 'Cairo'),
                                                    ),
                                                    Text(
                                                      "سُورَةُ ${surah.name}",
                                                      style: TextStyle(color: Colors.white70, fontSize: 15, fontFamily: 'Amiri', fontWeight: FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 12),
                                                Container(
                                                  padding: EdgeInsets.all(12),
                                                  decoration: BoxDecoration(
                                                    color: Color(0xFF252525),
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  child: _buildSnippet(
                                                      result.matchedVerse!.text,
                                                      _searchQuery),
                                                ),
                                              ],
                                            )
                                          : Column(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "سُورَةُ ${surah.name}",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 22,
                                                    fontFamily: 'Amiri',
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                                SizedBox(height: 8),
                                                Text(
                                                  "${surah.type}  •  ${surah.totalVerses} آية  •  رقم ${surah.number}",
                                                  style: TextStyle(
                                                    color: Colors.grey[500],
                                                    fontSize: 14,
                                                    fontFamily: 'Cairo',
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
    );
  }
}

class Verse {
  final int id;
  final String text;
  Verse({required this.id, required this.text});
}

class Surah {
  final String name;
  final int number;
  final String content;
  final String type;
  final int totalVerses;
  final List<Verse> verses;

  Surah({
    required this.name,
    required this.number,
    required this.content,
    required this.type,
    required this.totalVerses,
    required this.verses,
  });
}
