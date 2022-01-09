import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:live/bloc/chat_video_only_bloc/ChatChannelVideoOnlySubscriptionBloc.dart';
import 'package:live/bloc/chat_video_only_bloc/ChatChannelVideoOnlySubscriptionEvent.dart';
import 'package:live/bloc/chat_video_only_bloc/ChatChannelVideoOnlySubscriptionState.dart';
import 'package:live/config/Config.dart';
import 'package:live/config/CustomColors.dart';
import 'package:live/constant/Constants.dart';
import 'package:live/constant/Dimens.dart';
import 'package:live/ui/common/AuthAppBar.dart';
import 'package:live/ui/common/CustomImageHolder.dart';
import 'package:live/ui/common/dialog/ChannelFileVideoSelectionDialog.dart';
import 'package:live/ui/common/dialog/ChannelSettingDialog.dart';
import 'package:live/ui/common/dialog/DeleteMessageDialog.dart';
import 'package:live/ui/common/dialog/FileDescriptionDialog.dart';
import 'package:live/ui/common/dialog/MembersListDialog.dart';
import 'package:live/ui/common/dialog/UsersListDialog.dart';
import 'package:live/ui/send_message/SendMessagePage.dart';
import 'package:live/ui/video_record/VideoRecordPage.dart';
import 'package:live/utils/Prefs.dart';
import 'package:live/utils/Utils.dart';
import 'package:live/viewobject/holder/ReactionsRequest.dart';
import 'package:live/viewobject/model/admins/ResponseAdmin.dart';
import 'package:live/viewobject/model/chatMessageResponse/ChatChannelMessageResponse.dart';
import 'package:live/viewobject/model/createChannel/ChatCreateChannelResponse.dart';
import 'package:live/viewobject/model/membersList/MemberListResponse.dart';
import 'package:live/viewobject/model/usersList/UsersListResponse.dart';
import 'package:lottie/lottie.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:video_player/video_player.dart';

class ChatVideoOnlyPage extends StatefulWidget {
  final int urlIndex;
  final String roomId;
  final String roomName;
  final String roomDescription;
  final String serverUrl;
  final bool isPrivate;
  final List<Channel> channelsList;
  final VoidCallback onLeaveChannel;
  final VoidCallback onDeleteChannel;
  const ChatVideoOnlyPage({
    Key? key,
    required this.urlIndex,
    required this.roomId,
    required this.roomName,
    required this.roomDescription,
    required this.channelsList,
    required this.isPrivate,
    required this.serverUrl,
    required this.onLeaveChannel,
    required this.onDeleteChannel,
  }) : super(key: key);

  @override
  ChatVideoOnlyPageState createState() => ChatVideoOnlyPageState();
}

class ChatVideoOnlyPageState extends State<ChatVideoOnlyPage>
    with AutomaticKeepAliveClientMixin {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  TextEditingController chatTextController = TextEditingController();
  ChatChannelVideoOnlySubscriptionBloc chatChannelSubscriptionBloc =
      ChatChannelVideoOnlySubscriptionBloc(
          InitialChatChannelVideoOnlySubscriptionState());
  CarouselController scrollController = CarouselController();
  PanelController panelController = PanelController();
  bool isLoading = true;
  String userId = "";
  bool isCTA = false;
  Channel? ctaChannel;
  List<Messages>? listVideoMessages = [];
  List<Users> listUsers = [];
  List<Members> listMembers = [];
  List<bool> listIsPaused = [];
  List<VideoPlayerController>? listVideoController = [];

  bool isMuted = true;

  String ctaRoomId = "";
  String ctaRoomName = "";
  String ctaRoomDescription = "";

  late ResponseAdmin responseAdmin;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    chatChannelSubscriptionBloc =
        BlocProvider.of<ChatChannelVideoOnlySubscriptionBloc>(context,
            listen: false);

    userId =
        Prefs.getStringList(Const.VALUE_HOLDER_CHAT_USER_ID)![widget.urlIndex];

    chatChannelSubscriptionBloc
        .subscriptionConnect(Config.listSocketUrl[widget.urlIndex]);
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
              "id": "WSawJYqDBeDM5J6ML",
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
              "id": "WSawJYqDBeDM5J6ML",
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
          } else if (map["msg"] == "changed" &&
              map["collection"] == "stream-room-messages" &&
              map["fields"]["eventName"] == widget.roomId) {
            Utils.customPrint(json.encode(map["fields"]));
            Map<String, dynamic> resultHistory = map["fields"];
            resultHistory['args'].forEach((v) {
              Messages message = Messages.fromJson(v);
              if (Messages.fromJson(v).u!.sId ==
                  Prefs.getStringList(
                      Const.VALUE_HOLDER_CHAT_USER_ID)![widget.urlIndex]) {
                chatTextController.text = "";
              }
              if (listVideoMessages!.indexWhere((element) =>
                      element.sId != null && element.sId == message.sId) ==
                  -1) {
                if (message.fileObject != null) {
                  List<String> split = message.fileObject!.type!.split("/");
                  if (split[0].toLowerCase() == "video") {
                    listVideoMessages!.insert(0, Messages.fromJson(v));
                    VideoPlayerController videoPlayerController =
                        VideoPlayerController.network(
                      Config.listChatUrl[widget.urlIndex] +
                          message.attachments![0].videoUrl!,
                      videoPlayerOptions: VideoPlayerOptions(
                        mixWithOthers: false,
                      ),
                    )..initialize().then((_) {
                            // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
                            setState(() {});
                          });
                    videoPlayerController.setLooping(false);
                    videoPlayerController.setVolume(isMuted ? 0 : 1);
                    listVideoController!.insert(0, videoPlayerController);
                    listIsPaused.insert(0, false);
                  }
                }
              } else {
                int updateIndex = listVideoMessages!.indexWhere((element) =>
                    element.sId != null && element.sId == message.sId);
                listVideoMessages![updateIndex] = message;
              }
            });
            if (mounted) {
              setState(() {});
            }
          }
        } else if (map.containsKey("msg") && map.containsKey("result")) {
          Utils.customPrint(json.encode(map["result"]));
          Map<String, dynamic> dump = map["result"];
          if (map["msg"] == "result" && dump.containsKey("messages")) {
            Map<String, dynamic> resultHistory = map["result"];
            resultHistory['messages'].forEach((v) {
              Messages dump = Messages.fromJson(v);
              if (dump.fileObject != null) {
                List<String> split = dump.fileObject!.type!.split("/");
                if (split[0].toLowerCase() == "video") {
                  listVideoMessages!.add(dump);
                  VideoPlayerController videoPlayerController =
                      VideoPlayerController.network(
                    Config.listChatUrl[widget.urlIndex] +
                        dump.attachments![0].videoUrl!,
                    videoPlayerOptions: VideoPlayerOptions(
                      mixWithOthers: false,
                    ),
                  )..initialize().then((_) {
                          // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
                          setState(() {});
                        });
                  videoPlayerController.setLooping(false);
                  videoPlayerController.setVolume(isMuted ? 0 : 1);
                  listVideoController!.add(
                    videoPlayerController,
                  );
                  listVideoController![0].play();
                  listIsPaused.add(false);
                }
              }
            });
            isLoading = false;
            setState(() {});
            Map listenNewMessage = {
              "msg": "sub",
              "id": "WSawJYqDBeDM5J6ML",
              "name": "stream-room-messages",
              "params": [
                widget.roomId,
                false.toString(),
              ]
            };
            chatChannelSubscriptionBloc.webSocketChannel!.sink
                .add(jsonEncode(listenNewMessage));
          }
        }
      }
    });

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if (panelController.isPanelClosed) {
        Future.delayed(Duration(seconds: 3)).then((value) {
          panelController.open();
        });
      }
    });
  }

  @override
  void dispose() {
    chatTextController.dispose();
    listVideoController!.forEach((element) {
      element.pause();
      element.removeListener(() {});
      element.dispose();
    });
    super.dispose();
  }

  Future<bool> _requestPop() {
    Utils.closeActivity(context);
    return Future<bool>.value(false);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // david+figma@peeq.live
    // spay_rik!scal4TUH

    return WillPopScope(
      onWillPop: _requestPop,
      child: BlocConsumer(
        bloc: chatChannelSubscriptionBloc,
        listener: (context, state) {
          print("this is state $state");
          if (state is ChatChannelVideoOnlySubscriptionProgressState) {
            isLoading = true;
          } else if (state is ChatChannelVideoOnlyLeaveChannelSuccessState) {
            isLoading = false;
            widget.onLeaveChannel();
          } else if (state is ChatChannelVideoOnlyDeleteChannelSuccessState) {
            isLoading = false;
            widget.onDeleteChannel();
          } else if (state is ChatChannelVideoOnlyUploadFileSuccessState) {
            isLoading = false;
          } else if (state is ChatChannelVideoOnlySubscriptionErrorState) {
            isLoading = false;
          } else if (state is ChatChannelVideoOnlyUsersListSuccessState) {
            isLoading = false;
            listUsers = state.usersListResponse!.users!;
            String dump = "";
            String admin = "";
            if (widget.urlIndex == 0) {
              admin = responseAdmin.result!.data!.cHAT![0].userName!;
            } else if (widget.urlIndex == 1) {
              admin = responseAdmin.result!.data!.hEALTHCARE![0].userName!;
            } else if (widget.urlIndex == 2) {
              admin = responseAdmin.result!.data!.vIRANI![0].userName!;
            } else if (widget.urlIndex == 3) {
              admin = responseAdmin.result!.data!.pEEQYIWU![0].userName!;
            }

            for (int i = 0; i < listUsers.length; i++) {
              if (listUsers[i]
                  .username!
                  .toLowerCase()
                  .contains(admin.toLowerCase())) {
                dump = listUsers[i].sId!;
                break;
              }
            }
            if (dump.isNotEmpty) {
              chatChannelSubscriptionBloc.add(
                ChatChannelAddUserToChannelResponseEvent(
                  urlIndex: widget.urlIndex,
                  map: {
                    "roomId": ctaRoomId,
                    "userId": dump,
                  },
                ),
              );
            } else {
              chatChannelSubscriptionBloc.add(
                ChatChannelMakePrivateEvent(
                  chatUrl: Config.listChatUrl[widget.urlIndex],
                  authToken: Prefs.getStringList(
                      Const.VALUE_HOLDER_CHAT_AUTH_TOKEN)![widget.urlIndex],
                  userId: Prefs.getStringList(
                      Const.VALUE_HOLDER_CHAT_USER_ID)![widget.urlIndex],
                  map: {
                    "roomId": ctaRoomId,
                    "roomName": ctaRoomName,
                    "type": "p"
                  },
                ),
              );
            }
          } else if (state
              is ChatChannelVideoOnlyCreateVideoCTAChannelSuccessState) {
            ctaRoomId = state.chatCreateChannelResponse!.channel!.sId!;
            ctaRoomName = state.chatCreateChannelResponse!.channel!.name!;
            ctaRoomDescription = Prefs.getString(Const.VALUE_HOLDER_USER_NAME)!
                    .split(" ")[0]
                    .trim() +
                " Video Shopping";
            chatChannelSubscriptionBloc.add(
              ChatChannelSetDescriptionResponseEvent(
                chatUrl: Config.listChatUrl[widget.urlIndex],
                authToken: Prefs.getStringList(
                    Const.VALUE_HOLDER_CHAT_AUTH_TOKEN)![widget.urlIndex],
                userId: Prefs.getStringList(
                    Const.VALUE_HOLDER_CHAT_USER_ID)![widget.urlIndex],
                map: {
                  "roomId": state.chatCreateChannelResponse!.channel!.sId!,
                  "description": Prefs.getString(Const.VALUE_HOLDER_USER_NAME)!
                          .split(" ")[0]
                          .trim() +
                      " Video Shopping",
                },
              ),
            );
          } else if (state is ChatChannelVideoOnlySetDescriptionSuccessState) {
            chatChannelSubscriptionBloc.add(
              AdminUserResponseEvent(),
            );
          } else if (state is GetAdminsSuccessState) {
            responseAdmin = state.responseAdmin;
            chatChannelSubscriptionBloc.add(
              ChatChannelUsersListResponseEvent(
                urlIndex: widget.urlIndex,
              ),
            );
          } else if (state is ChatChannelVideoOnlyMakePrivateSuccessState) {
            isLoading = false;
            Utils.openActivity(
              context,
              SendMessagePage(
                urlIndex: widget.urlIndex,
                roomId: ctaRoomId,
                roomName: ctaRoomName,
                isPrivate: true,
                roomDescription: ctaRoomDescription.isNotEmpty
                    ? ctaRoomDescription.replaceAll("_", " ")
                    : ctaRoomName.replaceAll("_", " "),
                onLeaveChannel: () {},
                onDeleteChannel: () {},
              ),
            );
          } else if (state
              is ChatChannelVideoOnlyAddUserToChannelSuccessState) {
            chatChannelSubscriptionBloc.add(
              ChatChannelMakePrivateEvent(
                chatUrl: Config.listChatUrl[widget.urlIndex],
                authToken: Prefs.getStringList(
                    Const.VALUE_HOLDER_CHAT_AUTH_TOKEN)![widget.urlIndex],
                userId: Prefs.getStringList(
                    Const.VALUE_HOLDER_CHAT_USER_ID)![widget.urlIndex],
                map: {
                  "roomId": ctaRoomId,
                  "roomName": ctaRoomName,
                  "type": "p"
                },
              ),
            );
          } else if (state is ChatChannelVideoOnlySetReactionSuccessState) {
            isLoading = false;
          } else if (state is ChatChannelVideoOnlyMembersListSuccessState) {
            isLoading = false;
            listMembers = state.membersListResponse!.members!;
            showMembersListDialog();
          } else if (state
              is ChatChannelVideoOnlyRemoveUserFromChannelSuccessState) {
            isLoading = false;
          }
        },
        builder: (context, state) {
          return SafeArea(
              child: Stack(
            alignment: Alignment.center,
            children: [
              Scaffold(
                key: _scaffoldKey,
                backgroundColor: CustomColors.background_bg01,
                resizeToAvoidBottomInset: true,
                body: Container(
                  color: CustomColors.background_bg01,
                  alignment: Alignment.center,
                  margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      listVideoMessages != null &&
                              listVideoMessages!.length != 0
                          ? CarouselSlider.builder(
                              carouselController: scrollController,
                              itemCount: listVideoMessages!.length,
                              options: CarouselOptions(
                                aspectRatio: 1,
                                enlargeCenterPage: true,
                                height: Utils.getScreenHeight(context),
                                scrollDirection: Axis.vertical,
                                enlargeStrategy:
                                    CenterPageEnlargeStrategy.scale,
                                enableInfiniteScroll: false,
                                viewportFraction: 1,
                                autoPlay: false,
                                reverse: false,
                                onPageChanged: (index, reason) {
                                  print("Current index " + index.toString());
                                  if (index == 0) {
                                    listVideoController![index + 1].pause();
                                    if (isMuted) {
                                      listVideoController![index].setVolume(0);
                                    } else {
                                      listVideoController![index].setVolume(1);
                                    }
                                    if (!listIsPaused[index]) {
                                      listVideoController![index].play();
                                    }
                                    listVideoController![index].addListener(() {
                                      if (mounted) {
                                        setState(() {});
                                      }
                                    });
                                    setState(() {});
                                  } else if (index ==
                                      listVideoMessages!.length - 1) {
                                    listVideoController![index - 1].pause();
                                    if (isMuted) {
                                      listVideoController![index].setVolume(0);
                                    } else {
                                      listVideoController![index].setVolume(1);
                                    }
                                    if (!listIsPaused[index]) {
                                      listVideoController![index].play();
                                    }
                                    listVideoController![index].addListener(() {
                                      if (mounted) {
                                        setState(() {});
                                      }
                                    });
                                    if (mounted) {
                                      setState(() {});
                                    }
                                  } else {
                                    listVideoController![index - 1].pause();
                                    listVideoController![index + 1].pause();
                                    if (isMuted) {
                                      listVideoController![index].setVolume(0);
                                    } else {
                                      listVideoController![index].setVolume(1);
                                    }
                                    if (!listIsPaused[index]) {
                                      listVideoController![index].play();
                                    }
                                    listVideoController![index].addListener(() {
                                      if (mounted) {
                                        setState(() {});
                                      }
                                    });
                                    if (mounted) {
                                      setState(() {});
                                    }
                                  }
                                },
                              ),
                              itemBuilder: (ctx, index, realIdx) {
                                return Container(
                                  alignment: Alignment.center,
                                  height: Utils.getScreenHeight(context),
                                  width: Utils.getScreenWidth(context),
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
                                      AspectRatio(
                                        aspectRatio: listVideoController![index]
                                                    .value
                                                    .size
                                                    .aspectRatio <
                                                0
                                            ? listVideoController![index]
                                                .value
                                                .size
                                                .aspectRatio
                                            : listVideoController![index]
                                                .value
                                                .aspectRatio,
                                        child: VideoPlayer(
                                            listVideoController![index]),
                                      ),
                                      Container(
                                        alignment: Alignment.bottomLeft,
                                        height: Utils.getScreenHeight(context),
                                        width: Utils.getScreenWidth(context),
                                        margin: EdgeInsets.fromLTRB(
                                            Dimens.space20.w,
                                            Dimens.space0.h,
                                            Dimens.space20.w,
                                            Dimens.space100.h),
                                        padding: EdgeInsets.fromLTRB(
                                            Dimens.space0.w,
                                            Dimens.space0.h,
                                            Dimens.space0.w,
                                            Dimens.space0.h),
                                        child: Text(
                                          listVideoMessages![index]
                                                          .attachments![0]
                                                          .description !=
                                                      null &&
                                                  listVideoMessages![index]
                                                      .attachments![0]
                                                      .description!
                                                      .isNotEmpty
                                              ? listVideoMessages![index]
                                                  .attachments![0]
                                                  .description!
                                              : widget.serverUrl,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2!
                                              .copyWith(
                                                color: Colors.white,
                                                fontFamily:
                                                    Config.PoppinsSemiBold,
                                                fontSize: Dimens.space18.sp,
                                                fontWeight: FontWeight.normal,
                                                fontStyle: FontStyle.normal,
                                              ),
                                        ),
                                      ),
                                      Positioned(
                                        left: 0,
                                        right: 0,
                                        bottom: 0,
                                        child: VideoProgressIndicator(
                                          listVideoController![index],
                                          allowScrubbing: true,
                                          colors: VideoProgressColors(
                                            backgroundColor: Colors.white,
                                            playedColor: Colors.green,
                                            bufferedColor: Colors.blue,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        left: 0,
                                        top: 0,
                                        right: 0,
                                        child: RoundedNetworkImageHolder(
                                          width: Dimens.space40,
                                          height: Dimens.space40,
                                          boxFit: BoxFit.cover,
                                          containerAlignment: Alignment.center,
                                          iconUrl: listVideoController![index]
                                                  .value
                                                  .isPlaying
                                              ? FontAwesomeIcons.pause
                                              : FontAwesomeIcons.play,
                                          iconColor: Colors.white,
                                          iconSize: Dimens.space25,
                                          boxDecorationColor:
                                              Colors.transparent,
                                          outerCorner: Dimens.space0,
                                          innerCorner: Dimens.space0,
                                          imageUrl: "",
                                          onTap: () {
                                            if (listVideoController![index]
                                                .value
                                                .isPlaying) {
                                              listVideoController![index]
                                                  .pause();
                                              listIsPaused[index] = true;
                                            } else {
                                              listVideoController![index]
                                                  .play();
                                              listIsPaused[index] = false;
                                            }
                                            setState(() {});
                                          },
                                        ),
                                      ),
                                      Positioned(
                                        right: 0,
                                        top: 0,
                                        bottom: 0,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                Container(
                                                  height: Dimens.space48.h,
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
                                                  child: PlainAssetImageHolder(
                                                    height: Dimens.space48,
                                                    width: Dimens.space48,
                                                    assetWidth: Dimens.space48,
                                                    assetHeight: Dimens.space48,
                                                    assetUrl:
                                                        "assets/images/icon_home_image_border_oval.png",
                                                    outerCorner: Dimens.space0,
                                                    innerCorner: Dimens.space0,
                                                    iconSize: Dimens.space0,
                                                    iconUrl: Icons
                                                        .camera_alt_outlined,
                                                    iconColor:
                                                        Colors.transparent,
                                                    boxDecorationColor:
                                                        Colors.transparent,
                                                    boxFit: BoxFit.contain,
                                                    onTap: () {},
                                                  ),
                                                ),
                                                Container(
                                                  height: Dimens.space40.h,
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
                                                  child: PlainAssetImageHolder(
                                                    height: Dimens.space40,
                                                    width: Dimens.space40,
                                                    assetWidth: Dimens.space40,
                                                    assetHeight: Dimens.space40,
                                                    assetUrl:
                                                        "assets/images/icon_profile.png",
                                                    outerCorner: Dimens.space0,
                                                    innerCorner: Dimens.space0,
                                                    iconSize: Dimens.space0,
                                                    iconUrl: Icons
                                                        .camera_alt_outlined,
                                                    iconColor:
                                                        Colors.transparent,
                                                    boxDecorationColor:
                                                        Colors.transparent,
                                                    boxFit: BoxFit.contain,
                                                    onTap: () {},
                                                  ),
                                                ),
                                                Container(
                                                  height: Dimens.space48.h,
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
                                                  child:
                                                      RoundedFileImageHolderWithText(
                                                    height: Dimens.space42,
                                                    width: Dimens.space42,
                                                    textColor: Colors.white,
                                                    fontFamily:
                                                        Config.PoppinsExtraBold,
                                                    text: listVideoMessages![
                                                                        index]
                                                                    .u !=
                                                                null &&
                                                            listVideoMessages![
                                                                        index]
                                                                    .u!
                                                                    .username !=
                                                                null
                                                        ? listVideoMessages![
                                                                index]
                                                            .u!
                                                            .username![0]
                                                            .toUpperCase()
                                                        : "Not Available",
                                                    fileUrl: '',
                                                    outerCorner: Dimens.space20,
                                                    innerCorner: Dimens.space20,
                                                    iconSize: Dimens.space0,
                                                    iconUrl: Icons
                                                        .camera_alt_outlined,
                                                    iconColor:
                                                        Colors.transparent,
                                                    boxDecorationColor:
                                                        Colors.transparent,
                                                    boxFit: BoxFit.contain,
                                                    onTap: () {},
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Container(
                                              height: Dimens.space48.h,
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
                                                width: Dimens.space40,
                                                height: Dimens.space40,
                                                boxFit: BoxFit.cover,
                                                containerAlignment:
                                                    Alignment.center,
                                                iconUrl: FontAwesomeIcons.heart,
                                                iconColor: listVideoMessages![
                                                                    index]
                                                                .reactions !=
                                                            null &&
                                                        listVideoMessages![
                                                                    index]
                                                                .reactions!
                                                                .heart !=
                                                            null &&
                                                        listVideoMessages![
                                                                index]
                                                            .reactions!
                                                            .heart!
                                                            .usernames!
                                                            .contains(Prefs
                                                                .getString(Const
                                                                    .VALUE_HOLDER_USERNAME))
                                                    ? Colors.red
                                                    : Colors.white,
                                                iconSize: Dimens.space30,
                                                boxDecorationColor:
                                                    Colors.transparent,
                                                outerCorner: Dimens.space0,
                                                innerCorner: Dimens.space0,
                                                imageUrl: "",
                                                onTap: () {
                                                  sendReaction(
                                                      listVideoMessages![index]
                                                          .sId!,
                                                      listVideoMessages![index]
                                                                      .reactions !=
                                                                  null &&
                                                              listVideoMessages![
                                                                          index]
                                                                      .reactions!
                                                                      .heart !=
                                                                  null &&
                                                              listVideoMessages![
                                                                      index]
                                                                  .reactions!
                                                                  .heart!
                                                                  .usernames!
                                                                  .contains(Prefs
                                                                      .getString(
                                                                          Const
                                                                              .VALUE_HOLDER_USERNAME))
                                                          ? false
                                                          : true);
                                                },
                                              ),
                                            ),
                                            Container(
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
                                              child: Text(
                                                listVideoMessages![index]
                                                                .reactions !=
                                                            null &&
                                                        listVideoMessages![
                                                                    index]
                                                                .reactions!
                                                                .heart !=
                                                            null
                                                    ? listVideoMessages![index]
                                                        .reactions!
                                                        .heart!
                                                        .usernames!
                                                        .length
                                                        .toString()
                                                    : "0",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText2!
                                                    .copyWith(
                                                      color: Colors.white,
                                                      fontFamily: Config
                                                          .PoppinsSemiBold,
                                                      fontSize:
                                                          Dimens.space12.sp,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontStyle:
                                                          FontStyle.normal,
                                                    ),
                                              ),
                                            ),
                                            Container(
                                              height: Dimens.space48.h,
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
                                                width: Dimens.space40,
                                                height: Dimens.space40,
                                                boxFit: BoxFit.cover,
                                                containerAlignment:
                                                    Alignment.center,
                                                iconUrl: FontAwesomeIcons.share,
                                                iconColor: Colors.white,
                                                iconSize: Dimens.space30,
                                                boxDecorationColor:
                                                    Colors.transparent,
                                                outerCorner: Dimens.space0,
                                                innerCorner: Dimens.space0,
                                                imageUrl: "",
                                                onTap: () {
                                                  Share.share(
                                                      "https://www.peeq.live/");
                                                },
                                              ),
                                            ),
                                            Container(
                                              height: Dimens.space48.h,
                                              alignment: Alignment.topCenter,
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
                                                width: Dimens.space40,
                                                height: Dimens.space40,
                                                boxFit: BoxFit.cover,
                                                containerAlignment:
                                                    Alignment.center,
                                                iconUrl:
                                                    listVideoController![index]
                                                                .value
                                                                .volume ==
                                                            0
                                                        ? Icons.volume_off
                                                        : Icons.volume_up,
                                                iconColor: Colors.white,
                                                iconSize: Dimens.space30,
                                                boxDecorationColor:
                                                    Colors.transparent,
                                                outerCorner: Dimens.space300,
                                                innerCorner: Dimens.space300,
                                                imageUrl: "",
                                                onTap: () {
                                                  if (isMuted) {
                                                    listVideoController![index]
                                                        .setVolume(1);
                                                    isMuted = false;
                                                  } else {
                                                    listVideoController![index]
                                                        .setVolume(0);
                                                    isMuted = true;
                                                  }
                                                  setState(() {});
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            )
                          : Container(),
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: customAppBar(
                          context,
                          leading: true,
                          centerTitle: true,
                          title: widget.roomDescription.isNotEmpty
                              ? widget.roomDescription
                              : widget.roomName,
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                      SlidingUpPanel(
                        maxHeight: Dimens.space300.h,
                        minHeight: Dimens.space20.h,
                        parallaxEnabled: true,
                        parallaxOffset: .5,
                        body: Container(),
                        controller: panelController,
                        panelBuilder: (sc) {
                          return Container(
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
                            decoration: BoxDecoration(
                              color: Color(0xff122730),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(Dimens.space12.r),
                                topRight: Radius.circular(Dimens.space12.r),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Container(
                                  width: Dimens.space35.w,
                                  height: Dimens.space5.h,
                                  margin: EdgeInsets.fromLTRB(
                                      Dimens.space0.w,
                                      Dimens.space8.h,
                                      Dimens.space0.w,
                                      Dimens.space8.h),
                                  padding: EdgeInsets.fromLTRB(
                                      Dimens.space0.w,
                                      Dimens.space0.h,
                                      Dimens.space0.w,
                                      Dimens.space0.h),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Color(0xff223344),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(Dimens.space100.r),
                                    ),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  margin: EdgeInsets.fromLTRB(
                                      Dimens.space5.w,
                                      Dimens.space10.h,
                                      Dimens.space5.w,
                                      Dimens.space10.h),
                                  padding: EdgeInsets.fromLTRB(
                                      Dimens.space0.w,
                                      Dimens.space10.h,
                                      Dimens.space0.w,
                                      Dimens.space10.h),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Container(
                                        height: Dimens.space48.h,
                                        alignment: Alignment.centerLeft,
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
                                              height: Dimens.space48.h,
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
                                              child: PlainAssetImageHolder(
                                                height: Dimens.space48,
                                                width: Dimens.space48,
                                                assetWidth: Dimens.space48,
                                                assetHeight: Dimens.space48,
                                                assetUrl:
                                                    "assets/images/icon_home_image_border_oval.png",
                                                outerCorner: Dimens.space0,
                                                innerCorner: Dimens.space0,
                                                iconSize: Dimens.space0,
                                                iconUrl:
                                                    Icons.camera_alt_outlined,
                                                iconColor: Colors.transparent,
                                                boxDecorationColor:
                                                    Colors.transparent,
                                                boxFit: BoxFit.contain,
                                                onTap: () {},
                                              ),
                                            ),
                                            Container(
                                              height: Dimens.space40.h,
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
                                              child: PlainAssetImageHolder(
                                                height: Dimens.space40,
                                                width: Dimens.space40,
                                                assetWidth: Dimens.space40,
                                                assetHeight: Dimens.space40,
                                                assetUrl:
                                                    "assets/images/icon_profile.png",
                                                outerCorner: Dimens.space0,
                                                innerCorner: Dimens.space0,
                                                iconSize: Dimens.space0,
                                                iconUrl:
                                                    Icons.camera_alt_outlined,
                                                iconColor: Colors.transparent,
                                                boxDecorationColor:
                                                    Colors.transparent,
                                                boxFit: BoxFit.contain,
                                                onTap: () {},
                                              ),
                                            ),
                                            Container(
                                              height: Dimens.space48.h,
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
                                              child:
                                                  RoundedFileImageHolderWithText(
                                                height: Dimens.space42,
                                                width: Dimens.space42,
                                                textColor: Colors.white,
                                                fontFamily:
                                                    Config.PoppinsExtraBold,
                                                text: listVideoMessages !=
                                                            null &&
                                                        listVideoMessages!
                                                                .length !=
                                                            0 &&
                                                        listVideoMessages![0]
                                                                .u !=
                                                            null &&
                                                        listVideoMessages![0]
                                                                .u!
                                                                .username !=
                                                            null
                                                    ? listVideoMessages![0]
                                                        .u!
                                                        .username![0]
                                                        .toUpperCase()
                                                    : "Not Available",
                                                fileUrl: '',
                                                outerCorner: Dimens.space20,
                                                innerCorner: Dimens.space20,
                                                iconSize: Dimens.space0,
                                                iconUrl:
                                                    Icons.camera_alt_outlined,
                                                iconColor: Colors.transparent,
                                                boxDecorationColor:
                                                    Colors.transparent,
                                                boxFit: BoxFit.contain,
                                                onTap: () {},
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          alignment: Alignment.centerLeft,
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
                                          child: Container(
                                            alignment: Alignment.centerLeft,
                                            margin: EdgeInsets.fromLTRB(
                                                Dimens.space5.w,
                                                Dimens.space0.h,
                                                Dimens.space27.w,
                                                Dimens.space0.h),
                                            padding: EdgeInsets.fromLTRB(
                                                Dimens.space5.w,
                                                Dimens.space5.h,
                                                Dimens.space5.w,
                                                Dimens.space5.h),
                                            constraints: BoxConstraints(
                                              maxWidth:
                                                  Utils.getScreenWidth(context),
                                              minWidth:
                                                  Utils.getScreenWidth(context),
                                            ),
                                            decoration: BoxDecoration(
                                              color: Color(0xff5E6272),
                                              shape: BoxShape.rectangle,
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(
                                                    Dimens.space0.r),
                                                topRight: Radius.circular(
                                                    Dimens.space12.r),
                                                bottomLeft: Radius.circular(
                                                    Dimens.space12.r),
                                                bottomRight: Radius.circular(
                                                    Dimens.space12.r),
                                              ),
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  margin: EdgeInsets.fromLTRB(
                                                      Dimens.space5.w,
                                                      Dimens.space5.h,
                                                      Dimens.space5.w,
                                                      Dimens.space5.h),
                                                  padding: EdgeInsets.fromLTRB(
                                                      Dimens.space0.w,
                                                      Dimens.space0.h,
                                                      Dimens.space0.w,
                                                      Dimens.space0.h),
                                                  child: Text(
                                                    widget.urlIndex == 0
                                                        ? "Hi ${Prefs.getString(Const.VALUE_HOLDER_USER_NAME)}, would you like to do a quick video shopping with Peeq?"
                                                        : widget.urlIndex == 1
                                                            ? "Hi ${Prefs.getString(Const.VALUE_HOLDER_USER_NAME)}, would you like to do a quick video shopping with Virani?"
                                                            : widget.urlIndex ==
                                                                    2
                                                                ? "Hi ${Prefs.getString(Const.VALUE_HOLDER_USER_NAME)}, would you like to do a free Video consultation with Dr Niranjan?"
                                                                : "Hi ${Prefs.getString(Const.VALUE_HOLDER_USER_NAME)}, would you like to do a live video shopping with Nicholas?",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText1!
                                                        .copyWith(
                                                          color: Colors.white,
                                                          fontFamily: Config
                                                              .InterRegular,
                                                          fontSize:
                                                              Dimens.space14.sp,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          fontStyle:
                                                              FontStyle.normal,
                                                        ),
                                                  ),
                                                ),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Container(
                                                      alignment:
                                                          Alignment.center,
                                                      margin:
                                                          EdgeInsets.fromLTRB(
                                                              Dimens.space5.w,
                                                              Dimens.space0.h,
                                                              Dimens.space5.w,
                                                              Dimens.space0.h),
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              Dimens.space0.w,
                                                              Dimens.space0.h,
                                                              Dimens.space0.w,
                                                              Dimens.space0.h),
                                                      child: Text(
                                                        listVideoMessages !=
                                                                    null &&
                                                                listVideoMessages!.length !=
                                                                    0 &&
                                                                listVideoMessages![
                                                                            0]
                                                                        .ts !=
                                                                    null &&
                                                                listVideoMessages![
                                                                            0]
                                                                        .ts!
                                                                        .date !=
                                                                    null
                                                            ? Utils.convertCallTime(
                                                                DateTime.fromMillisecondsSinceEpoch(
                                                                        listVideoMessages![0]
                                                                            .ts!
                                                                            .date!)
                                                                    .toString(),
                                                                'yyyy-MM-ddThh:mm:ss.SSSSSS',
                                                                "hh:mm a")
                                                            : "Not Available",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyText1!
                                                            .copyWith(
                                                              color:
                                                                  Colors.white,
                                                              fontFamily: Config
                                                                  .InterRegular,
                                                              fontSize: Dimens
                                                                  .space14.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              fontStyle:
                                                                  FontStyle
                                                                      .normal,
                                                            ),
                                                      ),
                                                    ),
                                                    Container(
                                                      alignment:
                                                          Alignment.center,
                                                      margin:
                                                          EdgeInsets.fromLTRB(
                                                              Dimens.space5.w,
                                                              Dimens.space0.h,
                                                              Dimens.space5.w,
                                                              Dimens.space0.h),
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              Dimens.space0.w,
                                                              Dimens.space0.h,
                                                              Dimens.space0.w,
                                                              Dimens.space0.h),
                                                      child: Text(
                                                        listVideoMessages !=
                                                                    null &&
                                                                listVideoMessages!.length !=
                                                                    0 &&
                                                                listVideoMessages![
                                                                            0]
                                                                        .ts !=
                                                                    null &&
                                                                listVideoMessages![
                                                                            0]
                                                                        .ts!
                                                                        .date !=
                                                                    null
                                                            ? Utils.convertMessageDateTime(
                                                                DateTime.fromMillisecondsSinceEpoch(
                                                                        listVideoMessages![0]
                                                                            .ts!
                                                                            .date!)
                                                                    .toString(),
                                                                "yyyy-MM-ddThh:mm:ss.SSSSSS",
                                                                "dd MMM")
                                                            : "Not Available",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyText1!
                                                            .copyWith(
                                                              color:
                                                                  Colors.white,
                                                              fontFamily: Config
                                                                  .InterRegular,
                                                              fontSize: Dimens
                                                                  .space14.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              fontStyle:
                                                                  FontStyle
                                                                      .normal,
                                                            ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Container(
                                      alignment: Alignment.centerRight,
                                      margin: EdgeInsets.fromLTRB(
                                          Dimens.space5.w,
                                          Dimens.space0.h,
                                          Dimens.space27.w,
                                          Dimens.space0.h),
                                      padding: EdgeInsets.fromLTRB(
                                          Dimens.space5.w,
                                          Dimens.space5.h,
                                          Dimens.space5.w,
                                          Dimens.space5.h),
                                      constraints: BoxConstraints(
                                        maxWidth: Dimens.space200.w,
                                        minWidth: Dimens.space200.w,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Color(0xffF67878),
                                        shape: BoxShape.rectangle,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(Dimens.space100.r),
                                        ),
                                      ),
                                      child: TextButton(
                                        onPressed: () {
                                          for (int i = 0;
                                              i < widget.channelsList.length;
                                              i++) {
                                            if (widget.channelsList[i].name!
                                                    .toLowerCase() ==
                                                Prefs.getString(Const
                                                            .VALUE_HOLDER_USERNAME)!
                                                        .split(" ")[0]
                                                        .trim()
                                                        .toLowerCase() +
                                                    "_Video_Shopping"
                                                        .toLowerCase()) {
                                              isCTA = true;
                                              ctaChannel =
                                                  widget.channelsList[i];
                                              setState(() {});
                                              print(isCTA.toString());
                                              break;
                                            } else {
                                              isCTA = false;
                                              setState(() {});
                                              print(isCTA.toString());
                                            }
                                          }
                                          if (isCTA) {
                                            Utils.openActivity(
                                              context,
                                              SendMessagePage(
                                                urlIndex: widget.urlIndex,
                                                roomId: ctaChannel!.sId!,
                                                roomName: ctaChannel!.name!,
                                                isPrivate: true,
                                                roomDescription: ctaChannel!
                                                        .description!.isNotEmpty
                                                    ? ctaChannel!.description!
                                                        .replaceAll("_", " ")
                                                    : ctaChannel!.name!
                                                        .replaceAll("_", " "),
                                                onLeaveChannel: () {},
                                                onDeleteChannel: () {},
                                              ),
                                            );
                                          } else {
                                            chatChannelSubscriptionBloc.add(
                                              ChatChannelCreateVideoCTAChannelResponseEvent(
                                                urlIndex: widget.urlIndex,
                                                userId: Prefs.getStringList(Const
                                                        .VALUE_HOLDER_CHAT_USER_ID)![
                                                    widget.urlIndex],
                                                authToken: Prefs.getStringList(Const
                                                        .VALUE_HOLDER_CHAT_AUTH_TOKEN)![
                                                    widget.urlIndex],
                                                map: {
                                                  "name": Prefs.getString(Const
                                                              .VALUE_HOLDER_USERNAME)!
                                                          .split(" ")[0]
                                                          .trim() +
                                                      "_Video_Shopping",
                                                  "readOnly": false,
                                                },
                                              ),
                                            );
                                          }
                                        },
                                        style: TextButton.styleFrom(
                                          backgroundColor: Colors.transparent,
                                          alignment: Alignment.center,
                                          tapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                          padding: EdgeInsets.fromLTRB(
                                              Dimens.space0.w,
                                              Dimens.space0.h,
                                              Dimens.space0.w,
                                              Dimens.space0.h),
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Container(
                                              alignment: Alignment.center,
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
                                              child: Text(
                                                "Chat with our Host",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1!
                                                    .copyWith(
                                                      color: Colors.white,
                                                      fontFamily:
                                                          Config.InterRegular,
                                                      fontSize:
                                                          Dimens.space14.sp,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontStyle:
                                                          FontStyle.normal,
                                                    ),
                                              ),
                                            ),
                                            RoundedNetworkImageHolder(
                                              width: Dimens.space20,
                                              height: Dimens.space20,
                                              boxFit: BoxFit.cover,
                                              containerAlignment:
                                                  Alignment.center,
                                              iconUrl: Icons.arrow_forward,
                                              iconColor: Colors.white,
                                              iconSize: Dimens.space20,
                                              boxDecorationColor:
                                                  Colors.transparent,
                                              outerCorner: Dimens.space0,
                                              innerCorner: Dimens.space0,
                                              imageUrl: "",
                                              onTap: () {},
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Expanded(
                                  child: Container(),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  height: Dimens.space80.h,
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
                                    color: Color(0xff262A34),
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(Dimens.space0.r),
                                      topRight:
                                          Radius.circular(Dimens.space0.r),
                                      bottomLeft:
                                          Radius.circular(Dimens.space0.r),
                                      bottomRight:
                                          Radius.circular(Dimens.space0.r),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                                    Dimens.space12.w)),
                                          ),
                                          child: TextField(
                                            controller: chatTextController,
                                            keyboardType: TextInputType.text,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2!
                                                .copyWith(
                                                  color: Colors.white,
                                                  fontFamily:
                                                      Config.heeboRegular,
                                                  fontSize: Dimens.space14.sp,
                                                  fontWeight: FontWeight.normal,
                                                ),
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
                                                  color: Color(0xff2E313C),
                                                  width: Dimens.space1.w,
                                                ),
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(
                                                      Dimens.space12.w),
                                                ),
                                              ),
                                              disabledBorder:
                                                  OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Color(0xff2E313C),
                                                  width: Dimens.space1.w,
                                                ),
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(
                                                      Dimens.space12.w),
                                                ),
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Color(0xff2E313C),
                                                  width: Dimens.space1.w,
                                                ),
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(
                                                      Dimens.space12.w),
                                                ),
                                              ),
                                              focusedErrorBorder:
                                                  OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Color(0xff2E313C),
                                                  width: Dimens.space1.w,
                                                ),
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(
                                                      Dimens.space12.w),
                                                ),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Color(0xff2E313C),
                                                  width: Dimens.space1.w,
                                                ),
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(
                                                      Dimens.space12.w),
                                                ),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Color(0xff2E313C),
                                                  width: Dimens.space1.w,
                                                ),
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(
                                                      Dimens.space12.w),
                                                ),
                                              ),
                                              filled: true,
                                              fillColor: Color(0xff1F2128),
                                              hintText: "Enter your message",
                                              hintStyle: Theme.of(context)
                                                  .textTheme
                                                  .bodyText2!
                                                  .copyWith(
                                                    color: Colors.white,
                                                    fontFamily:
                                                        Config.heeboRegular,
                                                    fontSize: Dimens.space14.sp,
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
                                          width: Dimens.space40.w,
                                          height: Dimens.space40.w,
                                          alignment: Alignment.center,
                                          margin: EdgeInsets.fromLTRB(
                                              Dimens.space0.w,
                                              Dimens.space0.h,
                                              Dimens.space16.w,
                                              Dimens.space0.h),
                                          padding: EdgeInsets.fromLTRB(
                                              Dimens.space0.w,
                                              Dimens.space0.h,
                                              Dimens.space0.w,
                                              Dimens.space0.h),
                                          child: RoundedNetworkImageHolder(
                                            width: Dimens.space44,
                                            height: Dimens.space44,
                                            boxFit: BoxFit.cover,
                                            containerAlignment:
                                                Alignment.center,
                                            iconUrl: Icons.send,
                                            iconColor: Colors.white,
                                            iconSize: Dimens.space20,
                                            boxDecorationColor: Colors.blue,
                                            outerCorner: Dimens.space300,
                                            innerCorner: Dimens.space300,
                                            imageUrl: "",
                                            onTap: sendMessage,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(Dimens.space12.r),
                          topRight: Radius.circular(Dimens.space12.r),
                        ),
                        onPanelSlide: (double pos) {},
                      ),
                    ],
                  ),
                ),
              ),
              isLoading
                  ? Container(
                      height: Utils.getScreenHeight(context).h,
                      width: Utils.getScreenWidth(context).w,
                      color: CustomColors.title_active!.withOpacity(0.2),
                      child: Center(
                        child: Lottie.asset(
                          'assets/lottie/Peeq_loader.json',
                          height: Utils.getScreenWidth(context) * 0.6,
                        ),
                      ),
                    )
                  : Container(),
            ],
          ));
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
        "id": "WSawJYqDBeDM5J6ML",
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

  void sendReaction(String messageId, bool shouldReact) {
    chatChannelSubscriptionBloc.webSocketChannel!.sink.add(
      json.encode(
        ReactionsRequest(
            msg: "method",
            method: "setReaction",
            id: "WSawJYqDBeDM5J6ML",
            params: [
              ":heart:",
              messageId,
              shouldReact.toString(),
            ]).toJson(),
      ),
    );
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
      "id": "WSawJYqDBeDM5J6ML",
      "params": [
        {
          "_id": messageId,
        }
      ]
    };
    chatChannelSubscriptionBloc.webSocketChannel!.sink
        .add(jsonEncode(deleteMessage));
    listVideoMessages!.removeAt(index);
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

  void getMembersList() {
    chatChannelSubscriptionBloc.add(
      ChatChannelMembersListResponseEvent(
        urlIndex: widget.urlIndex,
        roomId: widget.roomId,
      ),
    );
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
            getMembersList();
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
