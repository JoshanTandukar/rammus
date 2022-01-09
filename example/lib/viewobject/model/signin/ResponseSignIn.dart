class ResponseSignIn {
  Result? result;

  ResponseSignIn({this.result});

  ResponseSignIn.fromJson(Map<String, dynamic> json) {
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

class Result {
  Data? data;
  String? message;
  String? code;

  Result({this.data, this.code});

  Result.fromJson(Map<String, dynamic> json)
  {
    message = json['message'];
    if(int.parse(json['code']) >=200 && int.parse(json['code'])<300)
      data = json['data']!=null? Data.fromJson(json['data']):null;
    else
      data = null;
    code = json['code'];
  }

  Map<String, dynamic> toJson()
  {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    if (this.data != null)
    {
      data['data'] = this.data!.toJson();
    }
    data['code'] = this.code;
    data['message'] = this.message;
    return data;
  }
}

class Data {
  String? message;
  int? userId;
  String? userEmail;
  String? phonenumber;
  String? birthday;
  String? accessToken;
  String? refreshToken;
  String? username;

  Data({
    this.message,
    this.userId,
    this.userEmail,
    this.phonenumber,
    this.birthday,
    this.accessToken,
    this.refreshToken
  });

  Data.fromJson(Map<String, dynamic> json)
  {
    if(json.isNotEmpty)
    {
      message = json['message'];
      userId = json['user_id'];
      userEmail = json['user_email'];
      phonenumber = json['phonenumber'];
      birthday = json['birthday'];
      accessToken = json['access_token'];
      refreshToken = json['refresh_token'];
      username = json['user_name'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['message'] = this.message;
    data['user_id'] = this.userId;
    data['user_email'] = this.userEmail;
    data['phonenumber'] = this.phonenumber;
    data['birthday'] = this.birthday;
    data['access_token'] = this.accessToken;
    data['refresh_token'] = this.refreshToken;
    data['user_name'] = this.username;
    return data;
  }
}


