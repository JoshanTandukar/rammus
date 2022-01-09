import 'package:live/viewobject/model/appInfo/AppInfo.dart';

abstract class GetAppInfoState{}

class InitialAppInfoState extends GetAppInfoState{}

class AppInfoErrorState extends GetAppInfoState{
  final String errorMessage;
  AppInfoErrorState(this.errorMessage);
}

class AppInfoProgressState extends GetAppInfoState{}

class AppInfoSuccessState extends GetAppInfoState{
  final AppInfo appInfo;
  AppInfoSuccessState(this.appInfo);
}