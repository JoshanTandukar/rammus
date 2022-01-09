import 'package:live/viewobject/model/createChannel/ChatCreateChannelResponse.dart';

abstract class ChatCreateChannelState{}

class InitialChatCreateChannelState extends ChatCreateChannelState{}

class ChatCreateChannelErrorState extends ChatCreateChannelState
{
  final String errorMessage;
  ChatCreateChannelErrorState(this.errorMessage);
}

class ChatCreateChannelProgressState extends ChatCreateChannelState{}

class ChatCreateChannelSuccessState extends ChatCreateChannelState
{
  final ChatCreateChannelResponse? chatCreateChannelResponse;
  ChatCreateChannelSuccessState(this.chatCreateChannelResponse);
}