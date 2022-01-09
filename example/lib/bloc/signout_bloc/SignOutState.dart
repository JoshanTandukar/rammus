
import 'package:live/viewobject/model/signin/ResponseSignIn.dart';

abstract class SignOutState{}

class InitialSignOutState extends SignOutState{}

class SignOutErrorState extends SignOutState{
  final String errorMessage;
  SignOutErrorState(this.errorMessage);
}

class SignOutProgressState extends SignOutState{}

class SignOutSuccessState extends SignOutState{
  final String responseSignOut;
  SignOutSuccessState(this.responseSignOut);
}