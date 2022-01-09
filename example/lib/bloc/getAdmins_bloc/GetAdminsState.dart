import 'package:live/viewobject/model/admins/ResponseAdmin.dart';

abstract class GetAdminsState {}

class InitialGetAdminsState extends GetAdminsState {}

class GetAdminsErrorState extends GetAdminsState {
  final String errorMessage;
  GetAdminsErrorState(this.errorMessage);
}

class GetAdminsProgressState extends GetAdminsState {}

class GetAdminsSuccessState extends GetAdminsState {
  final ResponseAdmin getAdminsResponse;
  GetAdminsSuccessState(this.getAdminsResponse);
}
