import 'package:live/viewobject/model/createChannel/ChatCreateChannelResponse.dart';

class ChatChannelJoinedResponse
{
  List<Channel>? channels;
  int? offset;
  int? count;
  int? total;
  bool? success;
  String? error;

  ChatChannelJoinedResponse({this.channels, this.offset, this.count, this.total, this.success, this.error});

  ChatChannelJoinedResponse.fromJson(Map<String, dynamic> json)
  {
    if (json['channels'] != null)
    {
      channels = <Channel>[];
      json['channels'].forEach((v)
      {
        channels!.add(Channel.fromJson(v));
      });
    }
    offset = json['offset'];
    count = json['count'];
    total = json['total'];
    success = json['success'];
  }

  Map<String, dynamic> toJson()
  {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.channels != null)
    {
      data['channels'] = this.channels!.map((v) => v.toJson()).toList();
    }
    data['offset'] = this.offset;
    data['count'] = this.count;
    data['total'] = this.total;
    data['success'] = this.success;
    return data;
  }
}