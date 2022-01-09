import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live/api/ApiService.dart';
import 'package:live/bloc/chat_create_channel/ChatCreateChannelEvent.dart';
import 'package:live/bloc/chat_create_channel/ChatCreateChannelState.dart';
import 'package:live/config/Config.dart';
import 'package:live/constant/Constants.dart';
import 'package:live/utils/Prefs.dart';
import 'package:live/viewobject/model/createChannel/ChatCreateChannelResponse.dart';

class ChatCreateChannelBloc extends Bloc<ChatCreateChannelEvent, ChatCreateChannelState>
{
  ChatCreateChannelBloc(ChatCreateChannelState initialState) : super(initialState);

  @override
  Stream<ChatCreateChannelState> mapEventToState(ChatCreateChannelEvent event) async*
  {
    if (event is ChatCreateChannelResponseEvent)
    {
      yield* doChatCreateChannel(event.map, event.urlIndex);
    }
  }

  Stream<ChatCreateChannelState> doChatCreateChannel(Map<String,dynamic>? map, int? urlIndex) async*
  {
    print("Chat bloc");
    ApiService apiProvider = ApiService();
    yield InitialChatCreateChannelState();
    try
    {
      print("Chat initial state");
      yield ChatCreateChannelProgressState();
      print("Chat progress state");
      List<String>? authTokenChat = Prefs.getStringList(Const.VALUE_HOLDER_CHAT_AUTH_TOKEN)!;
      List<String>? userId = Prefs.getStringList(Const.VALUE_HOLDER_CHAT_USER_ID)!;
      ChatCreateChannelResponse chatCreateChannelResponse = await apiProvider.doChatCreateTeamApiCall(chatUrl: Config.listChatUrl[urlIndex!], map: map, authToken: authTokenChat[urlIndex], userId: userId[urlIndex]);
      yield ChatCreateChannelSuccessState(chatCreateChannelResponse);
      print("Chat success state");
    }
    catch (ex)
    {
      if (ex != "close")
      {
        print(ex.toString());
        yield ChatCreateChannelErrorState(ex.toString());
      }
    }
  }
}
