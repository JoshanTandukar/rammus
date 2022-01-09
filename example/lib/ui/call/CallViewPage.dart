import 'dart:io';

import 'package:flutter/material.dart';
import 'package:jitsi_meet/jitsi_meet.dart';
import 'package:live/utils/Utils.dart';

class CallViewPage extends StatefulWidget {
  final String? serverUrlLink;
  final String? subjectText;
  final String? nameText;
  final String? emailText;
  final String? iosAppBarRGBAColor;
  final bool? isAudioOnly;
  final bool? isAudioMuted;
  final bool? isVideoMuted;
  final String? roomText;

  const CallViewPage(
      {Key? key,
      this.serverUrlLink,
      this.subjectText,
      this.nameText,
      this.emailText,
      this.iosAppBarRGBAColor,
      this.isAudioOnly,
      this.isAudioMuted,
      this.isVideoMuted,
      this.roomText})
      : super(key: key);
  @override
  _CallViewPageState createState() => _CallViewPageState();
}

class _CallViewPageState extends State<CallViewPage> {
  @override
  void initState() {
    super.initState();
    JitsiMeet.addListener(JitsiMeetingListener(
        onConferenceWillJoin: _onConferenceWillJoin,
        onConferenceJoined: _onConferenceJoined,
        onConferenceTerminated: _onConferenceTerminated,
        onError: _onError));

    _joinMeeting(
        serverUrlLink: widget.serverUrlLink,
        subjectText: widget.subjectText,
        nameText: widget.nameText,
        emailText: widget.emailText,
        iosAppBarRGBAColor: widget.iosAppBarRGBAColor,
        isAudioOnly: widget.isAudioOnly,
        isAudioMuted: widget.isAudioMuted,
        isVideoMuted: widget.isVideoMuted,
        roomText: widget.roomText);
  }

  @override
  void dispose() {
    super.dispose();
    JitsiMeet.removeAllListeners();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return MaterialApp(
      home: Scaffold(
        body: Container(),
      ),
    );
  }

  _joinMeeting(
      {String? serverUrlLink,
      String? subjectText,
      String? nameText,
      String? emailText,
      String? iosAppBarRGBAColor = "#0080FF80",
      bool? isAudioOnly,
      bool? isAudioMuted,
      bool? isVideoMuted,
      String? roomText}) async {
    String? serverUrl = serverUrlLink;

    // Enable or disable any feature flag here
    // If feature flag are not provided, default values will be used
    // Full list of feature flags (and defaults) available in the README
    Map<FeatureFlagEnum, bool> featureFlags = {
      FeatureFlagEnum.WELCOME_PAGE_ENABLED: false,
    };
    // Here is an example, disabling features for each platform
    if (Platform.isAndroid) {
      // Disable ConnectionService usage on Android to avoid issues (see README)
      featureFlags[FeatureFlagEnum.CALL_INTEGRATION_ENABLED] = false;
    } else if (Platform.isIOS) {
      // Disable PIP on iOS as it looks weird
      featureFlags[FeatureFlagEnum.PIP_ENABLED] = false;
    }

    // Define meetings options here
    var options = JitsiMeetingOptions(room: roomText!)
      ..serverURL = serverUrl
      ..subject = subjectText
      ..userDisplayName = nameText
      ..userEmail = emailText
      ..iosAppBarRGBAColor = iosAppBarRGBAColor
      ..audioOnly = isAudioOnly
      ..audioMuted = isAudioMuted
      ..videoMuted = isVideoMuted
      ..featureFlags.addAll(featureFlags)
      ..webOptions = {
        "roomName": roomText,
        "width": "100%",
        "height": "100%",
        "enableWelcomePage": false,
        "chromeExtensionBanner": null,
        "userInfo": {"displayName": nameText}
      };

    debugPrint("JitsiMeetingOptions: $options");
    await JitsiMeet.joinMeeting(
      options,
      listener: JitsiMeetingListener(
          onConferenceWillJoin: (message) {
            debugPrint("${options.room} will join with message: $message");
          },
          onConferenceJoined: (message) {
            debugPrint("${options.room} joined with message: $message");
          },
          onConferenceTerminated: (message) {
            debugPrint("${options.room} terminated with message: $message");
          },
          genericListeners: [
            JitsiGenericListener(
                eventName: 'readyToClose',
                callback: (dynamic message) {
                  debugPrint("readyToClose callback");
                }),
          ]),
    );
  }

  void _onConferenceWillJoin(message) {
    debugPrint("_onConferenceWillJoin broadcasted with message: $message");
  }

  void _onConferenceJoined(message) {
    debugPrint("_onConferenceJoined broadcasted with message: $message");
  }

  void _onConferenceTerminated(message) {
    debugPrint("_onConferenceTerminated broadcasted with message: $message");
    Utils.closeActivity(context);
  }

  _onError(error) {
    debugPrint("_onError broadcasted: $error");
  }
}
