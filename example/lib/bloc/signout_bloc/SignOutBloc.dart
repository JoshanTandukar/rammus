import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live/api/ApiService.dart';
import 'package:live/viewobject/model/signin/ResponseSignIn.dart';

import 'SignOutEvent.dart';
import 'SignOutState.dart';

class SignOutBloc extends Bloc<SignOutEvent, SignOutState>
{
  SignOutBloc(SignOutState initialState) : super(initialState);

  @override
  Stream<SignOutState> mapEventToState(SignOutEvent event) async*
  {
    if (event is SignOutResponseEvent)
    {
      yield* doSignOutApiCall();
    }
  }

  Stream<SignOutState> doSignOutApiCall() async*
  {
    ApiService apiProvider = ApiService();
    yield InitialSignOutState();
    try
    {
      yield SignOutProgressState();
      String responseSignOut = "";
      print("this is logout2");
      responseSignOut =await apiProvider.doUserSignOutApiCall();
      yield SignOutSuccessState(responseSignOut);
    }
    catch (ex)
    {
      print(ex.toString());
      if (ex != "close")
      {
        yield SignOutErrorState(ex.toString());
      }
    }
  }
}
