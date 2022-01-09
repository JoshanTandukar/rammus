class UpdatePassword {
  Result? result;

  UpdatePassword({this.result});

  UpdatePassword.fromJson(Map<String, dynamic> json)
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
  List<Data>? data;
  String? code;

  Result({this.data, this.code});

  Result.fromJson(Map<String, dynamic> json)
  {
    if (json['data'] != null)
    {
      data = <Data>[];
      json['data'].forEach((v)
      {
        data?.add(new Data.fromJson(v));
      });
    }
    code = json['code'];
  }

  Map<String, dynamic> toJson()
  {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null)
    {
      data['data'] = this.data?.map((v) => v.toJson()).toList();
    }
    data['code'] = this.code;
    return data;
  }
}

class Data
{
  String? message;

  Data({this.message});

  Data.fromJson(Map<String, dynamic> json) {
    message = json['message'];
  }

  Map<String, dynamic> toJson()
  {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    return data;
  }
}