import 'dart:async';
import 'package:flutter/services.dart';
import 'package:live/config/CustomColors.dart';
import 'package:live/constant/Constants.dart';
import 'package:live/constant/Dimens.dart';
import 'package:live/ui/bottom_nav_bar/bottomNavBar.dart';
import 'package:live/ui/common/CustomImageHolder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:live/ui/welcome/WelcomePage.dart';
import 'package:live/utils/Utils.dart';
import 'package:live/utils/Prefs.dart';

class AppInfoPage extends StatefulWidget {
  const AppInfoPage({
    Key? key,
  }) : super(key: key);

  @override
  AppInfoPageState createState() => AppInfoPageState();
}

class AppInfoPageState extends State<AppInfoPage> with SingleTickerProviderStateMixin
{
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  bool isLightTheme = true;

  @override
  void initState()
  {
    super.initState();
    Future.delayed(Duration(seconds: 2)).then((value)
    {
      print("App Info Page ${Prefs.getStringList(Const.VALUE_HOLDER_CHAT_AUTH_TOKEN).toString()}");
      if(Prefs.getStringList(Const.VALUE_HOLDER_CHAT_AUTH_TOKEN)!=null && Prefs.getStringList(Const.VALUE_HOLDER_CHAT_AUTH_TOKEN)!.length!=0)
      {
        Utils.openActivity(context, TopLevel());
      }
      else
      {
        Utils.openActivity(context, WelcomePage());
      }
    });
  }

  @override
  void dispose()
  {
    super.dispose();
  }

  @override
  Widget build(BuildContext context)
  {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: CustomColors.background_bg01,
        systemNavigationBarColor: CustomColors.background_bg01,
        statusBarIconBrightness: Utils.isLightMode()?Brightness.light:Brightness.dark,
        statusBarBrightness: Utils.isLightMode()?Brightness.light:Brightness.dark,
        systemNavigationBarIconBrightness: Utils.isLightMode()?Brightness.light:Brightness.dark,
        systemNavigationBarDividerColor: CustomColors.background_bg01,
      ),
    );

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: CustomColors.background_bg01,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: CustomColors.background_bg01,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  PlainAssetImageHolder(
                    assetUrl: "assets/images/logo.png",
                    height: Dimens.space90,
                    width: Dimens.space90,
                    assetWidth: Dimens.space76,
                    assetHeight: Dimens.space76,
                    boxFit: BoxFit.contain,
                    iconUrl: Icons.person,
                    iconSize: Dimens.space10,
                    iconColor: CustomColors.background_bg01,
                    boxDecorationColor: Colors.transparent,
                    outerCorner: Dimens.space0,
                    innerCorner: Dimens.space0,
                    onTap: () {},
                  ),
                  RoundedAssetSvgWithColorHolder(
                    imageWidth: Dimens.space74,
                    imageHeight: Dimens.space22,
                    containerWidth: Dimens.space74,
                    containerHeight: Dimens.space22,
                    svgColor: CustomColors.title_active,
                    iconColor: CustomColors.title_active,
                    boxDecorationColor: Colors.transparent,
                    assetUrl: "assets/svg/peeq_text_logo.svg",
                    boxFit: BoxFit.contain,
                    iconUrl: Icons.person,
                    iconSize: Dimens.space0,
                    outerCorner: Dimens.space0,
                    innerCorner: Dimens.space0,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    ///TODO For Dev Testing Language and Theme
    // return Scaffold(
    //   key: _scaffoldKey,
    //   backgroundColor: CustomColors.background_bg01,
    //   body: Container(
    //     height: MediaQuery.of(context).size.height,
    //     width: MediaQuery.of(context).size.width,
    //     color: CustomColors.background_bg01,
    //     alignment: Alignment.center,
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       crossAxisAlignment: CrossAxisAlignment.center,
    //       mainAxisSize: MainAxisSize.max,
    //       children: [
    //         PlainAssetImageHolder(
    //           assetUrl: "assets/images/splash.png",
    //           height: Dimens.space60,
    //           width: Dimens.space180,
    //           assetWidth: Dimens.space180,
    //           assetHeight: Dimens.space60,
    //           boxFit: BoxFit.contain,
    //           iconUrl: Icons.person,
    //           iconSize: Dimens.space10,
    //           iconColor: CustomColors.background_bg01,
    //           boxDecorationColor: Colors.transparent,
    //           outerCorner: Dimens.space0,
    //           innerCorner: Dimens.space0,
    //           onTap: () {},
    //         ),
    //         Text(
    //           Utils.getString("appName"),
    //           style: Theme.of(context).textTheme.bodyText2!.copyWith(
    //             fontWeight: FontWeight.bold,
    //             color: CustomColors.title_active,
    //           ),
    //         ),
    //         Text(
    //           Utils.getString("thisIsTestLanguage"),
    //           style: Theme.of(context).textTheme.bodyText2!.copyWith(
    //             fontWeight: FontWeight.bold,
    //             color: CustomColors.title_active,
    //           ),
    //         ),
    //         FlutterSwitch(
    //             value: isLightTheme,
    //             onToggle: (value) {
    //               if (value) {
    //                 setState(() {
    //                   isLightTheme = value;
    //                   Prefs.setBool(Const.THEME_IS_LIGHT_THEME, true);
    //                   CustomColors.loadColor2(true);
    //                 });
    //               } else {
    //                 setState(() {
    //                   isLightTheme = value;
    //                   Prefs.setBool(Const.THEME_IS_LIGHT_THEME, false);
    //                   CustomColors.loadColor2(false);
    //                 });
    //               }
    //             }),
    //         TextButton(
    //           onPressed: () {
    //             setState(() {
    //               Prefs.setString(Const.LANGUAGE_LANGUAGE_CODE_KEY, "en");
    //               Prefs.setString(Const.LANGUAGE_COUNTRY_CODE_KEY, "US");
    //               Prefs.setString(
    //                   Const.LANGUAGE_LANGUAGE_NAME_KEY, "English");
    //               EasyLocalization.of(context)
    //                   ?.setLocale(Locale("en", "US"));
    //               Utils.openActivity(context, WelcomePage());
    //             });
    //           },
    //           child: Text(
    //             "English Sign Up",
    //             style: Theme.of(context).textTheme.bodyText2!.copyWith(
    //               fontWeight: FontWeight.bold,
    //               color: CustomColors.title_active,
    //             ),
    //           ),
    //         ),
    //         TextButton(
    //           onPressed: () {
    //             setState(() {
    //               Prefs.setString(Const.LANGUAGE_LANGUAGE_CODE_KEY, "en");
    //               Prefs.setString(Const.LANGUAGE_COUNTRY_CODE_KEY, "US");
    //               Prefs.setString(
    //                   Const.LANGUAGE_LANGUAGE_NAME_KEY, "English");
    //               EasyLocalization.of(context)
    //                   ?.setLocale(Locale("en", "US"));
    //               Utils.openActivity(context, WelcomePage());
    //             });
    //           },
    //           child: Text(
    //             "English Log In",
    //             style: Theme.of(context).textTheme.bodyText2!.copyWith(
    //               fontWeight: FontWeight.bold,
    //               color: CustomColors.title_active,
    //             ),
    //           ),
    //         ),
    //         TextButton(
    //           onPressed: () {
    //             setState(() {
    //               Prefs.setString(Const.LANGUAGE_LANGUAGE_CODE_KEY, "fr");
    //               Prefs.setString(Const.LANGUAGE_COUNTRY_CODE_KEY, "FR");
    //               Prefs.setString(
    //                   Const.LANGUAGE_LANGUAGE_NAME_KEY, "French");
    //               EasyLocalization.of(context)
    //                   ?.setLocale(Locale("fr", "FR"));
    //               Utils.openActivity(context, WelcomePage());
    //             });
    //           },
    //           child: Text(
    //             "French Sign Up",
    //             style: Theme.of(context).textTheme.bodyText2!.copyWith(
    //               fontWeight: FontWeight.bold,
    //               color: CustomColors.title_active,
    //             ),
    //           ),
    //         ),
    //         TextButton(
    //           onPressed: () {
    //             setState(() {
    //               Prefs.setString(Const.LANGUAGE_LANGUAGE_CODE_KEY, "fr");
    //               Prefs.setString(Const.LANGUAGE_COUNTRY_CODE_KEY, "FR");
    //               Prefs.setString(
    //                   Const.LANGUAGE_LANGUAGE_NAME_KEY, "French");
    //               EasyLocalization.of(context)
    //                   ?.setLocale(Locale("fr", "FR"));
    //               Utils.openActivity(context, WelcomePage());
    //             });
    //           },
    //           child: Text(
    //             "French Log In",
    //             style: Theme.of(context).textTheme.bodyText2!.copyWith(
    //               fontWeight: FontWeight.bold,
    //               color: CustomColors.title_active,
    //             ),
    //           ),
    //         ),
    //         TextButton(
    //           onPressed: () {
    //             setState(() {
    //               Prefs.setString(Const.LANGUAGE_LANGUAGE_CODE_KEY, "zh");
    //               Prefs.setString(Const.LANGUAGE_COUNTRY_CODE_KEY, "CN");
    //               Prefs.setString(
    //                   Const.LANGUAGE_LANGUAGE_NAME_KEY, "Chinese");
    //               EasyLocalization.of(context)
    //                   ?.setLocale(Locale("zh", "CN"));
    //               Utils.openActivity(context, WelcomePage());
    //             });
    //           },
    //           child: Text(
    //             "Chinese Sign Up",
    //             style: Theme.of(context).textTheme.bodyText2!.copyWith(
    //               fontWeight: FontWeight.bold,
    //               color: CustomColors.title_active,
    //             ),
    //           ),
    //         ),
    //         TextButton(
    //           onPressed: () {
    //             setState(() {
    //               Prefs.setString(Const.LANGUAGE_LANGUAGE_CODE_KEY, "zh");
    //               Prefs.setString(Const.LANGUAGE_COUNTRY_CODE_KEY, "CN");
    //               Prefs.setString(
    //                   Const.LANGUAGE_LANGUAGE_NAME_KEY, "Chinese");
    //               EasyLocalization.of(context)
    //                   ?.setLocale(Locale("zh", "CN"));
    //               Utils.openActivity(context, WelcomePage());
    //             });
    //           },
    //           child: Text(
    //             "Chinese Login",
    //             style: Theme.of(context).textTheme.bodyText2!.copyWith(
    //               fontWeight: FontWeight.bold,
    //               color: CustomColors.title_active,
    //             ),
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}
