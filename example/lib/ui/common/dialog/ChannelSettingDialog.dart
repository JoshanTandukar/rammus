import 'package:flutter/material.dart';
import 'package:live/config/Config.dart';
import 'package:live/constant/Dimens.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:live/ui/common/ButtonWidget.dart';
import 'package:live/utils/Utils.dart';

class ChannelSettingDialog extends StatefulWidget
{
  final VoidCallback onLeaveChannel;
  final VoidCallback onDeleteChannel;
  final VoidCallback onInviteUser;
  final VoidCallback onRemoveUser;

  ChannelSettingDialog({
    Key? key,
    required this.onLeaveChannel,
    required this.onDeleteChannel,
    required this.onInviteUser,
    required this.onRemoveUser,
  }) : super(key: key);

  @override
  ChannelSettingDialogState createState() => ChannelSettingDialogState();
}

class ChannelSettingDialogState extends State<ChannelSettingDialog>
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
        color: Color(0xff181A20),
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
            margin: EdgeInsets.fromLTRB(Dimens.space20.w, Dimens.space0.h, Dimens.space20.w, Dimens.space0.h),
            padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
            child: RoundedButtonWidget(
              width: Dimens.space170.w,
              height: Dimens.space48.h,
              onPressed: widget.onLeaveChannel,
              corner: Dimens.space0.r,
              buttonTextColor: Color(0xff5E6272),
              buttonBorderColor: Color(0xff181A20),
              buttonBackgroundColor: Color(0xff181A20),
              buttonText: Utils.getString("Leave Room"),
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
            margin: EdgeInsets.fromLTRB(Dimens.space20.w, Dimens.space0.h, Dimens.space20.w, Dimens.space0.h),
            padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
            child: RoundedButtonWidget(
              width: Dimens.space170.w,
              height: Dimens.space48.h,
              onPressed: widget.onDeleteChannel,
              corner: Dimens.space0.r,
              buttonTextColor: Color(0xff5E6272),
              buttonBorderColor: Color(0xff181A20),
              buttonBackgroundColor: Color(0xff181A20),
              buttonText: Utils.getString("Delete Room"),
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
            margin: EdgeInsets.fromLTRB(Dimens.space20.w, Dimens.space0.h, Dimens.space20.w, Dimens.space0.h),
            padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
            child: RoundedButtonWidget(
              width: Dimens.space170.w,
              height: Dimens.space48.h,
              onPressed: widget.onInviteUser,
              corner: Dimens.space0.r,
              buttonTextColor: Color(0xff5E6272),
              buttonBorderColor: Color(0xff181A20),
              buttonBackgroundColor: Color(0xff181A20),
              buttonText: Utils.getString("Invite User"),
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
            margin: EdgeInsets.fromLTRB(Dimens.space20.w, Dimens.space0.h, Dimens.space20.w, Dimens.space0.h),
            padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
            child: RoundedButtonWidget(
              width: Dimens.space170.w,
              height: Dimens.space48.h,
              onPressed: widget.onRemoveUser,
              corner: Dimens.space0.r,
              buttonTextColor: Color(0xff5E6272),
              buttonBorderColor: Color(0xff181A20),
              buttonBackgroundColor: Color(0xff181A20),
              buttonText: Utils.getString("Remove User"),
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
