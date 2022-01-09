
import 'package:flutter/cupertino.dart';
@immutable
abstract class SaasDomainEvent{}

class DomainEvent extends SaasDomainEvent{
  final Map<String, dynamic>? body;
  DomainEvent({@required this.body});
}