import os
import re

files_to_fix = [
    'doaa_page.dart',
    'moshaf_page.dart',
    'prayer_times_page.dart',
    'quran_page.dart',
    'sonan_page.dart'
]

for file in files_to_fix:
    filepath = os.path.join('lib', file)
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    # 1. Replace the plain IconButton for the drawer with Builder wrapped IconButton
    # We look for the common pattern:
    old_action = """          actions: [
            IconButton(
                icon: const Icon(Icons.menu_rounded, color: Color(0xFFFFD700)),
                onPressed: () => Scaffold.of(context).openEndDrawer(),
              ),
          ],"""
    new_action = """          actions: [
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu_rounded, color: Color(0xFFFFD700)),
                onPressed: () => Scaffold.of(context).openEndDrawer(),
              ),
            ),
          ],"""
    
    # Let's use a regex to be more flexible with indentation
    action_pattern = re.compile(r'actions:\s*\[\s*IconButton\(\s*icon:\s*const\s*Icon\(Icons\.menu_rounded,\s*color:\s*Color\(0xFFFFD700\)\),\s*onPressed:\s*\(\)\s*=>\s*Scaffold\.of\(context\)\.openEndDrawer\(\),\s*\),\s*\]', re.MULTILINE)
    
    match = action_pattern.search(content)
    if match:
        content = content[:match.start()] + new_action + content[match.end():]
        print(f"Fixed actions in {file}")

    # 2. Remove explicit leading: IconButton(...) for arrow_back
    leading_pattern = re.compile(r'\s*leading:\s*IconButton\(\s*icon:\s*Icon\(Icons\.arrow_back[^\)]*\),\s*onPressed:\s*\(\)\s*=>\s*Navigator\.of\(context\)\.pop\(\),\s*\),', re.MULTILINE)
    
    match_leading = leading_pattern.search(content)
    if match_leading:
        content = content[:match_leading.start()] + content[match_leading.end():]
        print(f"Removed leading in {file}")

    with open(filepath, 'w', encoding='utf-8') as f:
        f.write(content)
