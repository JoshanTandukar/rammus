class ResponseOtpVerification {
  Result? result;

  ResponseOtpVerification({this.result});

  ResponseOtpVerification.fromJson(Map<String, dynamic> json)
  {
    result = json['result'] != null ? new Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson()
  {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.result != null)
    {
      data['result'] = this.result!.toJson();
    }
    return data;
  }
}

class Result
{
  String? code;
  String? message;

  Result({this.code, this.message});

  Result.fromJson(Map<String, dynamic> json)
  {
    code = json['code'];
    message = json['message'];
  }

  Map<String, dynamic> toJson()
  {
    final Map<String, dynamic> result =  Map<String, dynamic>();
    result['code'] = this.code;
    result['message'] = this.message;
    return result;
  }
}