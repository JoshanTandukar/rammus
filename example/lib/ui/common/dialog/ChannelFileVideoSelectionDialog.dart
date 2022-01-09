import 'package:flutter/material.dart';
import 'package:live/config/Config.dart';
import 'package:live/config/CustomColors.dart';
import 'package:live/constant/Dimens.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:live/ui/common/ButtonWidget.dart';
import 'package:live/utils/Utils.dart';

class ChannelFileVideoSelectionDialog extends StatefulWidget
{
  final VoidCallback onFileSelectTap;
  final VoidCallback onLiveVideoSelectTap;

  ChannelFileVideoSelectionDialog({
    Key? key,
    required this.onFileSelectTap,
    required this.onLiveVideoSelectTap,
  }) : super(key: key);

  @override
  ChannelFileVideoSelectionDialogState createState() => ChannelFileVideoSelectionDialogState();
}

class ChannelFileVideoSelectionDialogState extends State<ChannelFileVideoSelectionDialog>
{
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
    return Container(
      decoration: BoxDecoration(
        color: CustomColors.background_bg01,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(Dimens.space12.r),
          topRight: Radius.circular(Dimens.space12.r),
        ),
      ),
      height: Dimens.space200.h,
      alignment: Alignment.topCenter,
      margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
      padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children:
        [
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.fromLTRB(Dimens.space10.w, Dimens.space30.h, Dimens.space10.w, Dimens.space0.h),
            padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
            child: Text(
              Utils.getString("createNew"),
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                color: CustomColors.text_active,
                fontFamily: Config.PoppinsBold,
                fontSize: Dimens.space14.sp,
                fontWeight: FontWeight.normal,
                fontStyle: FontStyle.normal,
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.fromLTRB(Dimens.space20.w, Dimens.space0.h, Dimens.space20.w, Dimens.space0.h),
            padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
            child: RoundedButtonWidget(
              width: Dimens.space170.w,
              height: Dimens.space48.h,
              onPressed: widget.onLiveVideoSelectTap,
              corner: Dimens.space0.r,
              buttonTextColor: CustomColors.text_active,
              buttonBorderColor: Colors.transparent,
              buttonBackgroundColor: Colors.transparent,
              buttonText: Utils.getString("videoMessage"),
              fontStyle: FontStyle.normal,
              titleTextAlign: TextAlign.left,
              innerContainerAlignment: Alignment.centerLeft,
              buttonFontSize: Dimens.space14.sp,
              buttonFontWeight: FontWeight.normal,
              buttonFontFamily: Config.InterBold,
              hasShadow: false,
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.fromLTRB(Dimens.space10.w, Dimens.space0.h, Dimens.space10.w, Dimens.space0.h),
            padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
            child: Text(
              Utils.getString("addFilesFrom"),
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                color: CustomColors.text_active,
                fontFamily: Config.PoppinsBold,
                fontSize: Dimens.space14.sp,
                fontWeight: FontWeight.normal,
                fontStyle: FontStyle.normal,
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.fromLTRB(Dimens.space20.w, Dimens.space0.h, Dimens.space20.w, Dimens.space0.h),
            padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
            child: RoundedButtonWidget(
              width: Dimens.space170.w,
              height: Dimens.space48.h,
              onPressed: widget.onFileSelectTap,
              corner: Dimens.space0.r,
              buttonTextColor: CustomColors.text_active,
              buttonBorderColor: Colors.transparent,
              buttonBackgroundColor: Colors.transparent,
              buttonText: Utils.getString("device"),
              fontStyle: FontStyle.normal,
              titleTextAlign: TextAlign.left,
              innerContainerAlignment: Alignment.centerLeft,
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
