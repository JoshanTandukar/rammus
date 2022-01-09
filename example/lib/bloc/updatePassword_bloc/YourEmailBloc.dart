import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live/api/ApiService.dart';
import 'package:live/viewobject/model/updatePassword/UpdatePassword.dart';
import 'YourEmailEvent.dart';
import 'YourEmailState.dart';

class UpdatePasswordBloc extends Bloc<UpdatePasswordEvent, UpdatePasswordState>
{
  UpdatePasswordBloc(UpdatePasswordState initialState) : super(initialState);

  @override
  Stream<UpdatePasswordState> mapEventToState(UpdatePasswordEvent event) async*
  {
    if (event is UpdatePasswordResponseEvent)
    {
      yield* doUpdatePasswordApiCall(event.map);
    }
  }

  Stream<UpdatePasswordState> doUpdatePasswordApiCall(Map<String,dynamic>? map) async*
  {
    ApiService apiProvider = ApiService();
    yield InitialUpdatePasswordState();
    try
    {
      yield UpdatePasswordProgressState();
      UpdatePassword responseOtp = await apiProvider.updatePassword(body: map);
      yield UpdatePasswordSuccessState(responseOtp);
    }
    catch (ex)
    {
      if (ex != "close")
      {
        yield UpdatePasswordErrorState(ex.toString());
      }
    }
  }
}
