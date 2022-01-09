
import 'package:flutter/cupertino.dart';
@immutable
abstract class OtpEvent{}

class OtpResponseEvent extends OtpEvent{
  final Map<String, dynamic>? map;
  OtpResponseEvent({@required this.map});
}
