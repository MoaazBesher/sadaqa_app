<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)
![iOS](https://img.shields.io/badge/iOS-000000?style=for-the-badge&logo=apple&logoColor=white)
![Android](https://img.shields.io/badge/Android-3DDC84?style=for-the-badge&logo=android&logoColor=white)
![CI/CD](https://img.shields.io/badge/GitHub_Actions-2088FF?style=for-the-badge&logo=github-actions&logoColor=white)

# صدقة جارية (Sadaqa Jaria)

**A comprehensive Islamic app** — prayer times, athkar, Quran, digital misbaha, and daily supplications.

> *"When a person dies, their deeds come to an end except for three: ongoing charity (sadaqa jariyah), beneficial knowledge, or a righteous child who prays for them."*

### [Download the App](https://sadaqa-mainpage.netlify.app/downloadpage/)

</div>

---

## Features

| | | |
|--|--|--|
| Prayer Times | Morning Athkar | Evening Athkar |
| Digital Misbaha | Holy Quran | Supplications (Du'a) |
| Sunnah Rawatib | Smart Notifications | Audio Athkar |

---

## Getting Started

### Prerequisites
- Flutter SDK (stable channel)
- Firebase project (for notifications, database)

### Installation

```bash
git clone https://github.com/MoaazBesher/sadaqa_site.git
cd sadaqa_site
flutter pub get
```

### Firebase Setup

```bash
# Option 1: Using FlutterFire CLI
dart pub global activate flutterfire_cli
flutterfire configure

# Option 2: Manual (copy example files)
cp firebase_options.dart.example lib/firebase_options.dart
cp google-services.json.example android/app/google-services.json
```

---

## Deep Linking with Notifications

Send a `data` payload to navigate directly to a specific screen:

```json
{
  "data": { "screen": "prayer_times" }
}
```

| `screen` value | Destination |
|----------------|-------------|
| `prayer_times` | Prayer Times |
| `morning_azkar` | Morning Athkar |
| `evening_azkar` | Evening Athkar |
| `misbaha` | Digital Misbaha |
| `doaa` | Supplications |
| `quran` | Quran |
| `moshaf` | Mushaf Reader |

---

## CI/CD

This project uses **GitHub Actions** for automated iOS builds:

| Stage | Description |
|-------|-------------|
| Stage 1 | Build without signing (validate compilation) |
| Stage 2 | Build signed IPA for distribution |

### Secrets required for signed builds:
| Secret | Description |
|--------|-------------|
| `IOS_CERTIFICATE` | Base64-encoded .p12 certificate |
| `IOS_CERTIFICATE_PASSWORD` | Certificate export password |
| `IOS_PROVISIONING_PROFILE` | Base64-encoded .mobileprovision profile |

---

## Supported Platforms

- Android (minimum SDK 21)
- iOS (minimum deployment target 13.0)

---

## License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.

<div align="center">

**جعله الله صدقة جارية**

</div>
