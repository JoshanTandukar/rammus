import 'package:flutter/material.dart';
import 'package:live/config/Config.dart';
import 'package:live/constant/Dimens.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:live/utils/Utils.dart';
import 'package:live/viewobject/model/membersList/MemberListResponse.dart';

class MembersListDialog extends StatefulWidget
{
  final List<Members> listMembers;
  final Function(Members) onRemoveUser;

  MembersListDialog({
    Key? key,
    required this.listMembers,
    required this.onRemoveUser,
  }) : super(key: key);

  @override
  MembersListDialogState createState() => MembersListDialogState();
}

class MembersListDialogState extends State<MembersListDialog>
{
  ScrollController scrollController = ScrollController();

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
      height: Dimens.space300.h,
      alignment: Alignment.topCenter,
      margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
      padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.fromLTRB(Dimens.space20.w, Dimens.space10.h, Dimens.space20.w, Dimens.space10.h),
            padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
            child: Text(
              Utils.getString("Remove User"),
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                color: Color(0xff5E6272),
                fontFamily: Config.PoppinsSemiBold,
                fontSize: Dimens.space18.sp,
                fontWeight: FontWeight.normal,
                fontStyle: FontStyle.normal,
              ),
            ),
          ),
          widget.listMembers.length!=0?
          Expanded(
            child: Container(
              alignment: Alignment.topCenter,
              margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
              padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
              child: ListView.builder(
                controller: scrollController,
                itemCount: widget.listMembers.length,
                reverse: false,
                scrollDirection: Axis.vertical,
                physics: AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.fromLTRB(Dimens.space0, Dimens.space0, Dimens.space0, Dimens.space0,),
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index)
                {
                  return Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    constraints: BoxConstraints(
                      maxWidth: Dimens.space150.w,
                      minWidth: Dimens.space10.w,
                    ),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.fromLTRB(Dimens.space20.w, Dimens.space10.h, Dimens.space20.w, Dimens.space10.h),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        alignment: Alignment.centerRight,
                      ),
                      onPressed:()
                      {
                        widget.onRemoveUser(widget.listMembers[index]);
                      },
                      child: Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        child: Text(
                          widget.listMembers[index].name!=null && widget.listMembers[index].name!.isNotEmpty? widget.listMembers[index].name!:"Not Available",
                          style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            color: Color(0xff5E6272),
                            fontFamily: Config.InterRegular,
                            fontSize: Dimens.space14.sp,
                            fontWeight: FontWeight.normal,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ):
          Container(),
        ],
      ),
    );
  }
}
