import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:filesize/filesize.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ios_voip_kit/flutter_ios_voip_kit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:live/bloc/chat_channel_subscription/ChatChannelSubscriptionBloc.dart';
import 'package:live/bloc/chat_channel_subscription/ChatChannelSubscriptionEvent.dart';
import 'package:live/bloc/chat_channel_subscription/ChatChannelSubscriptionState.dart';
import 'package:live/config/Config.dart';
import 'package:live/config/CustomColors.dart';
import 'package:live/constant/Constants.dart';
import 'package:live/constant/Dimens.dart';
import 'package:live/ui/agora/agorConfig.dart' as config;
import 'package:live/ui/agora/agoraDetails.dart';
import 'package:live/ui/agora/basic/join_channel_video/join_channel_video.dart';
import 'package:live/ui/common/AuthAppBar.dart';
import 'package:live/ui/common/CustomImageHolder.dart';
import 'package:live/ui/common/dialog/ChannelFileVideoSelectionDialog.dart';
import 'package:live/ui/common/dialog/ChannelSettingDialog.dart';
import 'package:live/ui/common/dialog/DeleteMessageDialog.dart';
import 'package:live/ui/common/dialog/FileDescriptionDialog.dart';
import 'package:live/ui/common/dialog/MembersListDialog.dart';
import 'package:live/ui/common/dialog/UsersListDialog.dart';
import 'package:live/ui/video_record/VideoRecordPage.dart';
import 'package:live/utils/Prefs.dart';
import 'package:live/utils/Utils.dart';
import 'package:live/viewobject/holder/ReactionsRequest.dart';
import 'package:live/viewobject/model/agoraToken/AgoraToken.dart';
import 'package:live/viewobject/model/chatMessageResponse/ChatChannelMessageResponse.dart';
import 'package:live/viewobject/model/membersList/MemberListResponse.dart';
import 'package:live/viewobject/model/usersList/UsersListResponse.dart';
import 'package:lottie/lottie.dart';
import 'package:video_player/video_player.dart';

class SendMessagePage extends StatefulWidget {
  final int urlIndex;
  final String roomId;
  final String roomName;
  final String roomDescription;
  final bool isPrivate;
  final VoidCallback onLeaveChannel;
  final VoidCallback onDeleteChannel;
  final bool isFromDashboard;
  const SendMessagePage({
    Key? key,
    required this.urlIndex,
    required this.roomId,
    required this.roomName,
    required this.isPrivate,
    required this.roomDescription,
    required this.onLeaveChannel,
    required this.onDeleteChannel,
    this.isFromDashboard = false,
  }) : super(key: key);

  @override
  _SendMessagePageState createState() => _SendMessagePageState();
}

class _SendMessagePageState extends State<SendMessagePage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  TextEditingController chatTextController = TextEditingController();
  ChatChannelSubscriptionBloc chatChannelSubscriptionBloc =
      ChatChannelSubscriptionBloc(InitialChatChannelSubscriptionState());
  ScrollController scrollController = ScrollController();
  bool isLoading = true;
  String userId = "";
  final voIPKit = FlutterIOSVoIPKit.instance;

  String eventLogin = "1";
  String eventHistory = "2";
  String eventMessages = "3";
  String eventUserActivity = "4";
  String eventSendMessage = "5";
  String eventDeleteMessage = "6";

  List<Messages>? listMessages = [];
  List<Users> listUsers = [];
  List<Members> listMembers = [];
  List ids = [];
  bool isVideo = false;
  bool isCalling = false;
  bool showVideo = false;

  bool isTyping = false;
  String whoIsTyping = "";
  bool isInit = false;
  AgoraToken? agoraToken;

  @override
  void initState() {
    super.initState();
    chatChannelSubscriptionBloc =
        BlocProvider.of<ChatChannelSubscriptionBloc>(context, listen: false);

    userId =
        Prefs.getStringList(Const.VALUE_HOLDER_CHAT_USER_ID)![widget.urlIndex];

    chatChannelSubscriptionBloc
        .subscriptionConnect(Config.listSocketUrl[widget.urlIndex]);
    // _controller = VideoPlayerController.network(
    //   'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
    //   // closedCaptionFile: _loadCaptions(),
    //   videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    // );
    //
    // _controller!.addListener(() {
    //   setState(() {});
    // });
    // _controller!.setLooping(true);
    // _controller!.initialize();
    getMembersList(true);
    chatChannelSubscriptionBloc.webSocketChannel!.stream.listen((event) {
      if (event != null) {
        Map<String, dynamic> map = json.decode(event);
        print("Events " + map.toString());
        if (map.containsKey("msg") && map["msg"] == "ping") {
          Map connect = {"msg": "pong"};
          chatChannelSubscriptionBloc.webSocketChannel!.sink
              .add(json.encode(connect));
        } else if (map.containsKey("msg") && map.containsKey("session")) {
          if (map["msg"] == "connected") {
            Map login = {
              "msg": "method",
              "method": "login",
              "id": eventLogin,
              "params": [
                {
                  "resume": Prefs.getStringList(
                      Const.VALUE_HOLDER_CHAT_AUTH_TOKEN)![widget.urlIndex],
                }
              ]
            };
            chatChannelSubscriptionBloc.webSocketChannel!.sink
                .add(jsonEncode(login));
          }
        } else if (map.containsKey("msg") && map.containsKey("collection")) {
          if (map["msg"] == "added" && map["collection"] == "users") {
            Map loadHistory = {
              "msg": "method",
              "method": "loadHistory",
              "id": eventHistory,
              "params": [
                widget.roomId,
                {
                  "\$date": DateTime.now().millisecondsSinceEpoch,
                },
                50,
                {
                  "\$date": DateTime.now().millisecondsSinceEpoch,
                },
              ]
            };
            chatChannelSubscriptionBloc.webSocketChannel!.sink
                .add(jsonEncode(loadHistory));

            Map listenUserActivity = {
              "msg": "sub",
              "id": eventUserActivity,
              "name": "stream-notify-room",
              "params": [
                "${widget.roomId}/user-activity",
                false.toString(),
              ]
            };
            chatChannelSubscriptionBloc.webSocketChannel!.sink
                .add(jsonEncode(listenUserActivity));

            Map listenNewMessage = {
              "msg": "sub",
              "id": eventMessages,
              "name": "stream-room-messages",
              "params": [
                widget.roomId,
                false.toString(),
              ]
            };
            chatChannelSubscriptionBloc.webSocketChannel!.sink
                .add(jsonEncode(listenNewMessage));
          } else if (map["msg"] == "changed" &&
              map["collection"] == "stream-room-messages" &&
              map["fields"]["eventName"] == widget.roomId) {
            Utils.customPrint(json.encode(map["fields"]));
            Map<String, dynamic> resultHistory = map["fields"];
            resultHistory['args'].forEach((v) {
              Messages message = Messages.fromJson(v);
              if (listMessages!.indexWhere((element) =>
                      element.sId != null && element.sId == message.sId) ==
                  -1) {
                listMessages!.insert(0, Messages.fromJson(v));
                if (Messages.fromJson(v).u!.sId ==
                    Prefs.getStringList(
                        Const.VALUE_HOLDER_CHAT_USER_ID)![widget.urlIndex]) {
                  chatTextController.text = "";
                }
              } else {
                int updateIndex = listMessages!.indexWhere((element) =>
                    element.sId != null && element.sId == message.sId);
                listMessages![updateIndex] = message;
              }
            });
            setState(() {});
          } else if (map["msg"] == "changed" &&
              map["collection"] == "stream-notify-room" &&
              map["fields"]["eventName"] == "${widget.roomId}/user-activity") {
            Map<String, dynamic> resultHistory = map["fields"];
            if (resultHistory['args'][1] != null &&
                resultHistory['args'][1].isNotEmpty) {
              whoIsTyping = resultHistory['args'][0];
              isTyping = true;
              setState(() {});
              Future.delayed(Duration(seconds: 2)).then((value) {
                whoIsTyping = "";
                isTyping = false;
                setState(() {});
              });
              // if(resultHistory['args'][0].toString().toLowerCase() != Prefs.getString(Const.VALUE_HOLDER_USERNAME)!.toLowerCase())
              // {
              //   whoIsTyping = resultHistory['args'][0];
              //   isTyping = true;
              // }
            } else {
              whoIsTyping = "";
              isTyping = false;
              setState(() {});
            }
          } else if (map["msg"] == "changed" &&
              map["collection"] == "stream-notify-room" &&
              map["fields"]["eventName"] == "${widget.roomId}/user-activity") {
            Map<String, dynamic> resultHistory = map["fields"];
            if (resultHistory['args'][1] != null &&
                resultHistory['args'][1].isNotEmpty) {
              whoIsTyping = resultHistory['args'][0];
              isTyping = true;
              setState(() {});
              Future.delayed(Duration(seconds: 2)).then((value) {
                whoIsTyping = "";
                isTyping = false;
                setState(() {});
              });
              // if(resultHistory['args'][0].toString().toLowerCase() != Prefs.getString(Const.VALUE_HOLDER_USERNAME)!.toLowerCase())
              // {
              //   whoIsTyping = resultHistory['args'][0];
              //   isTyping = true;
              // }
            } else {
              whoIsTyping = "";
              isTyping = false;
              setState(() {});
            }
          }
        } else if (map.containsKey("msg") && map.containsKey("result")) {
          Utils.customPrint(json.encode(map["result"]));
          Map<String, dynamic> dump = map["result"];
          if (map["msg"] == "result" && dump.containsKey("messages")) {
            Map<String, dynamic> resultHistory = map["result"];
            resultHistory['messages'].forEach((v) {
              listMessages!.add(Messages.fromJson(v));
            });
            isLoading = false;
            setState(() {});
          }
        }
      }
    });

    scrollController.addListener(() {});

    chatTextController.addListener(() {
      if (chatTextController.text.length != 0 &&
          chatTextController.text.isNotEmpty) {
        chatChannelSubscriptionBloc.webSocketChannel!.sink.add(
          json.encode(
            ReactionsRequest(
              msg: "method",
              method: "stream-notify-room",
              id: eventUserActivity,
              params: [
                "${widget.roomId}/typing",
                "${Prefs.getString(Const.VALUE_HOLDER_USERNAME)}",
                true.toString(),
              ],
            ).toJson(),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    chatTextController.dispose();
    chatChannelSubscriptionBloc.webSocketChannel!.sink.close();
    super.dispose();
  }

  Future<bool> _requestPop() {
    Utils.closeActivity(context);
    return Future<bool>.value(false);
  }

  @override
  Widget build(BuildContext context) {
    // david+figma@peeq.live
    // spay_rik!scal4TUH

    return WillPopScope(
      onWillPop: _requestPop,
      child: BlocConsumer(
        bloc: chatChannelSubscriptionBloc,
        listener: (context, state) {
          print("this is state $state");
          if (state is ChatChannelSubscriptionProgressState) {
            isLoading = true;
          } else if (state is ChatChannelLeaveChannelSuccessState) {
            isLoading = false;
            widget.onLeaveChannel();
          } else if (state is ChatChannelDeleteChannelSuccessState) {
            isLoading = false;
            widget.onDeleteChannel();
          } else if (state is ChatChannelUploadFileSuccessState) {
            isLoading = false;
          } else if (state is ChatChannelSubscriptionErrorState) {
            isLoading = false;
          } else if (state is ChatChannelUsersListSuccessState) {
            isLoading = false;
            listUsers = state.usersListResponse!.users!;
            showUsersListDialog();
          } else if (state is ChatChannelAddUserToChannelSuccessState) {
            isLoading = false;
          } else if (state is AgoraTokenSuccessState) {
            String callerName = widget.isPrivate ? "" : "";
            isLoading = false;
            agoraToken = state.agoraToken;
            chatChannelSubscriptionBloc.add(
              StartVideoEvent(
                  authToken: Prefs.getStringList(
                      Const.VALUE_HOLDER_CHAT_AUTH_TOKEN)![widget.urlIndex],
                  userId: Prefs.getStringList(
                      Const.VALUE_HOLDER_CHAT_USER_ID)![widget.urlIndex],
                  map: {
                    "params": {
                      "serverUrl": agoraToken?.result?.data?.agoraToken ?? "",
                      "roomName": "${agoraToken?.result?.data?.channelName}",
                      "subject": agoraToken?.result?.data?.uid.toString() ?? "",
                      "userIds": ids,
                      "useSandBox": kDebugMode ? true : false,
                      "environment": Const.env,
                    }
                  }),
            );
            Map param = {
              "params": {
                "serverUrl": agoraToken?.result?.data?.agoraToken ?? "",
                "roomName": agoraToken?.result?.data?.channelName ?? "",
                "subject": agoraToken?.result?.data?.uid.toString() ?? "",
                "userIds": ids,
                "initiatorId": Prefs.getString(Const.VALUE_HOLDER_USER_ID),
                "useSandBox": kDebugMode ? true : false,
              }
            };
            print("this is userid ${param}");
          } else if (state is VideoCallSuccessState) {
            print("this is video success");
            isLoading = false;
            AgoraDetail.uid = agoraToken?.result?.data?.uid ?? 0;
            AgoraDetail.token = agoraToken?.result?.data?.agoraToken ?? "";
            AgoraDetail.appId = config.appId ?? "";
            AgoraDetail.channelId = agoraToken?.result?.data?.channelName ?? "";
            isCalling = true;
            showVideo = true;
            // voIPKit.endCall();
            setState(() {});
          } else if (state is ChatChannelMembersListSuccessState) {
            isLoading = false;
            listMembers = state.membersListResponse!.members!;
            if (isInit == false) {
              showMembersListDialog();
            } else {
              ids = listMembers
                  .where((member) => member.sId != userId)
                  .where((member) => member.username!.contains("_"))
                  .map((e) => e.username)
                  .map((username) {
                return username!
                    .substring(username.indexOf("_") + 1, username.length);
              }).toList();
              print("this is user id $ids");
              print(
                  "this is userid ${Prefs.getString(Const.VALUE_HOLDER_USER_ID)}");
            }
          } else if (state is ChatChannelGroupMembersListSuccessState) {
            isLoading = false;
            listMembers = state.membersListResponse!.members!;
            if (isInit == false) {
              showMembersListDialog();
            } else {
              ids = listMembers
                  .where((member) => member.sId != userId)
                  .where((member) => member.username!.contains("_"))
                  .map((e) => e.username)
                  .map((username) {
                return username!
                    .substring(username.indexOf("_") + 1, username.length);
              }).toList();
            }
          } else if (state is ChatChannelRemoveUserFromChannelSuccessState) {
            isLoading = false;
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              isCalling && showVideo
                  ? JoinChannelVideo(
                      isIncoming: false,
                      onClose: () {
                        showVideo = false;
                        setState(() {});
                      },
                    )
                  : Stack(
                      alignment: Alignment.center,
                      children: [
                        Scaffold(
                          key: _scaffoldKey,
                          backgroundColor: CustomColors.background_bg01,
                          resizeToAvoidBottomInset: true,
                          appBar: customAppBar(
                            context,
                            leading: true,
                            centerTitle: true,
                            title: widget.roomDescription,
                            backgroundColor: CustomColors.background_bg01,
                            actions: [
                              // widget.isFromDashboard
                              //     ? Container()
                              //     : Container(
                              //         width: Dimens.space40.w,
                              //         height: Dimens.space40.w,
                              //         alignment: Alignment.center,
                              //         margin: EdgeInsets.fromLTRB(
                              //             Dimens.space10.w,
                              //             Dimens.space0.h,
                              //             Dimens.space0.w,
                              //             Dimens.space0.h),
                              //         padding: EdgeInsets.fromLTRB(
                              //             Dimens.space0.w,
                              //             Dimens.space0.h,
                              //             Dimens.space0.w,
                              //             Dimens.space0.h),
                              //         child: RoundedNetworkImageHolder(
                              //           width: Dimens.space40,
                              //           height: Dimens.space40,
                              //           boxFit: BoxFit.cover,
                              //           containerAlignment: Alignment.center,
                              //           iconUrl: Icons.call,
                              //           iconColor: CustomColors.text_active!,
                              //           iconSize: Dimens.space25,
                              //           boxDecorationColor: Colors.transparent,
                              //           outerCorner: Dimens.space300,
                              //           innerCorner: Dimens.space300,
                              //           imageUrl: "",
                              //           onTap: () {
                              //             if (isCalling && showVideo == false) {
                              //               showVideo = true;
                              //               setState(() {});
                              //             } else {
                              //               String uid =
                              //                   "${DateTime.now().second}${Prefs.getString(Const.VALUE_HOLDER_USER_ID)}";
                              //               print("this is uid ${Prefs.getString(Const.VALUE_HOLDER_USER_NAME)} ${widget.roomDescription}");
                              //               isVideo = false;
                              //               chatChannelSubscriptionBloc.add(
                              //                 AgoraTokenEvent(
                              //                   body: {
                              //                     "params": {
                              //                       "environment": kDebugMode
                              //                           ? "DEV"
                              //                           : "PROD",
                              //                       "uid": int.parse(uid),
                              //                       "channelName":
                              //                           widget.isPrivate? "${Prefs.getString(Const.VALUE_HOLDER_USER_NAME)}_$uid": "${widget.roomDescription}_$uid",
                              //                     }
                              //                   },
                              //                 ),
                              //               );
                              //             }
                              //           },
                              //         ),
                              //       ),
                              widget.isFromDashboard
                                  ? Container()
                                  : Container(
                                      width: Dimens.space40.w,
                                      height: Dimens.space40.w,
                                      alignment: Alignment.center,
                                      margin: EdgeInsets.fromLTRB(
                                          Dimens.space10.w,
                                          Dimens.space0.h,
                                          Dimens.space0.w,
                                          Dimens.space0.h),
                                      padding: EdgeInsets.fromLTRB(
                                          Dimens.space0.w,
                                          Dimens.space0.h,
                                          Dimens.space0.w,
                                          Dimens.space0.h),
                                      child: RoundedNetworkImageHolder(
                                        width: Dimens.space40,
                                        height: Dimens.space40,
                                        boxFit: BoxFit.cover,
                                        containerAlignment: Alignment.center,
                                        iconUrl: Icons.video_call,
                                        iconColor: CustomColors.text_active!,
                                        iconSize: Dimens.space30,
                                        boxDecorationColor: Colors.transparent,
                                        outerCorner: Dimens.space300,
                                        innerCorner: Dimens.space300,
                                        imageUrl: "",
                                        onTap: () {
                                          if (isCalling && showVideo == false) {
                                            showVideo = true;
                                            setState(() {});
                                          } else {
                                            String uid =
                                                "${DateTime.now().second}${Prefs.getString(Const.VALUE_HOLDER_USER_ID)}";
                                            print(
                                                "this is uid ${Prefs.getString(Const.VALUE_HOLDER_USER_NAME)} ${widget.roomDescription}");
                                            isVideo = false;
                                            chatChannelSubscriptionBloc.add(
                                              AgoraTokenEvent(
                                                body: {
                                                  "params": {
                                                    "environment": kDebugMode
                                                        ? "DEV"
                                                        : "PROD",
                                                    "uid": int.parse(uid),
                                                    "channelName": widget
                                                            .isPrivate
                                                        ? "${Prefs.getString(Const.VALUE_HOLDER_USER_NAME)}_$uid"
                                                        : "${widget.roomDescription}_$uid",
                                                  }
                                                },
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ),
                              Container(
                                width: Dimens.space40.w,
                                height: Dimens.space40.w,
                                alignment: Alignment.center,
                                margin: EdgeInsets.fromLTRB(
                                    Dimens.space10.w,
                                    Dimens.space0.h,
                                    Dimens.space0.w,
                                    Dimens.space0.h),
                                padding: EdgeInsets.fromLTRB(
                                    Dimens.space0.w,
                                    Dimens.space0.h,
                                    Dimens.space0.w,
                                    Dimens.space0.h),
                                child: RoundedNetworkImageHolder(
                                  width: Dimens.space40,
                                  height: Dimens.space40,
                                  boxFit: BoxFit.cover,
                                  containerAlignment: Alignment.center,
                                  iconUrl: Icons.more_vert_rounded,
                                  iconColor: CustomColors.text_active!,
                                  iconSize: Dimens.space30,
                                  boxDecorationColor: Colors.transparent,
                                  outerCorner: Dimens.space300,
                                  innerCorner: Dimens.space300,
                                  imageUrl: "",
                                  onTap: () {
                                    showChannelSettingDialog();
                                  },
                                ),
                              ),
                            ],
                          ),
                          body: Container(
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            color: CustomColors.background_bg01,
                            margin: EdgeInsets.fromLTRB(
                                Dimens.space0.w,
                                Dimens.space0.h,
                                Dimens.space0.w,
                                Dimens.space0.h),
                            padding: EdgeInsets.fromLTRB(
                                Dimens.space0.w,
                                Dimens.space0.h,
                                Dimens.space0.w,
                                Dimens.space0.h),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  color: CustomColors.background_bg01,
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.fromLTRB(
                                      Dimens.space0.w,
                                      Dimens.space0.h,
                                      Dimens.space0.w,
                                      Dimens.space60.h),
                                  padding: EdgeInsets.fromLTRB(
                                      Dimens.space0.w,
                                      Dimens.space0.h,
                                      Dimens.space0.w,
                                      Dimens.space0.h),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      listMessages != null &&
                                              listMessages!.length != 0
                                          ? Expanded(
                                              child: Container(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                margin: EdgeInsets.fromLTRB(
                                                    Dimens.space0.w,
                                                    Dimens.space0.h,
                                                    Dimens.space0.w,
                                                    Dimens.space0.h),
                                                padding: EdgeInsets.fromLTRB(
                                                    Dimens.space0.w,
                                                    Dimens.space0.h,
                                                    Dimens.space0.w,
                                                    Dimens.space0.h),
                                                child: ListView.builder(
                                                  controller: scrollController,
                                                  itemCount:
                                                      listMessages!.length,
                                                  reverse: true,
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  physics:
                                                      AlwaysScrollableScrollPhysics(),
                                                  padding: EdgeInsets.fromLTRB(
                                                    Dimens.space0,
                                                    Dimens.space0,
                                                    Dimens.space0,
                                                    Dimens.space0,
                                                  ),
                                                  shrinkWrap: true,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    if (listMessages![index]
                                                                .u !=
                                                            null &&
                                                        listMessages![index]
                                                                .u!
                                                                .sId !=
                                                            null &&
                                                        listMessages![index]
                                                                .u!
                                                                .sId ==
                                                            userId) {
                                                      return Container(
                                                        alignment: Alignment
                                                            .centerRight,
                                                        margin:
                                                            EdgeInsets.fromLTRB(
                                                                Dimens.space5.w,
                                                                Dimens
                                                                    .space10.h,
                                                                Dimens.space5.w,
                                                                Dimens
                                                                    .space10.h),
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                Dimens.space0.w,
                                                                Dimens
                                                                    .space10.h,
                                                                Dimens.space0.w,
                                                                Dimens
                                                                    .space10.h),
                                                        constraints:
                                                            BoxConstraints(
                                                          maxWidth:
                                                              Dimens.space150.w,
                                                          minWidth:
                                                              Dimens.space10.w,
                                                        ),
                                                        child: TextButton(
                                                          style: TextButton
                                                              .styleFrom(
                                                            padding: EdgeInsets
                                                                .fromLTRB(
                                                                    Dimens
                                                                        .space0
                                                                        .w,
                                                                    Dimens
                                                                        .space0
                                                                        .h,
                                                                    Dimens
                                                                        .space0
                                                                        .w,
                                                                    Dimens
                                                                        .space0
                                                                        .h),
                                                            tapTargetSize:
                                                                MaterialTapTargetSize
                                                                    .shrinkWrap,
                                                            alignment: Alignment
                                                                .centerRight,
                                                          ),
                                                          onPressed: () {
                                                            showDeleteMessageDialog(
                                                                listMessages![
                                                                        index]
                                                                    .sId!,
                                                                index);
                                                          },
                                                          child: Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              Container(
                                                                alignment: Alignment
                                                                    .centerRight,
                                                                margin: EdgeInsets.fromLTRB(
                                                                    Dimens
                                                                        .space0
                                                                        .w,
                                                                    Dimens
                                                                        .space0
                                                                        .h,
                                                                    Dimens
                                                                        .space0
                                                                        .w,
                                                                    Dimens
                                                                        .space0
                                                                        .h),
                                                                padding: EdgeInsets.fromLTRB(
                                                                    Dimens
                                                                        .space0
                                                                        .w,
                                                                    Dimens
                                                                        .space0
                                                                        .h,
                                                                    Dimens
                                                                        .space0
                                                                        .w,
                                                                    Dimens
                                                                        .space0
                                                                        .h),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .end,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  children: [
                                                                    Row(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .end,
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .max,
                                                                      children: [
                                                                        Container(
                                                                          alignment:
                                                                              Alignment.centerRight,
                                                                          margin: EdgeInsets.fromLTRB(
                                                                              Dimens.space5.w,
                                                                              Dimens.space0.h,
                                                                              Dimens.space5.w,
                                                                              Dimens.space0.h),
                                                                          padding: EdgeInsets.fromLTRB(
                                                                              Dimens.space0.w,
                                                                              Dimens.space0.h,
                                                                              Dimens.space0.w,
                                                                              Dimens.space0.h),
                                                                          child:
                                                                              Text(
                                                                            listMessages![index].u != null && listMessages![index].u!.username != null
                                                                                ? listMessages![index].u!.username!.split("_")[0]
                                                                                : "Not Available",
                                                                            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                                                                  color: CustomColors.text_active,
                                                                                  fontFamily: Config.InterRegular,
                                                                                  fontSize: Dimens.space10.sp,
                                                                                  fontWeight: FontWeight.normal,
                                                                                  fontStyle: FontStyle.normal,
                                                                                ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Container(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerRight,
                                                                      margin: EdgeInsets.fromLTRB(
                                                                          Dimens
                                                                              .space0
                                                                              .w,
                                                                          Dimens
                                                                              .space0
                                                                              .h,
                                                                          Dimens
                                                                              .space5
                                                                              .w,
                                                                          Dimens
                                                                              .space0
                                                                              .h),
                                                                      padding: EdgeInsets.fromLTRB(
                                                                          Dimens
                                                                              .space5
                                                                              .w,
                                                                          Dimens
                                                                              .space5
                                                                              .h,
                                                                          Dimens
                                                                              .space5
                                                                              .w,
                                                                          Dimens
                                                                              .space5
                                                                              .h),
                                                                      constraints:
                                                                          BoxConstraints(
                                                                        maxWidth: Dimens
                                                                            .space250
                                                                            .w,
                                                                        minWidth: Dimens
                                                                            .space10
                                                                            .w,
                                                                      ),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: Color(
                                                                            0xff2196F3),
                                                                        shape: BoxShape
                                                                            .rectangle,
                                                                        borderRadius:
                                                                            BorderRadius.only(
                                                                          topLeft: Radius.circular(Dimens
                                                                              .space12
                                                                              .r),
                                                                          topRight: Radius.circular(Dimens
                                                                              .space12
                                                                              .r),
                                                                          bottomLeft: Radius.circular(Dimens
                                                                              .space12
                                                                              .r),
                                                                          bottomRight: Radius.circular(Dimens
                                                                              .space0
                                                                              .r),
                                                                        ),
                                                                      ),
                                                                      child:
                                                                          Column(
                                                                        mainAxisSize:
                                                                            MainAxisSize.max,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.center,
                                                                        children: [
                                                                          listMessages![index].msg != null && listMessages![index].msg != ""
                                                                              ? Container(
                                                                                  alignment: Alignment.centerRight,
                                                                                  margin: EdgeInsets.fromLTRB(Dimens.space5.w, Dimens.space5.h, Dimens.space5.w, Dimens.space5.h),
                                                                                  padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                                                                                  child: Text(
                                                                                    listMessages![index].msg!,
                                                                                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                                                                          color: Colors.white,
                                                                                          fontFamily: Config.InterRegular,
                                                                                          fontSize: Dimens.space14.sp,
                                                                                          fontWeight: FontWeight.normal,
                                                                                          fontStyle: FontStyle.normal,
                                                                                        ),
                                                                                  ),
                                                                                )
                                                                              : Container(),
                                                                          listMessages![index].fileObject != null
                                                                              ? Container(
                                                                                  alignment: Alignment.center,
                                                                                  margin: EdgeInsets.fromLTRB(Dimens.space5.w, Dimens.space5.h, Dimens.space5.w, Dimens.space5.h),
                                                                                  padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                                                                                  child: ListView.builder(
                                                                                    controller: scrollController,
                                                                                    itemCount: listMessages![index].attachments!.length,
                                                                                    reverse: false,
                                                                                    scrollDirection: Axis.vertical,
                                                                                    physics: AlwaysScrollableScrollPhysics(),
                                                                                    padding: EdgeInsets.fromLTRB(
                                                                                      Dimens.space0,
                                                                                      Dimens.space0,
                                                                                      Dimens.space0,
                                                                                      Dimens.space0,
                                                                                    ),
                                                                                    shrinkWrap: true,
                                                                                    itemBuilder: (BuildContext context, fileIndex) {
                                                                                      return Container(
                                                                                          alignment: Alignment.centerRight,
                                                                                          margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                                                                                          padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                                                                                          child: Column(
                                                                                            mainAxisSize: MainAxisSize.max,
                                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                                            crossAxisAlignment: CrossAxisAlignment.end,
                                                                                            children: [
                                                                                              Row(
                                                                                                mainAxisSize: MainAxisSize.max,
                                                                                                mainAxisAlignment: MainAxisAlignment.end,
                                                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                                                children: [
                                                                                                  Expanded(
                                                                                                    child: Container(
                                                                                                      alignment: Alignment.centerRight,
                                                                                                      margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                                                                                                      padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                                                                                                      child: Text(
                                                                                                        listMessages![index].attachments![fileIndex].title!,
                                                                                                        maxLines: 1,
                                                                                                        overflow: TextOverflow.ellipsis,
                                                                                                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                                                                                              color: Colors.white,
                                                                                                              fontFamily: Config.InterRegular,
                                                                                                              fontSize: Dimens.space12.sp,
                                                                                                              fontWeight: FontWeight.normal,
                                                                                                              fontStyle: FontStyle.normal,
                                                                                                            ),
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                  Container(
                                                                                                    alignment: Alignment.centerRight,
                                                                                                    margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                                                                                                    padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                                                                                                    child: LayoutBuilder(
                                                                                                      builder: (BuildContext context, BoxConstraints constraints) {
                                                                                                        List<String> fileType = listMessages![index].fileObject!.type!.split("/");
                                                                                                        if (fileType[0] == "image") {
                                                                                                          return Text(
                                                                                                            "(" + filesize(listMessages![index].attachments![fileIndex].imageSize) + ")",
                                                                                                            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                                                                                                  color: Colors.white,
                                                                                                                  fontFamily: Config.InterRegular,
                                                                                                                  fontSize: Dimens.space12.sp,
                                                                                                                  fontWeight: FontWeight.normal,
                                                                                                                  fontStyle: FontStyle.normal,
                                                                                                                ),
                                                                                                          );
                                                                                                        } else if (fileType[0] == "video") {
                                                                                                          return Text(
                                                                                                            "(" + filesize(listMessages![index].attachments![fileIndex].videoSize) + ")",
                                                                                                            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                                                                                                  color: Colors.white,
                                                                                                                  fontFamily: Config.InterRegular,
                                                                                                                  fontSize: Dimens.space12.sp,
                                                                                                                  fontWeight: FontWeight.normal,
                                                                                                                  fontStyle: FontStyle.normal,
                                                                                                                ),
                                                                                                          );
                                                                                                        } else {
                                                                                                          return Container();
                                                                                                        }
                                                                                                      },
                                                                                                    ),
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                              Container(
                                                                                                alignment: Alignment.center,
                                                                                                margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                                                                                                padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space10.h, Dimens.space0.w, Dimens.space0.h),
                                                                                                child: LayoutBuilder(
                                                                                                  builder: (BuildContext context, BoxConstraints constraints) {
                                                                                                    List<String> fileType = listMessages![index].fileObject!.type!.split("/");
                                                                                                    if (fileType[0] == "image") {
                                                                                                      return RoundedNetworkImageHolder(
                                                                                                        imageUrl: Config.listChatUrl[widget.urlIndex] + listMessages![index].attachments![0].imageUrl!,
                                                                                                        width: Dimens.space200.w,
                                                                                                        height: Dimens.space200.w,
                                                                                                        iconUrl: Icons.check_circle,
                                                                                                        iconSize: Dimens.space0,
                                                                                                        boxFit: BoxFit.cover,
                                                                                                        boxDecorationColor: Colors.transparent,
                                                                                                        iconColor: Colors.transparent,
                                                                                                        onTap: () {},
                                                                                                      );
                                                                                                    } else if (fileType[0] == "video") {
                                                                                                      VideoPlayerController? _controller = VideoPlayerController.network(
                                                                                                        Config.listChatUrl[widget.urlIndex] + listMessages![index].attachments![0].videoUrl!,
                                                                                                        // closedCaptionFile: _loadCaptions(),
                                                                                                        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
                                                                                                      );
                                                                                                      _controller.addListener(() {});
                                                                                                      _controller.setLooping(true);
                                                                                                      _controller.initialize();
                                                                                                      return AspectRatio(
                                                                                                        aspectRatio: _controller.value.aspectRatio,
                                                                                                        child: Stack(
                                                                                                          alignment: Alignment.bottomCenter,
                                                                                                          children: <Widget>[
                                                                                                            VideoPlayer(_controller),
                                                                                                            ClosedCaption(text: _controller.value.caption.text),
                                                                                                            _ControlsOverlay(controller: _controller),
                                                                                                            VideoProgressIndicator(_controller, allowScrubbing: true),
                                                                                                          ],
                                                                                                        ),
                                                                                                      );
                                                                                                    } else {
                                                                                                      return Container();
                                                                                                    }
                                                                                                  },
                                                                                                ),
                                                                                              ),
                                                                                            ],
                                                                                          ));
                                                                                    },
                                                                                  ),
                                                                                )
                                                                              : Container(),
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.end,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.center,
                                                                            mainAxisSize:
                                                                                MainAxisSize.max,
                                                                            children: [
                                                                              Container(
                                                                                alignment: Alignment.center,
                                                                                margin: EdgeInsets.fromLTRB(Dimens.space5.w, Dimens.space0.h, Dimens.space5.w, Dimens.space0.h),
                                                                                padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                                                                                child: Text(
                                                                                  listMessages![index].ts != null && listMessages![index].ts!.date != null ? Utils.convertMessageDateTime(DateTime.fromMillisecondsSinceEpoch(listMessages![index].ts!.date!).toString(), "yyyy-MM-ddThh:mm:ss.SSSSSS", "dd MMM") : "Not Available",
                                                                                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                                                                        color: Colors.white,
                                                                                        fontFamily: Config.InterRegular,
                                                                                        fontSize: Dimens.space10.sp,
                                                                                        fontWeight: FontWeight.normal,
                                                                                        fontStyle: FontStyle.normal,
                                                                                      ),
                                                                                ),
                                                                              ),
                                                                              Container(
                                                                                alignment: Alignment.center,
                                                                                margin: EdgeInsets.fromLTRB(Dimens.space5.w, Dimens.space0.h, Dimens.space5.w, Dimens.space0.h),
                                                                                padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                                                                                child: Text(
                                                                                  listMessages![index].ts != null && listMessages![index].ts!.date != null ? Utils.convertCallTime(DateTime.fromMillisecondsSinceEpoch(listMessages![index].ts!.date!).toString(), 'yyyy-MM-ddThh:mm:ss.SSSSSS', "hh:mm a") : "Not Available",
                                                                                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                                                                        color: Colors.white,
                                                                                        fontFamily: Config.InterRegular,
                                                                                        fontSize: Dimens.space10.sp,
                                                                                        fontWeight: FontWeight.normal,
                                                                                        fontStyle: FontStyle.normal,
                                                                                      ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Container(
                                                                height: Dimens
                                                                    .space48.h,
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                margin: EdgeInsets.fromLTRB(
                                                                    Dimens
                                                                        .space0
                                                                        .w,
                                                                    Dimens
                                                                        .space0
                                                                        .h,
                                                                    Dimens
                                                                        .space0
                                                                        .w,
                                                                    Dimens
                                                                        .space0
                                                                        .h),
                                                                padding: EdgeInsets.fromLTRB(
                                                                    Dimens
                                                                        .space0
                                                                        .w,
                                                                    Dimens
                                                                        .space0
                                                                        .h,
                                                                    Dimens
                                                                        .space0
                                                                        .w,
                                                                    Dimens
                                                                        .space0
                                                                        .h),
                                                                child: Stack(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  children: [
                                                                    Container(
                                                                      height: Dimens
                                                                          .space48
                                                                          .h,
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      margin: EdgeInsets.fromLTRB(
                                                                          Dimens
                                                                              .space0
                                                                              .w,
                                                                          Dimens
                                                                              .space0
                                                                              .h,
                                                                          Dimens
                                                                              .space0
                                                                              .w,
                                                                          Dimens
                                                                              .space0
                                                                              .h),
                                                                      padding: EdgeInsets.fromLTRB(
                                                                          Dimens
                                                                              .space0
                                                                              .w,
                                                                          Dimens
                                                                              .space0
                                                                              .h,
                                                                          Dimens
                                                                              .space0
                                                                              .w,
                                                                          Dimens
                                                                              .space0
                                                                              .h),
                                                                      child:
                                                                          PlainAssetImageHolder(
                                                                        height:
                                                                            Dimens.space48,
                                                                        width: Dimens
                                                                            .space48,
                                                                        assetWidth:
                                                                            Dimens.space48,
                                                                        assetHeight:
                                                                            Dimens.space48,
                                                                        assetUrl:
                                                                            "assets/images/icon_home_image_border_oval.png",
                                                                        outerCorner:
                                                                            Dimens.space0,
                                                                        innerCorner:
                                                                            Dimens.space0,
                                                                        iconSize:
                                                                            Dimens.space0,
                                                                        iconUrl:
                                                                            Icons.camera_alt_outlined,
                                                                        iconColor:
                                                                            Colors.transparent,
                                                                        boxDecorationColor:
                                                                            Colors.transparent,
                                                                        boxFit:
                                                                            BoxFit.contain,
                                                                        onTap:
                                                                            () {},
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      height: Dimens
                                                                          .space40
                                                                          .h,
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      margin: EdgeInsets.fromLTRB(
                                                                          Dimens
                                                                              .space0
                                                                              .w,
                                                                          Dimens
                                                                              .space0
                                                                              .h,
                                                                          Dimens
                                                                              .space0
                                                                              .w,
                                                                          Dimens
                                                                              .space0
                                                                              .h),
                                                                      padding: EdgeInsets.fromLTRB(
                                                                          Dimens
                                                                              .space0
                                                                              .w,
                                                                          Dimens
                                                                              .space0
                                                                              .h,
                                                                          Dimens
                                                                              .space0
                                                                              .w,
                                                                          Dimens
                                                                              .space0
                                                                              .h),
                                                                      child:
                                                                          PlainAssetImageHolder(
                                                                        height:
                                                                            Dimens.space40,
                                                                        width: Dimens
                                                                            .space40,
                                                                        assetWidth:
                                                                            Dimens.space40,
                                                                        assetHeight:
                                                                            Dimens.space40,
                                                                        assetUrl:
                                                                            "assets/images/icon_profile.png",
                                                                        outerCorner:
                                                                            Dimens.space0,
                                                                        innerCorner:
                                                                            Dimens.space0,
                                                                        iconSize:
                                                                            Dimens.space0,
                                                                        iconUrl:
                                                                            Icons.camera_alt_outlined,
                                                                        iconColor:
                                                                            Colors.transparent,
                                                                        boxDecorationColor:
                                                                            Colors.transparent,
                                                                        boxFit:
                                                                            BoxFit.contain,
                                                                        onTap:
                                                                            () {},
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      height: Dimens
                                                                          .space48
                                                                          .h,
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      margin: EdgeInsets.fromLTRB(
                                                                          Dimens
                                                                              .space0
                                                                              .w,
                                                                          Dimens
                                                                              .space0
                                                                              .h,
                                                                          Dimens
                                                                              .space0
                                                                              .w,
                                                                          Dimens
                                                                              .space0
                                                                              .h),
                                                                      padding: EdgeInsets.fromLTRB(
                                                                          Dimens
                                                                              .space0
                                                                              .w,
                                                                          Dimens
                                                                              .space0
                                                                              .h,
                                                                          Dimens
                                                                              .space0
                                                                              .w,
                                                                          Dimens
                                                                              .space0
                                                                              .h),
                                                                      child:
                                                                          RoundedFileImageHolderWithText(
                                                                        height:
                                                                            Dimens.space42,
                                                                        width: Dimens
                                                                            .space42,
                                                                        textColor:
                                                                            Colors.white,
                                                                        fontFamily:
                                                                            Config.PoppinsExtraBold,
                                                                        text: listMessages![index].u != null &&
                                                                                listMessages![index].u!.username != null
                                                                            ? listMessages![index].u!.username![0].toUpperCase()
                                                                            : "Not Available",
                                                                        fileUrl:
                                                                            '',
                                                                        outerCorner:
                                                                            Dimens.space20,
                                                                        innerCorner:
                                                                            Dimens.space20,
                                                                        iconSize:
                                                                            Dimens.space0,
                                                                        iconUrl:
                                                                            Icons.camera_alt_outlined,
                                                                        iconColor:
                                                                            Colors.transparent,
                                                                        boxDecorationColor:
                                                                            Colors.transparent,
                                                                        boxFit:
                                                                            BoxFit.contain,
                                                                        onTap:
                                                                            () {},
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    } else {
                                                      return Container(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        margin:
                                                            EdgeInsets.fromLTRB(
                                                                Dimens.space5.w,
                                                                Dimens
                                                                    .space10.h,
                                                                Dimens.space5.w,
                                                                Dimens
                                                                    .space10.h),
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                Dimens.space0.w,
                                                                Dimens
                                                                    .space10.h,
                                                                Dimens.space0.w,
                                                                Dimens
                                                                    .space10.h),
                                                        child: TextButton(
                                                          style: TextButton
                                                              .styleFrom(
                                                            padding: EdgeInsets
                                                                .fromLTRB(
                                                                    Dimens
                                                                        .space0
                                                                        .w,
                                                                    Dimens
                                                                        .space0
                                                                        .h,
                                                                    Dimens
                                                                        .space0
                                                                        .w,
                                                                    Dimens
                                                                        .space0
                                                                        .h),
                                                            tapTargetSize:
                                                                MaterialTapTargetSize
                                                                    .shrinkWrap,
                                                            alignment: Alignment
                                                                .centerLeft,
                                                          ),
                                                          onPressed: () {},
                                                          child: Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              Container(
                                                                height: Dimens
                                                                    .space48.h,
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                margin: EdgeInsets.fromLTRB(
                                                                    Dimens
                                                                        .space0
                                                                        .w,
                                                                    Dimens
                                                                        .space0
                                                                        .h,
                                                                    Dimens
                                                                        .space0
                                                                        .w,
                                                                    Dimens
                                                                        .space0
                                                                        .h),
                                                                padding: EdgeInsets.fromLTRB(
                                                                    Dimens
                                                                        .space0
                                                                        .w,
                                                                    Dimens
                                                                        .space0
                                                                        .h,
                                                                    Dimens
                                                                        .space0
                                                                        .w,
                                                                    Dimens
                                                                        .space0
                                                                        .h),
                                                                child: Stack(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  children: [
                                                                    Container(
                                                                      height: Dimens
                                                                          .space48
                                                                          .h,
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      margin: EdgeInsets.fromLTRB(
                                                                          Dimens
                                                                              .space0
                                                                              .w,
                                                                          Dimens
                                                                              .space0
                                                                              .h,
                                                                          Dimens
                                                                              .space0
                                                                              .w,
                                                                          Dimens
                                                                              .space0
                                                                              .h),
                                                                      padding: EdgeInsets.fromLTRB(
                                                                          Dimens
                                                                              .space0
                                                                              .w,
                                                                          Dimens
                                                                              .space0
                                                                              .h,
                                                                          Dimens
                                                                              .space0
                                                                              .w,
                                                                          Dimens
                                                                              .space0
                                                                              .h),
                                                                      child:
                                                                          PlainAssetImageHolder(
                                                                        height:
                                                                            Dimens.space48,
                                                                        width: Dimens
                                                                            .space48,
                                                                        assetWidth:
                                                                            Dimens.space48,
                                                                        assetHeight:
                                                                            Dimens.space48,
                                                                        assetUrl:
                                                                            "assets/images/icon_home_image_border_oval.png",
                                                                        outerCorner:
                                                                            Dimens.space0,
                                                                        innerCorner:
                                                                            Dimens.space0,
                                                                        iconSize:
                                                                            Dimens.space0,
                                                                        iconUrl:
                                                                            Icons.camera_alt_outlined,
                                                                        iconColor:
                                                                            Colors.transparent,
                                                                        boxDecorationColor:
                                                                            Colors.transparent,
                                                                        boxFit:
                                                                            BoxFit.contain,
                                                                        onTap:
                                                                            () {},
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      height: Dimens
                                                                          .space40
                                                                          .h,
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      margin: EdgeInsets.fromLTRB(
                                                                          Dimens
                                                                              .space0
                                                                              .w,
                                                                          Dimens
                                                                              .space0
                                                                              .h,
                                                                          Dimens
                                                                              .space0
                                                                              .w,
                                                                          Dimens
                                                                              .space0
                                                                              .h),
                                                                      padding: EdgeInsets.fromLTRB(
                                                                          Dimens
                                                                              .space0
                                                                              .w,
                                                                          Dimens
                                                                              .space0
                                                                              .h,
                                                                          Dimens
                                                                              .space0
                                                                              .w,
                                                                          Dimens
                                                                              .space0
                                                                              .h),
                                                                      child:
                                                                          PlainAssetImageHolder(
                                                                        height:
                                                                            Dimens.space40,
                                                                        width: Dimens
                                                                            .space40,
                                                                        assetWidth:
                                                                            Dimens.space40,
                                                                        assetHeight:
                                                                            Dimens.space40,
                                                                        assetUrl:
                                                                            "assets/images/icon_profile.png",
                                                                        outerCorner:
                                                                            Dimens.space0,
                                                                        innerCorner:
                                                                            Dimens.space0,
                                                                        iconSize:
                                                                            Dimens.space0,
                                                                        iconUrl:
                                                                            Icons.camera_alt_outlined,
                                                                        iconColor:
                                                                            Colors.transparent,
                                                                        boxDecorationColor:
                                                                            Colors.transparent,
                                                                        boxFit:
                                                                            BoxFit.contain,
                                                                        onTap:
                                                                            () {},
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      height: Dimens
                                                                          .space48
                                                                          .h,
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      margin: EdgeInsets.fromLTRB(
                                                                          Dimens
                                                                              .space0
                                                                              .w,
                                                                          Dimens
                                                                              .space0
                                                                              .h,
                                                                          Dimens
                                                                              .space0
                                                                              .w,
                                                                          Dimens
                                                                              .space0
                                                                              .h),
                                                                      padding: EdgeInsets.fromLTRB(
                                                                          Dimens
                                                                              .space0
                                                                              .w,
                                                                          Dimens
                                                                              .space0
                                                                              .h,
                                                                          Dimens
                                                                              .space0
                                                                              .w,
                                                                          Dimens
                                                                              .space0
                                                                              .h),
                                                                      child:
                                                                          RoundedFileImageHolderWithText(
                                                                        height:
                                                                            Dimens.space42,
                                                                        width: Dimens
                                                                            .space42,
                                                                        textColor:
                                                                            Colors.white,
                                                                        fontFamily:
                                                                            Config.PoppinsExtraBold,
                                                                        text: listMessages![index].u != null &&
                                                                                listMessages![index].u!.username != null
                                                                            ? listMessages![index].u!.username![0].toUpperCase()
                                                                            : "Not Available",
                                                                        fileUrl:
                                                                            '',
                                                                        outerCorner:
                                                                            Dimens.space20,
                                                                        innerCorner:
                                                                            Dimens.space20,
                                                                        iconSize:
                                                                            Dimens.space0,
                                                                        iconUrl:
                                                                            Icons.camera_alt_outlined,
                                                                        iconColor:
                                                                            Colors.transparent,
                                                                        boxDecorationColor:
                                                                            Colors.transparent,
                                                                        boxFit:
                                                                            BoxFit.contain,
                                                                        onTap:
                                                                            () {},
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child:
                                                                    Container(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  margin: EdgeInsets.fromLTRB(
                                                                      Dimens
                                                                          .space0
                                                                          .w,
                                                                      Dimens
                                                                          .space0
                                                                          .h,
                                                                      Dimens
                                                                          .space0
                                                                          .w,
                                                                      Dimens
                                                                          .space0
                                                                          .h),
                                                                  padding: EdgeInsets.fromLTRB(
                                                                      Dimens
                                                                          .space0
                                                                          .w,
                                                                      Dimens
                                                                          .space0
                                                                          .h,
                                                                      Dimens
                                                                          .space0
                                                                          .w,
                                                                      Dimens
                                                                          .space0
                                                                          .h),
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    children: [
                                                                      Row(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.center,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        mainAxisSize:
                                                                            MainAxisSize.max,
                                                                        children: [
                                                                          Container(
                                                                            alignment:
                                                                                Alignment.centerRight,
                                                                            margin: EdgeInsets.fromLTRB(
                                                                                Dimens.space5.w,
                                                                                Dimens.space0.h,
                                                                                Dimens.space5.w,
                                                                                Dimens.space0.h),
                                                                            padding: EdgeInsets.fromLTRB(
                                                                                Dimens.space0.w,
                                                                                Dimens.space0.h,
                                                                                Dimens.space0.w,
                                                                                Dimens.space0.h),
                                                                            child:
                                                                                Text(
                                                                              listMessages![index].u != null && listMessages![index].u!.username != null ? listMessages![index].u!.username!.split("_")[0] : "Not Available",
                                                                              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                                                                    color: CustomColors.text_active,
                                                                                    fontFamily: Config.InterRegular,
                                                                                    fontSize: Dimens.space10.sp,
                                                                                    fontWeight: FontWeight.normal,
                                                                                    fontStyle: FontStyle.normal,
                                                                                  ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Container(
                                                                        alignment:
                                                                            Alignment.centerLeft,
                                                                        margin: EdgeInsets.fromLTRB(
                                                                            Dimens.space5.w,
                                                                            Dimens.space0.h,
                                                                            Dimens.space0.w,
                                                                            Dimens.space0.h),
                                                                        padding: EdgeInsets.fromLTRB(
                                                                            Dimens.space5.w,
                                                                            Dimens.space5.h,
                                                                            Dimens.space5.w,
                                                                            Dimens.space5.h),
                                                                        constraints:
                                                                            BoxConstraints(
                                                                          maxWidth: Dimens
                                                                              .space250
                                                                              .w,
                                                                          minWidth: Dimens
                                                                              .space10
                                                                              .w,
                                                                        ),
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              Color(0xff5E6272),
                                                                          shape:
                                                                              BoxShape.rectangle,
                                                                          borderRadius:
                                                                              BorderRadius.only(
                                                                            topLeft:
                                                                                Radius.circular(Dimens.space0.r),
                                                                            topRight:
                                                                                Radius.circular(Dimens.space12.r),
                                                                            bottomLeft:
                                                                                Radius.circular(Dimens.space12.r),
                                                                            bottomRight:
                                                                                Radius.circular(Dimens.space12.r),
                                                                          ),
                                                                        ),
                                                                        child:
                                                                            Column(
                                                                          mainAxisSize:
                                                                              MainAxisSize.max,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.center,
                                                                          children: [
                                                                            listMessages![index].msg != null && listMessages![index].msg != ""
                                                                                ? Container(
                                                                                    alignment: Alignment.centerLeft,
                                                                                    margin: EdgeInsets.fromLTRB(Dimens.space5.w, Dimens.space5.h, Dimens.space5.w, Dimens.space5.h),
                                                                                    padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                                                                                    child: Text(
                                                                                      listMessages![index].msg!,
                                                                                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                                                                            color: Colors.white,
                                                                                            fontFamily: Config.InterRegular,
                                                                                            fontSize: Dimens.space14.sp,
                                                                                            fontWeight: FontWeight.normal,
                                                                                            fontStyle: FontStyle.normal,
                                                                                          ),
                                                                                    ),
                                                                                  )
                                                                                : Container(),
                                                                            listMessages![index].fileObject != null
                                                                                ? Container(
                                                                                    alignment: Alignment.centerLeft,
                                                                                    margin: EdgeInsets.fromLTRB(Dimens.space5.w, Dimens.space5.h, Dimens.space5.w, Dimens.space5.h),
                                                                                    padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                                                                                    child: ListView.builder(
                                                                                      controller: scrollController,
                                                                                      itemCount: listMessages![index].attachments!.length,
                                                                                      reverse: false,
                                                                                      scrollDirection: Axis.vertical,
                                                                                      physics: AlwaysScrollableScrollPhysics(),
                                                                                      padding: EdgeInsets.fromLTRB(
                                                                                        Dimens.space0,
                                                                                        Dimens.space0,
                                                                                        Dimens.space0,
                                                                                        Dimens.space0,
                                                                                      ),
                                                                                      shrinkWrap: true,
                                                                                      itemBuilder: (BuildContext context, fileIndex) {
                                                                                        return Container(
                                                                                          alignment: Alignment.centerLeft,
                                                                                          margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                                                                                          padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                                                                                          child: Column(
                                                                                            mainAxisSize: MainAxisSize.max,
                                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                                            crossAxisAlignment: CrossAxisAlignment.end,
                                                                                            children: [
                                                                                              Row(
                                                                                                mainAxisSize: MainAxisSize.max,
                                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                                                children: [
                                                                                                  Expanded(
                                                                                                    child: Container(
                                                                                                      alignment: Alignment.centerLeft,
                                                                                                      margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                                                                                                      padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                                                                                                      child: Text(
                                                                                                        listMessages![index].attachments![fileIndex].title!,
                                                                                                        maxLines: 1,
                                                                                                        overflow: TextOverflow.ellipsis,
                                                                                                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                                                                                              color: Colors.white,
                                                                                                              fontFamily: Config.InterRegular,
                                                                                                              fontSize: Dimens.space12.sp,
                                                                                                              fontWeight: FontWeight.normal,
                                                                                                              fontStyle: FontStyle.normal,
                                                                                                            ),
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                  Container(
                                                                                                    alignment: Alignment.centerLeft,
                                                                                                    margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                                                                                                    padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                                                                                                    child: LayoutBuilder(
                                                                                                      builder: (BuildContext context, BoxConstraints constraints) {
                                                                                                        List<String> fileType = listMessages![index].fileObject!.type!.split("/");
                                                                                                        if (fileType[0] == "image") {
                                                                                                          return Text(
                                                                                                            "(" + filesize(listMessages![index].attachments![fileIndex].imageSize) + ")",
                                                                                                            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                                                                                                  color: Colors.white,
                                                                                                                  fontFamily: Config.InterRegular,
                                                                                                                  fontSize: Dimens.space12.sp,
                                                                                                                  fontWeight: FontWeight.normal,
                                                                                                                  fontStyle: FontStyle.normal,
                                                                                                                ),
                                                                                                          );
                                                                                                        } else if (fileType[0] == "video") {
                                                                                                          return Text(
                                                                                                            "(" + filesize(listMessages![index].attachments![fileIndex].videoSize) + ")",
                                                                                                            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                                                                                                  color: Colors.white,
                                                                                                                  fontFamily: Config.InterRegular,
                                                                                                                  fontSize: Dimens.space12.sp,
                                                                                                                  fontWeight: FontWeight.normal,
                                                                                                                  fontStyle: FontStyle.normal,
                                                                                                                ),
                                                                                                          );
                                                                                                        } else {
                                                                                                          return Container();
                                                                                                        }
                                                                                                      },
                                                                                                    ),
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                              Container(
                                                                                                alignment: Alignment.center,
                                                                                                margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                                                                                                padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space10.h, Dimens.space0.w, Dimens.space0.h),
                                                                                                child: LayoutBuilder(
                                                                                                  builder: (BuildContext context, BoxConstraints constraints) {
                                                                                                    List<String> fileType = listMessages![index].fileObject!.type!.split("/");
                                                                                                    if (fileType[0] == "image") {
                                                                                                      return RoundedNetworkImageHolder(
                                                                                                        imageUrl: Config.listChatUrl[widget.urlIndex] + listMessages![index].attachments![0].imageUrl!,
                                                                                                        width: Dimens.space200.w,
                                                                                                        height: Dimens.space200.w,
                                                                                                        iconUrl: Icons.check_circle,
                                                                                                        iconSize: Dimens.space0,
                                                                                                        boxFit: BoxFit.cover,
                                                                                                        boxDecorationColor: Colors.transparent,
                                                                                                        iconColor: Colors.transparent,
                                                                                                        onTap: () {},
                                                                                                      );
                                                                                                    } else if (fileType[0] == "video") {
                                                                                                      VideoPlayerController? _controller = VideoPlayerController.network(
                                                                                                        Config.listChatUrl[widget.urlIndex] + listMessages![index].attachments![0].videoUrl!,
                                                                                                        // closedCaptionFile: _loadCaptions(),
                                                                                                        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
                                                                                                      );
                                                                                                      _controller.addListener(() {});
                                                                                                      _controller.setLooping(true);
                                                                                                      _controller.initialize();
                                                                                                      return AspectRatio(
                                                                                                        aspectRatio: _controller.value.aspectRatio,
                                                                                                        child: Stack(
                                                                                                          alignment: Alignment.bottomCenter,
                                                                                                          children: <Widget>[
                                                                                                            VideoPlayer(_controller),
                                                                                                            ClosedCaption(text: _controller.value.caption.text),
                                                                                                            _ControlsOverlay(controller: _controller),
                                                                                                            VideoProgressIndicator(_controller, allowScrubbing: true),
                                                                                                          ],
                                                                                                        ),
                                                                                                      );
                                                                                                    } else {
                                                                                                      return Container();
                                                                                                    }
                                                                                                  },
                                                                                                ),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        );
                                                                                      },
                                                                                    ),
                                                                                  )
                                                                                : Container(),
                                                                            Row(
                                                                              mainAxisAlignment: MainAxisAlignment.end,
                                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                                              mainAxisSize: MainAxisSize.max,
                                                                              children: [
                                                                                Container(
                                                                                  alignment: Alignment.center,
                                                                                  margin: EdgeInsets.fromLTRB(Dimens.space5.w, Dimens.space0.h, Dimens.space5.w, Dimens.space0.h),
                                                                                  padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                                                                                  child: Text(
                                                                                    listMessages![index].ts != null && listMessages![index].ts!.date != null ? Utils.convertMessageDateTime(DateTime.fromMillisecondsSinceEpoch(listMessages![index].ts!.date!).toString(), "yyyy-MM-ddThh:mm:ss.SSSSSS", "dd MMM") : "Not Available",
                                                                                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                                                                          color: Colors.white,
                                                                                          fontFamily: Config.InterRegular,
                                                                                          fontSize: Dimens.space10.sp,
                                                                                          fontWeight: FontWeight.normal,
                                                                                          fontStyle: FontStyle.normal,
                                                                                        ),
                                                                                  ),
                                                                                ),
                                                                                Container(
                                                                                  alignment: Alignment.center,
                                                                                  margin: EdgeInsets.fromLTRB(Dimens.space5.w, Dimens.space0.h, Dimens.space5.w, Dimens.space0.h),
                                                                                  padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                                                                                  child: Text(
                                                                                    listMessages![index].ts != null && listMessages![index].ts!.date != null ? Utils.convertCallTime(DateTime.fromMillisecondsSinceEpoch(listMessages![index].ts!.date!).toString(), 'yyyy-MM-ddThh:mm:ss.SSSSSS', "hh:mm a") : "Not Available",
                                                                                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                                                                          color: Colors.white,
                                                                                          fontFamily: Config.InterRegular,
                                                                                          fontSize: Dimens.space10.sp,
                                                                                          fontWeight: FontWeight.normal,
                                                                                          fontStyle: FontStyle.normal,
                                                                                        ),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    }
                                                  },
                                                ),
                                              ),
                                            )
                                          : Container(),
                                      isTyping
                                          ? Container(
                                              alignment: Alignment.bottomLeft,
                                              margin: EdgeInsets.fromLTRB(
                                                  Dimens.space20.w,
                                                  Dimens.space5.h,
                                                  Dimens.space20..w,
                                                  Dimens.space5.h),
                                              padding: EdgeInsets.fromLTRB(
                                                  Dimens.space0.w,
                                                  Dimens.space0.h,
                                                  Dimens.space0.w,
                                                  Dimens.space0.h),
                                              child: Text(
                                                whoIsTyping + " is typing...",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1!
                                                    .copyWith(
                                                      color: CustomColors
                                                          .text_active,
                                                      fontFamily:
                                                          Config.InterRegular,
                                                      fontSize:
                                                          Dimens.space10.sp,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontStyle:
                                                          FontStyle.italic,
                                                    ),
                                              ),
                                            )
                                          : Container(),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  left: Dimens.space0.w,
                                  right: Dimens.space0.w,
                                  bottom: Dimens.space0.w,
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: Dimens.space60.h,
                                    margin: EdgeInsets.fromLTRB(
                                        Dimens.space0.w,
                                        Dimens.space0.h,
                                        Dimens.space0.w,
                                        Dimens.space0.h),
                                    padding: EdgeInsets.fromLTRB(
                                        Dimens.space0.w,
                                        Dimens.space0.h,
                                        Dimens.space0.w,
                                        Dimens.space0.h),
                                    decoration: BoxDecoration(
                                      color: CustomColors.background_bg01,
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.only(
                                        topLeft:
                                            Radius.circular(Dimens.space0.r),
                                        topRight:
                                            Radius.circular(Dimens.space0.r),
                                        bottomLeft:
                                            Radius.circular(Dimens.space0.r),
                                        bottomRight:
                                            Radius.circular(Dimens.space0.r),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          child: Container(
                                            height: Dimens.space50.h,
                                            margin: EdgeInsets.fromLTRB(
                                                Dimens.space12.w,
                                                Dimens.space0.h,
                                                Dimens.space12.w,
                                                Dimens.space0.h),
                                            padding: EdgeInsets.fromLTRB(
                                                Dimens.space0.w,
                                                Dimens.space0.h,
                                                Dimens.space0.w,
                                                Dimens.space0.h),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: Colors.transparent,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(
                                                    Dimens.space12.w),
                                              ),
                                            ),
                                            child: TextField(
                                              controller: chatTextController,
                                              keyboardType: TextInputType.text,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText2!
                                                  .copyWith(
                                                      color: CustomColors
                                                          .text_active,
                                                      fontFamily:
                                                          Config.heeboRegular,
                                                      fontSize:
                                                          Dimens.space14.sp,
                                                      fontWeight:
                                                          FontWeight.normal),
                                              textAlign: TextAlign.left,
                                              textAlignVertical:
                                                  TextAlignVertical.center,
                                              textInputAction:
                                                  TextInputAction.newline,
                                              onChanged: (value) {
                                                setState(() {});
                                              },
                                              decoration: InputDecoration(
                                                contentPadding:
                                                    EdgeInsets.fromLTRB(
                                                        Dimens.space16.w,
                                                        Dimens.space0.h,
                                                        Dimens.space16.w,
                                                        Dimens.space0.h),
                                                border: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Color(0xffECEBEB),
                                                    width: Dimens.space1.w,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(
                                                        Dimens.space300.w),
                                                  ),
                                                ),
                                                disabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Color(0xffECEBEB),
                                                    width: Dimens.space1.w,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(
                                                        Dimens.space300.w),
                                                  ),
                                                ),
                                                errorBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Color(0xffECEBEB),
                                                    width: Dimens.space1.w,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(
                                                        Dimens.space300.w),
                                                  ),
                                                ),
                                                focusedErrorBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Color(0xffECEBEB),
                                                    width: Dimens.space1.w,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(
                                                        Dimens.space300.w),
                                                  ),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Color(0xffECEBEB),
                                                    width: Dimens.space1.w,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(
                                                        Dimens.space300.w),
                                                  ),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Color(0xffECEBEB),
                                                    width: Dimens.space1.w,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(
                                                        Dimens.space300.w),
                                                  ),
                                                ),
                                                filled: true,
                                                fillColor: CustomColors
                                                    .background_bg01,
                                                hintText: "Send a message",
                                                hintStyle: Theme.of(context)
                                                    .textTheme
                                                    .bodyText2!
                                                    .copyWith(
                                                      color: CustomColors
                                                          .text_active,
                                                      fontFamily:
                                                          Config.heeboRegular,
                                                      fontSize:
                                                          Dimens.space14.sp,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                    ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Offstage(
                                          offstage:
                                              chatTextController.text.isNotEmpty
                                                  ? false
                                                  : true,
                                          child: Container(
                                            width: Dimens.space20.w,
                                            height: Dimens.space20.w,
                                            alignment: Alignment.center,
                                            margin: EdgeInsets.fromLTRB(
                                                Dimens.space0.w,
                                                Dimens.space0.h,
                                                Dimens.space0.w,
                                                Dimens.space0.h),
                                            padding: EdgeInsets.fromLTRB(
                                                Dimens.space0.w,
                                                Dimens.space0.h,
                                                Dimens.space0.w,
                                                Dimens.space0.h),
                                            child: RoundedNetworkImageHolder(
                                              width: Dimens.space20,
                                              height: Dimens.space20,
                                              boxFit: BoxFit.cover,
                                              containerAlignment:
                                                  Alignment.center,
                                              iconUrl: Icons.send,
                                              iconColor: Color(0xffA1A4AA),
                                              iconSize: Dimens.space20,
                                              boxDecorationColor:
                                                  Colors.transparent,
                                              outerCorner: Dimens.space0,
                                              innerCorner: Dimens.space0,
                                              imageUrl: "",
                                              onTap: sendMessage,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: Dimens.space20.w,
                                          height: Dimens.space20.w,
                                          alignment: Alignment.center,
                                          margin: EdgeInsets.fromLTRB(
                                              Dimens.space10.w,
                                              Dimens.space0.h,
                                              Dimens.space26.w,
                                              Dimens.space0.h),
                                          padding: EdgeInsets.fromLTRB(
                                              Dimens.space0.w,
                                              Dimens.space0.h,
                                              Dimens.space0.w,
                                              Dimens.space0.h),
                                          child: RoundedNetworkImageHolder(
                                            width: Dimens.space20,
                                            height: Dimens.space20,
                                            boxFit: BoxFit.cover,
                                            containerAlignment:
                                                Alignment.center,
                                            iconUrl: Icons
                                                .add_circle_outline_rounded,
                                            iconColor: Color(0xffA1A4AA),
                                            iconSize: Dimens.space20,
                                            boxDecorationColor:
                                                Colors.transparent,
                                            outerCorner: Dimens.space0,
                                            innerCorner: Dimens.space0,
                                            imageUrl: "",
                                            onTap: () {
                                              showFileVideoSelectionDialog();
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        isLoading
                            ? Container(
                                height: Utils.getScreenHeight(context),
                                width: Utils.getScreenWidth(context),
                                color:
                                    CustomColors.title_active!.withOpacity(0.2),
                                child: Center(
                                  child: Lottie.asset(
                                    'assets/lottie/Peeq_loader.json',
                                    height: Utils.getScreenWidth(context) * 0.6,
                                  ),
                                ),
                              )
                            : Container(),
                      ],
                    ),
            ],
          );
        },
      ),
    );
  }

  void sendMessage() {
    Utils.unFocusKeyboard(context);
    if (chatTextController.text.isNotEmpty) {
      Map sendMessage = {
        "msg": "method",
        "method": "sendMessage",
        "id": eventSendMessage,
        "params": [
          {
            "rid": widget.roomId,
            "msg": chatTextController.text,
          }
        ]
      };
      chatChannelSubscriptionBloc.webSocketChannel!.sink
          .add(jsonEncode(sendMessage));
    }
  }

  void uploadFile(String filePath, String fileName, String fileDescription) {
    chatChannelSubscriptionBloc.add(
      ChatChannelFileUploadResponseEvent(
        roomId: widget.roomId,
        urlIndex: widget.urlIndex,
        map: {
          "file": filePath,
          "fileName": fileName,
          "description": fileDescription,
        },
      ),
    );
  }

  void deleteMessage(String messageId, int index) {
    Map deleteMessage = {
      "msg": "method",
      "method": "deleteMessage",
      "id": eventDeleteMessage,
      "params": [
        {
          "_id": messageId,
        }
      ]
    };
    chatChannelSubscriptionBloc.webSocketChannel!.sink
        .add(jsonEncode(deleteMessage));
    listMessages!.removeAt(index);
    setState(() {});
  }

  void leaveChannel() {
    chatChannelSubscriptionBloc.add(
      ChatChannelLeaveRoomResponseEvent(
        urlIndex: widget.urlIndex,
        map: {
          "roomId": widget.roomId,
        },
      ),
    );
  }

  void deleteChannel() {
    if (widget.isPrivate) {
      chatChannelSubscriptionBloc.add(
        ChatChannelDeletePrivateRoomResponseEvent(
          urlIndex: widget.urlIndex,
          map: {
            "roomName": widget.roomName,
            "roomId": widget.roomId,
          },
        ),
      );
    } else {
      chatChannelSubscriptionBloc.add(
        ChatChannelDeletePublicRoomResponseEvent(
          urlIndex: widget.urlIndex,
          map: {
            "roomName": widget.roomName,
            "roomId": widget.roomId,
          },
        ),
      );
    }
  }

  void getUsersList() {
    chatChannelSubscriptionBloc.add(
      ChatChannelUsersListResponseEvent(
        urlIndex: widget.urlIndex,
      ),
    );
  }

  void getMembersList(bool isTrue) {
    isInit = isTrue;
    if (widget.isPrivate) {
      chatChannelSubscriptionBloc.add(
        ChatChannelGroupMembersListResponseEvent(
          urlIndex: widget.urlIndex,
          roomId: widget.roomId,
        ),
      );
    } else {
      chatChannelSubscriptionBloc.add(
        ChatChannelMembersListResponseEvent(
          urlIndex: widget.urlIndex,
          roomId: widget.roomId,
        ),
      );
    }
  }

  void addUserToChannel(Users users) {
    chatChannelSubscriptionBloc.add(
      ChatChannelAddUserToChannelResponseEvent(urlIndex: widget.urlIndex, map: {
        "roomId": widget.roomId,
        "userId": users.sId,
      }),
    );
  }

  void removeUserFromChannel(Members users) {
    chatChannelSubscriptionBloc.add(
      ChatChannelRemoveUserFromChannelResponseEvent(
          urlIndex: widget.urlIndex,
          map: {
            "roomId": widget.roomId,
            "userId": users.sId,
          }),
    );
  }

  void showFileVideoSelectionDialog() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: true,
      isDismissible: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimens.space12.r),
      ),
      backgroundColor: Color(0xff181A20),
      builder: (BuildContext context) {
        return ChannelFileVideoSelectionDialog(
          onFileSelectTap: () async {
            Utils.closeActivity(context);
            FilePickerResult? result = await FilePicker.platform.pickFiles();

            if (result != null) {
              PlatformFile? file = result.files.first;
              print(file.name);
              print(file.bytes);
              print(file.size);
              print(file.extension);
              print(file.path);
              showFileDescriptionDialog(file.path!);
            } else {
              // User canceled the picker
            }
          },
          onLiveVideoSelectTap: () {
            Utils.closeActivity(context);
            Utils.openActivity(
              context,
              VideoRecordPage(
                onVideoRecorded: (videoPath) {
                  showFileDescriptionDialog(videoPath);
                },
              ),
            );
          },
        );
      },
    );
  }

  void showFileDescriptionDialog(String filePath) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: true,
      isDismissible: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimens.space12.r),
      ),
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return FileDescriptionDialog(
          filePath: filePath,
          onUpload: (fileName, fileDescription) {
            Utils.closeActivity(context);
            uploadFile(filePath, fileName, fileDescription);
          },
        );
      },
    );
  }

  void showDeleteMessageDialog(String messageId, int index) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: true,
      isDismissible: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimens.space12.r),
      ),
      backgroundColor: Color(0xff181A20),
      builder: (BuildContext context) {
        return DeleteMessageDialog(
          onMessageDelete: () {
            Utils.closeActivity(context);
            deleteMessage(messageId, index);
          },
        );
      },
    );
  }

  void showChannelSettingDialog() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: true,
      isDismissible: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimens.space12.r),
      ),
      backgroundColor: Color(0xff181A20),
      builder: (BuildContext context) {
        return ChannelSettingDialog(
          onLeaveChannel: () {
            Utils.closeActivity(context);
            leaveChannel();
          },
          onDeleteChannel: () {
            Utils.closeActivity(context);
            deleteChannel();
          },
          onInviteUser: () {
            Utils.closeActivity(context);
            getUsersList();
          },
          onRemoveUser: () {
            Utils.closeActivity(context);
            getMembersList(false);
          },
        );
      },
    );
  }

  void showUsersListDialog() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: true,
      isDismissible: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimens.space12.r),
      ),
      backgroundColor: Color(0xff181A20),
      builder: (BuildContext context) {
        return UsersListDialog(
          listUsers: listUsers,
          onInviteUser: (user) {
            Utils.closeActivity(context);
            addUserToChannel(user);
          },
        );
      },
    );
  }

  void showMembersListDialog() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: true,
      isDismissible: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimens.space12.r),
      ),
      backgroundColor: Color(0xff181A20),
      builder: (BuildContext context) {
        return MembersListDialog(
          listMembers: listMembers,
          onRemoveUser: (user) {
            Utils.closeActivity(context);
            removeUserFromChannel(user);
          },
        );
      },
    );
  }
}

class _ControlsOverlay extends StatelessWidget {
  const _ControlsOverlay({Key? key, required this.controller})
      : super(key: key);

  static const _examplePlaybackRates = [
    0.25,
    0.5,
    1.0,
    1.5,
    2.0,
    3.0,
    5.0,
    10.0,
  ];

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: Duration(milliseconds: 50),
          reverseDuration: Duration(milliseconds: 200),
          child: controller.value.isPlaying
              ? SizedBox.shrink()
              : Container(
                  color: Colors.black26,
                  child: Center(
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 100.0,
                      semanticLabel: 'Play',
                    ),
                  ),
                ),
        ),
        GestureDetector(
          onTap: () {
            controller.value.isPlaying ? controller.pause() : controller.play();
          },
        ),
        Align(
          alignment: Alignment.topRight,
          child: PopupMenuButton<double>(
            initialValue: controller.value.playbackSpeed,
            tooltip: 'Playback speed',
            onSelected: (speed) {
              controller.setPlaybackSpeed(speed);
            },
            itemBuilder: (context) {
              return [
                for (final speed in _examplePlaybackRates)
                  PopupMenuItem(
                    value: speed,
                    child: Text('${speed}x'),
                  )
              ];
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                // Using less vertical padding as the text is also longer
                // horizontally, so it feels like it would need more spacing
                // horizontally (matching the aspect ratio of the video).
                vertical: 12,
                horizontal: 16,
              ),
              child: Text('${controller.value.playbackSpeed}x'),
            ),
          ),
        ),
      ],
    );
  }
}
