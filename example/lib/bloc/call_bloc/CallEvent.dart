import 'package:flutter/cupertino.dart';

@immutable
abstract class CallEvent {}

class AgoraEvent extends CallEvent {
  final Map<String, dynamic>? body;
  AgoraEvent({this.body});
}

class PushTypeResponseEvent extends CallEvent {
  final Map<String, dynamic>? map;
  PushTypeResponseEvent({this.map});
}
