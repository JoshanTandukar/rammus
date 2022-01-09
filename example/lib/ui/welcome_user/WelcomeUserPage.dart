import 'package:flutter/gestures.dart';
import 'package:live/config/Config.dart';
import 'package:live/config/CustomColors.dart';
import 'package:live/constant/Constants.dart';
import 'package:live/constant/Dimens.dart';
import 'package:live/ui/bottom_nav_bar/bottomNavBar.dart';
import 'package:live/ui/common/ButtonWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:live/ui/dashboard/DashboardPage.dart';
import 'package:live/utils/Prefs.dart';
import 'package:live/utils/Utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WelcomeUserPage extends StatefulWidget
{
  const WelcomeUserPage({
    Key? key,
  }) : super(key: key);

  @override
  WelcomeUserPageState createState() => WelcomeUserPageState();
}

class WelcomeUserPageState extends State<WelcomeUserPage> with SingleTickerProviderStateMixin
{
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  bool isDarkTheme = false;

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
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: CustomColors.background_bg01,
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
                "assets/images/icon_medical_background.jpg",
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
                  child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.fromLTRB(Dimens.space32.w, Dimens.space41.h, Dimens.space32.w, Dimens.space0.h),
                    padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    child: Text(
                      (Prefs.getString(Const.VALUE_HOLDER_USER_NAME)!=null && Prefs.getString(Const.VALUE_HOLDER_USER_NAME)!.isNotEmpty?Prefs.getString(Const.VALUE_HOLDER_USER_NAME):Utils.getString("appName"))!+",\n"+Utils.getString("welcomeToHealthRecords"),
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        color: CustomColors.text_active,
                        fontFamily: Config.InterBold,
                        fontSize: Dimens.space24.sp,
                        fontWeight: FontWeight.normal,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(Dimens.space40.w, Dimens.space0.h, Dimens.space40.w, Dimens.space16.h),
                        padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        child: Text(
                          Utils.getString("healthRecordsOnYourPhone"),
                          textAlign: TextAlign.left,
                          style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            color: CustomColors.text_active,
                            fontFamily: Config.PoppinsSemiBold,
                            fontSize: Dimens.space40.sp,
                            fontWeight: FontWeight.normal,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.fromLTRB(Dimens.space40.w, Dimens.space0.h, Dimens.space40.w, Dimens.space16.h),
                        padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(Dimens.space30,),
                              topRight: Radius.circular(Dimens.space30,),
                              bottomLeft: Radius.circular(Dimens.space30,),
                              bottomRight: Radius.circular(Dimens.space30,),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 5,
                              offset: Offset(0, 5), // changes position of shadow
                            ),
                          ],
                        ),
                        child: RoundedButtonWidget(
                          width: Dimens.space293,
                          height: Dimens.space54,
                          onPressed: ()
                          {
                            Utils.openActivity(context, BottomNavBar());
                          },
                          corner: Dimens.space30,
                          buttonTextColor: CustomColors.button_textActive,
                          buttonBorderColor: CustomColors.button_active,
                          buttonBackgroundColor: CustomColors.button_active,
                          buttonText: Utils.getString("continue"),
                          fontStyle: FontStyle.normal,
                          titleTextAlign: TextAlign.center,
                          buttonFontSize: Dimens.space14,
                          buttonFontWeight: FontWeight.normal,
                          buttonFontFamily: Config.InterBold,
                          hasShadow: false,
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.fromLTRB(Dimens.space40.w, Dimens.space0.h, Dimens.space40.w, Dimens.space16.h),
                        padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        child: Text(
                          Utils.getString("continueWelcome"),
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            color: CustomColors.d_field_bgWhite,
                            fontFamily: Config.InterMedium,
                            fontSize: Dimens.space12.sp,
                            fontWeight: FontWeight.normal,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      ),
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
