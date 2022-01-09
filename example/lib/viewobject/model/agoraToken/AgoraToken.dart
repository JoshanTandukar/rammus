class AgoraToken {
  String? jsonrpc;
  Null id;
  Result? result;

  AgoraToken({required this.jsonrpc, this.id,required this.result});

  AgoraToken.fromJson(Map<String, dynamic> json) {
    jsonrpc = json['jsonrpc'];
    id = json['id'];
    result =
    json['result'] != null ? new Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['jsonrpc'] = this.jsonrpc;
    data['id'] = this.id;
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    return data;
  }
}

class Result {
  String? message;
  Data? data;
  String? code;

  Result({required this.message, required this.data, required this.code});

  Result.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['code'] = this.code;
    return data;
  }
}

class Data {
  int? uid;
  String? channelName;
  String? agoraToken;

  Data({required this.uid, required this.channelName, required this.agoraToken});

  Data.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    channelName = json['channelName'];
    agoraToken = json['agoraToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['channelName'] = this.channelName;
    data['agoraToken'] = this.agoraToken;
    return data;
  }
}