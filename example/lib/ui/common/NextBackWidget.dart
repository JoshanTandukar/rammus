import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:live/config/Config.dart';
import 'package:live/config/CustomColors.dart';
import 'package:live/constant/Dimens.dart';
import 'package:live/utils/Utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'ButtonWidget.dart';

class NextBackWidget extends StatelessWidget {
  final Function nextOnPress;
  final Function backOnPress;
  final bool isValid;
  final String nextButtonText;

  const NextBackWidget({Key? key, required this.nextOnPress, required this.backOnPress, required this.isValid, this.nextButtonText=""}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(

      alignment: Alignment.topCenter,
      height: 100,
      width: MediaQuery.of(context).size.width,
      color: CustomColors.background_bg01,
      margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
      padding: EdgeInsets.fromLTRB(Dimens.space24.w, Dimens.space0.h, Dimens.space24.w, Dimens.space35.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
            padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
            child: RoundedButtonWidget(
              width: Dimens.space97.w,
              height: Dimens.space48.h,
              onPressed: ()
              {
                backOnPress();
              },
              corner: Dimens.space30.r,
              buttonTextColor:  CustomColors.field_textDeactive,
              buttonBorderColor: Colors.transparent,
              buttonBackgroundColor: Colors.transparent,
              buttonText: Utils.getString("back"),
              fontStyle: FontStyle.normal,
              titleTextAlign: TextAlign.center,
              buttonFontSize: Dimens.space14.sp,
              buttonFontWeight: FontWeight.normal,
              buttonFontFamily: Config.InterBold,
              hasShadow: false,
            ),
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
            padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
            child: RoundedButtonWidget(
              width: nextButtonText == ""?Dimens.space97.w:Dimens.space170.w,
              height: Dimens.space48.h,
              onPressed: () {
               isValid?nextOnPress():print("invalid");
              },
              corner: Dimens.space24.r,
              buttonTextColor:isValid
                  ?CustomColors.button_textActive: CustomColors.button_deactiveButtonText,
              buttonBorderColor: isValid
                  ? CustomColors.button_active!
                  : CustomColors.button_deactive,
              buttonBackgroundColor: isValid
                  ? CustomColors.button_active!
                  : CustomColors.button_deactive,
              buttonText: nextButtonText == ""?Utils.getString("next").toUpperCase():nextButtonText,
              fontStyle: FontStyle.normal,
              titleTextAlign: TextAlign.center,
              buttonFontSize: Dimens.space14.sp,
              buttonFontWeight: FontWeight.normal,
              buttonFontFamily: Config.InterBold,
              hasShadow: false,
            ),
          ),
        ],
      ),
    );
  }
}
