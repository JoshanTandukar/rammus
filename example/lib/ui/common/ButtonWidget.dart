import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:live/config/Config.dart';
import 'package:live/constant/Dimens.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RoundedButtonWidget extends StatelessWidget
{
  final VoidCallback onPressed;
  final String buttonText;
  final Color? buttonBackgroundColor;
  final Color? buttonTextColor;
  final String buttonFontFamily;
  final Color? buttonBorderColor;
  final FontWeight buttonFontWeight;
  final double buttonFontSize;
  final double width;
  final double height;
  final bool hasShadow;
  final TextAlign titleTextAlign;
  final double corner;
  final FontStyle fontStyle;
  final Alignment innerContainerAlignment;

  const RoundedButtonWidget({
    required this.onPressed,
    required this.buttonText,
    required this.buttonBackgroundColor,
    required this.buttonTextColor,
    required this.buttonBorderColor,
    required this.corner,
    this.titleTextAlign = TextAlign.center,
    this.buttonFontFamily = Config.heeboRegular,
    this.buttonFontWeight = FontWeight.normal,
    this.buttonFontSize = Dimens.space16,
    this.fontStyle = FontStyle.normal,
    this.width = Dimens.space50,
    this.height = Dimens.space16,
    this.hasShadow = false,
    this.innerContainerAlignment = Alignment.center,
  });

  @override
  Widget build(BuildContext context)
  {
    return Container(
      alignment: Alignment.center,
      width: width.w,
      height: height.h,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: EdgeInsets.fromLTRB(Dimens.space10.w, Dimens.space0.h, Dimens.space10.w, Dimens.space0.h),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          backgroundColor: buttonBackgroundColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(corner.r),
              side: BorderSide(
                color: buttonBorderColor??Color(0xFF1ABCFE),
                width: 2,
              )
          ),
        ),
        child: Container(
          alignment: innerContainerAlignment,
          width: width.w,
          height: height.h,
          child: Text(
            buttonText,
            textAlign: titleTextAlign,
            style: Theme.of(context).textTheme.bodyText1?.copyWith(
              color: buttonTextColor,
              fontFamily: buttonFontFamily,
              fontWeight: buttonFontWeight,
              fontSize: buttonFontSize.sp,
              fontStyle: fontStyle,
            ),
          ),
        ),
      ),
    );
  }
}
