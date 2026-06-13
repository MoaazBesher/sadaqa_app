RegExp buildArabicSearchRegex(String query) {
  query = query.replaceAll(RegExp(r'[\u064B-\u065F\u0670\u06D6-\u06ED]'), '');
  String pattern = '';
  for (int i = 0; i < query.length; i++) {
    String char = query[i];
    if (char == 'ا' || char == 'أ' || char == 'إ' || char == 'آ' || char == 'ٱ') {
      pattern += '[اأإآٱ]';
    } else if (char == 'ه' || char == 'ة') {
      pattern += '[هة]';
    } else if (char == 'ى' || char == 'ي' || char == 'ئ') {
      pattern += '[ىيئ]';
    } else if (char == 'و' || char == 'ؤ') {
      pattern += '[وؤ]';
    } else if (char == ' ') {
      pattern += r'\s+';
    } else {
      pattern += char;
    }
    
    if (char != ' ') {
      pattern += r'[\u064B-\u065F\u0670\u06D6-\u06ED]*';
    }
  }
  return RegExp(pattern);
}
