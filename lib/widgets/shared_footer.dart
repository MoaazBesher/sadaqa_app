import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SharedFooter extends StatelessWidget {
  const SharedFooter({Key? key}) : super(key: key);

  void _launchDeveloperWebsite() async {
    final Uri url = Uri.parse('https://moaazbesher.netlify.app');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A1A),
        border: Border(
          top: BorderSide(
            color: Color(0xFF2A2A2A),
            width: 1,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Designed And Developed By',
                style: TextStyle(
                  color: Colors.white70,
                  fontFamily: 'Cairo',
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 6),
              InkWell(
                onTap: _launchDeveloperWebsite,
                borderRadius: BorderRadius.circular(4),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
                  child: Text(
                    'Moaaz Besher',
                    style: TextStyle(
                      color: Color(0xFFFFD700),
                      fontFamily: 'Cairo',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ],
          ),

        ],
      ),
    );
  }
}
