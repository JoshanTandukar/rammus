
import 'package:flutter/cupertino.dart';
@immutable
abstract class OtpVerificationEvent{}

class OtpVerificationResponseEvent extends OtpVerificationEvent{
  final Map<String, dynamic>? map;
  OtpVerificationResponseEvent({@required this.map});
}
