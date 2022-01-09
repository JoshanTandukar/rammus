
import 'package:flutter/cupertino.dart';
@immutable
abstract class GetEmailEvent{}

class EmailEvent extends GetEmailEvent{
  final Map<String, dynamic>? body;
  EmailEvent({@required this.body});
}