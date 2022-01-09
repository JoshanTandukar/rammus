import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:live/config/Config.dart';
import 'package:live/config/CustomColors.dart';
import 'package:live/constant/Dimens.dart';

class ErrorToastWidget extends StatelessWidget {
  final String message;

  const ErrorToastWidget({Key? key, required this.message}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.fromLTRB(
          Dimens.space0.w,
          Dimens.space32.h,
          Dimens.space0.w,
          Dimens.space0.h),
      padding: EdgeInsets.fromLTRB(
          Dimens.space40.w,
          Dimens.space18.h,
          Dimens.space40.w,
          Dimens.space18.h),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(Dimens.space0.w),
          ),
          color: Color(0xFFF24E1E),
          border: Border.all(
            width: Dimens.space0,
            color: Color(0xFFF24E1E),
          )),
      child: Text(
        message,
        style: Theme.of(context)
            .textTheme
            .bodyText1!
            .copyWith(
          color: CustomColors.toast_iconSuccess,
          fontFamily: Config.InterRegular,
          fontSize: Dimens.space14.sp,
          fontWeight: FontWeight.normal,
          fontStyle: FontStyle.normal,
        ),
      ),
    );
  }
}
