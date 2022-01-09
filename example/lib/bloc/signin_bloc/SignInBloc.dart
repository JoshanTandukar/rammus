import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live/api/ApiService.dart';
import 'package:live/viewobject/model/signin/ResponseSignIn.dart';

import 'SignInEvent.dart';
import 'SignInState.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState>
{
  SignInBloc(SignInState initialState) : super(initialState);

  @override
  Stream<SignInState> mapEventToState(SignInEvent event) async*
  {
    if (event is SignInResponseEvent)
    {
      yield* doSignInApiCall(event.map);
    }
  }

  Stream<SignInState> doSignInApiCall(Map<String,dynamic>? map) async*
  {
    print("this is signin param $map");
    ApiService apiProvider = ApiService();
    yield InitialSignInState();
    try
    {
      yield SignInProgressState();
      ResponseSignIn responseSignIn = await apiProvider.doUserSignInApiCall(body: map);
      print(responseSignIn.toJson().toString());
      yield SignInSuccessState(responseSignIn);
    }
    catch (ex)
    {
      print(ex.toString());
      if (ex != "close")
      {
        yield SignInErrorState(ex.toString());
      }
    }
  }
}
