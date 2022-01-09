
import 'package:live/viewobject/model/birthday/ResponseBirthday.dart';

abstract class BirthdayState{}

class InitialBirthdayState extends BirthdayState{}

class BirthdayErrorState extends BirthdayState{
  final String errorMessage;
  BirthdayErrorState(this.errorMessage);
}

class BirthdayProgressState extends BirthdayState{}

class BirthdaySuccessState extends BirthdayState{
  final ResponseBirthday birthdayResponse;
  BirthdaySuccessState(this.birthdayResponse);
}