
import 'package:live/viewobject/model/signin/ResponseSignIn.dart';

abstract class SignInState{}

class InitialSignInState extends SignInState{}

class SignInErrorState extends SignInState{
  final String errorMessage;
  SignInErrorState(this.errorMessage);
}

class SignInProgressState extends SignInState{}

class SignInSuccessState extends SignInState{
  final ResponseSignIn responseSignIn;
  SignInSuccessState(this.responseSignIn);
}