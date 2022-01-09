import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ios_voip_kit/call_state_type.dart';
import 'package:flutter_ios_voip_kit/flutter_ios_voip_kit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:live/bloc/call_bloc/CallBloc.dart';
import 'package:live/bloc/call_bloc/CallEvent.dart';
import 'package:live/bloc/call_bloc/CallState.dart';
import 'package:live/config/CustomColors.dart';
import 'package:live/constant/Constants.dart';
import 'package:live/ui/agora/agorConfig.dart' as config;
import 'package:live/ui/agora/agoraDetails.dart';
import 'package:live/ui/agora/basic/join_channel_video/join_channel_video.dart';
import 'package:live/ui/dashboard/DashboardPage.dart';
import 'package:live/ui/profile/Profile.dart';
import 'package:live/utils/Prefs.dart';
import 'package:live/utils/Utils.dart';
import 'package:live/viewobject/model/agoraToken/AgoraToken.dart';
import 'package:rammus/rammus.dart' as rammus;

class TopLevel extends StatefulWidget {
  const TopLevel({Key? key}) : super(key: key);

  @override
  _TopLevelState createState() => _TopLevelState();
}

class _TopLevelState extends State<TopLevel> {
  late FirebaseMessaging messaging;
  CallBloc callBloc = CallBloc(InitialCallState());

  bool isChina = true;

  @override
  void initState() {
    super.initState();
    callBloc = BlocProvider.of<CallBloc>(context, listen: false);
    if (Platform.isAndroid) {
      configureRammus();
      configureNotification();
    }
  }

  void configureFCM() async {
    print("Configuring FCM");
    NotificationSettings settings =
        await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
    FirebaseMessaging.instance.setAutoInitEnabled(false);
    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: false,
    );
    FirebaseMessaging.instance
        .subscribeToTopic(Const.NOTIFICATION_CHANNEL_VIDEO_CALL_TOPIC);
    String? token = Platform.isIOS
        ? await FirebaseMessaging.instance.getAPNSToken()
        : await FirebaseMessaging.instance.getToken();
    print("this is token $token");
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Notification foreground " + json.encode(message.data).toString());
      if (message.data.containsKey("type") &&
          message.data["type"].toString().toLowerCase() ==
              "START_VIDEO".toLowerCase()) {
        Utils.showCallNotification(
          title: message.data["title"],
          body: message.data["body"],
          serverUrl: message.data["serverUrl"],
          channelName: message.data["roomName"],
          uid: message.data["subject"],
        );
      }
    });
    FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);
    configureServerNotificationToken(
        await FirebaseMessaging.instance.getToken());
  }

  void configureRammus() {
    rammus.RammusClient rammusClient = rammus.RammusClient();
    if (!Platform.isAndroid) {
      // rammus.configureNotificationPresentationOption();
    }
    rammusClient.initPushService().then((value) async {
      print(
          "----------->init successful ${value.isSuccessful} ${value.response} ${value.errorCode} ${value.errorMessage}");
      if (value.isSuccessful!) {
        var deviceID = await rammusClient.deviceId;
        print("deviceID........>" + deviceID.toString());
        var channels = <rammus.NotificationChannel>[];
        channels.add(rammus.NotificationChannel(
          id: "centralized_activity",
          name: "集中活动",
          description: "集中活动",
          importance: rammus.AndroidNotificationImportance.MAX,
        ));
        channels.add(rammus.NotificationChannel(
          id: "psychological_tests",
          name: "心理测评",
          description: "心理测评",
          importance: rammus.AndroidNotificationImportance.MAX,
        ));
        channels.add(rammus.NotificationChannel(
          id: "system_notice",
          name: "公告信息",
          description: "公告信息",
          importance: rammus.AndroidNotificationImportance.MAX,
        ));
        channels.add(rammus.NotificationChannel(
          id: Const.NOTIFICATION_CHANNEL_VIDEO_CALL_TOPIC,
          name: Const.NOTIFICATION_CHANNEL_VIDEO_CALL,
          description: Const.NOTIFICATION_CHANNEL_VIDEO_CALL,
          importance: rammus.AndroidNotificationImportance.MAX,
        ));
        rammusClient.setupNotificationManager(channels).then((value) {
          print(
              "----------->init channel ${value.isSuccessful} ${value.response} ${value.errorCode} ${value.errorMessage}");
        });
        rammusClient.notificationResultStream.listen((data) {
          print("Rammus Notification -> ${data.summary}");
          print("Rammus Notification -> ${data.extras}");
          print("Rammus Notification -> ${data.title}");
          print("Rammus Notification -> ${data.appId}");
          print("Rammus Notification -> ${data.content}");
          print("Rammus Notification -> ${data.messageId}");
          print("Rammus Notification -> ${data.traceInfo}");

          String temp = data.content!.replaceAll("'", "\"");
          Map<String, dynamic> dump = json.decode(temp);
          Utils.showCallNotification(
            title: dump["title"],
            body: dump["title"],
            serverUrl: dump["serverUrl"],
            channelName: dump["roomName"],
            uid: dump["subject"],
          );
        });

        configureServerNotificationToken(deviceID);

        // rammus.onNotificationOpened.listen((data) {
        //   print("Rammus Notification -> ${data.summary}");
        //   print("Rammus Notification -> ${data.extras}");
        //   print("Rammus Notification -> ${data.title}");
        //   print("Rammus Notification -> ${data.badge}");
        //   print("Rammus Notification -> ${data.subtitle}");
        //   setState(() {
        //     _platformVersion = "${data.summary} 被点了";
        //   });
        // });
        //
        // rammus.onNotificationRemoved.listen((data)
        // {
        //   print("-----------> $data 被删除了");
        // });
        //
        // rammus.onNotificationReceivedInApp.listen((data) {
        //   print("Rammus Notification -> ${data.summary}");
        //   print("Rammus Notification -> ${data.extras}");
        //   print("Rammus Notification -> ${data.title}");
        //   print("Rammus Notification -> ${data.openActivity}");
        //   print("Rammus Notification -> ${data.openType}");
        //   print("Rammus Notification -> ${data.openUrl}");
        // });
        //
        // rammus.onNotificationClickedWithNoAction.listen((data) {
        //   print("Rammus Notification -> ${data.extras}");
        //   print("Rammus Notification -> ${data.title}");
        //   print("Rammus Notification -> ${data.summary}");
        // });
        //
        // rammus.onMessageArrived.listen((data)
        // {
        //   print("Rammus Message -> ${data.messageId}");
        //   print("Rammus Message -> ${data.title}");
        //   print("Rammus Message -> ${data.appId}");
        //   print("Rammus Message -> ${data.content}");
        //   print("Rammus Message -> ${data.traceInfo}");
        //   setState(() {
        //     _platformVersion = data.content;
        //   });
        // });
      }
    });
  }

  void configureServerNotificationToken(String? token) async {
    var voipToken = await FlutterIOSVoIPKit.instance.getVoIPToken();

    callBloc.add(PushTypeResponseEvent(map: {
      "params": {
        "signInMobileOs":
            Platform.isIOS ? "ios".toUpperCase() : "android".toUpperCase(),
        "callNotificationToken": Platform.isIOS ? voipToken : token,
        "pushType": Platform.isIOS
            ? "fcm".toUpperCase()
            : isChina
                ? "rammus".toUpperCase()
                : "fcm".toUpperCase(),
      }
    }));
  }

  void getDeviceId() async {
    // var deviceId = await rammus.deviceId;
    // print("deviceId:::$deviceId");
  }

  void configureNotification() {
    AwesomeNotifications().createdStream.listen((receivedNotification) {
      print("this is notification1 $receivedNotification");
    });

    AwesomeNotifications().displayedStream.listen((receivedNotification) {
      print("this is notification2 ---> $receivedNotification");
    });

    AwesomeNotifications().dismissedStream.listen((receivedNotification) {
      print("this is notification3 $receivedNotification");
    });

    AwesomeNotifications().actionStream.listen((receivedNotification) {
      processDefaultActionReceived(receivedNotification);
    });
  }

  Future<void> processDefaultActionReceived(
      ReceivedAction receivedNotification) async {
    print("this is key channel" + receivedNotification.channelKey!);
    if (receivedNotification.buttonKeyPressed == 'reject') {
      Utils.cancelVideoCallNotification();
    } else if (receivedNotification.buttonKeyPressed == 'accept') {
      String uid =
          "${DateTime.now().second}${Prefs.getString(Const.VALUE_HOLDER_USER_ID)}";
      callBloc.add(
        AgoraEvent(
          body: {
            "params": {
              "environment": kDebugMode ? "DEV" : "PROD",
              "uid": int.parse(uid),
              "channelName": receivedNotification.payload!['channelName']!,
            }
          },
        ),
      );
      Utils.cancelVideoCallNotification();
    } else if (receivedNotification.buttonKeyPressed == 'view') {
      Utils.cancelVideoCallNotification();
    } else {
      Utils.cancelVideoCallNotification();
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BottomNavBar();
  }
}

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int index = 0;

  final voIPKit = FlutterIOSVoIPKit.instance;
  late Timer timeOutTimer;
  bool isTalking = false;
  CallBloc callBloc = CallBloc(InitialCallState());
  AgoraToken? agoraToken;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    callBloc = BlocProvider.of<CallBloc>(context, listen: false);
    FlutterIOSVoIPKit.instance.onDidUpdatePushToken = (token) {
      print('🎈 example: onDidUpdatePushToken token = $token');
    };

    voIPKit.onDidReceiveIncomingPush = (
      Map<String, dynamic> payload,
    ) async {
      /// Notifies device of VoIP notifications(PushKit) with curl or your server(See README.md).
      /// [onDidReceiveIncomingPush] is not called when the app is not running, because app is not yet running when didReceiveIncomingPushWith is called.
      print('🎈 Home: onDidReceiveIncomingPush $payload');
      _timeOut();
    };

    voIPKit.onDidRejectIncomingCall = (String uuid,
        String callerId,
        String callerName,
        String serverUrl,
        String roomName,
        String subject,
        String type,
        String title) {
      if (isTalking) {
        return;
      }

      print('🎈 Home: onDidRejectIncomingCall $uuid, $callerId');
      voIPKit.endCall();
      timeOutTimer.cancel();

      setState(() {
        isTalking = false;
      });
    };

    voIPKit.onDidAcceptIncomingCall = (String uuid,
        String callerId,
        String callerName,
        String serverUrl,
        String roomName,
        String subject,
        String type,
        String title) {
      if (isTalking) {
        return;
      }
      print('🎈 Home: onDidAcceptIncomingCall $uuid, $callerId $callerName');
      voIPKit.acceptIncomingCall(callerState: CallStateType.calling);
      voIPKit.callConnected();
      timeOutTimer.cancel();
      setState(() {
        isTalking = true;
      });
      String uid =
          "${DateTime.now().second}${Prefs.getString(Const.VALUE_HOLDER_USER_ID)}";
      callBloc.add(AgoraEvent(body: {
        "params": {
          "environment": kDebugMode ? "DEV" : "PROD",
          "uid": int.parse(uid),
          "channelName": roomName,
        }
      }));
    };

    _showRequestAuthLocalNotification();
  }

  void _showRequestAuthLocalNotification() async {
    await voIPKit.requestAuthLocalNotification();
    print("this is local notification ");
  }

  void _timeOut({
    int seconds = 50,
  }) async {
    timeOutTimer = Timer(Duration(seconds: seconds), () async {
      print('🎈 example: timeOut');
      // final incomingCallerName = await voIPKit.getIncomingCallerName();
      // voIPKit.unansweredIncomingCall(
      //   skipLocalNotification: false,
      //   missedCallTitle: '📞 Missed call',
      //   missedCallBody: 'There was a call from $incomingCallerName',
      // );
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
      bloc: callBloc,
      listener: (context, state) {
        if (state is AgoraSuccessState) {
          isLoading = false;
          AgoraDetail.uid = state.agoraToken?.result?.data?.uid ?? 0;
          AgoraDetail.token = state.agoraToken?.result?.data?.agoraToken ?? "";
          AgoraDetail.appId = config.appId;
          AgoraDetail.channelId =
              state.agoraToken?.result?.data?.channelName ?? "";

          agoraToken = state.agoraToken;
          Utils.openActivity(
              context,
              JoinChannelVideo(
                isIncoming: true,
                onClose: () {},
              )
              // VideoPage()
              ).then((value) {
            voIPKit.endCall();
          });
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: getScreen(index),
          bottomNavigationBar: BottomNavigationBar(
            onTap: (data) {
              index = data;
              setState(() {});
              print("this is index $index");
            },
            showSelectedLabels: false,
            showUnselectedLabels: false,
            type: BottomNavigationBarType.fixed,
            currentIndex: 0,
            backgroundColor: Colors.white,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    "assets/svg/NewHome.svg",
                    fit: BoxFit.cover,
                    color: index == 0
                        ? CustomColors.button_active
                        : Color(0xffC0C1C6),
                    alignment: Alignment.center,
                    clipBehavior: Clip.antiAlias,
                    allowDrawingOutsideViewBox: false,
                    cacheColorFilter: true,
                    placeholderBuilder: (BuildContext context) => Icon(
                      Icons.add_photo_alternate_outlined,
                      size: 15,
                      color: CustomColors.title_active,
                    ),
                  ),
                  label: ""),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  "assets/svg/newMessage.svg",
                  fit: BoxFit.cover,
                  color: index == 1
                      ? CustomColors.button_active
                      : Color(0xffC0C1C6),
                  alignment: Alignment.center,
                  clipBehavior: Clip.antiAlias,
                  allowDrawingOutsideViewBox: false,
                  cacheColorFilter: true,
                  placeholderBuilder: (BuildContext context) => Icon(
                    Icons.add_photo_alternate_outlined,
                    size: 15,
                    color: CustomColors.title_active,
                  ),
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  "assets/svg/Search.svg",
                  fit: BoxFit.cover,
                  color: index == 2
                      ? CustomColors.button_active
                      : Color(0xffC0C1C6),
                  alignment: Alignment.center,
                  clipBehavior: Clip.antiAlias,
                  allowDrawingOutsideViewBox: false,
                  cacheColorFilter: true,
                  placeholderBuilder: (BuildContext context) => Icon(
                    Icons.add_photo_alternate_outlined,
                    size: 15,
                    color: CustomColors.title_active,
                  ),
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  "assets/svg/NewUsers.svg",
                  fit: BoxFit.cover,
                  color: index == 3
                      ? CustomColors.button_active
                      : Color(0xffC0C1C6),
                  alignment: Alignment.center,
                  clipBehavior: Clip.antiAlias,
                  allowDrawingOutsideViewBox: false,
                  cacheColorFilter: true,
                  placeholderBuilder: (BuildContext context) => Icon(
                    Icons.add_photo_alternate_outlined,
                    size: 15,
                    color: CustomColors.title_active,
                  ),
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  "assets/svg/NewHamburger.svg",
                  fit: BoxFit.cover,
                  color: index == 4
                      ? CustomColors.button_active
                      : Color(0xffC0C1C6),
                  alignment: Alignment.center,
                  clipBehavior: Clip.antiAlias,
                  allowDrawingOutsideViewBox: false,
                  cacheColorFilter: true,
                  placeholderBuilder: (BuildContext context) => Icon(
                    Icons.add_photo_alternate_outlined,
                    size: 15,
                    color: CustomColors.title_active,
                  ),
                ),
                label: '',
              ),
            ],
          ),
        );
      },
    );
  }

  Widget getScreen(int index) {
    if (index == 0) {
      return DashboardPage();
    } else if (index == 1) {
      return Container();
    } else if (index == 2) {
      return Container();
    } else if (index == 3) {
      return Container();
    } else {
      return Profile();
    }
  }
}
