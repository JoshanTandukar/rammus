import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live/api/ApiService.dart';
import 'package:live/bloc/appInfo_bloc/AppInfoEvent.dart';
import 'package:live/bloc/appInfo_bloc/AppInfoState.dart';
import 'package:live/viewobject/model/appInfo/AppInfo.dart';

class AppInfoBloc extends Bloc<GetAppInfoEvent, GetAppInfoState> {
  AppInfoBloc(GetAppInfoState initialState) : super(initialState);


  @override
  Stream<GetAppInfoState> mapEventToState(GetAppInfoEvent event) async* {
    if (event is GetAppInfoEvent) {
      yield* doAppInfoApiCall();
    }
  }

  Stream<GetAppInfoState> doAppInfoApiCall() async* {
    ApiService apiProvider = ApiService();
    yield InitialAppInfoState();
    try {
      AppInfo appInfo = await apiProvider.doVersionApiCall();
      yield AppInfoSuccessState(appInfo);
    } catch (ex) {
      if (ex != "close") {
        yield AppInfoErrorState(ex.toString());
      }
    }
  }
}
