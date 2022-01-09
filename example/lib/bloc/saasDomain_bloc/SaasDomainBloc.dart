



import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live/api/ApiService.dart';
import 'package:live/bloc/saasDomain_bloc/SaasDomainEvent.dart';
import 'package:live/bloc/saasDomain_bloc/SaasDomainState.dart';



class SaasDomainBloc extends Bloc<SaasDomainEvent, SaasDomainState> {
  SaasDomainBloc(SaasDomainState initialState) : super(initialState);

  @override
  Stream<SaasDomainState> mapEventToState(SaasDomainEvent event) async* {
    if (event is DomainEvent) {
      yield* doSaasDomainApiCall(event.body);
    }
  }

  Stream<SaasDomainState> doSaasDomainApiCall(Map<String,dynamic>? body) async* {
    ApiService apiProvider = ApiService();
    yield InitialSaasDomainState();
    try {
      Map SaasDomainResponse = await apiProvider.getEmailApiCall(body: body);
      yield SaasDomainSuccessState(SaasDomainResponse);
    } catch (ex) {
      if (ex != "close") {
        yield SaasDomainErrorState(ex.toString());
      }
    }
  }
}
