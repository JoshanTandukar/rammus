import 'package:flutter/material.dart';
import 'package:live/config/Config.dart';
import 'package:live/config/CustomColors.dart';
import 'package:live/constant/Constants.dart';
import 'package:live/constant/Dimens.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:live/enum/Enum.dart';
import 'package:live/ui/common/ButtonWidget.dart';
import 'package:live/ui/common/CustomImageHolder.dart';
import 'package:live/ui/create_peeq/CreatePeeqPage.dart';
import 'package:live/ui/otp/OtpPage.dart';
import 'package:live/utils/Prefs.dart';
import 'package:live/utils/Utils.dart';

class WelcomeDialog extends StatefulWidget
{
  WelcomeDialog({
    Key? key,
  }) : super(key: key);

  @override
  WelcomeDialogState createState() => WelcomeDialogState();
}

class WelcomeDialogState extends State<WelcomeDialog>
{
  @override
  void initState()
  {
    super.initState();
  }

  @override
  Widget build(BuildContext context)
  {
    return Container(
        decoration: BoxDecoration(
          color: CustomColors.background_bg01,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(Dimens.space12.r),
            topRight: Radius.circular(Dimens.space12.r),
          ),
        ),
        height: Dimens.space500.h,
        alignment: Alignment.center,
        margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
        padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
        child: Column(
          children:
          [
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space40.h, Dimens.space0.w, Dimens.space16.h),
              padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
              child: PlainAssetImageHolder(
                assetUrl: "assets/images/logo.png",
                height: Dimens.space80,
                width: Dimens.space80,
                assetWidth: Dimens.space80,
                assetHeight: Dimens.space80,
                boxFit: BoxFit.contain,
                iconUrl: Icons.person,
                iconSize: Dimens.space10,
                iconColor: CustomColors.button_deactive,
                boxDecorationColor: Colors.transparent,
                outerCorner: Dimens.space0,
                innerCorner: Dimens.space0,
                onTap: ()
                {

                },
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space10.h, Dimens.space0.w, Dimens.space15.h),
              padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
              child: Text(
                Utils.getString("welComeTo")+" "+Utils.getString("peeq"),
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  color: CustomColors.title_active,
                  fontFamily: Config.PoppinsSemiBold,
                  fontSize: Dimens.space18.sp,
                  fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.normal,
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.fromLTRB(Dimens.space35.w, Dimens.space0.h, Dimens.space35.w, Dimens.space40.h),
              padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
              child: Text(
                Utils.getString("whatWouldYouDo"),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  color: CustomColors.title_deactive,
                  fontFamily: Config.InterMedium,
                  fontSize: Dimens.space14.sp,
                  fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.normal,
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.fromLTRB(Dimens.space65.w, Dimens.space0.h, Dimens.space65.w, Dimens.space20.h),
              padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
              child: RoundedButtonWidget(
                width: Dimens.space296,
                height: Dimens.space54,
                onPressed: ()
                {
                  Prefs.setString(Const.VALUE_HOLDER_USER_TYPE, USER_TYPE.host.toString());
                  Utils.openActivity(context, CreatePeeqPage());
                },
                corner: Dimens.space30.r,
                buttonTextColor: CustomColors.button_textActive!,
                buttonBorderColor: CustomColors.brandColor_primary!,
                buttonBackgroundColor: CustomColors.brandColor_primary!,
                buttonText: Utils.getString("hostASession"),
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
              margin: EdgeInsets.fromLTRB(Dimens.space65.w, Dimens.space0.h, Dimens.space65.w, Dimens.space20.h),
              padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
              child: RoundedButtonWidget(
                width: Dimens.space296,
                height: Dimens.space54,
                onPressed: ()
                {
                  Prefs.setString(Const.VALUE_HOLDER_USER_TYPE, USER_TYPE.user.toString());
                  Utils.openActivity(context, OtpPage());
                },
                corner: Dimens.space30.r,
                buttonTextColor: CustomColors.brandColor_primary!,
                buttonBorderColor: CustomColors.brandColor_primary!,
                buttonBackgroundColor: Colors.transparent,
                buttonText: Utils.getString("joinASession"),
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
              margin: EdgeInsets.fromLTRB(Dimens.space65.w, Dimens.space0.h, Dimens.space65.w, Dimens.space0.h),
              padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
              child: RoundedButtonWidget(
                width: Dimens.space296,
                height: Dimens.space54,
                onPressed: ()
                {
                  Prefs.setString(Const.VALUE_HOLDER_USER_TYPE, USER_TYPE.user.toString());
                  Utils.openActivity(context, OtpPage());
                },
                corner: Dimens.space30.r,
                buttonTextColor: CustomColors.brandColor_primary!,
                buttonBorderColor: Colors.transparent,
                buttonBackgroundColor: Colors.transparent,
                buttonText: Utils.getString("explore"),
                fontStyle: FontStyle.normal,
                titleTextAlign: TextAlign.center,
                buttonFontSize: Dimens.space14,
                buttonFontWeight: FontWeight.normal,
                buttonFontFamily: Config.InterBold,
                hasShadow: false,
              ),
            ),
          ],
        )
    );
  }
}
