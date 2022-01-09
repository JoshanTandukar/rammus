class ResponseRegister {
  Result? result;

  ResponseRegister({this.result});

  ResponseRegister.fromJson(Map<String, dynamic> json)
  {
    result = json['result'] != null ? new Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson()
  {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    if (this.result != null)
    {
      data['result'] = this.result?.toJson();
    }
    return data;
  }
}

class Result
{
  String? message;
  String? code;

  Result({this.message, this.code});

  Result.fromJson(Map<String, dynamic> json)
  {
    message = json['message'];
    code = json['code'];
  }

  Map<String, dynamic> toJson()
  {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['code'] = this.code;
    return data;
  }
}