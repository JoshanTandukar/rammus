class ResponseOtp {
  Result? result;

  ResponseOtp({this.result});

  ResponseOtp.fromJson(Map<String, dynamic> json)
  {
    result = json['result'] != null ?  Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson()
  {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    if (this.result != null)
    {
      data['result'] = this.result!.toJson();
    }
    return data;
  }
}

class Result
{
  Data? data;
  String? code;
  String? message;

  Result({this.data, this.code, this.message});

  Result.fromJson(Map<String, dynamic> json)
  {
    data = json['data']!=null?Data.fromJson(json['data']):null;
    code = json['code'];
    message = json['message'];
  }

  Map<String, dynamic> toJson()
  {
    final Map<String, dynamic> result =  Map<String, dynamic>();
    result['data'] = this.data!.toJson();
    result['code'] = this.code;
    result['message'] = this.message;
    return result;
  }
}

class Data
{
  String? accessToken;

  Data({ this.accessToken});

  Data.fromJson(Map<String, dynamic> json)
  {
    accessToken = json['access_token'];
  }

  Map<String, dynamic> toJson()
  {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['access_token'] = this.accessToken;
    return data;
  }
}