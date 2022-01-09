
import 'package:flutter/cupertino.dart';
@immutable
abstract class UpdatePasswordEvent{}

class UpdatePasswordResponseEvent extends UpdatePasswordEvent{
  final Map<String, dynamic>? map;
  UpdatePasswordResponseEvent({@required this.map});
}
