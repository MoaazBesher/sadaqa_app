import os
import re

files_to_fix = [
    'doaa_page.dart',
    'evening_azkar_page.dart',
    'masbaha_page.dart',
    'morning_azkar_page.dart',
    'moshaf_page.dart',
    'quran_page.dart',
    'sonan_page.dart'
]

for file in files_to_fix:
    filepath = os.path.join('lib', file)
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    # Look for appBar: AppBar( and insert automaticallyImplyLeading: false,
    new_content = re.sub(r'appBar:\s*AppBar\(', r'appBar: AppBar(\n          automaticallyImplyLeading: false,', content)
    
    with open(filepath, 'w', encoding='utf-8') as f:
        f.write(new_content)
    print(f"Added automaticallyImplyLeading to {file}")
