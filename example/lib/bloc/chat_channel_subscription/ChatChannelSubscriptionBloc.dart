import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live/api/ApiService.dart';
import 'package:live/bloc/chat_channel_subscription/ChatChannelSubscriptionEvent.dart';
import 'package:live/bloc/chat_channel_subscription/ChatChannelSubscriptionState.dart';
import 'package:live/config/Config.dart';
import 'package:live/constant/Constants.dart';
import 'package:live/utils/Prefs.dart';
import 'package:live/viewobject/model/agoraToken/AgoraToken.dart';
import 'package:live/viewobject/model/createChannel/ChatCreateChannelResponse.dart';
import 'package:live/viewobject/model/membersList/MemberListResponse.dart';
import 'package:live/viewobject/model/startVideo/StartVideoResponse.dart';
import 'package:live/viewobject/model/usersList/UsersListResponse.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatChannelSubscriptionBloc extends Bloc<ChatChannelSubscriptionEvent, ChatChannelSubscriptionState>
{
  WebSocketChannel? webSocketChannel;

  ChatChannelSubscriptionBloc(ChatChannelSubscriptionState initialState) : super(initialState);


  @override
  Stream<ChatChannelSubscriptionState> mapEventToState(ChatChannelSubscriptionEvent event) async*
  {
    if (event is ChatChannelFileUploadResponseEvent)
    {
      yield* doChatChannelUploadFile(event.roomId, event.urlIndex, event.map);
    }
    else if(event is ChatChannelLeaveRoomResponseEvent)
    {
      yield* doChatChannelLeaveChannel(event.urlIndex, event.map);
    }
    else if(event is ChatChannelDeletePublicRoomResponseEvent)
    {
      yield* doChatChannelPublicDeleteChannel(event.urlIndex, event.map);
    }
    else if(event is ChatChannelDeletePrivateRoomResponseEvent)
    {
      yield* doChatChannelDeletePrivateChannel(event.urlIndex, event.map);
    }
    else if(event is ChatChannelUsersListResponseEvent)
    {
      yield* doChatChannelGetUserList(event.urlIndex);
    }
    else if(event is ChatChannelAddUserToChannelResponseEvent)
    {
      yield* doChatChannelAddUserToChannel(event.urlIndex, event.map);
    }
    else if(event is ChatChannelMembersListResponseEvent)
    {
      yield* doChatChannelGetMemberList(event.urlIndex, event.roomId);
    }
    else if(event is ChatChannelGroupMembersListResponseEvent)
    {
      yield* doChatChannelGetGroupMemberList(event.urlIndex, event.roomId);
    }
    else if(event is ChatChannelRemoveUserFromChannelResponseEvent)
    {
      yield* doChatChannelRemoveUserFromChannel(event.urlIndex, event.map);
    }
    else if(event is ChatChannelSetReactionResponseEvent)
    {
      yield* doChatChannelSetReaction(event.urlIndex, event.map);
    }
    else if(event is ChatChannelCreateVideoCTAChannelResponseEvent)
    {
      yield* doChatChannelCreateVideoCTAChannel(urlIndex: event.urlIndex, authToken: event.authToken, userId: event.userId, map: event.map);
    }
    else if(event is ChatChannelSetDescriptionResponseEvent)
    {
      yield* doChatChannelSetDescription(userId: event.userId, authToken: event.authToken, chatUrl: event.chatUrl, map: event.map);
    }
    else if (event is ChatChannelMakePrivateEvent)
    {
      yield* doChatChannelMakePrivate(chatUrl: event.chatUrl, authToken: event.authToken, userId: event.userId, map: event.map);
    }
    else if (event is StartVideoEvent)
    {
      yield* doStartVideo( authToken: event.authToken, userId: event.userId, map: event.map);
    }
    else if (event is AgoraTokenEvent)
    {
      yield* doAgoraToken(  map: event.body);
    }
  }

  void subscriptionConnect(String? socketUrl)
  {
    webSocketChannel = IOWebSocketChannel.connect(socketUrl!);
    Map mapConnect = {
      "msg": "connect",
      "version": "1",
      "support": ["1", "pre2", "pre1"],
    };
    webSocketChannel!.sink.add(json.encode(mapConnect));
  }

  Stream<ChatChannelSubscriptionState> doChatChannelUploadFile(String? roomId, int? urlIndex, Map<String,dynamic>? map) async*
  {
    ApiService apiService = ApiService();
    try
    {
      print("Chat initial state");
      yield ChatChannelSubscriptionProgressState();
      print("Chat progress state");
      List<String>? authTokenChat = Prefs.getStringList(Const.VALUE_HOLDER_CHAT_AUTH_TOKEN);
      List<String>? userId = Prefs.getStringList(Const.VALUE_HOLDER_CHAT_USER_ID);
      ChatCreateChannelResponse result = await apiService.doChatChannelUploadFileApiCall(roomId: roomId, authToken: authTokenChat![urlIndex!],userId: userId![urlIndex], chatUrl: Config.listChatUrl[urlIndex], map:map);
      yield ChatChannelUploadFileSuccessState(result);
      print(result);
    }
    catch (ex)
    {
      if (ex != "close")
      {
        print(ex.toString());
        yield ChatChannelSubscriptionErrorState(ex.toString());
      }
    }
  }

  Stream<ChatChannelSubscriptionState> doChatChannelLeaveChannel(int? urlIndex, Map<String,dynamic>? map) async*
  {
    ApiService apiService = ApiService();
    try
    {
      print("Chat initial state");
      yield ChatChannelSubscriptionProgressState();
      print("Chat progress state");
      List<String>? authTokenChat = Prefs.getStringList(Const.VALUE_HOLDER_CHAT_AUTH_TOKEN);
      List<String>? userId = Prefs.getStringList(Const.VALUE_HOLDER_CHAT_USER_ID);
      ChatCreateChannelResponse result = await apiService.doChatChanelLeaveChannelApiCall(authToken: authTokenChat![urlIndex!],userId: userId![urlIndex], chatUrl: Config.listChatUrl[urlIndex], map:map);
      yield ChatChannelLeaveChannelSuccessState(result);
      print(result);
    }
    catch (ex)
    {
      if (ex != "close")
      {
        print(ex.toString());
        yield ChatChannelSubscriptionErrorState(ex.toString());
      }
    }
  }

  Stream<ChatChannelSubscriptionState> doChatChannelPublicDeleteChannel(int? urlIndex, Map<String,dynamic>? map) async*
  {
    ApiService apiService = ApiService();
    try
    {
      print("Chat initial state");
      yield ChatChannelSubscriptionProgressState();
      print("Chat progress state");
      List<String>? authTokenChat = Prefs.getStringList(Const.VALUE_HOLDER_CHAT_AUTH_TOKEN);
      List<String>? userId = Prefs.getStringList(Const.VALUE_HOLDER_CHAT_USER_ID);
      ChatCreateChannelResponse result = await apiService.doChatChannelDeletePublicChannelApiCall(authToken: authTokenChat![urlIndex!],userId: userId![urlIndex], chatUrl: Config.listChatUrl[urlIndex], map:map);
      yield ChatChannelDeleteChannelSuccessState(result);
      print(result);
    }
    catch (ex)
    {
      if (ex != "close")
      {
        print(ex.toString());
        yield ChatChannelSubscriptionErrorState(ex.toString());
      }
    }
  }

  Stream<ChatChannelSubscriptionState> doChatChannelDeletePrivateChannel(int? urlIndex, Map<String,dynamic>? map) async*
  {
    ApiService apiService = ApiService();
    try
    {
      print("Chat initial state");
      yield ChatChannelSubscriptionProgressState();
      print("Chat progress state");
      List<String>? authTokenChat = Prefs.getStringList(Const.VALUE_HOLDER_CHAT_AUTH_TOKEN);
      List<String>? userId = Prefs.getStringList(Const.VALUE_HOLDER_CHAT_USER_ID);
      ChatCreateChannelResponse result = await apiService.doChatChannelDeletePrivateChannelApiCall(authToken: authTokenChat![urlIndex!],userId: userId![urlIndex], chatUrl: Config.listChatUrl[urlIndex], map:map);
      yield ChatChannelDeleteChannelSuccessState(result);
      print(result);
    }
    catch (ex)
    {
      if (ex != "close")
      {
        print(ex.toString());
        yield ChatChannelSubscriptionErrorState(ex.toString());
      }
    }
  }

  Stream<ChatChannelSubscriptionState> doChatChannelGetUserList(int? urlIndex) async*
  {
    ApiService apiService = ApiService();
    try
    {
      print("Chat initial state");
      yield ChatChannelSubscriptionProgressState();
      print("Chat progress state");
      List<String>? authTokenChat = Prefs.getStringList(Const.VALUE_HOLDER_CHAT_AUTH_TOKEN);
      List<String>? userId = Prefs.getStringList(Const.VALUE_HOLDER_CHAT_USER_ID);
      UsersListResponse result = await apiService.doChatChannelGetUserListApiCall(authToken: authTokenChat![urlIndex!],userId: userId![urlIndex], chatUrl: Config.listChatUrl[urlIndex]);
      yield ChatChannelUsersListSuccessState(result);
      print(result);
    }
    catch (ex)
    {
      if (ex != "close")
      {
        print(ex.toString());
        yield ChatChannelSubscriptionErrorState(ex.toString());
      }
    }
  }

  Stream<ChatChannelSubscriptionState> doChatChannelAddUserToChannel(int? urlIndex, Map<String,dynamic>? map) async*
  {
    ApiService apiService = ApiService();
    try
    {
      print("Chat initial state");
      yield ChatChannelSubscriptionProgressState();
      print("Chat progress state");
      List<String>? authTokenChat = Prefs.getStringList(Const.VALUE_HOLDER_CHAT_AUTH_TOKEN);
      List<String>? userId = Prefs.getStringList(Const.VALUE_HOLDER_CHAT_USER_ID);
      UsersListResponse result = await apiService.doChatChannelAddUserToChannelApiCall(authToken: authTokenChat![urlIndex!],userId: userId![urlIndex], chatUrl: Config.listChatUrl[urlIndex], map:map);
      yield ChatChannelAddUserToChannelSuccessState(result);
      print(result);
    }
    catch (ex)
    {
      if (ex != "close")
      {
        print(ex.toString());
        yield ChatChannelSubscriptionErrorState(ex.toString());
      }
    }
  }

  Stream<ChatChannelSubscriptionState> doChatChannelGetMemberList(int? urlIndex, String? roomId) async*
  {
    ApiService apiService = ApiService();
    try
    {
      print("Chat initial state");
      yield ChatChannelSubscriptionProgressState();
      print("Chat progress state");
      List<String>? authTokenChat = Prefs.getStringList(Const.VALUE_HOLDER_CHAT_AUTH_TOKEN);
      List<String>? userId = Prefs.getStringList(Const.VALUE_HOLDER_CHAT_USER_ID);
      MembersListResponse result = await apiService.doChatChannelGetMemberListApiCall(authToken: authTokenChat![urlIndex!],userId: userId![urlIndex], chatUrl: Config.listChatUrl[urlIndex], roomId: roomId);
      yield ChatChannelMembersListSuccessState(result);
      print(result);
    }
    catch (ex)
    {
      if (ex != "close")
      {
        print(ex.toString());
        yield ChatChannelSubscriptionErrorState(ex.toString());
      }
    }
  }

  Stream<ChatChannelSubscriptionState> doChatChannelGetGroupMemberList(int? urlIndex, String? roomId) async*
  {
    ApiService apiService = ApiService();
    try
    {
      print("Chat initial state");
      yield ChatChannelSubscriptionProgressState();
      print("Chat progress state");
      List<String>? authTokenChat = Prefs.getStringList(Const.VALUE_HOLDER_CHAT_AUTH_TOKEN);
      List<String>? userId = Prefs.getStringList(Const.VALUE_HOLDER_CHAT_USER_ID);
      MembersListResponse result = await apiService.doChatChannelGetGroupMemberListApiCall(authToken: authTokenChat![urlIndex!],userId: userId![urlIndex], chatUrl: Config.listChatUrl[urlIndex], roomId: roomId);
      yield ChatChannelGroupMembersListSuccessState(result);
      print(result);
    }
    catch (ex)
    {
      if (ex != "close")
      {
        print(ex.toString());
        yield ChatChannelSubscriptionErrorState(ex.toString());
      }
    }
  }

  Stream<ChatChannelSubscriptionState> doChatChannelRemoveUserFromChannel(int? urlIndex, Map<String,dynamic>? map) async*
  {
    ApiService apiService = ApiService();
    try
    {
      print("Chat initial state");
      yield ChatChannelSubscriptionProgressState();
      print("Chat progress state");
      List<String>? authTokenChat = Prefs.getStringList(Const.VALUE_HOLDER_CHAT_AUTH_TOKEN);
      List<String>? userId = Prefs.getStringList(Const.VALUE_HOLDER_CHAT_USER_ID);
      UsersListResponse result = await apiService.doChatChannelRemoveUserFromChannelApiCall(authToken: authTokenChat![urlIndex!],userId: userId![urlIndex], chatUrl: Config.listChatUrl[urlIndex], map:map);
      yield ChatChannelRemoveUserFromChannelSuccessState(result);
      print(result);
    }
    catch (ex)
    {
      if (ex != "close")
      {
        print(ex.toString());
        yield ChatChannelSubscriptionErrorState(ex.toString());
      }
    }
  }

  Stream<ChatChannelSubscriptionState> doChatChannelSetReaction(int? urlIndex, Map<String,dynamic>? map) async*
  {
    ApiService apiService = ApiService();
    try
    {
      print("Chat initial state");
      yield ChatChannelSubscriptionProgressState();
      print("Chat progress state");
      List<String>? authTokenChat = Prefs.getStringList(Const.VALUE_HOLDER_CHAT_AUTH_TOKEN);
      List<String>? userId = Prefs.getStringList(Const.VALUE_HOLDER_CHAT_USER_ID);
      UsersListResponse result = await apiService.doChatChannelSetReactionApiCall(authToken: authTokenChat![urlIndex!],userId: userId![urlIndex], chatUrl: Config.listChatUrl[urlIndex], map:map);
      yield ChatChannelSetReactionSuccessState(result);
      print(result);
    }
    catch (ex)
    {
      if (ex != "close")
      {
        print(ex.toString());
        yield ChatChannelSubscriptionErrorState(ex.toString());
      }
    }
  }

  Stream<ChatChannelSubscriptionState> doChatChannelCreateVideoCTAChannel({int? urlIndex, String? authToken, String? userId, Map<String,dynamic>? map}) async*
  {
    print("Chat bloc");
    ApiService apiProvider = ApiService();
    try
    {
      print("Chat initial state");
      yield ChatChannelSubscriptionProgressState();
      print("Chat progress state");
      List<String>? authTokenChat = Prefs.getStringList(Const.VALUE_HOLDER_CHAT_AUTH_TOKEN)!;
      List<String>? userId = Prefs.getStringList(Const.VALUE_HOLDER_CHAT_USER_ID)!;
      ChatCreateChannelResponse chatCreateChannelResponse = await apiProvider.doChatCreateChannelApiCall(chatUrl: Config.listChatUrl[urlIndex!],map: map, authToken: authTokenChat[urlIndex], userId: userId[urlIndex]);
      yield ChatChannelCreateVideoCTAChannelSuccessState(chatCreateChannelResponse);
      print("Chat success state");
    }
    catch (ex)
    {
      if (ex != "close")
      {
        print(ex.toString());
        yield ChatChannelSubscriptionErrorState(ex.toString());
      }
    }
  }

  Stream<ChatChannelSubscriptionState> doChatChannelSetDescription({String? chatUrl, String? authToken, String? userId, Map<String,dynamic>? map}) async*
  {
    print("Chat bloc");
    ApiService apiProvider = ApiService();
    try
    {
      print("Chat initial state");
      yield ChatChannelSubscriptionProgressState();
      print("Chat progress state");
      ChatCreateChannelResponse chatCreateChannelResponse = await apiProvider.doChatChannelSetDescription(chatUrl: chatUrl, map: map, authToken: authToken, userId: userId);
      yield ChatChannelSetDescriptionSuccessState(chatCreateChannelResponse);
      print("Chat success state");
    }
    catch (ex)
    {
      if (ex != "close")
      {
        print(ex.toString());
        yield ChatChannelSubscriptionErrorState(ex.toString());
      }
    }
  }

  Stream<ChatChannelSubscriptionState> doChatChannelMakePrivate({String? chatUrl, String? authToken, String? userId, Map<String,dynamic>? map}) async*
  {
    print("Chat bloc");
    ApiService apiProvider = ApiService();
    try
    {
      print("Chat initial state");
      yield ChatChannelSubscriptionProgressState();
      print("Chat progress state");
      ChatCreateChannelResponse channelResponse = await apiProvider.doChatChannelMakePrivateApiCall(chatUrl: chatUrl, authToken: authToken, userId: userId, map: map);
      yield ChatChannelMakePrivateSuccessState(channelResponse);
      print("Chat success state");
    }
    catch (ex)
    {
      if (ex != "close")
      {
        print(ex.toString());
        yield ChatChannelSubscriptionErrorState(ex.toString());
      }
    }
  }

  Stream<ChatChannelSubscriptionState> doStartVideo({String? chatUrl, String? authToken, String? userId, Map<String,dynamic>? map}) async*
  {
    print("Start Video bloc");
    ApiService apiProvider = ApiService();
    try
    {
      print("Start Video initial state");
      yield ChatChannelSubscriptionProgressState();
      print("Start Video progress state");
      StartVideo startVideoResponse = await apiProvider.doStartVideoApiCall(authToken: authToken, userId: userId, map: map);
      yield VideoCallSuccessState(startVideoResponse);
      print("Start Video success state");
    }
    catch (ex)
    {
      if (ex != "close")
      {
        print(ex.toString());
        yield ChatChannelSubscriptionErrorState(ex.toString());
      }
    }
  }

  Stream<ChatChannelSubscriptionState> doAgoraToken({Map<String,dynamic>? map}) async*
  {
    print("Agora Token bloc");
    ApiService apiProvider = ApiService();
    try
    {
      print("Agora Token initial state");
      yield ChatChannelSubscriptionProgressState();
      print("Agora Token progress state $map");
      AgoraToken agoraToken = await apiProvider.getAgoraToken( body: map);
      yield AgoraTokenSuccessState(agoraToken);
      print("Start Video success state");
    }
    catch (ex)
    {
      if (ex != "close")
      {
        print(ex.toString());
        yield ChatChannelSubscriptionErrorState(ex.toString());
      }
    }
  }
}
