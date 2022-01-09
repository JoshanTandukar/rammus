import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live/api/ApiService.dart';
import 'package:live/bloc/yourEmail_bloc/YourEmailEvent.dart';
import 'package:live/bloc/yourEmail_bloc/YourEmailState.dart';
import 'package:live/viewobject/model/responseYourEmail/ResponseYourEmail.dart';

class YourEmailBloc extends Bloc<YourEmailEvent, YourEmailState>
{
  YourEmailBloc(YourEmailState initialState) : super(initialState);

  @override
  Stream<YourEmailState> mapEventToState(YourEmailEvent event) async*
  {
    if (event is YourEmailResponseEvent)
    {
      yield* doYourEmailApiCall(event.map);
    }
  }

  Stream<YourEmailState> doYourEmailApiCall(Map<String,dynamic>? map) async*
  {
    ApiService apiProvider = ApiService();
    yield InitialYourEmailState();
    try
    {
      yield YourEmailProgressState();
      ResponseYourEmail responseOtp = await apiProvider.doYourEmailApiCall(map: map);
      yield YourEmailSuccessState(responseOtp);
    }
    catch (ex)
    {
      if (ex != "close")
      {
        yield YourEmailErrorState(ex.toString());
      }
    }
  }
}
