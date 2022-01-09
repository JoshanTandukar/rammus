import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live/api/ApiService.dart';
import 'package:live/bloc/userNameValidation_bloc/UsernameValidationEvent.dart';
import 'package:live/bloc/userNameValidation_bloc/UsernameValidationState.dart';
import 'package:live/viewobject/model/username/ResponseUsername.dart';

class UserNameValidationBloc extends Bloc<UsernameValidationEvent, UsernameValidationState> {
  UserNameValidationBloc(InitialUsernameValidationState initialState) : super(initialState);

  @override
  Stream<UsernameValidationState> mapEventToState(UsernameValidationEvent event) async*
  {
    if (event is DoUsernameValidationEvent)
    {
      yield* doUsernameVerifyApiCall(event.map);
    }
  }

  Stream<UsernameValidationState> doUsernameVerifyApiCall(Map<String,dynamic>? map) async*
  {
    ApiService apiProvider = ApiService();
    yield InitialUsernameValidationState();
    try
    {
      yield UsernameValidationProgressState();
      ResponseUsername sendValidationResponse = await apiProvider.doUsernameVerifyApiCall(map: map);
      yield UsernameValidationSuccessState(sendValidationResponse);
    }
    catch (ex)
    {
      if (ex != "close") {
        yield UsernameValidationErrorState(ex.toString());
      }
    }
  }
}
