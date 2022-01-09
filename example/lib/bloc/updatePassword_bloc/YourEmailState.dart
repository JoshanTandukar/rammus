
import 'package:live/viewobject/model/responseYourEmail/ResponseYourEmail.dart';
import 'package:live/viewobject/model/updatePassword/UpdatePassword.dart';

abstract class UpdatePasswordState{}

class InitialUpdatePasswordState extends UpdatePasswordState{}

class UpdatePasswordErrorState extends UpdatePasswordState{
  final String errorMessage;
  UpdatePasswordErrorState(this.errorMessage);
}

class UpdatePasswordProgressState extends UpdatePasswordState{}

class UpdatePasswordSuccessState extends UpdatePasswordState{
  final UpdatePassword updatePassword;
  UpdatePasswordSuccessState(this.updatePassword);
}