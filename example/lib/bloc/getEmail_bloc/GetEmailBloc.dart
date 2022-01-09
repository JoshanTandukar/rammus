



import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live/api/ApiService.dart';
import 'package:live/bloc/appInfo_bloc/AppInfoEvent.dart';
import 'package:live/bloc/appInfo_bloc/AppInfoState.dart';
import 'package:live/bloc/getEmail_bloc/GetEmailEvent.dart';
import 'package:live/bloc/getEmail_bloc/GetEmailState.dart';

class GetEmailBloc extends Bloc<GetEmailEvent, GetEmailState>
{
  GetEmailBloc(GetEmailState initialState) : super(initialState);

  @override
  Stream<GetEmailState> mapEventToState(GetEmailEvent event) async* {
    if (event is EmailEvent) {
      yield* doGetEmailApiCall(event.body);
    }
  }

  Stream<GetEmailState> doGetEmailApiCall(Map<String,dynamic>? body) async* {
    ApiService apiProvider = ApiService();
    yield InitialGetEmailState();
    try {
      yield GetEmailProgressState();
      Map getEmailResponse = await apiProvider.getEmailApiCall(body: body);
      yield GetEmailSuccessState(getEmailResponse);
    } catch (ex) {
      if (ex != "close") {
        yield GetEmailErrorState(ex.toString());
      }
    }
  }
}
