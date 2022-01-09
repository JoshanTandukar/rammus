class ChatRegisterUserResponse
{
  User? user;
  bool? success;
  String? error;

  ChatRegisterUserResponse({this.user, this.success});

  ChatRegisterUserResponse.fromJson(Map<String, dynamic> json)
  {
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    success = json['success'];
    error = json['error'] != null ? json['error'] : null;
  }

  Map<String, dynamic> toJson()
  {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['user'] = this.user!.toJson();
    data['success'] = this.success;
    data['error'] = this.error;
    return data;
  }
}

class User
{
  String? sId;
  String? type;
  String? status;
  bool? active;
  String? name;
  String? username;
  List<String>? lRooms;

  User({
    this.sId,
    this.type,
    this.status,
    this.active,
    this.name,
    this.username,
    this.lRooms
  });

  User.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    type = json['type'];
    status = json['status'];
    active = json['active'];
    name = json['name'];
    username = json['username'];
    lRooms = json['__rooms'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['_id'] = this.sId;
    data['type'] = this.type;
    data['status'] = this.status;
    data['active'] = this.active;
    data['name'] = this.name;
    data['username'] = this.username;
    data['__rooms'] = this.lRooms;
    return data;
  }
}