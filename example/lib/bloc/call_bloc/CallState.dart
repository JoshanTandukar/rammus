import 'package:live/viewobject/model/agoraToken/AgoraToken.dart';
import 'package:live/viewobject/model/signin/ResponseSignIn.dart';

abstract class CallState {}

class InitialCallState extends CallState {}

class CallErrorState extends CallState {
  final String errorMessage;
  CallErrorState(this.errorMessage);
}

class CallProgressState extends CallState {}

class AgoraSuccessState extends CallState {
  final AgoraToken? agoraToken;
  AgoraSuccessState(this.agoraToken);
}

class PushTypeSuccessState extends CallState {
  final ResponseSignIn? responseSignIn;
  PushTypeSuccessState(this.responseSignIn);
}
