import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:live/config/Config.dart';
import 'package:live/config/CustomColors.dart';
import 'package:live/constant/Constants.dart';
import 'package:live/constant/Dimens.dart';
import 'package:live/ui/common/AuthAppBar.dart';
import 'package:live/ui/common/CustomImageHolder.dart';
import 'package:live/ui/common/NextBackWidget.dart';
import 'package:live/ui/otp/OtpPage.dart';
import 'package:live/utils/Prefs.dart';
import 'package:live/utils/Utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CreatePeeqPage extends StatefulWidget
{
  @override
  CreatePeeqPageState createState() => CreatePeeqPageState();
}

class CreatePeeqPageState extends State<CreatePeeqPage>
{

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  TextEditingController controllerEmail = TextEditingController();
  bool isBusinessSelected = false;
  bool isPersonalSelected = true;
  bool isValid = true;

  @override
  void initState()
  {
    super.initState();
  }

  @override
  void dispose()
  {
    controllerEmail.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context)
  {
    // david+figma@peeq.live
    // spay_rik!scal4TUH
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: CustomColors.background_bg01,
      appBar: customAppBar(
        context,
        title:Utils.getString("getStarted"),
        centerTitle: true,
        leading: false,
        actions: null,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space24.h, Dimens.space0.w, Dimens.space0.h),
        padding: EdgeInsets.fromLTRB(Dimens.space24.w, Dimens.space0.h, Dimens.space24.w, Dimens.space0.h),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(Dimens.space24.w),
              topLeft: Radius.circular(Dimens.space24.w),
            ),
            color: CustomColors.background_bg01,
            border: Border.all(
              width: Dimens.space1,
              color: CustomColors.background_bg01!,
            )
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space32.h, Dimens.space0.w, Dimens.space0.h),
              padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
              child: Text(
                  Utils.getString("selectAnAccountType"),
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    color: CustomColors.title_active,
                    fontFamily: Config.PoppinsSemiBold,
                    fontSize: Dimens.space32.sp,
                    fontWeight: FontWeight.normal,
                    fontStyle: FontStyle.normal,
                  )
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space8.h, Dimens.space0.w, Dimens.space0.h),
              padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
              child: Text(
                  Utils.getString("unlockFeatures"),
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    color: CustomColors.title_deactive,
                    fontFamily: Config.InterMedium,
                    fontSize: Dimens.space12.sp,
                    fontWeight: FontWeight.normal,
                    fontStyle: FontStyle.normal,
                  )
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space12.h, Dimens.space0.w, Dimens.space12.h),
              padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children:
                [
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          alignment: Alignment.center,
                        ),
                        onPressed: ()
                        {
                          setState(()
                          {
                            Prefs.setString(Const.VALUE_HOLDER_USER_BUSINESS_TYPE, "business");
                            isBusinessSelected = true;
                            isPersonalSelected = false;
                          });
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              height: Dimens.space195.h,
                              width: Dimens.space154.w,
                              padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                              margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors:CustomColors.gradient_gradient01,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(Dimens.space20.w),
                                ),
                              ),
                            ),
                            !isBusinessSelected?
                            Container(
                              alignment: Alignment.center,
                              height: Dimens.space193.h,
                              width: Dimens.space152.w,
                              padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                              margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                              decoration: BoxDecoration(
                                color: CustomColors.background_bg01,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(Dimens.space20.w),
                                ),
                              ),
                            ):Container(),
                            isBusinessSelected?
                            Positioned(
                              left: Dimens.space20.w,
                              top: Dimens.space6.h,
                              child: Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                                margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                                child: CustomCheckBox(
                                  assetUrl: "",
                                  height: Dimens.space40,
                                  width: Dimens.space40,
                                  assetWidth: Dimens.space40,
                                  assetHeight: Dimens.space40,
                                  boxFit: BoxFit.contain,
                                  iconUrl: FontAwesomeIcons.check,
                                  iconSize: Dimens.space11,
                                  iconColor: CustomColors.title_active,
                                  boxDecorationColorOne: CustomColors.icon_bg01,
                                  boxDecorationColorTwo: CustomColors.icon_bg01,
                                  outerCorner: Dimens.space300,
                                  innerCorner: Dimens.space300,
                                  onTap: () {},
                                ),
                              ),
                            ):Container(),
                            isBusinessSelected?
                            Positioned(
                              left: Dimens.space28.w,
                              top: Dimens.space15.h,
                              child: Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                                margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                                child: CustomCheckBox(
                                  assetUrl: "",
                                  height: Dimens.space24,
                                  width: Dimens.space24,
                                  assetWidth: Dimens.space24,
                                  assetHeight: Dimens.space24,
                                  boxFit: BoxFit.contain,
                                  iconUrl: FontAwesomeIcons.check,
                                  iconSize: Dimens.space11,
                                  iconColor: CustomColors.title_active,
                                  boxDecorationColorOne: CustomColors.toast_success,
                                  boxDecorationColorTwo: CustomColors.toast_success,
                                  outerCorner: Dimens.space300,
                                  innerCorner: Dimens.space300,
                                  onTap: () {},
                                ),
                              ),
                            ):Container(),
                            Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.fromLTRB(Dimens.space30.w, Dimens.space0.h, Dimens.space30.w, Dimens.space0.h),
                              padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                              child: Text(
                                Utils.getString("business"),
                                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                  color: CustomColors.title_active,
                                  fontFamily: Config.PoppinsSemiBold,
                                  fontSize: Dimens.space18.sp,
                                  fontWeight: FontWeight.normal,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          alignment: Alignment.center,
                        ),
                        onPressed: ()
                        {
                          setState(()
                          {
                            Prefs.setString(Const.VALUE_HOLDER_USER_BUSINESS_TYPE, "personal");
                            isBusinessSelected = false;
                            isPersonalSelected = true;
                          });
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              height: Dimens.space195.h,
                              width: Dimens.space154.w,
                              padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                              margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors:CustomColors.gradient_gradient01,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(Dimens.space20.w),
                                ),
                              ),
                            ),
                            !isPersonalSelected?
                            Container(
                              alignment: Alignment.center,
                              height: Dimens.space193.h,
                              width: Dimens.space152.w,
                              padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                              margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                              decoration: BoxDecoration(
                                color: CustomColors.background_bg01,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(Dimens.space20.w),
                                ),
                              ),
                            ):Container(),
                            isPersonalSelected?
                            Positioned(
                              left: Dimens.space20.w,
                              top: Dimens.space6.h,
                              child: Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                                margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                                child: CustomCheckBox(
                                  assetUrl: "",
                                  height: Dimens.space40,
                                  width: Dimens.space40,
                                  assetWidth: Dimens.space40,
                                  assetHeight: Dimens.space40,
                                  boxFit: BoxFit.contain,
                                  iconUrl: FontAwesomeIcons.check,
                                  iconSize: Dimens.space11,
                                  iconColor: CustomColors.title_active,
                                  boxDecorationColorOne: CustomColors.icon_bg01,
                                  boxDecorationColorTwo: CustomColors.icon_bg01,
                                  outerCorner: Dimens.space300,
                                  innerCorner: Dimens.space300,
                                  onTap: () {},
                                ),
                              ),
                            ):Container(),
                            isPersonalSelected?
                            Positioned(
                              left: Dimens.space28.w,
                              top: Dimens.space15.h,
                              child: Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                                margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                                child: CustomCheckBox(
                                  assetUrl: "",
                                  height: Dimens.space24,
                                  width: Dimens.space24,
                                  assetWidth: Dimens.space24,
                                  assetHeight: Dimens.space24,
                                  boxFit: BoxFit.contain,
                                  iconUrl: FontAwesomeIcons.check,
                                  iconSize: Dimens.space11,
                                  iconColor: CustomColors.title_active,
                                  boxDecorationColorOne: CustomColors.toast_success,
                                  boxDecorationColorTwo: CustomColors.toast_success,
                                  outerCorner: Dimens.space300,
                                  innerCorner: Dimens.space300,
                                  onTap: () {},
                                ),
                              ),
                            ):Container(),
                            Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.fromLTRB(Dimens.space30.w, Dimens.space0.h, Dimens.space30.w, Dimens.space0.h),
                              padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                              child: Text(
                                Utils.getString("personal"),
                                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                  color: CustomColors.title_active,
                                  fontFamily: Config.PoppinsSemiBold,
                                  fontSize: Dimens.space18.sp,
                                  fontWeight: FontWeight.normal,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      extendBody: true,
      bottomSheet: NextBackWidget(
        backOnPress: ()
        {
          Utils.closeActivity(context);
        },
        nextOnPress: ()
        {
          Utils.openActivity(context, OtpPage());
        },
        isValid: isValid,
      ),
    );
  }
}
