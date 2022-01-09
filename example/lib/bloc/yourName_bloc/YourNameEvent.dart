
import 'package:flutter/cupertino.dart';
@immutable
abstract class YourNameEvent{}

class YourNameResponseEvent extends YourNameEvent{
  final Map<String, dynamic>? map;
  YourNameResponseEvent({@required this.map});
}
