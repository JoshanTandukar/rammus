
import 'package:flutter/cupertino.dart';
@immutable
abstract class ChatCreateChannelEvent{}

class  ChatCreateChannelResponseEvent extends ChatCreateChannelEvent
{
  final Map<String, dynamic>? map;
  final int? urlIndex;
  ChatCreateChannelResponseEvent({@required this.map, @required this.urlIndex});
}