class ChatLoginUserResponse
{
  String? status;
  Data? data;

  ChatLoginUserResponse({this.status, this.data});

  ChatLoginUserResponse.fromJson(Map<String, dynamic> json)
  {
    status = json['status'];
    data = json['data'] != null ?  Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson()
  {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null)
    {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data
{
  String? userId;
  String? authToken;
  Me? me;

  Data({this.userId, this.authToken, this.me});

  Data.fromJson(Map<String, dynamic> json)
  {
    userId = json['userId'];
    authToken = json['authToken'];
    me = json['me'] != null ?  Me.fromJson(json['me']) : null;
  }

  Map<String, dynamic> toJson()
  {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['userId'] = this.userId;
    data['authToken'] = this.authToken;
    if (this.me != null)
    {
      data['me'] = this.me!.toJson();
    }
    return data;
  }
}

class Me
{
  String? sId;
  Services? services;
  List<Emails>? emails;
  String? status;
  bool? active;
  String? sUpdatedAt;
  List<String>? roles;
  String? name;
  String? username;
  String? statusConnection;
  double? utcOffset;
  String? avatarUrl;
  Settings? settings;

  Me({
    this.sId,
    this.services,
    this.emails,
    this.status,
    this.active,
    this.sUpdatedAt,
    this.roles,
    this.name,
    this.username,
    this.statusConnection,
    this.utcOffset,
    this.avatarUrl,
    this.settings
  });

  Me.fromJson(Map<String, dynamic> json)
  {
    sId = json['_id'];
    services = json['services'] != null ?  Services.fromJson(json['services']) : null;
    if (json['emails'] != null)
    {
      emails =  <Emails>[];
      json['emails'].forEach((v)
      {
        emails!.add( Emails.fromJson(v));
      });
    }
    status = json['status'];
    active = json['active'];
    sUpdatedAt = json['_updatedAt'];
    roles = json['roles'].cast<String>();
    name = json['name'];
    username = json['username'];
    statusConnection = json['statusConnection'];
    utcOffset = json['utcOffset'];
    avatarUrl = json['avatarUrl'];
    settings = json['settings'] != null ?  Settings.fromJson(json['settings']) : null;
  }

  Map<String, dynamic> toJson()
  {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.services != null)
    {
      data['services'] = this.services!.toJson();
    }
    if (this.emails != null)
    {
      data['emails'] = this.emails!.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    data['active'] = this.active;
    data['_updatedAt'] = this.sUpdatedAt;
    data['roles'] = this.roles;
    data['name'] = this.name;
    data['username'] = this.username;
    data['statusConnection'] = this.statusConnection;
    data['utcOffset'] = this.utcOffset;
    data['avatarUrl'] = this.avatarUrl;
    if (this.settings != null)
    {
      data['settings'] = this.settings!.toJson();
    }
    return data;
  }
}

class Services
{
  Password? password;
  Email2fa? email2fa;

  Services({this.password, this.email2fa});

  Services.fromJson(Map<String, dynamic> json)
  {
    password = json['password'] != null ?  Password.fromJson(json['password']) : null;
    email2fa = json['email2fa'] != null ?  Email2fa.fromJson(json['email2fa']) : null;
  }

  Map<String, dynamic> toJson()
  {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    if (this.password != null)
    {
      data['password'] = this.password!.toJson();
    }
    if (this.email2fa != null)
    {
      data['email2fa'] = this.email2fa!.toJson();
    }
    return data;
  }
}

class Password
{
  String? bCrypt;

  Password({this.bCrypt});

  Password.fromJson(Map<String, dynamic> json)
  {
    bCrypt = json['bcrypt'];
  }

  Map<String, dynamic> toJson()
  {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['bcrypt'] = this.bCrypt;
    return data;
  }
}

class Email2fa
{
  bool? enabled;

  Email2fa({this.enabled});

  Email2fa.fromJson(Map<String, dynamic> json)
  {
    enabled = json['enabled'];
  }

  Map<String, dynamic> toJson()
  {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['enabled'] = this.enabled;
    return data;
  }
}

class Emails
{
  String? address;
  bool? verified;

  Emails({this.address, this.verified});

  Emails.fromJson(Map<String, dynamic> json)
  {
    address = json['address'];
    verified = json['verified'];
  }

  Map<String, dynamic> toJson()
  {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['address'] = this.address;
    data['verified'] = this.verified;
    return data;
  }
}

class Settings
{
  Preferences? preferences;

  Settings({this.preferences});

  Settings.fromJson(Map<String, dynamic> json)
  {
    preferences = json['preferences'] != null ?  Preferences.fromJson(json['preferences']) : null;
  }

  Map<String, dynamic> toJson()
  {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    if (this.preferences != null)
    {
      data['preferences'] = this.preferences!.toJson();
    }
    return data;
  }
}

class Preferences
{
  bool? enableAutoAway;
  int? idleTimeLimit;
  bool? desktopNotificationRequireInteraction;
  String? audioNotifications;
  String? desktopNotifications;
  String? mobileNotifications;
  bool? unreadAlert;
  bool? useEmojis;
  bool? convertAsciiEmoji;
  bool? autoImageLoad;
  bool? saveMobileBandwidth;
  bool? collapseMediaByDefault;
  bool? hideUserNames;
  bool? hideRoles;
  bool? hideFlexTab;
  bool? displayAvatars;
  bool? sidebarGroupByType;
  String? sidebarViewMode;
  bool? sidebarDisplayAvatar;
  bool? sidebarShowUnread;
  String? sidebarSortby;
  bool? showMessageInMainThread;
  bool? sidebarShowFavorites;
  String? sendOnEnter;
  int? messageViewMode;
  String? emailNotificationMode;
  String? newRoomNotification;
  String? newMessageNotification;
  bool? muteFocusedConversations;
  int? notificationsSoundVolume;
  bool? enableMessageParserEarlyAdoption;

  Preferences({
    this.enableAutoAway,
    this.idleTimeLimit,
    this.desktopNotificationRequireInteraction,
    this.audioNotifications,
    this.desktopNotifications,
    this.mobileNotifications,
    this.unreadAlert,
    this.useEmojis,
    this.convertAsciiEmoji,
    this.autoImageLoad,
    this.saveMobileBandwidth,
    this.collapseMediaByDefault,
    this.hideUserNames,
    this.hideRoles,
    this.hideFlexTab,
    this.displayAvatars,
    this.sidebarGroupByType,
    this.sidebarViewMode,
    this.sidebarDisplayAvatar,
    this.sidebarShowUnread,
    this.sidebarSortby,
    this.showMessageInMainThread,
    this.sidebarShowFavorites,
    this.sendOnEnter,
    this.messageViewMode,
    this.emailNotificationMode,
    this.newRoomNotification,
    this.newMessageNotification,
    this.muteFocusedConversations,
    this.notificationsSoundVolume,
    this.enableMessageParserEarlyAdoption
  });

  Preferences.fromJson(Map<String, dynamic> json)
  {
    enableAutoAway = json['enableAutoAway'];
    idleTimeLimit = json['idleTimeLimit'];
    desktopNotificationRequireInteraction = json['desktopNotificationRequireInteraction'];
    audioNotifications = json['audioNotifications'];
    desktopNotifications = json['desktopNotifications'];
    mobileNotifications = json['mobileNotifications'];
    unreadAlert = json['unreadAlert'];
    useEmojis = json['useEmojis'];
    convertAsciiEmoji = json['convertAsciiEmoji'];
    autoImageLoad = json['autoImageLoad'];
    saveMobileBandwidth = json['saveMobileBandwidth'];
    collapseMediaByDefault = json['collapseMediaByDefault'];
    hideUserNames = json['hideUsernames'];
    hideRoles = json['hideRoles'];
    hideFlexTab = json['hideFlexTab'];
    displayAvatars = json['displayAvatars'];
    sidebarGroupByType = json['sidebarGroupByType'];
    sidebarViewMode = json['sidebarViewMode'];
    sidebarDisplayAvatar = json['sidebarDisplayAvatar'];
    sidebarShowUnread = json['sidebarShowUnread'];
    sidebarSortby = json['sidebarSortby'];
    showMessageInMainThread = json['showMessageInMainThread'];
    sidebarShowFavorites = json['sidebarShowFavorites'];
    sendOnEnter = json['sendOnEnter'];
    messageViewMode = json['messageViewMode'];
    emailNotificationMode = json['emailNotificationMode'];
    newRoomNotification = json['newRoomNotification'];
    newMessageNotification = json['newMessageNotification'];
    muteFocusedConversations = json['muteFocusedConversations'];
    notificationsSoundVolume = json['notificationsSoundVolume'];
    enableMessageParserEarlyAdoption = json['enableMessageParserEarlyAdoption'];
  }

  Map<String, dynamic> toJson()
  {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['enableAutoAway'] = this.enableAutoAway;
    data['idleTimeLimit'] = this.idleTimeLimit;
    data['desktopNotificationRequireInteraction'] = this.desktopNotificationRequireInteraction;
    data['audioNotifications'] = this.audioNotifications;
    data['desktopNotifications'] = this.desktopNotifications;
    data['mobileNotifications'] = this.mobileNotifications;
    data['unreadAlert'] = this.unreadAlert;
    data['useEmojis'] = this.useEmojis;
    data['convertAsciiEmoji'] = this.convertAsciiEmoji;
    data['autoImageLoad'] = this.autoImageLoad;
    data['saveMobileBandwidth'] = this.saveMobileBandwidth;
    data['collapseMediaByDefault'] = this.collapseMediaByDefault;
    data['hideUsernames'] = this.hideUserNames;
    data['hideRoles'] = this.hideRoles;
    data['hideFlexTab'] = this.hideFlexTab;
    data['displayAvatars'] = this.displayAvatars;
    data['sidebarGroupByType'] = this.sidebarGroupByType;
    data['sidebarViewMode'] = this.sidebarViewMode;
    data['sidebarDisplayAvatar'] = this.sidebarDisplayAvatar;
    data['sidebarShowUnread'] = this.sidebarShowUnread;
    data['sidebarSortby'] = this.sidebarSortby;
    data['showMessageInMainThread'] = this.showMessageInMainThread;
    data['sidebarShowFavorites'] = this.sidebarShowFavorites;
    data['sendOnEnter'] = this.sendOnEnter;
    data['messageViewMode'] = this.messageViewMode;
    data['emailNotificationMode'] = this.emailNotificationMode;
    data['newRoomNotification'] = this.newRoomNotification;
    data['newMessageNotification'] = this.newMessageNotification;
    data['muteFocusedConversations'] = this.muteFocusedConversations;
    data['notificationsSoundVolume'] = this.notificationsSoundVolume;
    data['enableMessageParserEarlyAdoption'] = this.enableMessageParserEarlyAdoption;
    return data;
  }
}