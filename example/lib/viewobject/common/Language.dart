import 'dart:ui';

class Language
{
  Language({
    required this.languageCode,
    required this.countryCode,
    required this.name
  });
  final String languageCode;
  final String countryCode;
  final String name;



  Locale toLocale()
  {
    return Locale(languageCode, countryCode);
  }
}
