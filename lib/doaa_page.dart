import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'widgets/shared_drawer.dart';
import 'widgets/shared_footer.dart';
import 'package:share_plus/share_plus.dart';
import 'package:clipboard/clipboard.dart';

class DoaaPage extends StatefulWidget {
  @override
  _DoaaPageState createState() => _DoaaPageState();
}

class _DoaaPageState extends State<DoaaPage> {
  List<DoaaCategory> _doaaCategories = [];
  bool _isLoading = true;
  Map<String, bool> _expandedState = {};

  @override
  void initState() {
    super.initState();
    _loadDoaa();
  }

  Future<void> _loadDoaa() async {
    try {
      final String jsonString =
          await rootBundle.loadString('assets/doaa.json');
      final List<dynamic> jsonData = json.decode(jsonString);

      final categories = jsonData
          .map((item) => DoaaCategory(
                title: item['title'] as String,
                duas: List<String>.from(item['duas']),
              ))
          .toList();

      setState(() {
        _doaaCategories = categories;
        _expandedState = {for (var c in categories) c.title: false};
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _copyDoaa(String text) {
    FlutterClipboard.copy(text).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("تم نسخ الدعاء!", style: TextStyle(fontFamily: 'Cairo')),
          backgroundColor: Colors.green,
        ),
      );
    });
  }

  void _shareDoaa(String text) {
    Share.share(
      text,
      subject: 'دعاء من تطبيق صدقة جارية',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const SharedDrawer(activeSection: AppSection.doaa),
      backgroundColor: Color(0xFF121212),
      appBar: AppBar(
          automaticallyImplyLeading: false,
        backgroundColor: Color(0xFF1E1E1E),
        title: Text(
          'أدعية',
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
        iconTheme: IconThemeData(
          color: Color(0xFFFFD700),
          size: 30,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFFFFD700),
                    ),
                  )
                : SingleChildScrollView(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _buildDoaaList(),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
          ),
          // الفوتر
          const SharedFooter(),
        ],
      ),
    );
  }

  Widget _buildDoaaList() {
    return Column(
      children: _doaaCategories.map((category) {
        return Card(
          margin: EdgeInsets.symmetric(vertical: 8),
          color: Color(0xFF1b1a1a),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: ExpansionTile(
            title: Text(
              category.title,
              style: TextStyle(
                color: Color(0xFFE0E0E0),
                fontSize: 18,
                fontFamily: 'Cairo',
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            initiallyExpanded: _expandedState[category.title] ?? false,
            onExpansionChanged: (expanded) {
              setState(() {
                _expandedState[category.title] = expanded;
              });
            },
            children: category.duas.map((doaa) {
              return Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Card(
                  color: Color(0xFF252525),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          doaa,
                          style: TextStyle(
                            color: Color(0xFFE0E0E0),
                            fontSize: 16,
                            fontFamily: 'Cairo',
                            height: 1.6,
                          ),
                          textAlign: TextAlign.right,
                        ),
                        SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              onPressed: () => _copyDoaa(doaa),
                              icon: Icon(Icons.copy, color: Colors.black),
                              style: IconButton.styleFrom(
                                backgroundColor: Color(0xFFFFD700),
                              ),
                            ),
                            SizedBox(width: 8),
                            IconButton(
                              onPressed: () => _shareDoaa(doaa),
                              icon: Icon(Icons.share, color: Colors.black),
                              style: IconButton.styleFrom(
                                backgroundColor: Color(0xFFFFD700),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      }).toList(),
    );
  }
}

class DoaaCategory {
  final String title;
  final List<String> duas;

  DoaaCategory({required this.title, required this.duas});
}