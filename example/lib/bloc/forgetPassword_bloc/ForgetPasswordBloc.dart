import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live/api/ApiService.dart';
import 'package:live/viewobject/model/forgetPassword/ForgetPassword.dart';

import 'ForgetPasswordEvent.dart';
import 'ForgetPasswordState.dart';

class ForgetPasswordBloc extends Bloc<ForgetPasswordEvent, ForgetPasswordState>
{
  ForgetPasswordBloc(ForgetPasswordState initialState) : super(initialState);

  @override
  Stream<ForgetPasswordState> mapEventToState(ForgetPasswordEvent event) async*
  {
    if (event is ForgetPasswordResponseEvent)
    {
      yield* doForgetPasswordApiCall(event.map);
    }
  }

  Stream<ForgetPasswordState> doForgetPasswordApiCall(Map<String,dynamic>? map) async*
  {
    ApiService apiProvider = ApiService();
    yield InitialForgetPasswordState();
    try
    {
      yield ForgetPasswordProgressState();
      ForgetPassword responseOtp = await apiProvider.forgetPassword(body: map);
      yield ForgetPasswordSuccessState(responseOtp);
    }
    catch (ex)
    {
      if (ex != "close")
      {
        yield ForgetPasswordErrorState(ex.toString());
      }
    }
  }
}
