import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:functional_widget_annotation/functional_widget_annotation.dart';
import 'package:live/config/Config.dart';
import 'package:live/config/CustomColors.dart';
import 'package:live/constant/Dimens.dart';
import 'package:live/utils/Utils.dart';

@swidget
AppBar customAppBar(BuildContext context,{required bool leading,required bool centerTitle, List<Widget>? actions, String title="", Color? backgroundColor})
{
  if(leading)
  {
    return AppBar(
      toolbarHeight: kToolbarHeight,
      backgroundColor: backgroundColor,
      backwardsCompatibility: false,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: CustomColors.background_bg01,
        systemNavigationBarColor: CustomColors.background_bg01,
        statusBarIconBrightness: Utils.isLightMode()?Brightness.dark:Brightness.light,
        statusBarBrightness: Utils.isLightMode()?Brightness.dark:Brightness.light,
        systemNavigationBarIconBrightness: Utils.isLightMode()?Brightness.dark:Brightness.light,
        systemNavigationBarDividerColor: CustomColors.background_bg01,
      ),
      elevation: 0,
      centerTitle: centerTitle,
      leading: Container(
        height: kToolbarHeight,
        width: kToolbarHeight,
        alignment: Alignment.center,
        margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
        child: Container(
          alignment: Alignment.center,
          height: Dimens.space26.w,
          width: Dimens.space26.w,
          margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(Dimens.space8.w),
            ),
            color: Colors.transparent,
            border: Border.all(
              width: Dimens.space2,
              color: CustomColors.text_active!,
            ),
          ),
          child: TextButton(
            style: TextButton.styleFrom(
              alignment: Alignment.center,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
            ),
            onPressed: ()
            {
              Utils.closeActivity(context);
            },
            child: Icon(
              Icons.arrow_back,
              color: CustomColors.text_active!,
              size: Dimens.space16.w,
            ),
          ),
        ),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyText2!.copyWith(
          color: CustomColors.text_active,
          fontFamily: Config.PoppinsSemiBold,
          fontSize: Dimens.space18.sp,
          fontWeight: FontWeight.normal,
          fontStyle: FontStyle.normal,
        ),
      ),
      actions: actions,
    );
  }
  else
  {
    return AppBar(
      toolbarHeight: kToolbarHeight,
      backgroundColor: backgroundColor,
      elevation: 0,
      centerTitle: centerTitle,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: CustomColors.background_bg01,
        systemNavigationBarColor: CustomColors.background_bg01,
        statusBarIconBrightness: Utils.isLightMode()?Brightness.dark:Brightness.light,
        statusBarBrightness: Utils.isLightMode()?Brightness.dark:Brightness.light,
        systemNavigationBarIconBrightness: Utils.isLightMode()?Brightness.dark:Brightness.light,
        systemNavigationBarDividerColor: CustomColors.background_bg01,
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyText1!.copyWith(
          color: Colors.white,
          fontFamily: Config.PoppinsSemiBold,
          fontSize: Dimens.space18.sp,
          fontWeight: FontWeight.normal,
          fontStyle: FontStyle.normal,
        ),
      ),
      actions: actions,
    );
  }
}