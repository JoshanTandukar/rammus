
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live/api/ApiService.dart';
import 'package:live/viewobject/model/responseRegister/ResponseRegister.dart';

import 'RegisterEvent.dart';
import 'RegisterState.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc(RegisterState initialState) : super(initialState);

  @override
  Stream<RegisterState> mapEventToState(RegisterEvent event) async* {
    if (event is RegisterResponseEvent) {
      yield* doRegisterApiCall(event.body);
    }
  }

  Stream<RegisterState> doRegisterApiCall(Map<String,dynamic>? map) async* {
    ApiService apiProvider = ApiService();
    yield InitialRegisterState();
    try {
      yield RegisterProgressState();
      ResponseRegister registerResponse = await apiProvider.doUserRegisterApiCall(map: map);
      yield RegisterSuccessState(registerResponse);
    } catch (ex) {
      if (ex != "close") {
        yield RegisterErrorState(ex.toString());
      }
    }
  }
}
