import 'package:live/viewobject/model/admins/ResponseAdmin.dart';
import 'package:live/viewobject/model/agoraToken/AgoraToken.dart';
import 'package:live/viewobject/model/createChannel/ChatCreateChannelResponse.dart';
import 'package:live/viewobject/model/membersList/MemberListResponse.dart';
import 'package:live/viewobject/model/startVideo/StartVideoResponse.dart';
import 'package:live/viewobject/model/usersList/UsersListResponse.dart';

abstract class ChatChannelVideoOnlySubscriptionState {}

class InitialChatChannelVideoOnlySubscriptionState
    extends ChatChannelVideoOnlySubscriptionState {}

class ChatChannelVideoOnlySubscriptionErrorState
    extends ChatChannelVideoOnlySubscriptionState {
  final String errorMessage;
  ChatChannelVideoOnlySubscriptionErrorState(this.errorMessage);
}

class ChatChannelVideoOnlySubscriptionProgressState
    extends ChatChannelVideoOnlySubscriptionState {}

class ChatChannelVideoOnlySendMessageSuccessState
    extends ChatChannelVideoOnlySubscriptionState {
  final ChatCreateChannelResponse chatCreateChannelResponse;
  ChatChannelVideoOnlySendMessageSuccessState(this.chatCreateChannelResponse);
}

class ChatChannelVideoOnlyUploadFileSuccessState
    extends ChatChannelVideoOnlySubscriptionState {
  final ChatCreateChannelResponse chatCreateChannelResponse;
  ChatChannelVideoOnlyUploadFileSuccessState(this.chatCreateChannelResponse);
}

class ChatChannelVideoOnlyLeaveChannelSuccessState
    extends ChatChannelVideoOnlySubscriptionState {
  final ChatCreateChannelResponse? chatCreateChannelResponse;
  ChatChannelVideoOnlyLeaveChannelSuccessState(this.chatCreateChannelResponse);
}

class ChatChannelVideoOnlyDeleteChannelSuccessState
    extends ChatChannelVideoOnlySubscriptionState {
  final ChatCreateChannelResponse? chatCreateChannelResponse;
  ChatChannelVideoOnlyDeleteChannelSuccessState(this.chatCreateChannelResponse);
}

class ChatChannelVideoOnlyUsersListSuccessState
    extends ChatChannelVideoOnlySubscriptionState {
  final UsersListResponse? usersListResponse;
  ChatChannelVideoOnlyUsersListSuccessState(this.usersListResponse);
}

class ChatChannelVideoOnlyAddUserToChannelSuccessState
    extends ChatChannelVideoOnlySubscriptionState {
  final UsersListResponse? usersListResponse;
  ChatChannelVideoOnlyAddUserToChannelSuccessState(this.usersListResponse);
}

class ChatChannelVideoOnlyMembersListSuccessState
    extends ChatChannelVideoOnlySubscriptionState {
  final MembersListResponse? membersListResponse;
  ChatChannelVideoOnlyMembersListSuccessState(this.membersListResponse);
}

class ChatChannelVideoOnlyGroupMembersListSuccessState
    extends ChatChannelVideoOnlySubscriptionState {
  final MembersListResponse? membersListResponse;
  ChatChannelVideoOnlyGroupMembersListSuccessState(this.membersListResponse);
}

class VideoCallVideoOnlySuccessState
    extends ChatChannelVideoOnlySubscriptionState {
  final StartVideo? startVideo;
  VideoCallVideoOnlySuccessState(this.startVideo);
}

class AgoraTokenVideoOnlySuccessState
    extends ChatChannelVideoOnlySubscriptionState {
  final AgoraToken? agoraToken;
  AgoraTokenVideoOnlySuccessState(this.agoraToken);
}

class ChatChannelVideoOnlyRemoveUserFromChannelSuccessState
    extends ChatChannelVideoOnlySubscriptionState {
  final UsersListResponse? usersListResponse;
  ChatChannelVideoOnlyRemoveUserFromChannelSuccessState(this.usersListResponse);
}

class ChatChannelVideoOnlySetReactionSuccessState
    extends ChatChannelVideoOnlySubscriptionState {
  final UsersListResponse? usersListResponse;
  ChatChannelVideoOnlySetReactionSuccessState(this.usersListResponse);
}

class ChatChannelVideoOnlyCreateVideoCTAChannelSuccessState
    extends ChatChannelVideoOnlySubscriptionState {
  final ChatCreateChannelResponse? chatCreateChannelResponse;
  ChatChannelVideoOnlyCreateVideoCTAChannelSuccessState(
      this.chatCreateChannelResponse);
}

class ChatChannelVideoOnlySetDescriptionSuccessState
    extends ChatChannelVideoOnlySubscriptionState {
  final ChatCreateChannelResponse? chatCreateChannelResponse;
  ChatChannelVideoOnlySetDescriptionSuccessState(
      this.chatCreateChannelResponse);
}

class ChatChannelVideoOnlyMakePrivateSuccessState
    extends ChatChannelVideoOnlySubscriptionState {
  final ChatCreateChannelResponse channelResponse;
  ChatChannelVideoOnlyMakePrivateSuccessState(this.channelResponse);
}

class GetAdminsSuccessState extends ChatChannelVideoOnlySubscriptionState {
  final ResponseAdmin responseAdmin;
  GetAdminsSuccessState(this.responseAdmin);
}
