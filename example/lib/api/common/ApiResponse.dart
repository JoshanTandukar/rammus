import 'dart:convert';
import 'package:http/http.dart';

class ApiResponse
{
  ApiResponse(Response response)
  {
    code = response.statusCode;
    print(code);
    if (isSuccessful())
    {
      body = response.body;
      errorMessage = '';
    }
    else
    {
      body = null;
      final dynamic hashMap = json.decode(response.body);
      if(hashMap['detail'] is String){
        errorMessage = hashMap['detail'];
      }
    }
  }

  int? code;
  String? body;
  String? errorMessage;
  Response? response0;

  bool isSuccessful()
  {
    return code! >= 200 && code! < 300;
  }
}
