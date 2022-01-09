import 'dart:io';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:live/bloc/birthday_bloc/BirthdayBloc.dart';
import 'package:live/bloc/birthday_bloc/BirthdayState.dart';
import 'package:live/bloc/chat_bloc/ChatBloc.dart';
import 'package:live/bloc/chat_bloc/ChatState.dart';
import 'package:live/bloc/chat_create_channel/ChatCreateChannelBloc.dart';
import 'package:live/bloc/chat_create_channel/ChatCreateChannelState.dart';
import 'package:live/bloc/chat_channel_subscription/ChatChannelSubscriptionBloc.dart';
import 'package:live/bloc/chat_channel_subscription/ChatChannelSubscriptionState.dart';
import 'package:live/bloc/chat_video_only_bloc/ChatChannelVideoOnlySubscriptionBloc.dart';
import 'package:live/bloc/chat_video_only_bloc/ChatChannelVideoOnlySubscriptionState.dart';
import 'package:live/bloc/forgetPassword_bloc/ForgetPasswordBloc.dart';
import 'package:live/bloc/forgetPassword_bloc/ForgetPasswordState.dart';
import 'package:live/bloc/otpVerification_bloc/OtpVerificationBloc.dart';
import 'package:live/bloc/otpVerification_bloc/OtpVerificationState.dart';
import 'package:live/bloc/otp_bloc/OtpBloc.dart';
import 'package:live/bloc/otp_bloc/OtpState.dart';
import 'package:live/bloc/register_bloc/RegisterBloc.dart';
import 'package:live/bloc/register_bloc/RegisterState.dart';
import 'package:live/bloc/signin_bloc/SignInBloc.dart';
import 'package:live/bloc/signin_bloc/SignInState.dart';
import 'package:live/bloc/userNameValidation_bloc/UsernameValidationBloc.dart';
import 'package:live/bloc/userNameValidation_bloc/UsernameValidationState.dart';
import 'package:live/bloc/yourName_bloc/YourNameBloc.dart';
import 'package:live/bloc/yourName_bloc/YourNameState.dart';
import 'package:live/config/CustomColors.dart';
import 'package:live/constant/Constants.dart';
import 'package:live/ui/app_info/AppInfoPage.dart';
import 'package:live/utils/Prefs.dart';
import 'bloc/call_bloc/CallBloc.dart';
import 'bloc/call_bloc/CallState.dart';
import 'bloc/signout_bloc/SignOutBloc.dart';
import 'bloc/signout_bloc/SignOutState.dart';
import 'flavors.dart';
import 'dart:async';
import 'package:dynamic_themes/dynamic_themes.dart';
import 'package:easy_localization/easy_localization.dart';
// import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:live/bloc/appInfo_bloc/AppInfoBloc.dart';
import 'package:live/bloc/appInfo_bloc/AppInfoState.dart';
import 'package:live/config/Config.dart';
import 'package:live/viewobject/common/Language.dart';
import 'package:live/bloc/getEmail_bloc/GetEmailBloc.dart';
import 'package:live/bloc/getEmail_bloc/GetEmailState.dart';
import 'package:live/bloc/saasDomain_bloc/SaasDomainBloc.dart';
import 'package:live/bloc/saasDomain_bloc/SaasDomainState.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await EasyLocalization.ensureInitialized();
  F.appFlavor = Flavor.DEV;
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  GestureBinding.instance?.resamplingEnabled = false;
  Prefs.init();
  // initializePusher();

  AwesomeNotifications().initialize(null, [
    NotificationChannel(
      channelKey: Const.NOTIFICATION_CHANNEL_VIDEO_CALL,
      channelName: Const.NOTIFICATION_CHANNEL_VIDEO_CALL,
      channelDescription: Const.NOTIFICATION_CHANNEL_VIDEO_CALL,
      channelGroupKey: Const.NOTIFICATION_CHANNEL_VIDEO_CALL,
      importance: NotificationImportance.Max,
      criticalAlerts: true,
      defaultColor: Colors.purple,
      ledColor: Colors.purple,
      playSound: false,
      locked: true,
      channelShowBadge: true,
      enableLights: true,
      groupAlertBehavior: GroupAlertBehavior.All,
      defaultPrivacy: NotificationPrivacy.Private,
      onlyAlertOnce: false,
      enableVibration: true,
      vibrationPattern: highVibrationPattern,
    ),
  ]);
  // runZonedGuarded(() {
  runApp(
    EasyLocalization(
      path: 'assets/langs',
      supportedLocales: getSupportedLanguages(),
      child: PSApp(),
    ),
  );
  // }, FirebaseCrashlytics.instance.recordError);
}

List<Locale> getSupportedLanguages() {
  final List<Locale> localeList = <Locale>[];
  for (final Language lang in Config.psSupportedLanguageList) {
    localeList.add(Locale(lang.languageCode, lang.countryCode));
  }
  print('Loaded Languages');
  return localeList;
}

class PSApp extends StatefulWidget {
  @override
  _PSAppState createState() => _PSAppState();
}

class _PSAppState extends State<PSApp>
{

  @override
  void initState()
  {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(375, 812),
      builder: () => MultiBlocProvider(
        providers: [
          BlocProvider<AppInfoBloc>(
            create: (BuildContext context) =>
                AppInfoBloc(InitialAppInfoState()),
          ),
          BlocProvider<OtpBloc>(
            create: (BuildContext context) => OtpBloc(InitialOtpState()),
          ),
          BlocProvider<OtpVerificationBloc>(
            create: (BuildContext context) =>
                OtpVerificationBloc(InitialOtpVerificationState()),
          ),
          BlocProvider<ForgetPasswordBloc>(
            create: (BuildContext context) =>
                ForgetPasswordBloc(InitialForgetPasswordState()),
          ),
          BlocProvider<YourNameBloc>(
            create: (BuildContext context) =>
                YourNameBloc(InitialYourNameState()),
          ),
          BlocProvider<SignInBloc>(
            create: (BuildContext context) => SignInBloc(InitialSignInState()),
          ),
          BlocProvider<BirthdayBloc>(
            create: (BuildContext context) =>
                BirthdayBloc(InitialBirthdayState()),
          ),
          BlocProvider<UserNameValidationBloc>(
            create: (BuildContext context) =>
                UserNameValidationBloc(InitialUsernameValidationState()),
          ),
          BlocProvider<GetEmailBloc>(
            create: (BuildContext context) =>
                GetEmailBloc(InitialGetEmailState()),
          ),
          BlocProvider<SaasDomainBloc>(
            create: (BuildContext context) =>
                SaasDomainBloc(InitialSaasDomainState()),
          ),
          BlocProvider<ChatBloc>(
            create: (BuildContext context) => ChatBloc(InitialChatState()),
          ),
          BlocProvider<RegisterBloc>(
            create: (BuildContext context) =>
                RegisterBloc(InitialRegisterState()),
          ),
          BlocProvider<ChatChannelSubscriptionBloc>(
            create: (BuildContext context) => ChatChannelSubscriptionBloc(
                InitialChatChannelSubscriptionState()),
          ),
          BlocProvider<ChatChannelVideoOnlySubscriptionBloc>(
            create: (BuildContext context) => ChatChannelVideoOnlySubscriptionBloc(
                InitialChatChannelVideoOnlySubscriptionState()),
          ),
          BlocProvider<ChatCreateChannelBloc>(
            create: (BuildContext context) =>
                ChatCreateChannelBloc(InitialChatCreateChannelState()),
          ),
          BlocProvider<CallBloc>(
            create: (BuildContext context) =>
                CallBloc(InitialCallState()),
          ),
          BlocProvider<SignOutBloc>(
            create: (BuildContext context) =>
                SignOutBloc(InitialSignOutState()),
          ),
        ],
        child: DynamicTheme(
          themeCollection: themeCollection,
          defaultThemeId: AppThemes.light,
          builder: (context, theme) {
            return MaterialApp(
              debugShowCheckedModeBanner: true,
              builder: (BuildContext context, Widget? child) {
                bool? value = Prefs.getBool(Const.THEME_IS_LIGHT_THEME);
                if (value != null) {
                  CustomColors.loadColor2(value);
                } else {
                  if (MediaQuery.of(context).platformBrightness ==
                      Brightness.light) {
                    Prefs.setBool(Const.THEME_IS_LIGHT_THEME, true);
                    CustomColors.loadColor2(true);
                  } else {
                    Prefs.setBool(Const.THEME_IS_LIGHT_THEME, false);
                    CustomColors.loadColor2(false);
                  }
                }

                String? currentLanguage =
                Prefs.getString(Const.LANGUAGE_LANGUAGE_CODE_KEY);

                if (currentLanguage != null) {
                  EasyLocalization.of(context)?.setLocale(Locale(
                      currentLanguage,
                      Prefs.getString(Const.LANGUAGE_COUNTRY_CODE_KEY)));
                } else {
                  Config.psSupportedLanguageList.forEach((element) {
                    String appLocale = Platform.localeName;
                    List<String> listAppLocale = appLocale.split("_");
                    if (element.languageCode == listAppLocale[0]) {
                      Prefs.setString(Const.LANGUAGE_LANGUAGE_CODE_KEY,
                          element.languageCode);
                      Prefs.setString(
                          Const.LANGUAGE_COUNTRY_CODE_KEY, element.countryCode);
                      Prefs.setString(
                          Const.LANGUAGE_LANGUAGE_NAME_KEY, element.name);
                      EasyLocalization.of(context)?.setLocale(
                          Locale(element.languageCode, element.countryCode));
                    }
                  });
                }

                return MediaQuery(
                  data: MediaQuery.of(context).copyWith(
                    textScaleFactor: 1,
                  ), //set desired text scale factor here
                  child: child!,
                );
              },
              title: 'Peeq Live',
              theme: ThemeData.light(),
              darkTheme: ThemeData.dark(),
              home: AppInfoPage(),
              localizationsDelegates: <LocalizationsDelegate<dynamic>>[
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                EasyLocalization.of(context)!.delegate,
              ],
              supportedLocales: EasyLocalization.of(context)!.supportedLocales,
              locale: EasyLocalization.of(context)!.locale,
            );
          },
        ),
      ),
    );
  }
}

class AppThemes {
  static const int light = 0;
  static const int dark = 1;
}

final themeCollection = ThemeCollection(
  themes: {
    AppThemes.light: ThemeData.light(),
    AppThemes.dark: ThemeData.dark(),
  },
  fallbackTheme: ThemeData.light(),
);
