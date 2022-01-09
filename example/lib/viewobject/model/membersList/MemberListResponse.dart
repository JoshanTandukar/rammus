class MembersListResponse
{
  List<Members>? members;
  int? count;
  int? offset;
  int? total;
  bool? success;
  String? error;

  MembersListResponse({this.members, this.count, this.offset, this.total, this.success});

  MembersListResponse.fromJson(Map<String, dynamic> json)
  {
    if (json['members'] != null)
    {
      members =  <Members>[];
      json['members'].forEach((v)
      {
        members!.add(Members.fromJson(v));
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
    if (this.members != null)
    {
      data['members'] = this.members!.map((v) => v.toJson()).toList();
    }
    data['count'] = this.count;
    data['offset'] = this.offset;
    data['total'] = this.total;
    data['success'] = this.success;
    data['error'] = this.error;
    return data;
  }
}

class Members
{
  String? sId;
  String? status;
  String? sUpdatedAt;
  String? name;
  String? username;

  Members({
    this.sId,
    this.status,
    this.sUpdatedAt,
    this.name,
    this.username,
  });

  Members.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    status = json['status'];
    sUpdatedAt = json['_updatedAt'];
    name = json['name'];
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['status'] = this.status;
    data['_updatedAt'] = this.sUpdatedAt;
    data['name'] = this.name;
    data['username'] = this.username;
    return data;
  }
}