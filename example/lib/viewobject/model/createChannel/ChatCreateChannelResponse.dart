class ChatCreateChannelResponse
{
  Channel? channel;
  bool? success;
  String? error;

  ChatCreateChannelResponse({this.channel, this.success, this.error});

  ChatCreateChannelResponse.fromJson(Map<String, dynamic> json)
  {
    channel = json['channel'] != null ?  Channel.fromJson(json['channel']) : null;
    success = json['success'];
    error = json['error'];
  }

  Map<String, dynamic> toJson()
  {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    if (this.channel != null)
    {
      data['channel'] = this.channel!.toJson();
    }
    data['success'] = this.success;
    data['error'] = this.error;
    return data;
  }
}

class Channel
{
  String? sId;
  String? fname;
  String? name;
  String? description;
  String? t;
  int? msgs;
  int? usersCount;
  U? u;
  String? ts;
  bool? ro;
  bool? def;
  bool? sysMes;
  String? sUpdatedAt;

  Channel({this.sId, this.fname, this.name, this.description, this.t, this.msgs, this.usersCount, this.u, this.ts, this.ro, this.def, this.sysMes, this.sUpdatedAt});

  Channel.fromJson(Map<String, dynamic> json)
  {
    sId = json['_id'];
    fname = json['fname'];
    name = json['name'];
    description = json.containsKey("description")?json['description']:null;
    t = json['t'];
    msgs = json['msgs'];
    usersCount = json['usersCount'];
    u = json['u'] != null ?  U.fromJson(json['u']) : null;
    ts = json['ts'];
    ro = json['ro'];
    def = json['default'];
    sysMes = json['sysMes'];
    sUpdatedAt = json['_updatedAt'];
  }

  Map<String, dynamic> toJson()
  {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['_id'] = this.sId;
    data['fname'] = this.fname;
    data['name'] = this.name;
    data['t'] = this.t;
    data['msgs'] = this.msgs;
    data['usersCount'] = this.usersCount;
    data['description'] = this.description;
    if (this.u != null)
    {
      data['u'] = this.u!.toJson();
    }
    data['ts'] = this.ts;
    data['ro'] = this.ro;
    data['default'] = this.def;
    data['sysMes'] = this.sysMes;
    data['_updatedAt'] = this.sUpdatedAt;
    return data;
  }
}

class U
{
  String? sId;
  String? username;

  U({this.sId, this.username});

  U.fromJson(Map<String, dynamic> json)
  {
    sId = json['_id'];
    username = json['username'];
  }

  Map<String, dynamic> toJson()
  {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['_id'] = this.sId;
    data['username'] = this.username;
    return data;
  }
}