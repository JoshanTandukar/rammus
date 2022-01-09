import 'package:live/config/Config.dart';
import 'package:live/config/CustomColors.dart';
import 'package:live/constant/Dimens.dart';
import 'package:live/ui/common/ButtonWidget.dart';
import 'package:live/ui/common/CustomImageHolder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:live/ui/login/LoginPage.dart';
import 'package:live/ui/otp/OtpPage.dart';
import 'package:live/ui/password/PasswordSetUpPage.dart';
import 'package:live/utils/Utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';

class WelcomePage extends StatefulWidget
{
  const WelcomePage({
    Key? key,
  }) : super(key: key);

  @override
  WelcomePageState createState() => WelcomePageState();
}

class WelcomePageState extends State<WelcomePage> with SingleTickerProviderStateMixin
{
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  void initState()
  {
    super.initState();
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
        statusBarIconBrightness: Utils.isLightMode()?Brightness.dark:Brightness.light,
        statusBarBrightness: Utils.isLightMode()?Brightness.dark:Brightness.light,
        systemNavigationBarIconBrightness: Utils.isLightMode()?Brightness.dark:Brightness.light,
        systemNavigationBarDividerColor: CustomColors.background_bg01,
      ),
    );

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: CustomColors.background_bg02,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: CustomColors.background_bg01,
        alignment: Alignment.center,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
              padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
              child: Image.asset(
                "assets/images/icon_background.png",
                fit: BoxFit.cover,
                height: MediaQuery.of(context).size.height,
                width: double.maxFinite,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space230.h, Dimens.space0.w, Dimens.space0.h),
                        padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        child: Text(
                          Utils.getString("welcomeToPeeq"),
                          style: Theme.of(context).textTheme.bodyText2!.copyWith(
                            color: CustomColors.title_active,
                            fontSize: Dimens.space24.sp,
                            fontFamily: Config.InterBold,
                            fontWeight: FontWeight.normal,
                                fontStyle: FontStyle.normal,
                          ),
                        ),
                      ),
                      // Container(
                      //   alignment: Alignment.center,
                      //   margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space233.h, Dimens.space0.w, Dimens.space0.h),
                      //   padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      //   child: PlainAssetImageHolder(
                      //     assetUrl: "assets/images/icon_wave.png",
                      //     height: Dimens.space24,
                      //     width: Dimens.space24,
                      //     assetWidth: Dimens.space24,
                      //     assetHeight: Dimens.space24,
                      //     boxFit: BoxFit.contain,
                      //     iconUrl: Icons.person,
                      //     iconSize: Dimens.space10,
                      //     iconColor: CustomColors.appbar_backgroundColor,
                      //     boxDecorationColor: Colors.transparent,
                      //     outerCorner: Dimens.space0,
                      //     innerCorner: Dimens.space0,
                      //     onTap: () {},
                      //   ),
                      // ),
                    ],
                  ),
                ),
                Expanded(
                  child: PlainAssetImageHolder(
                    assetUrl: "assets/images/logo.png",
                    height: Dimens.space100,
                    width: Dimens.space100,
                    assetWidth: Dimens.space100,
                    assetHeight: Dimens.space100,
                    boxFit: BoxFit.contain,
                    iconUrl: Icons.person,
                    iconSize: Dimens.space10,
                    iconColor: CustomColors.appbar_backgroundColor,
                    boxDecorationColor: Colors.transparent,
                    outerCorner: Dimens.space0,
                    innerCorner: Dimens.space0,
                    onTap: ()
                    {

                    },
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.fromLTRB(Dimens.space65.w, Dimens.space0.h, Dimens.space65.w, Dimens.space0.h),
                        padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        child: RoundedButtonWidget(
                          width: Dimens.space246,
                          height: Dimens.space54,
                          onPressed: ()
                          {
                            Utils.openActivity(context, LoginPage());
                          },
                          corner: Dimens.space30.r,
                          buttonTextColor: CustomColors.button_textActive,
                          buttonBorderColor: CustomColors.brandColor_primary,
                          buttonBackgroundColor: CustomColors.brandColor_primary,
                          buttonText: Utils.getString("signIn"),
                          fontStyle: FontStyle.normal,
                          titleTextAlign: TextAlign.center,
                          buttonFontSize: Dimens.space18,
                          buttonFontWeight: FontWeight.normal,
                          buttonFontFamily: Config.InterMedium,
                          hasShadow: false,
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.fromLTRB(Dimens.space65.w, Dimens.space20.h, Dimens.space65.w, Dimens.space0.h),
                        padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        child: RoundedButtonWidget(
                          width: Dimens.space246,
                          height: Dimens.space54,
                          onPressed: ()
                          {
                            Utils.openActivity(context, OtpPage());
                          },
                          corner: Dimens.space30.r,
                          buttonTextColor: CustomColors.title_active,
                          buttonBorderColor: CustomColors.brandColor_primary,
                          buttonBackgroundColor: Colors.transparent,
                          buttonText: Utils.getString("getStarted"),
                          fontStyle: FontStyle.normal,
                          titleTextAlign: TextAlign.center,
                          buttonFontSize: Dimens.space18,
                          buttonFontWeight: FontWeight.normal,
                          buttonFontFamily: Config.InterMedium,
                          hasShadow: false,
                        ),
                      ),
                      // Container(
                      //   alignment: Alignment.topCenter,
                      //   margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space34.h, Dimens.space0.w, Dimens.space34.h),
                      //   padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      //   child: RichText(
                      //     text: TextSpan(
                      //       text: "",
                      //       style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      //         color: CustomColors.brandColor_primary,
                      //         fontFamily: Config.InterMedium,
                      //         fontSize: Dimens.space14.sp,
                      //         fontWeight: FontWeight.normal,
                      //         fontStyle: FontStyle.normal,
                      //       ),
                      //       children: <TextSpan>
                      //       [
                      //         TextSpan(
                      //           text: Utils.getString("gotAnInvite"),
                      //           style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      //             color: CustomColors.brandColor_primary,
                      //             fontFamily: Config.InterSemiBold,
                      //             fontSize: Dimens.space14.sp,
                      //             fontWeight: FontWeight.normal,
                      //             fontStyle: FontStyle.normal,
                      //           ),
                      //           recognizer: TapGestureRecognizer()
                      //             ..onTap = ()
                      //             {
                      //               Utils.openActivity(context, OtpPage());
                      //             },
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
