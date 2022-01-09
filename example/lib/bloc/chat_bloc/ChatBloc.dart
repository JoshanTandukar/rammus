import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live/api/ApiService.dart';
import 'package:live/bloc/chat_bloc/ChatEvent.dart';
import 'package:live/bloc/chat_bloc/ChatState.dart';
import 'package:live/config/Config.dart';
import 'package:live/constant/Constants.dart';
import 'package:live/utils/Prefs.dart';
import 'package:live/viewobject/model/chatChannelGroupJoined/ChatChannelGroupJoinedResponse.dart';
import 'package:live/viewobject/model/chatChannelJoined/ChatChannelJoinedResponse.dart';
import 'package:live/viewobject/model/chatLoginUser/ChatLoginUserResponse.dart';
import 'package:live/viewobject/model/chatRegisterUser/ChatRegisterUserResponse.dart';
import 'package:live/viewobject/model/createChannel/ChatCreateChannelResponse.dart';
import 'package:live/viewobject/model/usersList/UsersListResponse.dart';
import 'package:quiver/iterables.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc(ChatState initialState) : super(initialState);

  @override
  Stream<ChatState> mapEventToState(ChatEvent event) async* {
    if (event is ChatLoginEvent) {
      yield* doChatLoginEvent(event.map);
    } else if (event is ChatRegisterEvent) {
      yield* doChatRegister(event.map);

      ///unused only for testing
      // } else if (event is ChatCreateChannelEvent) {
      //   yield* doChatCreateChannel(event.map);
    } else if (event is ChatChannelMakePrivateEvent) {
      yield* doChatChannelMakePrivate(
          chatUrl: event.chatUrl,
          authToken: event.authToken,
          userId: event.userId,
          map: event.map);
    } else if (event is ChatChannelJoinedEvent) {
      yield* doChatChannelJoined();
    } else if (event is ChatChannelEncryptionEvent) {
      yield* doChatChannelEncryption(event.map);
    } else if (event is ChatChannelChannelListResponseEvent) {
      yield* doChatChannelList();
    } else if (event is ChatChannelJoinPublicChannelResponseEvent) {
      yield* doChatChannelJoinPublicChannel(event.map);
    } else if (event is ChatChannelCreateHealthRecordChannelResponseEvent) {
      yield* doChatChannelCreateHealthRecordChannel(event.map);
    } else if (event is ChatChannelSetDescriptionResponseEvent) {
      yield* doChatChannelSetDescription(
          userId: event.userId,
          authToken: event.authToken,
          chatUrl: event.chatUrl,
          map: event.map);
    } else if (event is ChatChannelUsersListResponseEvent) {
      yield* doChatChannelGetUserList(event.urlIndex);
    } else if (event is ChatChannelAddUserToChannelResponseEvent) {
      yield* doChatChannelAddUserToChannel(event.urlIndex, event.map);
    }
  }

  Stream<ChatState> doChatLoginEvent(Map<String, dynamic>? map) async* {
    print("Chat bloc");
    ApiService apiProvider = ApiService();
    yield InitialChatState();
    try {
      print("Chat initial state");
      yield ChatProgressState();
      print("Chat progress state");
      final results = await Future.wait([
        for (var dump in Config.listChatUrl)
          apiProvider
              .doChatLoginApiCall(chatUrl: dump, map: map)
              .catchError((error, stackTrace) {
            return ChatLoginUserResponse();
          })
      ]);
      yield ChatLoginSuccessState(results);
      print("Chat success state");
    } catch (ex) {
      if (ex != "close") {
        print(ex.toString());
        yield ChatErrorState(ex.toString());
      }
    }
  }

  Stream<ChatState> doChatRegister(Map<String, dynamic>? map) async* {
    print("Chat bloc");
    ApiService apiProvider = ApiService();
    yield InitialChatState();
    try {
      print("Chat initial state");
      yield ChatProgressState();
      print("Chat progress state");
      final results = await Future.wait([
        for (var dump in Config.listChatUrl)
          apiProvider
              .doChatRegisterApiCall(chatUrl: dump, map: map)
              .catchError((error, stackTrace) {
            return ChatRegisterUserResponse();
          }),
      ]);

      yield ChatRegisterSuccessState(results);
      print("Chat success state");
    } catch (ex) {
      if (ex != "close") {
        print(ex.toString());
        yield ChatErrorState(ex.toString());
      } else {
        yield ChatErrorState(ex.toString());
      }
    }
  }

  ///unused only for testing
  // Stream<ChatState> doChatCreateChannel(Map<String, dynamic>? map) async* {
  //   print("Chat bloc");
  //   ApiService apiProvider = ApiService();
  //   yield InitialChatState();
  //   try {
  //     print("Chat initial state");
  //     yield ChatProgressState();
  //     print("Chat progress state");
  //     List<String>? authTokenChat =
  //         Prefs.getStringList(Const.VALUE_HOLDER_CHAT_AUTH_TOKEN)!;
  //     List<String>? userId =
  //         Prefs.getStringList(Const.VALUE_HOLDER_CHAT_USER_ID)!;
  //     final results = await Future.wait([
  //       apiProvider.doChatCreateChannelApiCall(
  //           chatUrl: Config.listChatUrl[0],
  //           map: map,
  //           authToken: authTokenChat[0],
  //           userId: userId[0]),
  //       apiProvider.doChatCreateChannelApiCall(
  //           chatUrl: Config.listChatUrl[1],
  //           map: map,
  //           authToken: authTokenChat[1],
  //           userId: userId[1]),
  //       apiProvider.doChatCreateChannelApiCall(
  //           chatUrl: Config.listChatUrl[2],
  //           map: map,
  //           authToken: authTokenChat[2],
  //           userId: userId[2]),
  //       apiProvider.doChatCreateChannelApiCall(
  //           chatUrl: Config.listChatUrl[3],
  //           map: map,
  //           authToken: authTokenChat[3],
  //           userId: userId[3]),
  //     ]);
  //     yield ChatCreateChannelSuccessState(results);
  //     print("Chat success state");
  //   } catch (ex) {
  //     if (ex != "close") {
  //       print(ex.toString());
  //       yield ChatErrorState(ex.toString());
  //     }
  //   }
  // }

  Stream<ChatState> doChatChannelMakePrivate(
      {String? chatUrl,
      String? authToken,
      String? userId,
      Map<String, dynamic>? map}) async* {
    print("Chat bloc");
    ApiService apiProvider = ApiService();
    yield InitialChatState();
    try {
      print("Chat initial state");
      yield ChatProgressState();
      print("Chat progress state");
      ChatCreateChannelResponse channelResponse =
          await apiProvider.doChatChannelMakePrivateApiCall(
              chatUrl: chatUrl, authToken: authToken, userId: userId, map: map);
      yield ChatChannelMakePrivateSuccessState(channelResponse);
      print("Chat success state");
    } catch (ex) {
      if (ex != "close") {
        print(ex.toString());
        yield ChatErrorState(ex.toString());
      }
    }
  }

  Stream<ChatState> doChatChannelJoined() async* {
    print("Chat bloc");
    ApiService apiProvider = ApiService();
    try {
      print("Chat initial state");
      yield ChatProgressState();
      print("Chat progress state");
      List<String>? authTokenChat =
          Prefs.getStringList(Const.VALUE_HOLDER_CHAT_AUTH_TOKEN);
      List<String>? userId =
          Prefs.getStringList(Const.VALUE_HOLDER_CHAT_USER_ID);

      final resultsChatChannelJoined = await Future.wait([
        for (var dump in zip([Config.listChatUrl, authTokenChat!, userId!]))
          apiProvider
              .doChatChannelJoinedApiCall(
            chatUrl: dump[0],
            authToken: dump[1],
            userId: dump[2],
          )
              .catchError((error, stackTrace) {
            return ChatChannelJoinedResponse();
          }),
      ]);

      final resultsChatChannelGroupJoined = await Future.wait([
        for (var dump in zip([Config.listChatUrl, authTokenChat, userId]))
          apiProvider
              .doChatChannelGroupJoinedApiCall(
            chatUrl: dump[0],
            authToken: dump[1],
            userId: dump[2],
          )
              .catchError((error, stackTrace) {
            return ChatChannelGroupJoinedResponse();
          }),
      ]);

      yield ChatChannelJoinedSuccessState(
          resultsChatChannelJoined, resultsChatChannelGroupJoined);
      print("Chat success state");
    } catch (ex) {
      if (ex != "close") {
        print(ex.toString());
        yield ChatErrorState(ex.toString());
      }
    }
  }

  Stream<ChatState> doChatChannelEncryption(Map<String, dynamic>? map) async* {
    print("Chat bloc");
    ApiService apiProvider = ApiService();
    yield InitialChatState();
    try {
      print("Chat initial state");
      yield ChatProgressState();
      print("Chat progress state");
      ChatChannelGroupJoinedResponse channelResponse =
          await apiProvider.doChatChannelEncryptionApiCall(map: map);
      yield ChatChannelEncryptionSuccessState(channelResponse);
      print("Chat success state");
    } catch (ex) {
      if (ex != "close") {
        print(ex.toString());
        yield ChatErrorState(ex.toString());
      }
    }
  }

  Stream<ChatState> doChatChannelList() async* {
    print("Chat bloc");
    ApiService apiProvider = ApiService();
    yield InitialChatState();
    try {
      print("Chat initial state");
      yield ChatProgressState();
      print("Chat progress state");
      List<String>? authTokenChat =
          Prefs.getStringList(Const.VALUE_HOLDER_CHAT_AUTH_TOKEN)!;
      List<String>? userId =
          Prefs.getStringList(Const.VALUE_HOLDER_CHAT_USER_ID)!;

      final results = await Future.wait([
        for (var dump in zip([Config.listChatUrl, authTokenChat, userId]))
          apiProvider
              .doChatChannelChannelListApiCall(
            chatUrl: dump[0],
            authToken: dump[1],
            userId: dump[2],
          )
              .catchError((error, stackTrace) {
            return ChatChannelJoinedResponse();
          }),
      ]);

      yield ChatChannelListSuccessState(results);
      print("Chat success state");
    } catch (ex) {
      if (ex != "close") {
        print(ex.toString());
        yield ChatErrorState(ex.toString());
      }
    }
  }

  Stream<ChatState> doChatChannelJoinPublicChannel(List<String>? map) async* {
    print("Chat bloc");
    ApiService apiProvider = ApiService();
    yield InitialChatState();
    try {
      print("Chat initial state");
      yield ChatProgressState();
      print("Chat progress state");
      List<String>? authTokenChat =
          Prefs.getStringList(Const.VALUE_HOLDER_CHAT_AUTH_TOKEN)!;
      List<String>? userId =
          Prefs.getStringList(Const.VALUE_HOLDER_CHAT_USER_ID)!;

      final results = await Future.wait([
        for (var dump in zip([Config.listChatUrl, authTokenChat, userId, map!]))
          apiProvider.doChatChannelJoinPublicChannel(
            chatUrl: dump[0],
            authToken: dump[1],
            userId: dump[2],
            map: {
              "roomId": dump[3],
            },
          ).catchError((error, stackTrace) {
            return ChatCreateChannelResponse();
          }),
      ]);

      yield ChatChannelJoinSuccessState(results);
      print("Chat success state");
    } catch (ex) {
      if (ex != "close") {
        print(ex.toString());
        yield ChatErrorState(ex.toString());
      }
    }
  }

  Stream<ChatState> doChatChannelCreateHealthRecordChannel(
      Map<String, dynamic>? map) async* {
    print("Chat bloc");
    ApiService apiProvider = ApiService();
    yield InitialChatState();
    try {
      print("Chat initial state");
      yield ChatProgressState();
      print("Chat progress state");
      List<String>? authTokenChat =
          Prefs.getStringList(Const.VALUE_HOLDER_CHAT_AUTH_TOKEN)!;
      List<String>? userId =
          Prefs.getStringList(Const.VALUE_HOLDER_CHAT_USER_ID)!;
      ChatCreateChannelResponse chatCreateChannelResponse =
          await apiProvider.doChatCreateChannelApiCall(
        chatUrl: Config.listChatUrl[0],
        map: map,
        authToken: authTokenChat[0],
        userId: userId[0],
      );
      yield ChatChannelCreateHealthRecordChannelSuccessState(
          chatCreateChannelResponse);
      print("Chat success state");
    } catch (ex) {
      if (ex != "close") {
        print(ex.toString());
        yield ChatErrorState(ex.toString());
      }
    }
  }

  Stream<ChatState> doChatChannelSetDescription(
      {String? chatUrl,
      String? authToken,
      String? userId,
      Map<String, dynamic>? map}) async* {
    print("Chat bloc");
    ApiService apiProvider = ApiService();
    yield InitialChatState();
    try {
      print("Chat initial state");
      yield ChatProgressState();
      print("Chat progress state");
      ChatCreateChannelResponse chatCreateChannelResponse =
          await apiProvider.doChatChannelSetDescription(
              chatUrl: chatUrl, map: map, authToken: authToken, userId: userId);
      yield ChatChannelSetDescriptionSuccessState(chatCreateChannelResponse);
      print("Chat success state");
    } catch (ex) {
      if (ex != "close") {
        print(ex.toString());
        yield ChatErrorState(ex.toString());
      }
    }
  }

  Stream<ChatState> doChatChannelGetUserList(int? urlIndex) async* {
    ApiService apiService = ApiService();
    try {
      print("Chat initial state");
      yield ChatProgressState();
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
      yield ChatChannelUsersListSuccessState(result);
      print(result);
    } catch (ex) {
      if (ex != "close") {
        print(ex.toString());
        yield ChatErrorState(ex.toString());
      }
    }
  }

  Stream<ChatState> doChatChannelAddUserToChannel(
      int? urlIndex, Map<String, dynamic>? map) async* {
    ApiService apiService = ApiService();
    try {
      print("Chat initial state");
      yield ChatProgressState();
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
      yield ChatChannelAddUserToChannelSuccessState(result);
      print(result);
    } catch (ex) {
      if (ex != "close") {
        print(ex.toString());
        yield ChatErrorState(ex.toString());
      }
    }
  }
}
