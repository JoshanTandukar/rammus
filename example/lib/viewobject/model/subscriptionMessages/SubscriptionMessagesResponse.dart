import 'package:live/viewobject/model/chatMessageResponse/ChatChannelMessageResponse.dart';

class SubscriptionMessagesResponse {
  String? msg;
  String? collection;
  String? id;
  Fields? fields;

  SubscriptionMessagesResponse({
    required this.msg,
    required this.collection,
    required this.id,
    required this.fields
  });

  SubscriptionMessagesResponse.fromJson(Map<String, dynamic> json)
  {
    msg = json['msg'];
    collection = json['collection'];
    id = json['id'];
    fields = json['fields'] != null ?  Fields.fromJson(json['fields']) : null;
  }

  Map<String, dynamic> toJson() 
  {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['msg'] = this.msg;
    data['collection'] = this.collection;
    data['id'] = this.id;
    if (this.fields != null)
    {
      data['fields'] = this.fields!.toJson();
    }
    return data;
  }
}

class Fields
{
  String? eventName;
  List<Messages>? args;

  Fields({this.eventName, this.args});

  Fields.fromJson(Map<String, dynamic> json)
  {
    eventName = json['eventName'];
    if (json['args'] != null)
    {
      args =  <Messages>[];
      json['args'].forEach((v)
      {
        args!.add(Messages.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson()
  {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['eventName'] = this.eventName;
    if (this.args != null)
    {
      data['args'] = this.args!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}