
import 'package:flutter/cupertino.dart';
@immutable
abstract class UsernameValidationEvent{}

class DoUsernameValidationEvent extends UsernameValidationEvent{
  final Map<String, dynamic>? map;
  DoUsernameValidationEvent({@required this.map});
}