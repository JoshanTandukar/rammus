
import 'package:flutter/cupertino.dart';
@immutable
abstract class YourEmailEvent{}

class YourEmailResponseEvent extends YourEmailEvent{
  final Map<String, dynamic>? map;
  YourEmailResponseEvent({@required this.map});
}
