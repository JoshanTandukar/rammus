class UsersListResponse
{
  List<Users>? users;
  int? count;
  int? offset;
  int? total;
  bool? success;
  String? error;

  UsersListResponse({this.users, this.count, this.offset, this.total, this.success});

  UsersListResponse.fromJson(Map<String, dynamic> json)
  {
    if (json['users'] != null)
    {
      users =  <Users>[];
      json['users'].forEach((v)
      {
        users!.add(Users.fromJson(v));
      });
    }
    count = json['count'];
    offset = json['offset'];
    total = json['total'];
    success = json['success'];
    error = json['error'];
  }

  Map<String, dynamic> toJson()
  {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    if (this.users != null)
    {
      data['users'] = this.users!.map((v) => v.toJson()).toList();
    }
    data['count'] = this.count;
    data['offset'] = this.offset;
    data['total'] = this.total;
    data['success'] = this.success;
    data['error'] = this.error;
    return data;
  }
}

class Users
{
  String? sId;
  String? status;
  bool? active;
  String? name;
  String? nameInsensitive;
  String? username;
  // List<String>? roles;

  Users({
    this.sId,
    this.status,
    this.active,
    this.name,
    this.nameInsensitive,
    this.username,
    // this.roles,
  });

  Users.fromJson(Map<String, dynamic> json)
  {
    sId = json['_id'];
    status = json['status'];
    active = json['active'];
    name = json['name'];
    nameInsensitive = json['nameInsensitive'];
    username = json['username'];
    //TODO
    /// roles wont be provide if fetch from user account
    // roles = json['roles'].cast<String>();
  }

  Map<String, dynamic> toJson()
  {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['_id'] = this.sId;
    data['status'] = this.status;
    data['active'] = this.active;
    data['name'] = this.name;
    data['nameInsensitive'] = this.nameInsensitive;
    data['username'] = this.username;
    // data['roles'] = this.roles;
    return data;
  }
}