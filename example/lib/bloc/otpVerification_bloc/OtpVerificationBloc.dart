import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live/api/ApiService.dart';
import 'package:live/bloc/otpVerification_bloc/OtpVerificationEvent.dart';
import 'package:live/bloc/otpVerification_bloc/OtpVerificationState.dart';
import 'package:live/viewobject/model/otp_verification/ResponseOtpVerification.dart';

class OtpVerificationBloc extends Bloc<OtpVerificationEvent, OtpVerificationState>
{
  OtpVerificationBloc(OtpVerificationState initialState) : super(initialState);

  @override
  Stream<OtpVerificationState> mapEventToState(OtpVerificationEvent event) async*
  {
    if (event is OtpVerificationResponseEvent)
    {
      yield* doOtpVerificationApiCall(event.map);
    }
  }

  Stream<OtpVerificationState> doOtpVerificationApiCall(Map<String,dynamic>? map) async*
  {
    print("Otp bloc");
    ApiService apiProvider = ApiService();
    yield InitialOtpVerificationState();
    try
    {
      print("Otp initial state");
      yield OtpVerificationProgressState();
      print("Otp progress state");

      ResponseOtpVerification responseOtp = await apiProvider.doOtpVerificationApiCall(map: map);
      print("Otp success state");

      yield OtpVerificationSuccessState(responseOtp);
    }
    catch (ex)
    {
      if (ex != "close")
      {
        yield OtpVerificationErrorState(ex.toString());
      }
    }
  }
}
