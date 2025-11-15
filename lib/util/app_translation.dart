// import 'dart:ui';
// import 'package:get/get.dart';
//
// class AppTranslation extends Translations {
//   @override
//   Map<String, Map<String, String>> get keys => {
//     'en_US': {
//       'app_title': 'RH Hotel',
//       'home_title': 'Home',
//       'toggle_theme': 'Toggle theme',
//       'change_language': 'Change language',
//       'invalid_credentials': 'Invalid Credentials',
//       'field_empty': 'Please fill out all fields',
//       'home': 'Dashboard',
//       'logout': 'Logout',
//       'coming_soon': 'Coming Soon...',
//       'confirm_logout': 'Do you want to logout?',
//       'user': 'User',
//       'no_record': 'No Record Found',
//       'room': 'Room',
//       'setting': 'Setting',
//       'select_language': 'Select Language',
//       'view_profile': 'View Profile',
//       'booking_history': 'Booking History',
//       'booking': 'Booking',
//       'available': 'Available',
//       'busy': 'Busy',
//       'cleaning': 'Cleaning',
//       'blocked': 'Blocked',
//       'unknown': 'Unknown',
//     },
//     'hi_IN': {
//       'app_title': 'RH Hotel',
//       'home_title': 'मुख्य पृष्ठ',
//       'toggle_theme': 'थीम बदलें',
//       'change_language': 'भाषा बदलें',
//       'invalid_credentials': 'अमान्य क्रेडेंशियल',
//       'field_empty': 'कृपया सभी फील्ड भरें',
//       'home': 'डैशबोर्ड',
//       'logout': 'लॉग आउट',
//       'coming_soon': 'जल्द आ रहा है...',
//       'confirm_logout': 'क्या आप लॉग आउट करना चाहते हैं?',
//       'user': 'उपयोगकर्ता',
//       'no_record': 'कोई रिकॉर्ड नहीं मिला',
//       'room': 'कमरा', // Room
//       'setting': 'सेटिंग', // Setting
//       'view_profile': 'प्रोफ़ाइल देखें',
//       'select_language': 'भाषा चुनें',
//       'booking_history': 'बुकिंग इतिहास',
//       'booking': 'बुकिंग',
//       'available': 'उपलब्ध',
//       'busy': 'व्यस्त',
//       'cleaning': 'सफाई',
//       'blocked': 'अवरुद्ध',
//       'unknown': 'अज्ञात',
//     },
//     'mr_IN': {
//       'app_title': 'RH Hotel',
//       'home_title': 'मुख्यपृष्ठ',
//       'toggle_theme': 'थीम बदला',
//       'change_language': 'भाषा बदला',
//       'invalid_credentials': 'अवैध क्रेडेन्शियल्स',
//       'field_empty': 'कृपया सर्व फील्ड भरा',
//       'home': 'डैशबोर्ड',
//       'logout': 'लॉग आउट',
//       'coming_soon': 'लवकरच येत आहे...',
//       'confirm_logout': 'तुम्हाला लॉग आउट करायचे आहे का?',
//       'user': 'वापरकर्ता',
//       'no_record': 'कोणतेही रेकॉर्ड सापडले नाहीत',
//       'room': 'खोली',
//       'setting': 'सेटिंग',
//       'select_language': 'भाषा निवडा',
//       'view_profile': 'प्रोफाइल बघा',
//       'booking_history': 'बुकिंग इतिहास',
//       'booking': 'बुकिंग',
//       'available': 'उपलब्ध',
//       'busy': 'व्यस्त',
//       'cleaning': 'स्वच्छता',
//       'blocked': 'ब्लॉक केलेला',
//       'unknown': 'अज्ञात',
//     },
//     'ur_PK': {
//       'app_title': 'RH Hotel',
//       'home_title': 'ہوم',
//       'toggle_theme': 'تھیم تبدیل کریں',
//       'change_language': 'زبان تبدیل کریں',
//       'invalid_credentials': 'غلط تفصیلات',
//       'field_empty': 'براہ کرم تمام خانے پُر کریں',
//       'home': 'ڈیش بورڈ',
//       'logout': 'لاگ آؤٹ',
//       'coming_soon': 'جلد آرہا ہے۔۔۔',
//       'confirm_logout': 'کیا آپ لاگ آؤٹ کرنا چاہتے ہیں؟',
//       'user': 'صارف',
//       'no_record': 'کوئی ریکارڈ نہیں ملا',
//       'room': 'کمرہ',
//       'setting': 'سیٹنگ',
//       'select_language': 'زبان منتخب کریں',
//       'view_profile': 'پروفائل دیکھیں',
//       'booking_history': 'بکنگ کی تاریخ',
//       'booking': 'بکنگ',
//       'available': 'دستیاب',
//       'busy': 'مصروف',
//       'cleaning': 'صفائی',
//       'blocked': 'مسدود',
//       'unknown': 'نامعلوم',
//     },
//     'ar_SA': {
//       'app_title': 'فندق RH',
//       'home_title': 'الصفحة الرئيسية',
//       'toggle_theme': 'تبديل السمة',
//       'change_language': 'تغيير اللغة',
//       'invalid_credentials': 'بيانات الاعتماد غير صالحة',
//       'field_empty': 'يرجى ملء جميع الحقول',
//       'home': 'لوحة التحكم',
//       'logout': 'تسجيل الخروج',
//       'coming_soon': 'قريبا...',
//       'confirm_logout': 'هل تريد تسجيل الخروج؟',
//       'user': 'المستخدم',
//       'no_record': 'لم يتم العثور على سجل',
//       'room': 'غرفة',
//       'setting': 'الإعدادات',
//       'select_language': 'اختار اللغة',
//       'view_profile': 'عرض الملف الشخصي',
//       'booking_history': 'تاريخ الحجز',
//       'booking': 'الحجز',
//       'available': 'متاح',
//       'busy': 'مشغول',
//       'cleaning': 'تنظيف',
//       'blocked': 'محظور',
//       'unknown': 'غير معروف',
//     },
//   };
//
//   /// Finds the key name corresponding to a specific translated value.
//   static String? getKeyFromValue(String value, {Locale? locale}) {
//     // Determine the locale to use (current locale by default)
//     locale ??= Get.locale;
//
//     // Get the specific language map (e.g., 'en_US' map)
//     final languageMap = Get.find<AppTranslation>().keys[locale.toString()];
//
//     if (languageMap == null) {
//       return null;
//     }
//
//     // Iterate through all entries in the map to find a match
//     for (var entry in languageMap.entries) {
//       if (entry.value == value) {
//         return entry.key; // Return the key name ("available")
//       }
//     }
//
//     return null;
//   }
// }
import 'dart:ui';
import 'package:get/get.dart';

class AppTranslation extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': {
      'app_title': 'RH Hotel',
      'home_title': 'Home',
      'toggle_theme': 'Toggle theme',
      'change_language': 'Change language',
      'invalid_credentials': 'Invalid Credentials',
      'field_empty': 'Please fill out all fields',
      'home': 'Dashboard',
      'logout': 'Logout',
      'coming_soon': 'Coming Soon...',
      'confirm_logout': 'Do you want to logout?',
      'user': 'User',
      'no_record': 'No Record Found',
      'room': 'Room',
      'setting': 'Setting',
      // 'hindi':'Hindi',
      // 'marathi':'Marathi',
      // 'urdu':'Urdu',
      // 'english':'English',
      // 'light': 'Light',
      // 'dark': 'Dark',
      // 'system': 'System',
      // 'select theme': 'Select Theme',
      'select_language': 'Select Language',
      'booking_history': 'Booking History',
      'booking': 'Booking',
      'available': 'Available',
      'busy': 'Busy',
      'cleaning': 'Cleaning',
      'blocked': 'Blocked',
      'unknown': 'Unknown',

    },
    'hi_IN': {
      'app_title': 'RH Hotel',
      'home_title': 'मुख्य पृष्ठ',
      'toggle_theme': 'थीम बदलें',
      'change_language': 'भाषा बदलें',
      'invalid_credentials': 'अमान्य क्रेडेंशियल',
      'field_empty': 'कृपया सभी फील्ड भरें',
      'home': 'डैशबोर्ड',
      'logout': 'लॉग आउट',
      'coming_soon': 'जल्द आ रहा है...',
      'confirm_logout': 'क्या आप लॉग आउट करना चाहते हैं?',
      'user': 'उपयोगकर्ता',
      'no_record': 'कोई रिकॉर्ड नहीं मिला',
      'room': 'कमरा', // Room
      'setting': 'सेटिंग', // Setting
      // 'hindi':'हिंदी',
      // 'marathi':'मराठी',
      // 'urdu':'उर्दू',
      // 'english':'अंग्रेज़ी',
      // 'light': 'लाइट',
      // 'dark': 'डार्क',
      // 'system': 'सिस्टम',
      // 'select theme': 'थीम चुनें',
      'select_language': 'भाषा चुनें',
      'booking_history': 'बुकिंग इतिहास',
      'booking': 'बुकिंग',
      'available': 'उपलब्ध',
      'busy': 'व्यस्त',
      'cleaning': 'सफाई',
      'blocked': 'अवरुद्ध',
      'unknown': 'अज्ञात',
    },
    'mr_IN': {
      'app_title': 'RH Hotel',
      'home_title': 'मुख्यपृष्ठ',
      'toggle_theme': 'थीम बदला',
      'change_language': 'भाषा बदला',
      'invalid_credentials': 'अवैध क्रेडेन्शियल्स',
      'field_empty': 'कृपया सर्व फील्ड भरा',
      'home': 'डैशबोर्ड',
      'logout': 'लॉग आउट',
      'coming_soon': 'लवकरच येत आहे...',
      'confirm_logout': 'तुम्हाला लॉग आउट करायचे आहे का?',
      'user': 'वापरकर्ता',
      'no_record': 'कोणतेही रेकॉर्ड सापडले नाहीत',
      'room': 'खोली',
      'setting': 'सेटिंग',
      // 'hindi':'हिंदी',
      // 'marathi':'मराठी',
      // 'urdu':'उर्दू',
      // 'english':'इंग्रजी',
      // 'light': 'लाइट',
      // 'dark': 'डार्क',
      // 'system': 'सिस्टम',
      // 'select theme': 'थीम निवडा',
      'select_language': 'भाषा निवडा',
      'booking_history': 'बुकिंग इतिहास',
      'booking': 'बुकिंग',
      'available': 'उपलब्ध',
      'busy': 'व्यस्त',
      'cleaning': 'स्वच्छता',
      'blocked': 'ब्लॉक केलेला',
      'unknown': 'अज्ञात',
    },
    'ur_PK': {
      'app_title': 'RH Hotel',
      'home_title': 'ہوم',
      'toggle_theme': 'تھیم تبدیل کریں',
      'change_language': 'زبان تبدیل کریں',
      'invalid_credentials': 'غلط تفصیلات',
      'field_empty': 'براہ کرم تمام خانے پُر کریں',
      'home': 'ڈیش بورڈ',
      'logout': 'لاگ آؤٹ',
      'coming_soon': 'جلد آرہا ہے۔۔۔',
      'confirm_logout': 'کیا آپ لاگ آؤٹ کرنا چاہتے ہیں؟',
      'user': 'صارف',
      'no_record': 'کوئی ریکارڈ نہیں ملا',
      'room': 'کمرہ',
      'setting': 'سیٹنگ',
      // 'hindi':'ہندی',
      // 'marathi':'مراٹھی',
      // 'urdu':'اردو',
      // 'english':'انگریزی',
      // 'light': 'لائٹ',
      // 'dark': 'ڈارک',
      // 'system': 'سسٹم',
      // 'select theme': 'تھیم منتخب کریں',
      'select_language': 'زبان منتخب کریں',
      'booking_history': 'بکنگ کی تاریخ',
      'booking': 'بکنگ',
      'available': 'دستیاب',
      'busy': 'مصروف',
      'cleaning': 'صفائی',
      'blocked': 'مسدود',
      'unknown': 'نامعلوم',
    },
  };
  /// Finds the key name corresponding to a specific translated value.
  static String? getKeyFromValue(String value, {Locale? locale}) {
    // Determine the locale to use (current locale by default)
    locale ??= Get.locale;

    // Get the specific language map (e.g., 'en_US' map)
    final languageMap = Get.find<AppTranslation>().keys[locale.toString()];

    if (languageMap == null) {
      return null;
    }

    // Iterate through all entries in the map to find a match
    for (var entry in languageMap.entries) {
      if (entry.value == value) {
        return entry.key; // Return the key name ("available")
      }
    }

    return null; // Return null if the value is not found
  }
}
