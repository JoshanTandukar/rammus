import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ios_voip_kit/flutter_ios_voip_kit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:live/config/CustomColors.dart';
import 'package:live/constant/Dimens.dart';
import 'package:live/ui/agora/agorConfig.dart' as config;
import 'package:live/ui/bottom_nav_bar/bottomNavBar.dart';
import 'package:live/utils/Utils.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../agoraDetails.dart';

/// MultiChannel Example
class JoinChannelVideo extends StatefulWidget {
  final Function onClose;
  final bool isIncoming;

  const JoinChannelVideo({
    Key? key,
    required this.onClose,
    required this.isIncoming,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<JoinChannelVideo> {
  late RtcEngine _engine;
  bool isJoined = false, switchCamera = true, switchRender = true;
  List<int> remoteUid = [];
  bool isLoading = false;
  bool enableVideo = true;
  bool isMute = false;
  bool enableSpeakerphone = true;
  final GlobalKey stackKey = GlobalKey();
  var _x = 40.0;
  var _y = 120.0;
  final voIPKit = FlutterIOSVoIPKit.instance;
  bool switchView = false;

  void initState() {
    super.initState();
    _joinChannel().then((data) {
      this._initEngine();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _engine.leaveChannel();
    _engine.destroy();
  }

  _initEngine() async {
    this._addListeners();
    await _engine.enableAudio();
    await _engine.enableVideo();
    await _engine.startPreview();
    await _engine.enableLocalVideo(enableVideo);
    await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await _engine.setClientRole(ClientRole.Broadcaster);
    await _engine.setEnableSpeakerphone(enableSpeakerphone);
    return "ok";
  }

  _addListeners() {
    _engine.setEventHandler(RtcEngineEventHandler(
      error: (error) {
        print("Agora: join channel success ${error}");
      },
      joinChannelSuccess: (channel, uid, elapsed) {
        print("Agora: join channel success ${channel} ${uid} ${elapsed}");
        log('joinChannelSuccess ${channel} ${uid} ${elapsed}');
        Future.delayed(Duration(seconds: 1), () {
          setState(() {
            isJoined = true;
          });
        });
      },
      userJoined: (uid, elapsed) {
        print("Agora: user joined ${uid} ${elapsed}");
        log('userJoined  ${uid} ${elapsed}');
        remoteUid.add(uid);
        Future.delayed(Duration(seconds: 1), () {
          setState(() {});
        });
      },
      userOffline: (uid, reason) {
        print("Agora: user offline ${uid} ${reason}");
        log('userOffline  ${uid} ${reason}');
        setState(() {
          remoteUid.removeWhere((element) => element == uid);
        });
        print("this is remoteuid length ${remoteUid.length}");
        if (remoteUid.length == 0) {
          Future.delayed(Duration(seconds: 1), () {
            _engine.leaveChannel().then((_) {
              voIPKit.endCall();
              Utils.removeStackActivity(context, BottomNavBar());
              // Utils.closeActivity(context);
            });
          });
        }
      },
      leaveChannel: (stats) {
        print("Agora: user leave channel ${stats.toJson()}");
        log('leaveChannel ${stats.toJson()}');
        setState(() {
          isJoined = false;
          remoteUid.clear();
        });
      },
    ));
  }

  Map userDetail = {
    "userName": "Sushan",
  };

  _joinChannel() async {
    print(
        "this is appId ${config.appId} uid ${AgoraDetail.uid} channelName ${AgoraDetail.channelId} token ${AgoraDetail.token}");
    _engine = await RtcEngine.createWithContext(RtcEngineContext(config.appId));
    if (defaultTargetPlatform == TargetPlatform.android) {
      await [Permission.microphone, Permission.camera].request();
    }
    await _engine.joinChannel(
        AgoraDetail.token ?? "",
        AgoraDetail.channelId ?? "",
        jsonEncode(userDetail),
        AgoraDetail.uid ?? 0);
    _engine.enableAudio();
    return "ok";
  }

  _switchRender() {
    setState(() {
      switchRender = !switchRender;
      remoteUid = List.of(remoteUid.reversed);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: Utils.getScreenHeight(context),
        child: Stack(
          key: stackKey, // 3.
          fit: StackFit.expand,
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: Dimens.space144.h,
              child: remoteUid.length == 0 || remoteUid.length == 1
                  ? !switchView
                      ? Stack(
                          children: [
                            _renderLocalPreview(),
                            if (!enableVideo)
                              Container(
                                color: Colors.black,
                              )
                          ],
                        )
                      : RtcRemoteView.SurfaceView(
                          uid: remoteUid[0],
                        )
                  : remoteUid.length == 2
                      ? threeUsers()
                      : fourUsers(),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Color(0xff122730),
                height: Dimens.space144.h,
                width: Utils.getScreenWidth(context),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    actionButton(
                        isMute ? "MicrophoneOff" : "MicrophoneOn", "Mute", () {
                      print("Audio mute $isMute");
                      if (isMute) {
                        _engine.enableAudio().then((value) {
                          setState(() {
                            isMute = false;
                          });
                        }).catchError((err) {
                          log('switchCamera $err');
                        });
                      } else {
                        _engine.disableAudio().then((value) {
                          setState(() {
                            isMute = true;
                          });
                        }).catchError((err) {
                          log('audio $err');
                        });
                      }
                    }),
                    actionButton("Videomute", "Stop Video", () async {
                      print("video is mute $enableVideo");
                      enableVideo = !enableVideo;
                      await _engine.enableLocalVideo(enableVideo);
                      setState(() {});
                    }),
                    actionButton(enableSpeakerphone ? "Speaker" : "SpeakerOff",
                        "Speaker", () async {
                      enableSpeakerphone = !enableSpeakerphone;
                      await _engine.setEnableSpeakerphone(enableSpeakerphone);
                      setState(() {});
                    }),
                    actionButton("CallEnd", "End Call", () async {
                      await _engine.leaveChannel();
                      voIPKit.endCall();
                      Utils.removeStackActivity(context, BottomNavBar());
                      // Utils.closeActivity(context);
                    }),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: Dimens.space100.h,
                width: Utils.getScreenWidth(context),
                child: Padding(
                  padding: EdgeInsets.all(Dimens.space18.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      widget.isIncoming
                          ? Container()
                          : Padding(
                              padding:
                                  EdgeInsets.only(bottom: Dimens.space10.h),
                              child: InkWell(
                                onTap: () {
                                  print("close is pressed");
                                  widget.onClose();
                                },
                                child: SvgPicture.asset(
                                  "assets/svg/arrowLeft.svg",
                                  fit: BoxFit.cover,
                                  color: Colors.white,
                                  alignment: Alignment.center,
                                  clipBehavior: Clip.antiAlias,
                                  allowDrawingOutsideViewBox: false,
                                  cacheColorFilter: true,
                                  placeholderBuilder: (BuildContext context) =>
                                      Icon(
                                    Icons.add_photo_alternate_outlined,
                                    size: 15,
                                    color: CustomColors.title_active,
                                  ),
                                ),
                              ),
                            ),
                      Padding(
                        padding: EdgeInsets.only(left: Dimens.space15.w),
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                AgoraDetail.channelId.substring(
                                    0, AgoraDetail.channelId.indexOf("_")),
                                style: TextStyle(
                                    fontSize: Dimens.space15.sp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              Row(
                                children: [
                                  Text(
                                    "In Session ",
                                    style: TextStyle(
                                        fontSize: Dimens.space15.sp,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  OtpTimer()
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: Dimens.space10.h),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                _engine.switchCamera().then((value) {
                                  setState(() {
                                    switchCamera = !switchCamera;
                                  });
                                }).catchError((err) {
                                  log('switchCamera $err');
                                });
                              },
                              child: Container(
                                child: SvgPicture.asset(
                                  "assets/svg/CameraFlip.svg",
                                  fit: BoxFit.cover,
                                  color: Colors.white,
                                  alignment: Alignment.center,
                                  clipBehavior: Clip.antiAlias,
                                  allowDrawingOutsideViewBox: false,
                                  cacheColorFilter: true,
                                  placeholderBuilder: (BuildContext context) =>
                                      Icon(
                                    Icons.add_photo_alternate_outlined,
                                    size: 15,
                                    color: CustomColors.title_active,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            InkWell(
                              onTap: () {},
                              child: Container(
                                child: SvgPicture.asset(
                                  "assets/svg/threeDots.svg",
                                  fit: BoxFit.cover,
                                  color: Colors.white,
                                  alignment: Alignment.center,
                                  clipBehavior: Clip.antiAlias,
                                  allowDrawingOutsideViewBox: false,
                                  cacheColorFilter: true,
                                  placeholderBuilder: (BuildContext context) =>
                                      Icon(
                                    Icons.add_photo_alternate_outlined,
                                    size: 15,
                                    color: CustomColors.title_active,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: Dimens.space5.w,
                            ),
                            widget.isIncoming
                                ? Container()
                                : InkWell(
                                    onTap: () {
                                      widget.onClose();
                                    },
                                    child: Container(
                                      child: SvgPicture.asset(
                                        "assets/svg/CloseX.svg",
                                        fit: BoxFit.cover,
                                        color: Colors.white,
                                        alignment: Alignment.center,
                                        clipBehavior: Clip.antiAlias,
                                        allowDrawingOutsideViewBox: false,
                                        cacheColorFilter: true,
                                        placeholderBuilder:
                                            (BuildContext context) => Icon(
                                          Icons.add_photo_alternate_outlined,
                                          size: 15,
                                          color: CustomColors.title_active,
                                        ),
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.only(right: Dimens.space13.h),
                child: Container(
                  height: Dimens.space273.h,
                  width: Dimens.space55.h,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(Dimens.space55.r)),
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: Dimens.space30.h, bottom: Dimens.space30.h),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          "assets/svg/Pluscircle.svg",
                          fit: BoxFit.cover,
                          color: Colors.white,
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
                        SvgPicture.asset(
                          "assets/svg/User.svg",
                          fit: BoxFit.cover,
                          color: Colors.white,
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
                        SvgPicture.asset(
                          "assets/svg/Chat.svg",
                          fit: BoxFit.cover,
                          color: Colors.white,
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
                        SvgPicture.asset(
                          "assets/svg/Shoppingcart.svg",
                          fit: BoxFit.cover,
                          color: Colors.white,
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
                        SvgPicture.asset(
                          "assets/svg/Creditcard.svg",
                          fit: BoxFit.cover,
                          color: Colors.white,
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
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (remoteUid.length == 1)
              Positioned(
                // 5.
                left: _x,
                top: _y,
                child: Draggable(
                  // 6.
                  child: InkWell(
                    onTap: () {
                      switchView = !switchView;
                      setState(() {});
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        Dimens.space50.r,
                      ),
                      child: Container(
                          width: Dimens.space80.h,
                          height: Dimens.space100.h,
                          child: !switchView
                              ? RtcRemoteView.SurfaceView(
                                  uid: remoteUid[0],
                                )
                              : _renderLocalPreview()),
                    ),
                  ),
                  feedback: ClipRRect(
                    borderRadius: BorderRadius.circular(
                      Dimens.space50.r,
                    ),
                    child: Container(
                      width: Dimens.space80.h,
                      height: Dimens.space100.h,
                      child: RtcRemoteView.SurfaceView(
                        uid: remoteUid[0],
                      ),
                    ),
                  ), // 8.
                  // childWhenDragging: Container(), // 9.
                  onDragEnd: (dragDetails) {
                    // 10.
                    setState(() {
                      final parentPos = stackKey.globalPaintBounds;
                      if (parentPos == null) return;
                      _x = dragDetails.offset.dx - parentPos.left; // 11.
                      _y = dragDetails.offset.dy - parentPos.top;
                    });
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  threeUsers() {
    return Container(
      child: Column(
        children: [
          Expanded(
            child: !enableVideo
                ? Container(
                    color: Colors.black,
                  )
                : RtcLocalView.SurfaceView(),
          ),
          Expanded(
            child: Row(
              children: List.of(remoteUid.map(
                (e) {
                  return Expanded(
                    child: RtcRemoteView.SurfaceView(
                      uid: e,
                    ),
                  );
                },
              )),
            ),
          ),
        ],
      ),
    );
  }

  fourUsers() {
    return Container(
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                    child: !enableVideo
                        ? Container(
                            color: Colors.black,
                          )
                        : RtcLocalView.SurfaceView()),
                Expanded(
                  child: RtcRemoteView.SurfaceView(
                    uid: remoteUid[0],
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Row(children: [
              Expanded(
                child: RtcRemoteView.SurfaceView(
                  uid: remoteUid[1],
                ),
              ),
              Expanded(
                child: RtcRemoteView.SurfaceView(
                  uid: remoteUid[2],
                ),
              )
            ]),
          ),
        ],
      ),
    );
  }

  Widget actionButton(String icon, String label, Function onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () {
            onTap();
          },
          child: Container(
            height: Dimens.space55.h,
            width: Dimens.space55.h,
            decoration: BoxDecoration(
                color: Color(0xff1ABCFE),
                borderRadius: BorderRadius.circular(50)),
            child: Padding(
              padding: EdgeInsets.all(Dimens.space15.h),
              child: SvgPicture.asset(
                "assets/svg/$icon.svg",
                fit: BoxFit.cover,
                color: Colors.white,
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
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          label,
          style: TextStyle(fontSize: Dimens.space12.sp, color: Colors.white),
        ),
      ],
    );
  }

  Widget _renderLocalPreview() {
    if (isJoined) {
      return RtcLocalView.SurfaceView();
    } else {
      return Text(
        'Joining Channel, Please wait.....',
        textAlign: TextAlign.center,
      );
    }
  }
}

class OtpTimer extends StatefulWidget {
  @override
  _OtpTimerState createState() => _OtpTimerState();
}

class _OtpTimerState extends State<OtpTimer> {
  final interval = const Duration(seconds: 1);

  final int timerMaxSeconds = 60000;

  int currentSeconds = 0;
  Timer? timer;

  String get timerText =>
      '${((currentSeconds) ~/ 60).toString().padLeft(2, '0')}: ${((timerMaxSeconds + currentSeconds) % 60).toString().padLeft(2, '0')}';

  startTimeout(int milliseconds) {
    var duration = interval;
    timer = Timer.periodic(duration, (timer) {
      setState(() {
        currentSeconds = timer.tick;
        if (timer.tick >= timerMaxSeconds) timer.cancel();
      });
    });
  }

  @override
  void initState() {
    startTimeout(100);
    super.initState();
  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 2,
        ),
        Text(
          timerText,
          style: TextStyle(
              fontSize: Dimens.space15.sp,
              color: Colors.white,
              fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}

extension GlobalKeyExtension on GlobalKey {
  get globalPaintBounds {
    final renderObject = currentContext?.findRenderObject();
    var translation = renderObject?.getTransformTo(null).getTranslation();
    if (translation != null && renderObject?.paintBounds != null) {
      return renderObject!.paintBounds
          .shift(Offset(translation.x, translation.y));
    } else {
      return null;
    }
  }
}
