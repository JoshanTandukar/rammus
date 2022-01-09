
import 'package:live/viewobject/model/otp/ResponseOtp.dart';

abstract class OtpState{}

class InitialOtpState extends OtpState{}

class OtpErrorState extends OtpState{
  final String errorMessage;
  OtpErrorState(this.errorMessage);
}

class OtpProgressState extends OtpState{}

class OtpSuccessState extends OtpState{
  final ResponseOtp otpResponse;
  OtpSuccessState(this.otpResponse);
}