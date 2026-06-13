import os
import re

files = [
    'prayer_times_page.dart',
    'sonan_page.dart',
    'morning_azkar_page.dart',
    'evening_azkar_page.dart',
    'doaa_page.dart',
    'quran_page.dart',
    'moshaf_page.dart',
    'masbaha_page.dart'
]

for filename in files:
    filepath = os.path.join(r'e:\flutterApps\sadaqa_site\lib', filename)
    if not os.path.exists(filepath):
        print(f"Skipping {filename}, not found")
        continue

    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    # 1. Add imports if not present
    if "import 'widgets/shared_drawer.dart';" not in content:
        content = re.sub(r"(import 'package:flutter/material\.dart';)", r"\1\nimport 'widgets/shared_drawer.dart';\nimport 'widgets/shared_footer.dart';", content)

    # 2. Add endDrawer to Scaffold
    if "endDrawer: const SharedDrawer()," not in content:
        content = re.sub(r'(return\s+Scaffold\s*\()', r'\1\n      endDrawer: const SharedDrawer(),', content)

    # 3. Replace usage of footers
    content = re.sub(r'_(buildFooter|buildProfessionalFooter)\s*\(\)\s*,', r'const SharedFooter(),', content)

    # 4. Remove the footer method
    # It starts with "Widget _buildFooter() {" or "Widget _buildProfessionalFooter() {"
    # We find the start, then match braces to remove the whole method.
    pattern = re.compile(r'\s*Widget _(buildFooter|buildProfessionalFooter)\s*\(\)\s*\{')
    match = pattern.search(content)
    if match:
        start_idx = match.start()
        # Find the matching closing brace
        brace_count = 0
        idx = content.find('{', start_idx)
        if idx != -1:
            brace_count = 1
            idx += 1
            while brace_count > 0 and idx < len(content):
                if content[idx] == '{':
                    brace_count += 1
                elif content[idx] == '}':
                    brace_count -= 1
                idx += 1
            # idx is now the character after the closing brace
            content = content[:start_idx] + content[idx:]

    with open(filepath, 'w', encoding='utf-8') as f:
        f.write(content)
    print(f"Refactored {filename}")
