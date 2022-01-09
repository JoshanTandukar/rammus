
import 'package:live/viewobject/model/forgetPassword/ForgetPassword.dart';
import 'package:live/viewobject/model/responseYourEmail/ResponseYourEmail.dart';

abstract class ForgetPasswordState{}

class InitialForgetPasswordState extends ForgetPasswordState{}

class ForgetPasswordErrorState extends ForgetPasswordState{
  final String errorMessage;
  ForgetPasswordErrorState(this.errorMessage);
}

class ForgetPasswordProgressState extends ForgetPasswordState{}

class ForgetPasswordSuccessState extends ForgetPasswordState{
  final ForgetPassword forgetPassword;
  ForgetPasswordSuccessState(this.forgetPassword);
}