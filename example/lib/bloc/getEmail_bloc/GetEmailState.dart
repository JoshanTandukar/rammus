import 'package:live/viewobject/model/appInfo/AppInfo.dart';

abstract class GetEmailState{}

class InitialGetEmailState extends GetEmailState{}

class GetEmailErrorState extends GetEmailState{
  final String errorMessage;
  GetEmailErrorState(this.errorMessage);
}

class GetEmailProgressState extends GetEmailState{}

class GetEmailSuccessState extends GetEmailState{
  final Map getEmailResponse;
  GetEmailSuccessState(this.getEmailResponse);
}