
import 'package:flutter/cupertino.dart';

@immutable
abstract class RegisterEvent{}

class RegisterResponseEvent extends RegisterEvent{
  final Map<String,dynamic>? body;
  RegisterResponseEvent({@required this.body});
}