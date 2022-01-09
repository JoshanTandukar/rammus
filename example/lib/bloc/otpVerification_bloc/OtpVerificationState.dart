import 'package:live/viewobject/model/otp_verification/ResponseOtpVerification.dart';

abstract class OtpVerificationState{}

class InitialOtpVerificationState extends OtpVerificationState{}

class OtpVerificationErrorState extends OtpVerificationState{
  final String errorMessage;
  OtpVerificationErrorState(this.errorMessage);
}

class OtpVerificationProgressState extends OtpVerificationState{}

class OtpVerificationSuccessState extends OtpVerificationState{
  final ResponseOtpVerification otpVerificationResponse;
  OtpVerificationSuccessState(this.otpVerificationResponse);
}