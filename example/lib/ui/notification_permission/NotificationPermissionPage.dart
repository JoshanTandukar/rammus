
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:live/config/Config.dart';
import 'package:live/config/CustomColors.dart';
import 'package:live/constant/Dimens.dart';
import 'package:live/ui/bottom_nav_bar/bottomNavBar.dart';
import 'package:live/ui/common/AuthAppBar.dart';
import 'package:live/ui/common/CustomImageHolder.dart';
import 'package:live/ui/common/NextBackWidget.dart';
import 'package:live/utils/Utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationPermissionPage extends StatefulWidget
{
  @override
  NotificationPermissionPageState createState() => NotificationPermissionPageState();
}

class NotificationPermissionPageState extends State<NotificationPermissionPage>
{
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
   AppLifecycleState _lastLifecyleState = AppLifecycleState.detached;

  bool notificationPermission = false;
  @override
  void initState()
  {
    super.initState();
    Permission.notification.isGranted.then((value)
    {
      notificationPermission = value;
      setState(() {});
    });


    SystemChannels.lifecycle.setMessageHandler(( event) async {
      if (_lastLifecyleState == AppLifecycleState.resumed) {
        await saveState();
      }
    });
  }

  Future<String> saveState() async {
    Permission.notification.isGranted.then((value)
    {
      notificationPermission = value;
      setState(() {});
    });
    return "String";
  }

  @override
  void dispose()
  {
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
      resizeToAvoidBottomInset: true,
      appBar: customAppBar(
        context,
        leading: true,
        centerTitle: false,
        backgroundColor: CustomColors.background_bg01,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: CustomColors.background_bg01,
        margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
        padding: EdgeInsets.fromLTRB(Dimens.space24.w, Dimens.space0.h, Dimens.space24.w, Dimens.space0.h),
        child: ListView(
          children: [
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space24.h, Dimens.space0.w, Dimens.space0.h),
              padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
              child: PlainAssetImageHolder(
                assetUrl: "assets/images/icon_notification_permission.png",
                height: Dimens.space200,
                width: Dimens.space200,
                assetWidth: Dimens.space200,
                assetHeight: Dimens.space200,
                boxFit: BoxFit.contain,
                iconUrl: Icons.person,
                iconSize: Dimens.space10,
                iconColor: CustomColors.button_deactive,
                boxDecorationColor: Colors.transparent,
                outerCorner: Dimens.space0,
                innerCorner: Dimens.space0,
                onTap: () {},
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.fromLTRB(Dimens.space40.w, Dimens.space24.h, Dimens.space40.w, Dimens.space0.h),
              padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
              child: Text(
                Utils.getString(notificationPermission == true?"Notification":"turnOnNotifications"),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  color: CustomColors.title_active,
                  fontFamily: Config.PoppinsSemiBold,
                  fontSize: Dimens.space30.sp,
                  fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.normal,
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.fromLTRB(Dimens.space20.w, Dimens.space32.h, Dimens.space20.w, Dimens.space0.h),
              padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
              child: Text(
                Utils.getString("enablePushNotification"),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  color: CustomColors.title_deactive,
                  fontFamily: Config.InterRegular,
                  fontSize: Dimens.space14.sp,
                  fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.normal,
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.fromLTRB(Dimens.space25.w, Dimens.space32.h, Dimens.space25.w, Dimens.space0.h),
              padding: EdgeInsets.fromLTRB(Dimens.space10.w, Dimens.space18.h, Dimens.space10.w, Dimens.space18.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(Dimens.space8.w),
                ),
                color: CustomColors.background_bg02,
                border: Border.all(
                  width: Dimens.space0,
                  color: CustomColors.background_bg02!,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children:
                [
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    child: Text(
                      Utils.getString("turnOnNotification"),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        color: CustomColors.field_textActive,
                        fontFamily: Config.InterMedium,
                        fontSize: Dimens.space14.sp,
                        fontWeight: FontWeight.normal,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    child: FlutterSwitch(
                      width: Dimens.space52.w,
                      height: Dimens.space32.w,
                      toggleSize: Dimens.space25.w,
                      value: notificationPermission,
                      onToggle: (value)
                      {
                        _requestPermission(context);
                      },
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
          Utils.openActivity(context, TopLevel());
        },
        isValid: true,
      ),
    );
  }

  // void requestPermission() async => Permission.notification.request().then((value)
  //   {
  //     print("this is value $value");
  //     notificationPermission = value.isGranted;
  //     setState(() {});
  //   });
  Future<void> _requestPermission(BuildContext context) async {
    final status = await Permission.notification.status;
    print("this is status $status");
    if (status.isDenied) {
      print("this is status $status");
      final result = await Permission.notification.request();
      print("this is result $result");
      final isPermanentlyDenied = result.isPermanentlyDenied;
      print("this is isPermanentlyDenied $isPermanentlyDenied");
      if (result.isGranted) {
        notificationPermission = result.isGranted;
        setState(() {});
        _showDialog(context,"Notification Permission!","Notification permission is granted.");
      } else if (isPermanentlyDenied) {
        openAppSettings().then((value) {
          if(value){
            Permission.notification.isGranted.then((value)
            {
              notificationPermission = value;
              setState(() {});
            });
          }
        });
      }else if(result == PermissionStatus.denied){
        openAppSettings().then((value) {
          print("this is valuse from open setting $value");
          if(value){
            Permission.notification.isGranted.then((value)
            {
              notificationPermission = value;
              setState(() {});
            });
          }
        });
      }
    } else if (status.isGranted) {
      _showDialog(context,"Notification Permission!","Notification permission is already granted.");
      notificationPermission = status.isGranted;
      setState(() {});
    }
  }

  void _showDialog(BuildContext context, String title, String subtitile) {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title:  Text(title),
          content: Text(subtitile),
          actions: <Widget>[
            TextButton(
                child: const Text('Okay'),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
          ],
        );
      },
    );
  }
}




