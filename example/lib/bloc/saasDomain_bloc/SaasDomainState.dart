import 'package:live/viewobject/model/appInfo/AppInfo.dart';

abstract class SaasDomainState{}

class InitialSaasDomainState extends SaasDomainState{}

class SaasDomainErrorState extends SaasDomainState{
  final String errorMessage;
  SaasDomainErrorState(this.errorMessage);
}

class SaasDomainProgressState extends SaasDomainState{}

class SaasDomainSuccessState extends SaasDomainState{
  final Map saasDomainResponse;
  SaasDomainSuccessState(this.saasDomainResponse);
}