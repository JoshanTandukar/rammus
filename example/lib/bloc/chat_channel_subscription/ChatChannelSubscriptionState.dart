import 'package:live/viewobject/model/agoraToken/AgoraToken.dart';
import 'package:live/viewobject/model/createChannel/ChatCreateChannelResponse.dart';
import 'package:live/viewobject/model/membersList/MemberListResponse.dart';
import 'package:live/viewobject/model/startVideo/StartVideoResponse.dart';
import 'package:live/viewobject/model/usersList/UsersListResponse.dart';

abstract class ChatChannelSubscriptionState{}

class InitialChatChannelSubscriptionState extends ChatChannelSubscriptionState{}

class ChatChannelSubscriptionErrorState extends ChatChannelSubscriptionState
{
  final String errorMessage;
  ChatChannelSubscriptionErrorState(this.errorMessage);
}

class ChatChannelSubscriptionProgressState extends ChatChannelSubscriptionState{}

class ChatChannelSendMessageSuccessState extends ChatChannelSubscriptionState
{
  final ChatCreateChannelResponse chatCreateChannelResponse;
  ChatChannelSendMessageSuccessState(this.chatCreateChannelResponse);
}

class ChatChannelUploadFileSuccessState extends ChatChannelSubscriptionState
{
  final ChatCreateChannelResponse chatCreateChannelResponse;
  ChatChannelUploadFileSuccessState(this.chatCreateChannelResponse);
}

class ChatChannelLeaveChannelSuccessState extends ChatChannelSubscriptionState
{
  final ChatCreateChannelResponse? chatCreateChannelResponse;
  ChatChannelLeaveChannelSuccessState(this.chatCreateChannelResponse);
}

class ChatChannelDeleteChannelSuccessState extends ChatChannelSubscriptionState
{
  final ChatCreateChannelResponse? chatCreateChannelResponse;
  ChatChannelDeleteChannelSuccessState(this.chatCreateChannelResponse);
}

class ChatChannelUsersListSuccessState extends ChatChannelSubscriptionState
{
  final UsersListResponse? usersListResponse;
  ChatChannelUsersListSuccessState(this.usersListResponse);
}

class ChatChannelAddUserToChannelSuccessState extends ChatChannelSubscriptionState
{
  final UsersListResponse? usersListResponse;
  ChatChannelAddUserToChannelSuccessState(this.usersListResponse);
}

class ChatChannelMembersListSuccessState extends ChatChannelSubscriptionState
{
  final MembersListResponse? membersListResponse;
  ChatChannelMembersListSuccessState(this.membersListResponse);
}

class ChatChannelGroupMembersListSuccessState extends ChatChannelSubscriptionState
{
  final MembersListResponse? membersListResponse;
  ChatChannelGroupMembersListSuccessState(this.membersListResponse);
}

class VideoCallSuccessState extends ChatChannelSubscriptionState
{
  final StartVideo? startVideo;
  VideoCallSuccessState(this.startVideo);
}

class AgoraTokenSuccessState extends ChatChannelSubscriptionState
{
  final AgoraToken? agoraToken;
  AgoraTokenSuccessState(this.agoraToken);
}

class ChatChannelRemoveUserFromChannelSuccessState extends ChatChannelSubscriptionState
{
  final UsersListResponse? usersListResponse;
  ChatChannelRemoveUserFromChannelSuccessState(this.usersListResponse);
}

class ChatChannelSetReactionSuccessState extends ChatChannelSubscriptionState
{
  final UsersListResponse? usersListResponse;
  ChatChannelSetReactionSuccessState(this.usersListResponse);
}

class ChatChannelCreateVideoCTAChannelSuccessState extends ChatChannelSubscriptionState
{
  final ChatCreateChannelResponse? chatCreateChannelResponse;
  ChatChannelCreateVideoCTAChannelSuccessState(this.chatCreateChannelResponse);
}

class ChatChannelSetDescriptionSuccessState extends ChatChannelSubscriptionState
{
  final ChatCreateChannelResponse? chatCreateChannelResponse;
  ChatChannelSetDescriptionSuccessState(this.chatCreateChannelResponse);
}

class ChatChannelMakePrivateSuccessState extends ChatChannelSubscriptionState
{
  final ChatCreateChannelResponse channelResponse;
  ChatChannelMakePrivateSuccessState(this.channelResponse);
}