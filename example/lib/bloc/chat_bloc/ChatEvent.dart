import 'package:flutter/cupertino.dart';

@immutable
abstract class ChatEvent {}

class ChatLoginEvent extends ChatEvent {
  final Map<String, dynamic>? map;
  ChatLoginEvent({@required this.map});
}

class ChatRegisterEvent extends ChatEvent {
  final Map<String, dynamic>? map;
  ChatRegisterEvent({@required this.map});
}

///unused only for testing
// class ChatCreateChannelEvent extends ChatEvent {
//   final Map<String, dynamic>? map;
//   ChatCreateChannelEvent({@required this.map});
// }

class ChatChannelMakePrivateEvent extends ChatEvent {
  final String? chatUrl;
  final String? authToken;
  final String? userId;
  final Map<String, dynamic>? map;
  ChatChannelMakePrivateEvent(
      {@required this.chatUrl,
      @required this.authToken,
      @required this.userId,
      @required this.map});
}

class ChatChannelJoinedEvent extends ChatEvent {
  ChatChannelJoinedEvent();
}

class ChatChannelEncryptionEvent extends ChatEvent {
  final Map<String, dynamic>? map;
  ChatChannelEncryptionEvent({@required this.map});
}

class ChatChannelChannelListResponseEvent extends ChatEvent {
  ChatChannelChannelListResponseEvent();
}

class ChatChannelJoinPublicChannelResponseEvent extends ChatEvent {
  final List<String>? map;
  ChatChannelJoinPublicChannelResponseEvent({@required this.map});
}

class ChatChannelCreateHealthRecordChannelResponseEvent extends ChatEvent {
  final Map<String, dynamic>? map;
  ChatChannelCreateHealthRecordChannelResponseEvent({@required this.map});
}

class ChatChannelSetDescriptionResponseEvent extends ChatEvent {
  final String? chatUrl;
  final String? authToken;
  final String? userId;
  final Map<String, dynamic>? map;
  ChatChannelSetDescriptionResponseEvent(
      {@required this.chatUrl,
      @required this.authToken,
      @required this.userId,
      @required this.map});
}

class ChatChannelUsersListResponseEvent extends ChatEvent {
  final int? urlIndex;
  ChatChannelUsersListResponseEvent({@required this.urlIndex});
}

class ChatChannelAddUserToChannelResponseEvent extends ChatEvent {
  final Map<String, dynamic>? map;
  final int? urlIndex;
  ChatChannelAddUserToChannelResponseEvent(
      {@required this.urlIndex, @required this.map});
}
