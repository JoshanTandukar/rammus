
import 'package:live/viewobject/model/responseYourName/ResponseYourName.dart';

abstract class YourNameState{}

class InitialYourNameState extends YourNameState{}

class YourNameErrorState extends YourNameState{
  final String errorMessage;
  YourNameErrorState(this.errorMessage);
}

class YourNameProgressState extends YourNameState{}

class YourNameSuccessState extends YourNameState{
  final ResponseYourName yourNameResponse;
  YourNameSuccessState(this.yourNameResponse);
}