<div align="center">

<img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter"/>
<img src="https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black" alt="Firebase"/>
<img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart"/>
<img src="https://img.shields.io/badge/Android-3DDC84?style=for-the-badge&logo=android&logoColor=white" alt="Android"/>

# 🕌 صدقة جارية
### تطبيق إسلامي متكامل — Islamic Companion App

*"إِذَا مَاتَ الْإِنْسَانُ انْقَطَعَ عَنْهُ عَمَلُهُ إِلَّا مِنْ ثَلَاثَةٍ: إِلَّا مِنْ صَدَقَةٍ جَارِيَةٍ..."*

</div>

---

## 📖 About

**صدقة جارية** is a comprehensive Islamic mobile application built with Flutter, designed to be a daily companion for Muslims. It provides a rich set of features to help users maintain their spiritual routine with a beautiful, modern dark UI.

---

## ✨ Features

| Feature | Description |
|---------|-------------|
| 🕐 **أوقات الصلاة** | Real-time prayer times based on location |
| ☀️ **أذكار الصباح** | Morning Azkar with full Arabic text |
| 🌙 **أذكار المساء** | Evening Azkar with full Arabic text |
| 📿 **المسبحة الرقمية** | Digital Tasbih counter |
| 📖 **القرآن الكريم** | Full Quran reader (Mushaf & audio) |
| 🤲 **الأدعية** | Comprehensive collection of Du'aa |
| 🙏 **السنن الرواتب** | Rawatib Sunnah prayers guide |
| 🔔 **إشعارات Firebase** | Smart push notifications with deep linking |

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK `>=3.0.0`
- Dart SDK `>=3.0.0`
- Android Studio / VS Code
- A Firebase project ([Create one here](https://console.firebase.google.com))

### Installation

```bash
# 1. Clone the repository
git clone https://github.com/MoaazBesher/sadaqa_site.git
cd sadaqa_site

# 2. Install dependencies
flutter pub get

# 3. Setup Firebase (see Security Setup below)

# 4. Run the app
flutter run
```

---

## 🔒 Security Setup

> [!IMPORTANT]
> This project requires Firebase configuration files that are **NOT included** in the repository for security reasons. You must create your own.

### Step 1 — Create Firebase Project
1. Go to [Firebase Console](https://console.firebase.google.com)
2. Create a new project
3. Enable **Realtime Database** and **Cloud Messaging (FCM)**

### Step 2 — Setup `firebase_options.dart`

```bash
# Install FlutterFire CLI (easiest method)
dart pub global activate flutterfire_cli
flutterfire configure
```

Or manually:
```bash
# Copy the example file
cp firebase_options.dart.example lib/firebase_options.dart

# Edit lib/firebase_options.dart and replace all YOUR_* placeholders
```

### Step 3 — Setup `google-services.json` (Android)

```bash
# Copy the example file
cp google-services.json.example android/app/google-services.json

# Edit android/app/google-services.json and replace all YOUR_* placeholders
```

You can download the real `google-services.json` directly from your Firebase Console:
> Firebase Console → Project Settings → Your Android App → Download `google-services.json`

### Files Required (not in repo)

| File | Location | How to Get |
|------|----------|------------|
| `firebase_options.dart` | `lib/` | Run `flutterfire configure` |
| `google-services.json` | `android/app/` | Firebase Console → Download |
| `GoogleService-Info.plist` | `ios/Runner/` | Firebase Console → Download |

---

## 🔔 Notification Deep Linking

The app supports FCM deep linking. When sending a notification from Firebase Console or your backend, include a `data` payload with the `screen` key:

```json
{
  "notification": {
    "title": "حان وقت صلاة الفجر 🕌",
    "body": "اضغط لعرض أوقات الصلاة"
  },
  "data": {
    "screen": "prayer_times"
  }
}
```

### Supported Screen Values

| Value | Destination |
|-------|-------------|
| `prayer_times` | أوقات الصلاة |
| `morning_azkar` | أذكار الصباح |
| `evening_azkar` | أذكار المساء |
| `misbaha` | المسبحة |
| `sonan` | السنن الرواتب |
| `doaa` | الأدعية |
| `quran` | القرآن الكريم |
| `moshaf` | المصحف |

---

## 🏗️ Project Structure

```
lib/
├── main.dart                    # App entry point
├── splash_screen.dart           # Splash + FCM pending navigation
├── home_page.dart               # Main home screen
├── prayer_times_page.dart       # Prayer times
├── morning_azkar_page.dart      # Morning Azkar
├── evening_azkar_page.dart      # Evening Azkar
├── masbaha_page.dart            # Digital Tasbih
├── doaa_page.dart               # Du'aa collection
├── sonan_page.dart              # Sunnah prayers
├── quran_page.dart              # Quran index
├── moshaf_page.dart             # Full Mushaf reader
├── update_checker.dart          # Auto update checker
├── firebase_options.dart        # 🔒 NOT in repo — create from example
└── services/
    └── fcm_service.dart         # Firebase Cloud Messaging service
```

---

## 📦 Dependencies

```yaml
firebase_core: ^3.x
firebase_messaging: ^15.x
firebase_database: ^11.x
flutter_local_notifications: ^18.x
url_launcher: ^6.x
```

---

## 🤝 Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create your feature branch: `git checkout -b feature/amazing-feature`
3. Commit your changes: `git commit -m 'feat: add amazing feature'`
4. Push to the branch: `git push origin feature/amazing-feature`
5. Open a Pull Request

> [!WARNING]
> Never commit `firebase_options.dart`, `google-services.json`, or `GoogleService-Info.plist`. These are in `.gitignore` for security.

---

## 📄 License

This project is licensed under the MIT License.

---

<div align="center">

Made with ❤️ for the Muslim Ummah

**جعله الله صدقة جارية**

</div>
