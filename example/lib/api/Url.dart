class Url {
  Url._();

  static const String verification_send = '/mobile-number';
  static const String verification_verify = '/verification/verify';
  static const String your_name = '/name';
  static const String your_email = '/invitation/email/verify';
  static const String birthday = '/date-of-birth';
  static const String password = '/password-validation';

  static const String username = '/user-name';

  static const String verify_email = '/invitation/email/verify';

  static const String auth_signin = '/invitation/email/verify';
  static const String sass_domain = '/saas/domain';
  static const String business_type = '/businesstype';
  static const String update_password = '/update-password';
  static const String forget_password = '/forgot-password';
  static const String sign_in = '/sign-in';
  static const String start_video = '/session/start-video';
  static const String agora_token = '/session/agora-token';
  static const String reset_notification_token = '/reset-notification-token';
  static const String admins = '/admins';
  static const String update_push_notification_detail =
      '/update-push-notification-detail';

  static const String rocketChatRegister = '/api/v1/users.register';
  static const String rocketChatLogin = '/api/v1/login';
  static const String rocketChatCreateChannel = '/api/v1/channels.create';
  static const String rocketChatChannelSetDescription =
      '/api/v1/channels.setDescription';
  static const String rocketChatCreateTeam = '/api/v1/teams.create';
  static const String rocketChatChannelMakePrivate = '/api/v1/channels.setType';
  static const String rocketChatChannelJoined = '/api/v1/channels.list.joined';
  static const String rocketChatChannelGroupJoined = '/api/v1/groups.list';
  static const String rocketChatChannelEncryption =
      '/api/v1/e2e.setUserPublicAndPrivateKeys';
  static const String rocketChatChannelSendMessage = '/api/v1/chat.sendMessage';
  static const String rocketChatChannelMessageHistory =
      '/api/v1/channels.history';
  static const String rocketChatUploadFile = '/api/v1/rooms.upload/';
  static const String rocketChatLeaveRoom = '/api/v1/rooms.leave';
  static const String rocketChatDeletePublicRoom = '/api/v1/channels.delete';
  static const String rocketChatDeletePrivateRoom = '/api/v1/groups.delete';
  static const String rocketChatGetUsersList = '/api/v1/users.list';
  static const String rocketChatAddUserToChannel = '/api/v1/channels.invite';
  static const String rocketChatGetMembersList = '/api/v1/channels.members';
  static const String rocketChatGetGroupMembersList = '/api/v1/groups.members';
  static const String rocketChatRemoveUserFromChannel = '/api/v1/channels.kick';
  static const String rocketChatChannelPublicChannelList =
      '/api/v1/channels.list';
  static const String rocketChatChannelJoinPublicChannel =
      '/api/v1/channels.join';
  static const String rocketChatSetReaction = '/api/v1/chat.react';

  static const String ps_user_url = 'rest/users/get';
  static const String ps_userinfo_url = 'userinfo';
}
