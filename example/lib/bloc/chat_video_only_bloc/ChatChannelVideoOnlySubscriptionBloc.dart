import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live/api/ApiService.dart';
import 'package:live/bloc/chat_video_only_bloc/ChatChannelVideoOnlySubscriptionEvent.dart';
import 'package:live/bloc/chat_video_only_bloc/ChatChannelVideoOnlySubscriptionState.dart';
import 'package:live/config/Config.dart';
import 'package:live/constant/Constants.dart';
import 'package:live/utils/Prefs.dart';
import 'package:live/viewobject/model/admins/ResponseAdmin.dart';
import 'package:live/viewobject/model/agoraToken/AgoraToken.dart';
import 'package:live/viewobject/model/createChannel/ChatCreateChannelResponse.dart';
import 'package:live/viewobject/model/membersList/MemberListResponse.dart';
import 'package:live/viewobject/model/startVideo/StartVideoResponse.dart';
import 'package:live/viewobject/model/usersList/UsersListResponse.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatChannelVideoOnlySubscriptionBloc extends Bloc<
    ChatChannelVideoOnlySubscriptionEvent,
    ChatChannelVideoOnlySubscriptionState> {
  WebSocketChannel? webSocketChannel;

  ChatChannelVideoOnlySubscriptionBloc(
      ChatChannelVideoOnlySubscriptionState initialState)
      : super(initialState);

  @override
  Stream<ChatChannelVideoOnlySubscriptionState> mapEventToState(
      ChatChannelVideoOnlySubscriptionEvent event) async* {
    if (event is ChatChannelFileUploadResponseEvent) {
      yield* doChatChannelUploadFile(event.roomId, event.urlIndex, event.map);
    } else if (event is ChatChannelLeaveRoomResponseEvent) {
      yield* doChatChannelLeaveChannel(event.urlIndex, event.map);
    } else if (event is ChatChannelDeletePublicRoomResponseEvent) {
      yield* doChatChannelPublicDeleteChannel(event.urlIndex, event.map);
    } else if (event is ChatChannelDeletePrivateRoomResponseEvent) {
      yield* doChatChannelDeletePrivateChannel(event.urlIndex, event.map);
    } else if (event is ChatChannelUsersListResponseEvent) {
      yield* doChatChannelGetUserList(event.urlIndex);
    } else if (event is ChatChannelAddUserToChannelResponseEvent) {
      yield* doChatChannelAddUserToChannel(event.urlIndex, event.map);
    } else if (event is ChatChannelMembersListResponseEvent) {
      yield* doChatChannelGetMemberList(event.urlIndex, event.roomId);
    } else if (event is ChatChannelGroupMembersListResponseEvent) {
      yield* doChatChannelGetGroupMemberList(event.urlIndex, event.roomId);
    } else if (event is ChatChannelRemoveUserFromChannelResponseEvent) {
      yield* doChatChannelRemoveUserFromChannel(event.urlIndex, event.map);
    } else if (event is ChatChannelSetReactionResponseEvent) {
      yield* doChatChannelSetReaction(event.urlIndex, event.map);
    } else if (event is ChatChannelCreateVideoCTAChannelResponseEvent) {
      yield* doChatChannelCreateVideoCTAChannel(
          urlIndex: event.urlIndex,
          authToken: event.authToken,
          userId: event.userId,
          map: event.map);
    } else if (event is ChatChannelSetDescriptionResponseEvent) {
      yield* doChatChannelSetDescription(
          userId: event.userId,
          authToken: event.authToken,
          chatUrl: event.chatUrl,
          map: event.map);
    } else if (event is ChatChannelMakePrivateEvent) {
      yield* doChatChannelMakePrivate(
          chatUrl: event.chatUrl,
          authToken: event.authToken,
          userId: event.userId,
          map: event.map);
    } else if (event is StartVideoEvent) {
      yield* doStartVideo(
          authToken: event.authToken, userId: event.userId, map: event.map);
    } else if (event is AgoraTokenEvent) {
      yield* doAgoraToken(map: event.body);
    } else if (event is AdminUserResponseEvent) {
      yield* doGetAdminsApiCall();
    }
  }

  void subscriptionConnect(String? socketUrl) {
    webSocketChannel = IOWebSocketChannel.connect(socketUrl!);
    Map mapConnect = {
      "msg": "connect",
      "version": "1",
      "support": ["1", "pre2", "pre1"],
    };
    webSocketChannel!.sink.add(json.encode(mapConnect));
  }

  Stream<ChatChannelVideoOnlySubscriptionState> doChatChannelUploadFile(
      String? roomId, int? urlIndex, Map<String, dynamic>? map) async* {
    ApiService apiService = ApiService();
    try {
      print("Chat initial state");
      yield ChatChannelVideoOnlySubscriptionProgressState();
      print("Chat progress state");
      List<String>? authTokenChat =
          Prefs.getStringList(Const.VALUE_HOLDER_CHAT_AUTH_TOKEN);
      List<String>? userId =
          Prefs.getStringList(Const.VALUE_HOLDER_CHAT_USER_ID);
      ChatCreateChannelResponse result =
          await apiService.doChatChannelUploadFileApiCall(
              roomId: roomId,
              authToken: authTokenChat![urlIndex!],
              userId: userId![urlIndex],
              chatUrl: Config.listChatUrl[urlIndex],
              map: map);
      yield ChatChannelVideoOnlyUploadFileSuccessState(result);
      print(result);
    } catch (ex) {
      if (ex != "close") {
        print(ex.toString());
        yield ChatChannelVideoOnlySubscriptionErrorState(ex.toString());
      }
    }
  }

  Stream<ChatChannelVideoOnlySubscriptionState> doChatChannelLeaveChannel(
      int? urlIndex, Map<String, dynamic>? map) async* {
    ApiService apiService = ApiService();
    try {
      print("Chat initial state");
      yield ChatChannelVideoOnlySubscriptionProgressState();
      print("Chat progress state");
      List<String>? authTokenChat =
          Prefs.getStringList(Const.VALUE_HOLDER_CHAT_AUTH_TOKEN);
      List<String>? userId =
          Prefs.getStringList(Const.VALUE_HOLDER_CHAT_USER_ID);
      ChatCreateChannelResponse result =
          await apiService.doChatChanelLeaveChannelApiCall(
              authToken: authTokenChat![urlIndex!],
              userId: userId![urlIndex],
              chatUrl: Config.listChatUrl[urlIndex],
              map: map);
      yield ChatChannelVideoOnlyLeaveChannelSuccessState(result);
      print(result);
    } catch (ex) {
      if (ex != "close") {
        print(ex.toString());
        yield ChatChannelVideoOnlySubscriptionErrorState(ex.toString());
      }
    }
  }

  Stream<ChatChannelVideoOnlySubscriptionState>
      doChatChannelPublicDeleteChannel(
          int? urlIndex, Map<String, dynamic>? map) async* {
    ApiService apiService = ApiService();
    try {
      print("Chat initial state");
      yield ChatChannelVideoOnlySubscriptionProgressState();
      print("Chat progress state");
      List<String>? authTokenChat =
          Prefs.getStringList(Const.VALUE_HOLDER_CHAT_AUTH_TOKEN);
      List<String>? userId =
          Prefs.getStringList(Const.VALUE_HOLDER_CHAT_USER_ID);
      ChatCreateChannelResponse result =
          await apiService.doChatChannelDeletePublicChannelApiCall(
              authToken: authTokenChat![urlIndex!],
              userId: userId![urlIndex],
              chatUrl: Config.listChatUrl[urlIndex],
              map: map);
      yield ChatChannelVideoOnlyDeleteChannelSuccessState(result);
      print(result);
    } catch (ex) {
      if (ex != "close") {
        print(ex.toString());
        yield ChatChannelVideoOnlySubscriptionErrorState(ex.toString());
      }
    }
  }

  Stream<ChatChannelVideoOnlySubscriptionState>
      doChatChannelDeletePrivateChannel(
          int? urlIndex, Map<String, dynamic>? map) async* {
    ApiService apiService = ApiService();
    try {
      print("Chat initial state");
      yield ChatChannelVideoOnlySubscriptionProgressState();
      print("Chat progress state");
      List<String>? authTokenChat =
          Prefs.getStringList(Const.VALUE_HOLDER_CHAT_AUTH_TOKEN);
      List<String>? userId =
          Prefs.getStringList(Const.VALUE_HOLDER_CHAT_USER_ID);
      ChatCreateChannelResponse result =
          await apiService.doChatChannelDeletePrivateChannelApiCall(
              authToken: authTokenChat![urlIndex!],
              userId: userId![urlIndex],
              chatUrl: Config.listChatUrl[urlIndex],
              map: map);
      yield ChatChannelVideoOnlyDeleteChannelSuccessState(result);
      print(result);
    } catch (ex) {
      if (ex != "close") {
        print(ex.toString());
        yield ChatChannelVideoOnlySubscriptionErrorState(ex.toString());
      }
    }
  }

  Stream<ChatChannelVideoOnlySubscriptionState> doChatChannelGetUserList(
      int? urlIndex) async* {
    ApiService apiService = ApiService();
    try {
      print("Chat initial state");
      yield ChatChannelVideoOnlySubscriptionProgressState();
      print("Chat progress state");
      List<String>? authTokenChat =
          Prefs.getStringList(Const.VALUE_HOLDER_CHAT_AUTH_TOKEN);
      List<String>? userId =
          Prefs.getStringList(Const.VALUE_HOLDER_CHAT_USER_ID);
      UsersListResponse result =
          await apiService.doChatChannelGetUserListApiCall(
              authToken: authTokenChat![urlIndex!],
              userId: userId![urlIndex],
              chatUrl: Config.listChatUrl[urlIndex]);
      yield ChatChannelVideoOnlyUsersListSuccessState(result);
      print(result);
    } catch (ex) {
      if (ex != "close") {
        print(ex.toString());
        yield ChatChannelVideoOnlySubscriptionErrorState(ex.toString());
      }
    }
  }

  Stream<ChatChannelVideoOnlySubscriptionState> doChatChannelAddUserToChannel(
      int? urlIndex, Map<String, dynamic>? map) async* {
    ApiService apiService = ApiService();
    try {
      print("Chat initial state");
      yield ChatChannelVideoOnlySubscriptionProgressState();
      print("Chat progress state");
      List<String>? authTokenChat =
          Prefs.getStringList(Const.VALUE_HOLDER_CHAT_AUTH_TOKEN);
      List<String>? userId =
          Prefs.getStringList(Const.VALUE_HOLDER_CHAT_USER_ID);
      UsersListResponse result =
          await apiService.doChatChannelAddUserToChannelApiCall(
              authToken: authTokenChat![urlIndex!],
              userId: userId![urlIndex],
              chatUrl: Config.listChatUrl[urlIndex],
              map: map);
      yield ChatChannelVideoOnlyAddUserToChannelSuccessState(result);
      print(result);
    } catch (ex) {
      if (ex != "close") {
        print(ex.toString());
        yield ChatChannelVideoOnlySubscriptionErrorState(ex.toString());
      }
    }
  }

  Stream<ChatChannelVideoOnlySubscriptionState> doChatChannelGetMemberList(
      int? urlIndex, String? roomId) async* {
    ApiService apiService = ApiService();
    try {
      print("Chat initial state");
      yield ChatChannelVideoOnlySubscriptionProgressState();
      print("Chat progress state");
      List<String>? authTokenChat =
          Prefs.getStringList(Const.VALUE_HOLDER_CHAT_AUTH_TOKEN);
      List<String>? userId =
          Prefs.getStringList(Const.VALUE_HOLDER_CHAT_USER_ID);
      MembersListResponse result =
          await apiService.doChatChannelGetMemberListApiCall(
              authToken: authTokenChat![urlIndex!],
              userId: userId![urlIndex],
              chatUrl: Config.listChatUrl[urlIndex],
              roomId: roomId);
      yield ChatChannelVideoOnlyMembersListSuccessState(result);
      print(result);
    } catch (ex) {
      if (ex != "close") {
        print(ex.toString());
        yield ChatChannelVideoOnlySubscriptionErrorState(ex.toString());
      }
    }
  }

  Stream<ChatChannelVideoOnlySubscriptionState> doChatChannelGetGroupMemberList(
      int? urlIndex, String? roomId) async* {
    ApiService apiService = ApiService();
    try {
      print("Chat initial state");
      yield ChatChannelVideoOnlySubscriptionProgressState();
      print("Chat progress state");
      List<String>? authTokenChat =
          Prefs.getStringList(Const.VALUE_HOLDER_CHAT_AUTH_TOKEN);
      List<String>? userId =
          Prefs.getStringList(Const.VALUE_HOLDER_CHAT_USER_ID);
      MembersListResponse result =
          await apiService.doChatChannelGetGroupMemberListApiCall(
              authToken: authTokenChat![urlIndex!],
              userId: userId![urlIndex],
              chatUrl: Config.listChatUrl[urlIndex],
              roomId: roomId);
      yield ChatChannelVideoOnlyGroupMembersListSuccessState(result);
      print(result);
    } catch (ex) {
      if (ex != "close") {
        print(ex.toString());
        yield ChatChannelVideoOnlySubscriptionErrorState(ex.toString());
      }
    }
  }

  Stream<ChatChannelVideoOnlySubscriptionState>
      doChatChannelRemoveUserFromChannel(
          int? urlIndex, Map<String, dynamic>? map) async* {
    ApiService apiService = ApiService();
    try {
      print("Chat initial state");
      yield ChatChannelVideoOnlySubscriptionProgressState();
      print("Chat progress state");
      List<String>? authTokenChat =
          Prefs.getStringList(Const.VALUE_HOLDER_CHAT_AUTH_TOKEN);
      List<String>? userId =
          Prefs.getStringList(Const.VALUE_HOLDER_CHAT_USER_ID);
      UsersListResponse result =
          await apiService.doChatChannelRemoveUserFromChannelApiCall(
              authToken: authTokenChat![urlIndex!],
              userId: userId![urlIndex],
              chatUrl: Config.listChatUrl[urlIndex],
              map: map);
      yield ChatChannelVideoOnlyRemoveUserFromChannelSuccessState(result);
      print(result);
    } catch (ex) {
      if (ex != "close") {
        print(ex.toString());
        yield ChatChannelVideoOnlySubscriptionErrorState(ex.toString());
      }
    }
  }

  Stream<ChatChannelVideoOnlySubscriptionState> doChatChannelSetReaction(
      int? urlIndex, Map<String, dynamic>? map) async* {
    ApiService apiService = ApiService();
    try {
      print("Chat initial state");
      yield ChatChannelVideoOnlySubscriptionProgressState();
      print("Chat progress state");
      List<String>? authTokenChat =
          Prefs.getStringList(Const.VALUE_HOLDER_CHAT_AUTH_TOKEN);
      List<String>? userId =
          Prefs.getStringList(Const.VALUE_HOLDER_CHAT_USER_ID);
      UsersListResponse result =
          await apiService.doChatChannelSetReactionApiCall(
              authToken: authTokenChat![urlIndex!],
              userId: userId![urlIndex],
              chatUrl: Config.listChatUrl[urlIndex],
              map: map);
      yield ChatChannelVideoOnlySetReactionSuccessState(result);
      print(result);
    } catch (ex) {
      if (ex != "close") {
        print(ex.toString());
        yield ChatChannelVideoOnlySubscriptionErrorState(ex.toString());
      }
    }
  }

  Stream<ChatChannelVideoOnlySubscriptionState>
      doChatChannelCreateVideoCTAChannel(
          {int? urlIndex,
          String? authToken,
          String? userId,
          Map<String, dynamic>? map}) async* {
    print("Chat bloc");
    ApiService apiProvider = ApiService();
    try {
      print("Chat initial state");
      yield ChatChannelVideoOnlySubscriptionProgressState();
      print("Chat progress state");
      List<String>? authTokenChat =
          Prefs.getStringList(Const.VALUE_HOLDER_CHAT_AUTH_TOKEN)!;
      List<String>? userId =
          Prefs.getStringList(Const.VALUE_HOLDER_CHAT_USER_ID)!;
      ChatCreateChannelResponse chatCreateChannelResponse =
          await apiProvider.doChatCreateChannelApiCall(
              chatUrl: Config.listChatUrl[urlIndex!],
              map: map,
              authToken: authTokenChat[urlIndex],
              userId: userId[urlIndex]);
      yield ChatChannelVideoOnlyCreateVideoCTAChannelSuccessState(
          chatCreateChannelResponse);
      print("Chat success state");
    } catch (ex) {
      if (ex != "close") {
        print(ex.toString());
        yield ChatChannelVideoOnlySubscriptionErrorState(ex.toString());
      }
    }
  }

  Stream<ChatChannelVideoOnlySubscriptionState> doChatChannelSetDescription(
      {String? chatUrl,
      String? authToken,
      String? userId,
      Map<String, dynamic>? map}) async* {
    print("Chat bloc");
    ApiService apiProvider = ApiService();
    try {
      print("Chat initial state");
      yield ChatChannelVideoOnlySubscriptionProgressState();
      print("Chat progress state");
      ChatCreateChannelResponse chatCreateChannelResponse =
          await apiProvider.doChatChannelSetDescription(
              chatUrl: chatUrl, map: map, authToken: authToken, userId: userId);
      yield ChatChannelVideoOnlySetDescriptionSuccessState(
          chatCreateChannelResponse);
      print("Chat success state");
    } catch (ex) {
      if (ex != "close") {
        print(ex.toString());
        yield ChatChannelVideoOnlySubscriptionErrorState(ex.toString());
      }
    }
  }

  Stream<ChatChannelVideoOnlySubscriptionState> doChatChannelMakePrivate(
      {String? chatUrl,
      String? authToken,
      String? userId,
      Map<String, dynamic>? map}) async* {
    print("Chat bloc");
    ApiService apiProvider = ApiService();
    try {
      print("Chat initial state");
      yield ChatChannelVideoOnlySubscriptionProgressState();
      print("Chat progress state");
      ChatCreateChannelResponse channelResponse =
          await apiProvider.doChatChannelMakePrivateApiCall(
              chatUrl: chatUrl, authToken: authToken, userId: userId, map: map);
      yield ChatChannelVideoOnlyMakePrivateSuccessState(channelResponse);
      print("Chat success state");
    } catch (ex) {
      if (ex != "close") {
        print(ex.toString());
        yield ChatChannelVideoOnlySubscriptionErrorState(ex.toString());
      }
    }
  }

  Stream<ChatChannelVideoOnlySubscriptionState> doStartVideo(
      {String? chatUrl,
      String? authToken,
      String? userId,
      Map<String, dynamic>? map}) async* {
    print("Start Video bloc");
    ApiService apiProvider = ApiService();
    try {
      print("Start Video initial state");
      yield ChatChannelVideoOnlySubscriptionProgressState();
      print("Start Video progress state");
      StartVideo startVideoResponse = await apiProvider.doStartVideoApiCall(
          authToken: authToken, userId: userId, map: map);
      yield VideoCallVideoOnlySuccessState(startVideoResponse);
      print("Start Video success state");
    } catch (ex) {
      if (ex != "close") {
        print(ex.toString());
        yield ChatChannelVideoOnlySubscriptionErrorState(ex.toString());
      }
    }
  }

  Stream<ChatChannelVideoOnlySubscriptionState> doAgoraToken(
      {Map<String, dynamic>? map}) async* {
    print("Agora Token bloc");
    ApiService apiProvider = ApiService();
    try {
      print("Agora Token initial state");
      yield ChatChannelVideoOnlySubscriptionProgressState();
      print("Agora Token progress state $map");
      AgoraToken agoraToken = await apiProvider.getAgoraToken(body: map);
      yield AgoraTokenVideoOnlySuccessState(agoraToken);
      print("Start Video success state");
    } catch (ex) {
      if (ex != "close") {
        print(ex.toString());
        yield ChatChannelVideoOnlySubscriptionErrorState(ex.toString());
      }
    }
  }

  Stream<ChatChannelVideoOnlySubscriptionState> doGetAdminsApiCall() async* {
    ApiService apiProvider = ApiService();
    try {
      yield ChatChannelVideoOnlySubscriptionProgressState();
      ResponseAdmin responseAdmin = await apiProvider.doAdminsApiCall();
      yield GetAdminsSuccessState(responseAdmin);
    } catch (ex) {
      if (ex != "close") {
        yield ChatChannelVideoOnlySubscriptionErrorState(ex.toString());
      }
    }
  }
}
