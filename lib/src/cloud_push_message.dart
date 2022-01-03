class CloudPushMessage {
  final String? messageId;
  final String? appId;
  final String? title;
  final Map? content;
  final String? traceInfo;
  final String? summary;
  final Map? extras;

  CloudPushMessage(
      {this.messageId,
      this.appId,
      this.title,
      this.content,
      this.traceInfo,
      this.summary,
      this.extras});
}

class OnNotificationOpened {
  final String? title;
  final String? summary;
  final String? extras;
  final String? subtitle;
  final int? badge;

  OnNotificationOpened(
      this.title, this.summary, this.extras, this.subtitle, this.badge);
}

class OnNotificationClickedWithNoAction {
  final String? title;
  final String? summary;
  final Map? extras;

  OnNotificationClickedWithNoAction(this.title, this.summary, this.extras);
}

class OnNotificationReceivedInApp {
  final String? title;
  final String? summary;
  final Map? extras;
  final int? openType;
  final String? openActivity;
  final String? openUrl;

  OnNotificationReceivedInApp(this.title, this.summary, this.extras,
      this.openType, this.openActivity, this.openUrl);
}
