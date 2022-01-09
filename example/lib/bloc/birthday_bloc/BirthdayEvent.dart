
import 'package:flutter/cupertino.dart';
@immutable
abstract class BirthdayEvent{}

class BirthdayResponseEvent extends BirthdayEvent{
  final Map<String, dynamic>? map;
  BirthdayResponseEvent({@required this.map});
}

class BusinessTypeResponseEvent extends BirthdayEvent{
  final Map<String, dynamic>? map;
  BusinessTypeResponseEvent({@required this.map});
}
