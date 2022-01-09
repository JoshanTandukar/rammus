
import 'package:live/viewobject/model/responseYourEmail/ResponseYourEmail.dart';

abstract class YourEmailState{}

class InitialYourEmailState extends YourEmailState{}

class YourEmailErrorState extends YourEmailState{
  final String errorMessage;
  YourEmailErrorState(this.errorMessage);
}

class YourEmailProgressState extends YourEmailState{}

class YourEmailSuccessState extends YourEmailState{
  final ResponseYourEmail responseYourEmail;
  YourEmailSuccessState(this.responseYourEmail);
}