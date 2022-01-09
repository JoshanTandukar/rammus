import 'package:live/viewobject/model/responseRegister/ResponseRegister.dart';

abstract class RegisterState{}

class InitialRegisterState extends RegisterState{}

class RegisterErrorState extends RegisterState{
  final String errorMessage;
  RegisterErrorState(this.errorMessage);
}

class RegisterProgressState extends RegisterState{}

class RegisterSuccessState extends RegisterState{
  final ResponseRegister registerResponse;
  RegisterSuccessState(this.registerResponse);
}