
import 'package:flutter/cupertino.dart';
@immutable
abstract class ForgetPasswordEvent{}

class ForgetPasswordResponseEvent extends ForgetPasswordEvent{
  final Map<String, dynamic>? map;
  ForgetPasswordResponseEvent({@required this.map});
}
