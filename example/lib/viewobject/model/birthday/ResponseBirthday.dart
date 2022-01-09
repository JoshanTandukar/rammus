class ResponseBirthday {
  Result? result;

  ResponseBirthday({this.result});

  ResponseBirthday.fromJson(Map<String, dynamic> json)
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
  String? message;
  String? code;

  Result({this.message, this.code});

  Result.fromJson(Map<String, dynamic> json)
  {
    code = json['code'];
    message = json['message'];
  }

  Map<String, dynamic> toJson()
  {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['message'] = this.message;
    data['code'] = this.code;
    return data;
  }
}