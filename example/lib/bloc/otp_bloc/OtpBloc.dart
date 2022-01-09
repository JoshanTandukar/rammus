import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live/api/ApiService.dart';
import 'package:live/bloc/otp_bloc/OtpEvent.dart';
import 'package:live/bloc/otp_bloc/OtpState.dart';
import 'package:live/viewobject/model/otp/ResponseOtp.dart';

class OtpBloc extends Bloc<OtpEvent, OtpState>
{
  OtpBloc(OtpState initialState) : super(initialState);

  @override
  Stream<OtpState> mapEventToState(OtpEvent event) async*
  {
    if (event is OtpResponseEvent)
    {
      yield* doOtpApiCall(event.map);
    }
  }

  Stream<OtpState> doOtpApiCall(Map<String,dynamic>? map) async*
  {
    print("Otp bloc");
    ApiService apiProvider = ApiService();
    yield InitialOtpState();
    try
    {
      print("Otp initial state");
      yield OtpProgressState();
      print("Otp progress state");

      ResponseOtp responseOtp = await apiProvider.doOtpApiCall(map: map);
      print("Otp success state");

      yield OtpSuccessState(responseOtp);
    }
    catch (ex)
    {
      if (ex != "close")
      {
        yield OtpErrorState(ex.toString());
      }
    }
  }
}
