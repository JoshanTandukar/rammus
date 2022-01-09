
import 'package:live/viewobject/model/username/ResponseUsername.dart';

abstract class UsernameValidationState{}

class InitialUsernameValidationState extends UsernameValidationState{}

class UsernameValidationErrorState extends UsernameValidationState{
  final String errorMessage;
  UsernameValidationErrorState(this.errorMessage);
}

class UsernameValidationProgressState extends UsernameValidationState{}

class UsernameValidationSuccessState extends UsernameValidationState{
  final ResponseUsername sendValidationResponse;
  UsernameValidationSuccessState(this.sendValidationResponse);
}