import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live/api/ApiService.dart';
import 'package:live/bloc/yourName_bloc/YourNameEvent.dart';
import 'package:live/bloc/yourName_bloc/YourNameState.dart';
import 'package:live/viewobject/model/responseYourName/ResponseYourName.dart';

class YourNameBloc extends Bloc<YourNameEvent, YourNameState>
{
  YourNameBloc(YourNameState initialState) : super(initialState);

  @override
  Stream<YourNameState> mapEventToState(YourNameEvent event) async*
  {
    if (event is YourNameResponseEvent)
    {
      yield* doYourNameApiCall(event.map);
    }
  }

  Stream<YourNameState> doYourNameApiCall(Map<String,dynamic>? map) async*
  {
    ApiService apiProvider = ApiService();
    yield InitialYourNameState();
    try
    {
      yield YourNameProgressState();
      ResponseYourName responseOtp = await apiProvider.doYourNameApiCall(map: map);
      yield YourNameSuccessState(responseOtp);
    }
    catch (ex)
    {
      if (ex != "close")
      {
        yield YourNameErrorState(ex.toString());
      }
    }
  }
}
