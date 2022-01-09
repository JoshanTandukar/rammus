import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live/api/ApiService.dart';
import 'package:live/bloc/getAdmins_bloc/GetAdminsEvent.dart';
import 'package:live/bloc/getAdmins_bloc/GetAdminsState.dart';
import 'package:live/bloc/getEmail_bloc/GetEmailEvent.dart';
import 'package:live/viewobject/model/admins/ResponseAdmin.dart';

class GetAdminsBloc extends Bloc<GetAdminsEvent, GetAdminsState> {
  GetAdminsBloc(GetAdminsState initialState) : super(initialState);

  @override
  Stream<GetAdminsState> mapEventToState(GetAdminsEvent event) async* {
    if (event is EmailEvent) {
      yield* doGetAdminsApiCall();
    }
  }

  Stream<GetAdminsState> doGetAdminsApiCall() async* {
    ApiService apiProvider = ApiService();
    yield InitialGetAdminsState();
    try {
      yield GetAdminsProgressState();
      ResponseAdmin responseAdmin = await apiProvider.doAdminsApiCall();
      yield GetAdminsSuccessState(responseAdmin);
    } catch (ex) {
      if (ex != "close") {
        yield GetAdminsErrorState(ex.toString());
      }
    }
  }
}
