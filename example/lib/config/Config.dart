import 'package:flutter/foundation.dart';
import 'package:live/viewobject/common/Language.dart';

class Config {
  Config._();

  // App Version
  static const String appVersion = '1.0.20';

  ///dev
  static const String baseUrl =
      kReleaseMode ? 'https://odoo.peeq.live' : 'https://odoo.peeq.live';

  ///dev

  static const List<String> listChatUrl = [
    "https://chat.peeq.live",
  ];

  static const List<String> listSocketUrl = [
    "wss://chat.peeq.live/websocket",
  ];

  static const String chatUrl = 'https://chat.peeq.live';

  //Thumbnail generated folder URL
  static const String ps_app_image_thumbs_url =
      'https://miro.medium.com/max/1838/1*MI686k5sDQrISBM6L8pf5A.jpeg';

  // Animation Duration
  static const Duration animation_duration = Duration(milliseconds: 100);

  // Font Family
  static const String heeboRegular = 'HeeboRegular';
  static const String heeboMedium = 'HeeboMedium';
  static const String heeboBlack = 'HeeboBlack';
  static const String heeboBold = 'HeeboBold';
  static const String heeboExtraBold = 'HeeboExtraBold';
  static const String heeboLight = 'HeeboLight';
  static const String heeboThin = 'HeeboThin';
  static const String manropeRegular = 'ManropeRegular';
  static const String manropeMedium = 'ManropeMedium';
  static const String manropeBold = 'ManropeBold';
  static const String manropeExtraBold = 'ManropeExtraBold';
  static const String manropeLight = 'ManropeLight';
  static const String manropeSemiBold = 'ManropeSemiBold';
  static const String manropeThin = 'ManropeThin';
  static const String PoppinsBlack = 'PoppinsBlack';
  static const String PoppinsBlackItalic = 'PoppinsBlackItalic';
  static const String PoppinsBold = 'PoppinsBold';
  static const String PoppinsBoldItalic = 'PoppinsBoldItalic';
  static const String PoppinsExtraBold = 'PoppinsExtraBold';
  static const String PoppinsExtraBoldItalic = 'PoppinsExtraBoldItalic';
  static const String PoppinsExtraLight = 'PoppinsExtraLight';
  static const String PoppinsExtraLightItalic = 'PoppinsExtraLightItalic';
  static const String PoppinsItalic = 'PoppinsItalic';
  static const String PoppinsLight = 'PoppinsLight';
  static const String PoppinsLightItalic = 'PoppinsLightItalic';
  static const String PoppinsMedium = 'PoppinsMedium';
  static const String PoppinsMediumItalic = 'PoppinsMediumItalic';
  static const String PoppinsRegular = 'PoppinsRegular';
  static const String PoppinsSemiBold = 'PoppinsSemiBold';
  static const String PoppinsSemiBoldItalic = 'PoppinsSemiBoldItalic';
  static const String PoppinsThin = 'PoppinsThin';
  static const String PoppinsThinItalic = 'PoppinsThinItalic';
  static const String InterBlack = 'InterBlack';
  static const String InterBold = 'InterBold';
  static const String InterExtraBold = 'InterExtraBold';
  static const String InterExtraLight = 'InterExtraLight';
  static const String InterLight = 'InterLight';
  static const String InterMedium = 'InterMedium';
  static const String InterRegular = 'InterRegular';
  static const String InterSemiBold = 'InterSemiBold';
  static const String InterThin = 'InterThin';

  static const String app_db_name = 'krispcallMVP.db';

  static final Language defaultLanguage =
      Language(languageCode: 'fr', countryCode: 'FR', name: 'French');

  static final List<Language> psSupportedLanguageList = <Language>[
    Language(languageCode: 'en', countryCode: 'US', name: 'English'),
    Language(languageCode: 'fr', countryCode: 'FR', name: 'French'),
    Language(languageCode: 'zh', countryCode: 'CN', name: 'Chinese'),
  ];

  // iOS App No
  static const String iOSAppStoreId = '1515087604';

  ///
  /// Default Limit
  ///
  static const int DEFAULT_LOADING_LIMIT = 20;

  static const String dateFormat = "MM/dd/yyyy";
  static const String dateFullMonthYearAndTimeFormat = 'MMMM dd, y';
}
