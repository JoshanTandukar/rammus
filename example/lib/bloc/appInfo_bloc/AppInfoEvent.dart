
abstract class GetAppInfoEvent{}

class AppInfoEvent extends GetAppInfoEvent{
  final String link,token;
  AppInfoEvent(this.link, this.token);
}