
import 'package:flutter/cupertino.dart';

@immutable
abstract class ChatChannelSubscriptionEvent{}

class  ChatChannelFileUploadResponseEvent extends ChatChannelSubscriptionEvent
{
  final Map<String, dynamic>? map;
  final String? roomId;
  final int? urlIndex;
  ChatChannelFileUploadResponseEvent({@required this.roomId, @required this.urlIndex, @required this.map});
}

class  ChatChannelLeaveRoomResponseEvent extends ChatChannelSubscriptionEvent
{
  final Map<String, dynamic>? map;
  final int? urlIndex;
  ChatChannelLeaveRoomResponseEvent({@required this.urlIndex, @required this.map});
}

class  ChatChannelDeletePublicRoomResponseEvent extends ChatChannelSubscriptionEvent
{
  final Map<String, dynamic>? map;
  final int? urlIndex;
  ChatChannelDeletePublicRoomResponseEvent({@required this.urlIndex, @required this.map});
}

class  ChatChannelDeletePrivateRoomResponseEvent extends ChatChannelSubscriptionEvent
{
  final Map<String, dynamic>? map;
  final int? urlIndex;
  ChatChannelDeletePrivateRoomResponseEvent({@required this.urlIndex, @required this.map});
}

class  ChatChannelUsersListResponseEvent extends ChatChannelSubscriptionEvent
{
  final int? urlIndex;
  ChatChannelUsersListResponseEvent({@required this.urlIndex});
}

class  ChatChannelAddUserToChannelResponseEvent extends ChatChannelSubscriptionEvent
{
  final Map<String, dynamic>? map;
  final int? urlIndex;
  ChatChannelAddUserToChannelResponseEvent({@required this.urlIndex, @required this.map});
}

class  ChatChannelMembersListResponseEvent extends ChatChannelSubscriptionEvent
{
  final int? urlIndex;
  final String? roomId;
  ChatChannelMembersListResponseEvent({@required this.urlIndex, @required this.roomId});
}

class  ChatChannelGroupMembersListResponseEvent extends ChatChannelSubscriptionEvent
{
  final int? urlIndex;
  final String? roomId;
  ChatChannelGroupMembersListResponseEvent({@required this.urlIndex, @required this.roomId});
}

class  ChatChannelRemoveUserFromChannelResponseEvent extends ChatChannelSubscriptionEvent
{
  final Map<String, dynamic>? map;
  final int? urlIndex;
  ChatChannelRemoveUserFromChannelResponseEvent({@required this.urlIndex, @required this.map});
}

class  ChatChannelSetReactionResponseEvent extends ChatChannelSubscriptionEvent
{
  final Map<String, dynamic>? map;
  final int? urlIndex;
  ChatChannelSetReactionResponseEvent({@required this.urlIndex, @required this.map});
}

class  ChatChannelCreateVideoCTAChannelResponseEvent extends ChatChannelSubscriptionEvent
{
  final int? urlIndex;
  final String? authToken;
  final String? userId;
  final Map<String, dynamic>? map;
  ChatChannelCreateVideoCTAChannelResponseEvent({@required this.urlIndex, @required this.authToken, @required this.userId, @required this.map});
}

class  ChatChannelSetDescriptionResponseEvent extends ChatChannelSubscriptionEvent
{
  final String? chatUrl;
  final String? authToken;
  final String? userId;
  final Map<String, dynamic>? map;
  ChatChannelSetDescriptionResponseEvent({@required this.chatUrl, @required this.authToken, @required this.userId, @required this.map});
}

class  ChatChannelMakePrivateEvent extends ChatChannelSubscriptionEvent
{
  final String? chatUrl;
  final String? authToken;
  final String? userId;
  final Map<String, dynamic>? map;
  ChatChannelMakePrivateEvent({@required this.chatUrl, @required this.authToken, @required this.userId, @required this.map});
}

class  StartVideoEvent extends ChatChannelSubscriptionEvent
{
  final String? authToken;
  final String? userId;
  final Map<String, dynamic>? map;
  StartVideoEvent({@required this.authToken, @required this.userId, @required this.map});
}

class  AgoraTokenEvent extends ChatChannelSubscriptionEvent
{
  final Map<String, dynamic>? body;

  AgoraTokenEvent({this.body});
}
