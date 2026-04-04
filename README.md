<div align="center">

<img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white"/>
<img src="https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black"/>
<img src="https://img.shields.io/badge/Android-3DDC84?style=for-the-badge&logo=android&logoColor=white"/>

# 🕌 صدقة جارية

*"إِذَا مَاتَ الْإِنْسَانُ انْقَطَعَ عَنْهُ عَمَلُهُ إِلَّا مِنْ ثَلَاثَةٍ: إِلَّا مِنْ صَدَقَةٍ جَارِيَةٍ..."*

### [⬇️ تحميل وتثبيت التطبيق](https://sadaqa-mainpage.netlify.app/downloadpage/)

</div>

---

## ✨ المميزات

| | |
|--|--|
| 🕐 أوقات الصلاة | ☀️ أذكار الصباح |
| 🌙 أذكار المساء | 📿 المسبحة الرقمية |
| 📖 القرآن الكريم | 🤲 الأدعية |
| 🙏 السنن الرواتب | 🔔 إشعارات ذكية |

---

## 🚀 تشغيل المشروع محلياً

```bash
git clone https://github.com/MoaazBesher/sadaqa_site.git
cd sadaqa_site
flutter pub get
```

### إعداد Firebase 🔒

الملفات الحساسة غير مضمّنة في الريبو. أنشئ مشروع Firebase خاص بك:

```bash
# الطريقة الأسرع
dart pub global activate flutterfire_cli
flutterfire configure
```

أو انسخ الملفات المرجعية يدوياً:

```bash
cp firebase_options.dart.example lib/firebase_options.dart
cp google-services.json.example android/app/google-services.json
```

ثم استبدل `YOUR_*` بالقيم من [Firebase Console](https://console.firebase.google.com).

---

## 🔔 Deep Linking مع الإشعارات

أرسل `data` payload مع الإشعار لفتح صفحة معينة مباشرة:

```json
{
  "data": { "screen": "prayer_times" }
}
```

| `screen` value | الصفحة |
|----------------|--------|
| `prayer_times` | أوقات الصلاة |
| `morning_azkar` | أذكار الصباح |
| `evening_azkar` | أذكار المساء |
| `misbaha` | المسبحة |
| `doaa` | الأدعية |
| `quran` | القرآن |
| `moshaf` | المصحف |

---

<div align="center">
جعله الله صدقة جارية ❤️
</div>
