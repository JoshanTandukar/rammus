import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live/api/ApiService.dart';
import 'package:live/bloc/birthday_bloc/BirthdayEvent.dart';
import 'package:live/bloc/birthday_bloc/BirthdayState.dart';
import 'package:live/viewobject/model/birthday/ResponseBirthday.dart';

class BirthdayBloc extends Bloc<BirthdayEvent, BirthdayState>
{
  BirthdayBloc(BirthdayState initialState) : super(initialState);

  @override
  Stream<BirthdayState> mapEventToState(BirthdayEvent event) async*
  {
    if (event is BirthdayResponseEvent)
    {
      yield* doBirthdayApiCall(event.map);
    }
    if(event is BusinessTypeResponseEvent)
    {
      yield* doBusinessTypeApiCall(event.map);
    }
  }

  Stream<BirthdayState> doBirthdayApiCall(Map<String,dynamic>? map) async*
  {
    print("Otp bloc");
    ApiService apiProvider = ApiService();
    yield InitialBirthdayState();
    try
    {
      print("Otp initial state");
      yield BirthdayProgressState();
      print("Otp progress state");

      ResponseBirthday responseOtp = await apiProvider.doBirthdayApiCall(map: map);
      print("Otp success state");

      yield BirthdaySuccessState(responseOtp);
    }
    catch (ex)
    {
      if (ex != "close")
      {
        yield BirthdayErrorState(ex.toString());
      }
    }
  }

  Stream<BirthdayState> doBusinessTypeApiCall(Map<String,dynamic>? map) async*
  {
    print("Otp bloc");
    ApiService apiProvider = ApiService();
    yield InitialBirthdayState();
    try
    {
      print("Otp initial state");
      yield BirthdayProgressState();
      print("Otp progress state");

      ResponseBirthday responseBusinessType = await apiProvider.doBusinessTypeApiCall(map: map);
      print("Otp success state");

      yield BirthdaySuccessState(responseBusinessType);
    }
    catch (ex)
    {
      if (ex != "close")
      {
        yield BirthdayErrorState(ex.toString());
      }
    }
  }
}
