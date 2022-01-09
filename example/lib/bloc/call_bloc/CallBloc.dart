import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live/api/ApiService.dart';
import 'package:live/bloc/call_bloc/CallEvent.dart';
import 'package:live/bloc/call_bloc/CallState.dart';
import 'package:live/viewobject/model/agoraToken/AgoraToken.dart';
import 'package:live/viewobject/model/signin/ResponseSignIn.dart';

class CallBloc extends Bloc<CallEvent, CallState> {
  // WebSocketChannel? webSocketChannel;

  CallBloc(CallState initialState) : super(initialState);

  @override
  Stream<CallState> mapEventToState(CallEvent event) async* {
    if (event is AgoraEvent) {
      yield* doAgoraToken(map: event.body);
    } else if (event is PushTypeResponseEvent) {
      yield* doPushTypeApiCall(map: event.map);
    }
  }

  Stream<CallState> doAgoraToken({Map<String, dynamic>? map}) async* {
    print("Agora Token bloc");
    ApiService apiProvider = ApiService();
    try {
      print("Agora Token initial state");
      yield CallProgressState();
      print("Agora Token progress state $map");
      AgoraToken agoraToken = await apiProvider.getAgoraToken(body: map);
      yield AgoraSuccessState(agoraToken);
      print("Start Video success state");
    } catch (ex) {
      if (ex != "close") {
        print(ex.toString());
        yield CallErrorState(ex.toString());
      }
    }
  }

  Stream<CallState> doPushTypeApiCall({Map<String, dynamic>? map}) async* {
    print("this is signin param $map");
    ApiService apiProvider = ApiService();
    try {
      yield CallProgressState();
      ResponseSignIn responseSignIn =
          await apiProvider.doPushTypeApiCall(body: map);
      print(responseSignIn.toJson().toString());
      yield PushTypeSuccessState(responseSignIn);
    } catch (ex) {
      print(ex.toString());
      if (ex != "close") {
        yield CallErrorState(ex.toString());
      }
    }
  }
}
