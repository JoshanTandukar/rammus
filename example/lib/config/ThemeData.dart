import 'package:flutter/material.dart';
import 'package:live/config/Config.dart';
import 'package:live/config/CustomColors.dart';
import 'package:live/constant/Dimens.dart';

ThemeData themeData(ThemeData baseTheme) {
  if (baseTheme.brightness == Brightness.dark) {
    CustomColors.loadColor2(false);
    // Dark Theme
    return baseTheme.copyWith(
      primaryColor: CustomColors.brandColor_primary,
      primaryColorDark: CustomColors.brandColor_secondary,
      primaryColorLight: CustomColors.brandColor_primary,
      textTheme: TextTheme(
        headline1: TextStyle(
            color: CustomColors.title_active,
            fontFamily: Config.heeboRegular),
        headline2: TextStyle(
            color: CustomColors.title_active,
            fontFamily: Config.heeboRegular),
        headline3: TextStyle(
            color: CustomColors.title_active,
            fontFamily: Config.heeboRegular),
        headline4: TextStyle(
          color: CustomColors.title_active,
          fontFamily: Config.heeboRegular,
        ),
        headline5: TextStyle(
            color: CustomColors.title_active,
            fontFamily: Config.heeboRegular,
            fontSize: Dimens.space18,
            fontWeight: FontWeight.bold),
        headline6: TextStyle(
            color: CustomColors.title_active,
            fontFamily: Config.heeboRegular),
        subtitle1: TextStyle(
            color: CustomColors.title_active,
            fontFamily: Config.heeboRegular,
            fontSize: Dimens.space18,
            fontWeight: FontWeight.bold),
        bodyText1: TextStyle(
            color: CustomColors.title_active,
            fontFamily: Config.heeboRegular,
            fontWeight: FontWeight.bold,
            fontSize: 15),
        bodyText2: TextStyle(
            color: CustomColors.title_active,
            fontFamily: Config.heeboRegular,
            fontSize: 15),
        caption: TextStyle(
            color: CustomColors.title_active,
            fontFamily: Config.heeboRegular),
        button: TextStyle(
            color: CustomColors.title_active,
            fontFamily: Config.heeboRegular),
        subtitle2: TextStyle(
            color: CustomColors.title_active,
            fontFamily: Config.heeboRegular,
            fontSize: Dimens.space16,
            fontWeight: FontWeight.bold),
        overline: TextStyle(
            color: CustomColors.title_active,
            fontFamily: Config.heeboRegular),
      ),
      iconTheme: IconThemeData(color: CustomColors.icon_active),
      appBarTheme: AppBarTheme(color: CustomColors.appbar_backgroundColor),
    );
  } else {
    CustomColors.loadColor2(true);
    // White Theme
    return baseTheme.copyWith(
        primaryColor: CustomColors.brandColor_primary,
        primaryColorDark: CustomColors.brandColor_secondary,
        primaryColorLight: CustomColors.brandColor_primary,
        textTheme: TextTheme(
          headline1: TextStyle(
              color: CustomColors.title_active,
              fontFamily: Config.heeboRegular),
          headline2: TextStyle(
              color: CustomColors.title_active,
              fontFamily: Config.heeboRegular),
          headline3: TextStyle(
              color: CustomColors.title_active,
              fontFamily: Config.heeboRegular),
          headline4: TextStyle(
              color: CustomColors.title_active,
              fontFamily: Config.heeboRegular),
          headline5: TextStyle(
              color: CustomColors.title_active,
              fontFamily: Config.heeboRegular,
              fontSize: Dimens.space18,
              fontWeight: FontWeight.bold),
          headline6: TextStyle(
              color: CustomColors.title_active,
              fontFamily: Config.heeboRegular),
          subtitle1: TextStyle(
              color: CustomColors.title_active,
              fontFamily: Config.heeboRegular,
              fontSize: Dimens.space18,
              fontWeight: FontWeight.bold),
          bodyText1: TextStyle(
              color: CustomColors.title_active,
              fontFamily: Config.heeboRegular,
              fontWeight: FontWeight.bold,
              fontSize: 15),
          bodyText2: TextStyle(
              color: CustomColors.title_active,
              fontFamily: Config.heeboRegular,
              fontSize: 15),
          caption: TextStyle(
              color: CustomColors.title_active,
              fontFamily: Config.heeboRegular),
          button: TextStyle(
              color: CustomColors.title_active,
              fontFamily: Config.heeboRegular),
          subtitle2: TextStyle(
              color: CustomColors.title_active,
              fontFamily: Config.heeboRegular,
              fontSize: Dimens.space16,
              fontWeight: FontWeight.bold),
          overline: TextStyle(
              color: CustomColors.title_active,
              fontFamily: Config.heeboRegular),
        ),
        iconTheme: IconThemeData(color: CustomColors.icon_active),
        appBarTheme: AppBarTheme(color: CustomColors.appbar_backgroundColor));
  }
}
