
import 'package:flutter/cupertino.dart';
@immutable
abstract class SignInEvent{}

class SignInResponseEvent extends SignInEvent{
  final Map<String, dynamic>? map;
  SignInResponseEvent({@required this.map});
}
