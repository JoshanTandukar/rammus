class ReactionsRequest
{
  String? msg;
  String? method;
  String? id;
  List<String>? params;

  ReactionsRequest({this.msg, this.method, this.id, this.params});

  ReactionsRequest.fromJson(Map<String, dynamic> json)
  {
    this.msg = json['msg'];
    this.method = json['method'];
    this.id = json['id'];
    this.params = json['params'].cast<String>();
  }

  Map<String, dynamic> toJson()
  {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['msg'] = this.msg;
    data['method'] = this.method;
    data['id'] = this.id;
    data['params'] = this.params;
    return data;
  }
}