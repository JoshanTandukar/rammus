import 'package:live/viewobject/model/chatChannelGroupJoined/ChatChannelGroupJoinedResponse.dart';
import 'package:live/viewobject/model/chatChannelJoined/ChatChannelJoinedResponse.dart';
import 'package:live/viewobject/model/chatLoginUser/ChatLoginUserResponse.dart';
import 'package:live/viewobject/model/chatRegisterUser/ChatRegisterUserResponse.dart';
import 'package:live/viewobject/model/createChannel/ChatCreateChannelResponse.dart';
import 'package:live/viewobject/model/usersList/UsersListResponse.dart';

abstract class ChatState{}

class InitialChatState extends ChatState{}

class ChatErrorState extends ChatState
{
  final String errorMessage;
  ChatErrorState(this.errorMessage);
}

class ChatProgressState extends ChatState{}

class ChatLoginSuccessState extends ChatState
{
  final List<ChatLoginUserResponse>? chatLoginUserResponse;
  ChatLoginSuccessState(this.chatLoginUserResponse);
}

class ChatRegisterSuccessState extends ChatState
{
  final List<ChatRegisterUserResponse>? registerUserResponse;
  ChatRegisterSuccessState(this.registerUserResponse);
}

class ChatCreateChannelSuccessState extends ChatState
{
  final List<ChatCreateChannelResponse>? channelResponse;
  ChatCreateChannelSuccessState(this.channelResponse);
}

class ChatChannelMakePrivateSuccessState extends ChatState
{
  final ChatCreateChannelResponse channelResponse;
  ChatChannelMakePrivateSuccessState(this.channelResponse);
}

class ChatChannelJoinedSuccessState extends ChatState
{
  final List<ChatChannelJoinedResponse> chatChannelJoinedResponse;
  final List<ChatChannelGroupJoinedResponse> channelGroupJoinedResponse;
  ChatChannelJoinedSuccessState(this.chatChannelJoinedResponse, this.channelGroupJoinedResponse);
}

class ChatChannelEncryptionSuccessState extends ChatState
{
  final ChatChannelGroupJoinedResponse channelResponse;
  ChatChannelEncryptionSuccessState(this.channelResponse);
}

class ChatChannelListSuccessState extends ChatState
{
  final List<ChatChannelJoinedResponse> chatChannelJoinedResponse;
  ChatChannelListSuccessState(this.chatChannelJoinedResponse);
}

class ChatChannelJoinSuccessState extends ChatState
{
  final List<ChatCreateChannelResponse> listChatChannelJoinResponse;
  ChatChannelJoinSuccessState(this.listChatChannelJoinResponse);
}

class ChatChannelCreateHealthRecordChannelSuccessState extends ChatState
{
  final ChatCreateChannelResponse? chatCreateChannelResponse;
  ChatChannelCreateHealthRecordChannelSuccessState(this.chatCreateChannelResponse);
}

class ChatChannelSetDescriptionSuccessState extends ChatState
{
  final ChatCreateChannelResponse? chatCreateChannelResponse;
  ChatChannelSetDescriptionSuccessState(this.chatCreateChannelResponse);
}

class ChatChannelUsersListSuccessState extends ChatState
{
  final UsersListResponse? usersListResponse;
  ChatChannelUsersListSuccessState(this.usersListResponse);
}

class ChatChannelAddUserToChannelSuccessState extends ChatState
{
  final UsersListResponse? usersListResponse;
  ChatChannelAddUserToChannelSuccessState(this.usersListResponse);
}