import 'dart:convert';

import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:live/api/Url.dart';
import 'package:live/config/Config.dart';
import 'package:live/constant/Constants.dart';
import 'package:live/utils/Prefs.dart';
import 'package:live/utils/Utils.dart';
import 'package:live/viewobject/model/admins/ResponseAdmin.dart';
import 'package:live/viewobject/model/agoraToken/AgoraToken.dart';
import 'package:live/viewobject/model/appInfo/AppInfo.dart';
import 'package:live/viewobject/model/birthday/ResponseBirthday.dart';
import 'package:live/viewobject/model/chatChannelGroupJoined/ChatChannelGroupJoinedResponse.dart';
import 'package:live/viewobject/model/chatChannelJoined/ChatChannelJoinedResponse.dart';
import 'package:live/viewobject/model/chatLoginUser/ChatLoginUserResponse.dart';
import 'package:live/viewobject/model/chatRegisterUser/ChatRegisterUserResponse.dart';
import 'package:live/viewobject/model/createChannel/ChatCreateChannelResponse.dart';
import 'package:live/viewobject/model/forgetPassword/ForgetPassword.dart';
import 'package:live/viewobject/model/membersList/MemberListResponse.dart';
import 'package:live/viewobject/model/otp/ResponseOtp.dart';
import 'package:live/viewobject/model/otp_verification/ResponseOtpVerification.dart';
import 'package:live/viewobject/model/responseRegister/ResponseRegister.dart';
import 'package:live/viewobject/model/responseYourEmail/ResponseYourEmail.dart';
import 'package:live/viewobject/model/responseYourName/ResponseYourName.dart';
import 'package:live/viewobject/model/signin/ResponseSignIn.dart';
import 'package:live/viewobject/model/startVideo/StartVideoResponse.dart';
import 'package:live/viewobject/model/updatePassword/UpdatePassword.dart';
import 'package:live/viewobject/model/username/ResponseUsername.dart';
import 'package:live/viewobject/model/usersList/UsersListResponse.dart';

class ApiService {
  Future<AppInfo> doVersionApiCall({Map<String, dynamic>? body}) async {
    var url = Uri.http(Config.baseUrl, "abc", body);
    final response = await http.get(url);
    Map responseData = Utils.decodeJson(response.body);
    if (response.statusCode == Const.STATUS_OK) {
      AppInfo appInfo = AppInfo().fromMap(responseData["data"]);
      return appInfo;
    } else {
      throw Exception(responseData['msg']);
    }
  }

  Future<ResponseOtp> doOtpApiCall({Map<String, dynamic>? map}) async {
    print('this is map $map');
    var uri = Uri.parse(Config.baseUrl + Url.verification_send);
    Request req = Request('POST', uri)
      ..body = Utils.encodeJson(map)
      ..headers.addAll({'Content-Type': 'application/json'});
    print(uri.toString());
    StreamedResponse response = await req.send();
    final respStr = await response.stream.bytesToString();
    print('this is response $respStr');
    if (response.statusCode == Const.STATUS_OK) {
      ResponseOtp responseOtp = ResponseOtp.fromJson(json.decode(respStr));
      if (int.parse(responseOtp.result!.code!) >= 200 &&
          int.parse(responseOtp.result!.code!) < 300) {
        return responseOtp;
      } else if (int.parse(responseOtp.result!.code!) >= 400 &&
          int.parse(responseOtp.result!.code!) < 500) {
        return responseOtp;
      } else {
        throw Exception(response);
      }
    } else {
      throw Exception(response);
    }
  }

  Future<ResponseOtpVerification> doOtpVerificationApiCall(
      {Map<String, dynamic>? map}) async {
    print('this is map $map');
    var uri = Uri.parse(Config.baseUrl + Url.verification_verify);
    Request req = Request('POST', uri)
      ..body = Utils.encodeJson(map)
      ..headers.addAll({
        'Content-Type': 'application/json',
        "Authorization": 'Bearer ' +
            Prefs.getString(Const.VALUE_HOLDER_SIGN_UP_ACCESS_TOKEN)!,
      });
    print(uri.toString());
    StreamedResponse response = await req.send();
    final respStr = await response.stream.bytesToString();
    print('this is response $respStr');
    if (response.statusCode == Const.STATUS_OK) {
      ResponseOtpVerification responseOtp =
          ResponseOtpVerification.fromJson(json.decode(respStr));
      if (int.parse(responseOtp.result!.code!) >= 200 &&
          int.parse(responseOtp.result!.code!) < 300) {
        return responseOtp;
      } else if (int.parse(responseOtp.result!.code!) >= 400 &&
          int.parse(responseOtp.result!.code!) < 500) {
        return responseOtp;
      } else {
        throw Exception(response);
      }
    } else {
      throw Exception(response);
    }
  }

  Future<ResponseYourName> doYourNameApiCall(
      {Map<String, dynamic>? map}) async {
    print('this is map $map');
    var uri = Uri.parse(Config.baseUrl + Url.your_name);
    Request req = Request('POST', uri)
      ..body = Utils.encodeJson(map)
      ..headers.addAll({
        'Content-Type': 'application/json',
        "Authorization": 'Bearer ' +
            Prefs.getString(Const.VALUE_HOLDER_SIGN_UP_ACCESS_TOKEN)!,
      });
    print(uri.toString());
    StreamedResponse response = await req.send();
    final respStr = await response.stream.bytesToString();
    print('this is response $respStr');
    if (response.statusCode == Const.STATUS_OK) {
      ResponseYourName responseYourName =
          ResponseYourName.fromJson(json.decode(respStr));
      if (int.parse(responseYourName.result!.code!) >= 200 &&
          int.parse(responseYourName.result!.code!) < 300) {
        return responseYourName;
      } else {
        Utils.showToastMessage(responseYourName.result!.message!);
        throw Exception(response);
      }
    } else {
      throw Exception(response);
    }
  }

  Future<ResponseYourEmail> doYourEmailApiCall(
      {Map<String, dynamic>? map}) async {
    print('this is map $map');
    var uri = Uri.parse(Config.baseUrl + Url.your_email);
    Request req = Request('POST', uri)
      ..body = Utils.encodeJson(map)
      ..headers.addAll({
        'Content-Type': 'application/json',
        "Authorization": 'Bearer ' +
            Prefs.getString(Const.VALUE_HOLDER_SIGN_UP_ACCESS_TOKEN)!,
      });
    print(uri.toString());
    StreamedResponse response = await req.send();
    final respStr = await response.stream.bytesToString();
    print('this is response $respStr');
    if (response.statusCode == Const.STATUS_OK) {
      ResponseYourEmail responseYourEmail =
          ResponseYourEmail.fromJson(json.decode(respStr));
      if (int.parse(responseYourEmail.result!.code!) >= 200 &&
          int.parse(responseYourEmail.result!.code!) < 300) {
        return responseYourEmail;
      } else if (int.parse(responseYourEmail.result!.code!) >= 400 &&
          int.parse(responseYourEmail.result!.code!) < 500) {
        return responseYourEmail;
      } else {
        Utils.showToastMessage(responseYourEmail.result!.message!);
        throw Exception(response);
      }
    } else {
      throw Exception(response);
    }
  }

  Future<ResponseBirthday> doBirthdayApiCall(
      {Map<String, dynamic>? map}) async {
    print('this is map $map');
    var uri = Uri.parse(Config.baseUrl + Url.birthday);
    Request req = Request('POST', uri)
      ..body = Utils.encodeJson(map)
      ..headers.addAll({
        'Content-Type': 'application/json',
        "Authorization": 'Bearer ' +
            Prefs.getString(Const.VALUE_HOLDER_SIGN_UP_ACCESS_TOKEN)!,
      });
    print(uri.toString());
    StreamedResponse response = await req.send();
    final respStr = await response.stream.bytesToString();
    print('this is response $respStr');
    if (response.statusCode == Const.STATUS_OK) {
      ResponseBirthday responseBirthday =
          ResponseBirthday.fromJson(json.decode(respStr));
      if (int.parse(responseBirthday.result!.code!) >= 200 &&
          int.parse(responseBirthday.result!.code!) < 300) {
        Utils.showToastMessage(responseBirthday.result!.message!);
        return responseBirthday;
      } else {
        Utils.showToastMessage(responseBirthday.result!.message!);
        throw Exception(response);
      }
    } else {
      throw Exception(response);
    }
  }

  Future<ResponseBirthday> doBusinessTypeApiCall(
      {Map<String, dynamic>? map}) async {
    print('this is map $map');
    var uri = Uri.parse(Config.baseUrl + Url.business_type);
    Request req = Request('POST', uri)
      ..body = Utils.encodeJson(map)
      ..headers.addAll({'Content-Type': 'application/json'});
    print(uri.toString());
    StreamedResponse response = await req.send();
    final respStr = await response.stream.bytesToString();
    print('this is response $respStr');
    if (response.statusCode == Const.STATUS_OK) {
      ResponseBirthday responseBirthday =
          ResponseBirthday.fromJson(json.decode(respStr));
      if (int.parse(responseBirthday.result!.code!) >= 200 &&
          int.parse(responseBirthday.result!.code!) < 300) {
        Utils.showToastMessage(responseBirthday.result!.message!);
        return responseBirthday;
      } else {
        Utils.showToastMessage(responseBirthday.result!.message!);
        throw Exception(response);
      }
    } else {
      throw Exception(response);
    }
  }

  Future<ResponseRegister> doUserRegisterApiCall(
      {Map<String, dynamic>? map}) async {
    print('this is map $map');
    var uri = Uri.parse(Config.baseUrl + Url.password);
    Request req = Request('POST', uri)
      ..body = Utils.encodeJson(map)
      ..headers.addAll({
        'Content-Type': 'application/json',
        "Authorization": 'Bearer ' +
            Prefs.getString(Const.VALUE_HOLDER_SIGN_UP_ACCESS_TOKEN)!,
      });
    print(uri.toString());
    StreamedResponse response = await req.send();
    final respStr = await response.stream.bytesToString();
    print('this is response $respStr');
    if (response.statusCode == Const.STATUS_OK) {
      ResponseRegister responseRegister =
          ResponseRegister.fromJson(json.decode(respStr));
      if (int.parse(responseRegister.result!.code!) >= 200 &&
          int.parse(responseRegister.result!.code!) < 300) {
        return responseRegister;
      } else if (int.parse(responseRegister.result!.code!) >= 400 &&
          int.parse(responseRegister.result!.code!) < 500) {
        return responseRegister;
      } else {
        throw Exception(response);
      }
    } else {
      throw Exception(response);
    }
  }

  Future<ResponseUsername> doUsernameVerifyApiCall(
      {Map<String, dynamic>? map}) async {
    print('this is map $map');
    var uri = Uri.parse(Config.baseUrl + Url.username);
    Request req = Request('POST', uri)
      ..body = Utils.encodeJson(map)
      ..headers.addAll({'Content-Type': 'application/json'});
    print(uri.toString());
    StreamedResponse response = await req.send();
    final respStr = await response.stream.bytesToString();
    print('this is response $respStr');
    if (response.statusCode == Const.STATUS_OK) {
      ResponseUsername responseUsername =
          ResponseUsername.fromJson(json.decode(respStr));
      if (int.parse(responseUsername.result!.code!) >= 200 &&
          int.parse(responseUsername.result!.code!) < 300) {
        Utils.showToastMessage(responseUsername.result!.data![0].message!);
        return responseUsername;
      } else {
        Utils.showToastMessage(responseUsername.result!.data![0].message!);
        throw Exception(response);
      }
    } else {
      throw Exception(response);
    }
  }

  getEmailApiCall({Map<String, dynamic>? body}) async {
    var uri = Uri.parse(Config.baseUrl + Url.verify_email);
    Request req = Request('POST', uri)
      ..body = Utils.encodeJson(body)
      ..headers.addAll({'Content-Type': 'application/json'});
    print(uri.toString());
    StreamedResponse response = await req.send();
    final respStr = await response.stream.bytesToString();
    print('this is response $respStr');
    if (response.statusCode == Const.STATUS_OK) {
      return respStr;
    } else {
      throw Exception(response);
    }
  }

  Future updatePassword({String? url, Map<String, dynamic>? body}) async {
    var uri = Uri.parse(Config.baseUrl + Url.update_password);
    Request req = Request('POST', uri)
      ..body = Utils.encodeJson(body)
      ..headers.addAll({'Content-Type': 'application/json'});
    print(uri.toString());
    StreamedResponse response = await req.send();
    final respStr = await response.stream.bytesToString();
    print('this is response $respStr');
    if (response.statusCode == Const.STATUS_OK) {
      UpdatePassword responseUpdate =
          UpdatePassword.fromJson(json.decode(respStr));
      if (int.parse(responseUpdate.result!.code!) >= 200 &&
          int.parse(responseUpdate.result!.code!) < 300) {
        return responseUpdate;
      } else if (int.parse(responseUpdate.result!.code!) >= 400 &&
          int.parse(responseUpdate.result!.code!) < 500) {
        return responseUpdate;
      } else {
        throw Exception(response);
      }
    } else {
      throw Exception(response);
    }
  }

  Future getAgoraToken({String? url, Map<String, dynamic>? body}) async {
    var uri = Uri.parse(Config.baseUrl + Url.agora_token);
    print("this is uri $uri");
    Request req = Request('POST', uri)
      ..body = Utils.encodeJson(body)
      ..headers.addAll({
        'Content-Type': 'application/json',
        "Authorization":
            'Bearer ' + Prefs.getString(Const.VALUE_HOLDER_ACCESS_TOKEN)!,
      });
    StreamedResponse response = await req.send();
    final respStr = await response.stream.bytesToString();
    print('this is response $respStr');
    if (response.statusCode == Const.STATUS_OK) {
      AgoraToken agoraToken = AgoraToken.fromJson(json.decode(respStr));
      if (int.parse(agoraToken.result!.code!) >= 200 &&
          int.parse(agoraToken.result!.code!) < 300) {
        return agoraToken;
      } else if (int.parse(agoraToken.result!.code!) >= 400 &&
          int.parse(agoraToken.result!.code!) < 500) {
        return agoraToken;
      } else {
        throw Exception(response);
      }
    } else {
      throw Exception(response);
    }
  }

  Future doUserSignInApiCall({String? url, Map<String, dynamic>? body}) async {
    var uri = Uri.parse(Config.baseUrl + Url.sign_in);
    Request req = Request('POST', uri)
      ..body = Utils.encodeJson(body)
      ..headers.addAll({'Content-Type': 'application/json'});
    print(uri.toString());
    StreamedResponse response = await req.send();
    final respStr = await response.stream.bytesToString();
    print('this is response $body');
    print('this is response $respStr');
    if (response.statusCode == Const.STATUS_OK) {
      ResponseSignIn responseSignIn =
          ResponseSignIn.fromJson(json.decode(respStr));
      if (int.parse(responseSignIn.result!.code!) >= 200 &&
          int.parse(responseSignIn.result!.code!) < 300) {
        return responseSignIn;
      } else if (int.parse(responseSignIn.result!.code!) >= 400 &&
          int.parse(responseSignIn.result!.code!) < 500) {
        return responseSignIn;
      } else {
        throw Exception(response);
      }
    } else {
      throw Exception(response);
    }
  }

  Future doUserSignOutApiCall() async {
    var uri = Uri.parse(Config.baseUrl + Url.reset_notification_token);
    print(
        "this is logout 3 ${Prefs.getString(Const.VALUE_HOLDER_ACCESS_TOKEN)}");
    Request req = Request('POST', uri)
      ..body = "{}"
      ..headers.addAll({
        'Content-Type': 'application/json',
        "Authorization":
            'Bearer ' + Prefs.getString(Const.VALUE_HOLDER_ACCESS_TOKEN)!,
      });
    print(uri.toString());
    StreamedResponse response = await req.send();
    final respStr = await response.stream.bytesToString();
    print('this is response $respStr');
    if (response.statusCode == Const.STATUS_OK) {
      Map responseSignOut = json.decode(respStr);
      if (int.parse(responseSignOut["result"]["code"]) >= 200 &&
          int.parse(responseSignOut["result"]["code"]) < 300) {
        return "success";
      } else if (int.parse(responseSignOut["result"]["code"]) >= 400 &&
          int.parse(responseSignOut["result"]["code"]) < 500) {
        return "Failed";
      } else {
        throw Exception(response);
      }
    } else {
      throw Exception(response);
    }
  }

  Future forgetPassword({String? url, Map<String, dynamic>? body}) async {
    var uri = Uri.parse(Config.baseUrl + Url.forget_password);
    Request req = Request('POST', uri)
      ..body = Utils.encodeJson(body)
      ..headers.addAll(
        {'Content-Type': 'application/json'},
      );
    print(uri.toString());
    StreamedResponse response = await req.send();
    final respStr = await response.stream.bytesToString();
    print('this is response $respStr');
    if (response.statusCode == Const.STATUS_OK) {
      ForgetPassword responseForgetPassword =
          ForgetPassword.fromJson(json.decode(respStr));
      if (int.parse(responseForgetPassword.result!.code!) >= 200 &&
          int.parse(responseForgetPassword.result!.code!) < 300) {
        return responseForgetPassword;
      } else if (int.parse(responseForgetPassword.result!.code!) >= 400 &&
          int.parse(responseForgetPassword.result!.code!) < 500) {
        return responseForgetPassword;
      } else {
        throw Exception(response);
      }
    } else {
      throw Exception(response);
    }
  }

  Future<ChatLoginUserResponse> doChatLoginApiCall(
      {String? chatUrl, Map<String, dynamic>? map}) async {
    print('this is map $map');
    var uri = Uri.parse(chatUrl! + Url.rocketChatLogin);
    Request req = Request('POST', uri)
      ..body = Utils.encodeJson(map)
      ..headers.addAll({'Content-Type': 'application/json'});
    print(uri.toString());
    StreamedResponse response = await req.send().timeout(Duration(seconds: 5));
    final respStr = await response.stream.bytesToString();
    print('this is response $respStr');
    if (response.statusCode == Const.STATUS_OK) {
      ChatLoginUserResponse chatRegisterUserResponse =
          ChatLoginUserResponse.fromJson(json.decode(respStr));
      return chatRegisterUserResponse;
    } else {
      throw Exception(response);
    }
  }

  Future<ChatRegisterUserResponse> doChatRegisterApiCall(
      {String? chatUrl, Map<String, dynamic>? map}) async {
    print('this is map $map');
    var uri = Uri.parse(chatUrl! + Url.rocketChatRegister);
    Request req = Request('POST', uri)
      ..body = Utils.encodeJson(map)
      ..headers.addAll({'Content-Type': 'application/json'});
    print(uri.toString());
    StreamedResponse response = await req.send();
    final respStr = await response.stream.bytesToString();
    print('this is response $respStr');
    print('this is response ${response.statusCode}');
    if (response.statusCode >= Const.STATUS_OK && response.statusCode < 300) {
      ChatRegisterUserResponse chatRegisterUserResponse =
          ChatRegisterUserResponse.fromJson(json.decode(respStr));
      if (chatRegisterUserResponse.success!) {
        return chatRegisterUserResponse;
      } else {
        Utils.showToastMessage(chatRegisterUserResponse.error!);
        throw Exception(response);
      }
    } else if (response.statusCode >= Const.STATUS_BAD_REQUEST &&
        response.statusCode < 500) {
      ChatRegisterUserResponse chatRegisterUserResponse =
          ChatRegisterUserResponse.fromJson(json.decode(respStr));
      Utils.showToastMessage(chatRegisterUserResponse.error!);
      throw Exception(chatRegisterUserResponse.error);
    } else {
      throw Exception(response);
    }
  }

  Future<ChatCreateChannelResponse> doChatCreateChannelApiCall(
      {String? chatUrl,
      Map<String, dynamic>? map,
      String? authToken,
      String? userId}) async {
    print('this is map $map');
    var uri = Uri.parse(chatUrl! + Url.rocketChatCreateChannel);
    Request req = Request('POST', uri)
      ..body = Utils.encodeJson(map)
      ..headers.addAll(
        {
          'Content-Type': 'application/json',
          'X-Auth-Token': authToken!,
          'X-User-Id': userId!,
        },
      );
    print(uri.toString());
    StreamedResponse response = await req.send();
    final respStr = await response.stream.bytesToString();
    print('this is response $respStr');
    print('this is response ${response.statusCode}');
    if (response.statusCode >= Const.STATUS_OK && response.statusCode < 300) {
      ChatCreateChannelResponse chatCreateChannelResponse =
          ChatCreateChannelResponse.fromJson(json.decode(respStr));
      if (chatCreateChannelResponse.success!) {
        return chatCreateChannelResponse;
      } else {
        Utils.showToastMessage(chatCreateChannelResponse.error!);
        throw Exception(response);
      }
    } else if (response.statusCode >= Const.STATUS_BAD_REQUEST &&
        response.statusCode < 500) {
      ChatCreateChannelResponse chatRegisterUserResponse =
          ChatCreateChannelResponse.fromJson(json.decode(respStr));
      Utils.showToastMessage(chatRegisterUserResponse.error!);
      throw Exception(response);
    } else {
      throw Exception(response);
    }
  }

  Future<ChatCreateChannelResponse> doChatChannelSetDescription(
      {String? chatUrl,
      Map<String, dynamic>? map,
      String? authToken,
      String? userId}) async {
    print('this is map $map');
    var uri = Uri.parse(chatUrl! + Url.rocketChatChannelSetDescription);
    Request req = Request('POST', uri)
      ..body = Utils.encodeJson(map)
      ..headers.addAll(
        {
          'Content-Type': 'application/json',
          'X-Auth-Token': authToken!,
          'X-User-Id': userId!,
        },
      );
    print(uri.toString());
    StreamedResponse response = await req.send();
    final respStr = await response.stream.bytesToString();
    print('this is response $respStr');
    print('this is response ${response.statusCode}');
    if (response.statusCode >= Const.STATUS_OK && response.statusCode < 300) {
      ChatCreateChannelResponse chatCreateChannelResponse =
          ChatCreateChannelResponse.fromJson(json.decode(respStr));
      if (chatCreateChannelResponse.success!) {
        return chatCreateChannelResponse;
      } else {
        Utils.showToastMessage(chatCreateChannelResponse.error!);
        throw Exception(response);
      }
    } else if (response.statusCode >= Const.STATUS_BAD_REQUEST &&
        response.statusCode < 500) {
      ChatCreateChannelResponse chatRegisterUserResponse =
          ChatCreateChannelResponse.fromJson(json.decode(respStr));
      Utils.showToastMessage(chatRegisterUserResponse.error!);
      throw Exception(response);
    } else {
      throw Exception(response);
    }
  }

  Future<ChatCreateChannelResponse> doChatChannelMakePrivateApiCall(
      {String? chatUrl,
      String? authToken,
      String? userId,
      Map<String, dynamic>? map}) async {
    print('this is map $map');
    var uri = Uri.parse(chatUrl! + Url.rocketChatChannelMakePrivate);
    Request req = Request('POST', uri)
      ..body = Utils.encodeJson(map)
      ..headers.addAll(
        {
          'Content-Type': 'application/json',
          'X-Auth-Token': authToken!,
          'X-User-Id': userId!,
        },
      );
    print(uri.toString());
    StreamedResponse response = await req.send();
    final respStr = await response.stream.bytesToString();
    print('this is response $respStr');
    print('this is response ${response.statusCode}');
    if (response.statusCode >= Const.STATUS_OK && response.statusCode < 300) {
      ChatCreateChannelResponse chatCreateChannelResponse =
          ChatCreateChannelResponse.fromJson(json.decode(respStr));
      if (chatCreateChannelResponse.success!) {
        return chatCreateChannelResponse;
      } else {
        Utils.showToastMessage(chatCreateChannelResponse.error!);
        throw Exception(response);
      }
    } else if (response.statusCode >= Const.STATUS_BAD_REQUEST &&
        response.statusCode < 500) {
      ChatCreateChannelResponse chatRegisterUserResponse =
          ChatCreateChannelResponse.fromJson(json.decode(respStr));
      Utils.showToastMessage(chatRegisterUserResponse.error!);
      throw Exception(response);
    } else {
      throw Exception(response);
    }
  }

  Future<ChatChannelJoinedResponse> doChatChannelJoinedApiCall(
      {String? chatUrl, String? authToken, String? userId}) async {
    var uri = Uri.parse(chatUrl! + Url.rocketChatChannelJoined);
    Request req = Request('GET', uri)
      ..headers.addAll(
        {
          'Content-Type': 'application/json',
          'X-Auth-Token': authToken!,
          'X-User-Id': userId!,
        },
      );
    print(uri.toString());
    StreamedResponse response = await req.send().timeout(Duration(seconds: 5));
    final respStr = await response.stream.bytesToString();
    print('this is response $respStr');
    print('this is response ${response.statusCode}');
    if (response.statusCode >= Const.STATUS_OK && response.statusCode < 300) {
      ChatChannelJoinedResponse chatChannelJoinedResponse =
          ChatChannelJoinedResponse.fromJson(json.decode(respStr));
      if (chatChannelJoinedResponse.success!) {
        return chatChannelJoinedResponse;
      } else {
        Utils.showToastMessage(chatChannelJoinedResponse.error!);
        throw Exception(response);
      }
    } else if (response.statusCode >= Const.STATUS_BAD_REQUEST &&
        response.statusCode < 500) {
      ChatChannelJoinedResponse chatChannelJoinedResponse =
          ChatChannelJoinedResponse.fromJson(json.decode(respStr));
      Utils.showToastMessage(chatChannelJoinedResponse.error!);
      throw Exception(response);
    } else {
      throw Exception(response);
    }
  }

  Future<ChatChannelGroupJoinedResponse> doChatChannelGroupJoinedApiCall(
      {String? chatUrl, String? authToken, String? userId}) async {
    var uri = Uri.parse(chatUrl! + Url.rocketChatChannelGroupJoined);
    Request req = Request('GET', uri)
      ..headers.addAll(
        {
          'Content-Type': 'application/json',
          'X-Auth-Token': authToken!,
          'X-User-Id': userId!,
        },
      );
    print(uri.toString());
    StreamedResponse response = await req.send().timeout(Duration(seconds: 5));
    final respStr = await response.stream.bytesToString();
    print('this is response $respStr');
    print('this is response ${response.statusCode}');
    if (response.statusCode >= Const.STATUS_OK && response.statusCode < 300) {
      ChatChannelGroupJoinedResponse channelGroupJoinedResponse =
          ChatChannelGroupJoinedResponse.fromJson(json.decode(respStr));
      if (channelGroupJoinedResponse.success!) {
        return channelGroupJoinedResponse;
      } else {
        Utils.showToastMessage(channelGroupJoinedResponse.error!);
        throw Exception(response);
      }
    } else if (response.statusCode >= Const.STATUS_BAD_REQUEST &&
        response.statusCode < 500) {
      ChatChannelGroupJoinedResponse channelGroupJoinedResponse =
          ChatChannelGroupJoinedResponse.fromJson(json.decode(respStr));
      Utils.showToastMessage(channelGroupJoinedResponse.error!);
      throw Exception(response);
    } else {
      throw Exception(response);
    }
  }

  Future<ChatChannelGroupJoinedResponse> doChatChannelEncryptionApiCall(
      {Map<String, dynamic>? map}) async {
    var uri = Uri.parse(Config.chatUrl + Url.rocketChatChannelEncryption);
    Request req = Request('POST', uri)
      ..body = Utils.encodeJson(map)
      ..headers.addAll(
        {
          'Content-Type': 'application/json',
          'X-Auth-Token': Prefs.getString(Const.VALUE_HOLDER_CHAT_AUTH_TOKEN)!,
          'X-User-Id': Prefs.getString(Const.VALUE_HOLDER_CHAT_USER_ID)!,
        },
      );
    print(uri.toString());
    StreamedResponse response = await req.send();
    final respStr = await response.stream.bytesToString();
    print('this is response $respStr');
    print('this is response ${response.statusCode}');
    if (response.statusCode >= Const.STATUS_OK && response.statusCode < 300) {
      ChatChannelGroupJoinedResponse channelGroupJoinedResponse =
          ChatChannelGroupJoinedResponse.fromJson(json.decode(respStr));
      if (channelGroupJoinedResponse.success!) {
        return channelGroupJoinedResponse;
      } else {
        Utils.showToastMessage(channelGroupJoinedResponse.error!);
        throw Exception(response);
      }
    } else if (response.statusCode >= Const.STATUS_BAD_REQUEST &&
        response.statusCode < 500) {
      ChatChannelGroupJoinedResponse channelGroupJoinedResponse =
          ChatChannelGroupJoinedResponse.fromJson(json.decode(respStr));
      Utils.showToastMessage(channelGroupJoinedResponse.error!);
      throw Exception(response);
    } else {
      throw Exception(response);
    }
  }

  Future<String> doChatChannelSendMessageApiCall(
      {String? chatUrl,
      String? authToken,
      String? userId,
      Map<String, dynamic>? map}) async {
    var uri = Uri.parse(chatUrl! + Url.rocketChatChannelSendMessage);
    Request req = Request('POST', uri)
      ..body = Utils.encodeJson(map)
      ..headers.addAll(
        {
          'Content-Type': 'application/json',
          'X-Auth-Token': authToken!,
          'X-User-Id': userId!,
        },
      );
    print(uri.toString());
    StreamedResponse response = await req.send();
    final respStr = await response.stream.bytesToString();
    print('this is response $map');
    print('this is send message response $respStr');
    print('this is response ${response.statusCode}');
    if (response.statusCode >= Const.STATUS_OK && response.statusCode < 300) {
      return respStr;
    } else if (response.statusCode >= Const.STATUS_BAD_REQUEST &&
        response.statusCode < 500) {
      ChatChannelGroupJoinedResponse channelGroupJoinedResponse =
          ChatChannelGroupJoinedResponse.fromJson(json.decode(respStr));
      Utils.showToastMessage(channelGroupJoinedResponse.error!);
      throw Exception(response);
    } else {
      throw Exception(response);
    }
  }

  Future<ChatCreateChannelResponse> doChatCreateTeamApiCall(
      {String? chatUrl,
      Map<String, dynamic>? map,
      String? authToken,
      String? userId}) async {
    print('this is map $map');
    var uri = Uri.parse(chatUrl! + Url.rocketChatCreateTeam);
    Request req = Request('POST', uri)
      ..body = Utils.encodeJson(map)
      ..headers.addAll(
        {
          'Content-Type': 'application/json',
          'X-Auth-Token': authToken!,
          'X-User-Id': userId!,
        },
      );
    print(uri.toString());
    StreamedResponse response = await req.send();
    final respStr = await response.stream.bytesToString();
    print('this is response $respStr');
    print('this is response ${response.statusCode}');
    if (response.statusCode >= Const.STATUS_OK && response.statusCode < 300) {
      ChatCreateChannelResponse chatCreateChannelResponse =
          ChatCreateChannelResponse.fromJson(json.decode(respStr));
      if (chatCreateChannelResponse.success!) {
        return chatCreateChannelResponse;
      } else {
        Utils.showToastMessage(chatCreateChannelResponse.error!);
        throw Exception(response);
      }
    } else if (response.statusCode >= Const.STATUS_BAD_REQUEST &&
        response.statusCode < 500) {
      ChatCreateChannelResponse chatRegisterUserResponse =
          ChatCreateChannelResponse.fromJson(json.decode(respStr));
      Utils.showToastMessage(chatRegisterUserResponse.error!);
      throw Exception(response);
    } else {
      throw Exception(response);
    }
  }

  Future<ChatCreateChannelResponse> doChatChannelUploadFileApiCall(
      {String? chatUrl,
      String? authToken,
      String? userId,
      String? roomId,
      Map<String, dynamic>? map}) async {
    String tempFileName = map!["file"].toString().split("/").last;
    String tempFileExt = tempFileName.split(".").last;
    String ext = "";
    MediaType mediaType = MediaType('image', 'jpeg');
    if (tempFileExt != "") {
      if (tempFileExt.toLowerCase() == "jpeg" ||
          tempFileExt.toLowerCase() == "jpg" ||
          tempFileExt.toLowerCase() == "png" ||
          tempFileExt.toLowerCase() == "gif" ||
          tempFileExt.toLowerCase() == "tiff" ||
          tempFileExt.toLowerCase() == "psd" ||
          tempFileExt.toLowerCase() == "pdf" ||
          tempFileExt.toLowerCase() == "eps" ||
          tempFileExt.toLowerCase() == "ai" ||
          tempFileExt.toLowerCase() == "indo" ||
          tempFileExt.toLowerCase() == "raw") {
        ext = "." + tempFileExt;
        mediaType = MediaType('image', tempFileExt);
      } else if (tempFileExt.toLowerCase() == "mpg" ||
          tempFileExt.toLowerCase() == "mp2" ||
          tempFileExt.toLowerCase() == "mpeg" ||
          tempFileExt.toLowerCase() == "mpe" ||
          tempFileExt.toLowerCase() == "mpv" ||
          tempFileExt.toLowerCase() == "ogg" ||
          tempFileExt.toLowerCase() == "mp4" ||
          tempFileExt.toLowerCase() == "m4p" ||
          tempFileExt.toLowerCase() == "m4v" ||
          tempFileExt.toLowerCase() == "avi" ||
          tempFileExt.toLowerCase() == "wmv" ||
          tempFileExt.toLowerCase() == "mov" ||
          tempFileExt.toLowerCase() == "qt" ||
          tempFileExt.toLowerCase() == "flv" ||
          tempFileExt.toLowerCase() == "swf") {
        ext = "." + tempFileExt;
        mediaType = MediaType('video', tempFileExt);
      } else {
        ext = "." + tempFileExt;
        mediaType = MediaType('file', tempFileExt);
      }
    }
    print('this is map $map');
    var uri = Uri.parse(chatUrl! + Url.rocketChatUploadFile + roomId!);
    var req = http.MultipartRequest('POST', uri);
    req.headers.addAll(
      {
        'Content-Type': 'multipart/form-data',
        'X-Auth-Token': authToken!,
        'X-User-Id': userId!,
      },
    );
    req.files.add(
      await http.MultipartFile.fromPath(
        'file',
        map["file"],
        filename: map["fileName"] + ext,
        contentType: mediaType,
      ),
    );
    req.fields["description"] = map["description"];
    print(uri.toString());
    StreamedResponse response = await req.send();
    final respStr = await response.stream.bytesToString();
    print('this is response $respStr');
    print('this is response ${response.statusCode}');
    if (response.statusCode >= Const.STATUS_OK && response.statusCode < 300) {
      ChatCreateChannelResponse chatCreateChannelResponse =
          ChatCreateChannelResponse.fromJson(json.decode(respStr));
      if (chatCreateChannelResponse.success!) {
        return chatCreateChannelResponse;
      } else {
        Utils.showToastMessage(chatCreateChannelResponse.error!);
        throw Exception(response);
      }
    } else if (response.statusCode >= Const.STATUS_BAD_REQUEST &&
        response.statusCode < 500) {
      ChatCreateChannelResponse chatRegisterUserResponse =
          ChatCreateChannelResponse.fromJson(json.decode(respStr));
      Utils.showToastMessage(chatRegisterUserResponse.error!);
      throw Exception(response);
    } else {
      throw Exception(response);
    }
  }

  Future<ChatCreateChannelResponse> doChatChanelLeaveChannelApiCall(
      {String? chatUrl,
      Map<String, dynamic>? map,
      String? authToken,
      String? userId}) async {
    print('this is map $map');
    var uri = Uri.parse(chatUrl! + Url.rocketChatLeaveRoom);
    Request req = Request('POST', uri)
      ..body = Utils.encodeJson(map)
      ..headers.addAll(
        {
          'Content-Type': 'application/json',
          'X-Auth-Token': authToken!,
          'X-User-Id': userId!,
        },
      );
    print(uri.toString());
    StreamedResponse response = await req.send();
    final respStr = await response.stream.bytesToString();
    print('this is response $respStr');
    print('this is response ${response.statusCode}');
    if (response.statusCode >= Const.STATUS_OK && response.statusCode < 300) {
      ChatCreateChannelResponse chatCreateChannelResponse =
          ChatCreateChannelResponse.fromJson(json.decode(respStr));
      if (chatCreateChannelResponse.success!) {
        return chatCreateChannelResponse;
      } else {
        Utils.showToastMessage(chatCreateChannelResponse.error!);
        throw Exception(response);
      }
    } else if (response.statusCode >= Const.STATUS_BAD_REQUEST &&
        response.statusCode < 500) {
      ChatCreateChannelResponse chatRegisterUserResponse =
          ChatCreateChannelResponse.fromJson(json.decode(respStr));
      Utils.showToastMessage(chatRegisterUserResponse.error!);
      throw Exception(response);
    } else {
      throw Exception(response);
    }
  }

  Future<ChatCreateChannelResponse> doChatChannelDeletePublicChannelApiCall(
      {String? chatUrl,
      Map<String, dynamic>? map,
      String? authToken,
      String? userId}) async {
    print('this is map $map');
    var uri = Uri.parse(chatUrl! + Url.rocketChatDeletePublicRoom);
    Request req = Request('POST', uri)
      ..body = Utils.encodeJson(map)
      ..headers.addAll(
        {
          'Content-Type': 'application/json',
          'X-Auth-Token': authToken!,
          'X-User-Id': userId!,
        },
      );
    print(uri.toString());
    StreamedResponse response = await req.send();
    final respStr = await response.stream.bytesToString();
    print('this is response $respStr');
    print('this is response ${response.statusCode}');
    if (response.statusCode >= Const.STATUS_OK && response.statusCode < 300) {
      ChatCreateChannelResponse chatCreateChannelResponse =
          ChatCreateChannelResponse.fromJson(json.decode(respStr));
      if (chatCreateChannelResponse.success!) {
        return chatCreateChannelResponse;
      } else {
        Utils.showToastMessage(chatCreateChannelResponse.error!);
        throw Exception(response);
      }
    } else if (response.statusCode >= Const.STATUS_BAD_REQUEST &&
        response.statusCode < 500) {
      ChatCreateChannelResponse chatRegisterUserResponse =
          ChatCreateChannelResponse.fromJson(json.decode(respStr));
      Utils.showToastMessage(chatRegisterUserResponse.error!);
      throw Exception(response);
    } else {
      throw Exception(response);
    }
  }

  Future<ChatCreateChannelResponse> doChatChannelDeletePrivateChannelApiCall(
      {String? chatUrl,
      Map<String, dynamic>? map,
      String? authToken,
      String? userId}) async {
    print('this is map $map');
    var uri = Uri.parse(chatUrl! + Url.rocketChatDeletePrivateRoom);
    Request req = Request('POST', uri)
      ..body = Utils.encodeJson(map)
      ..headers.addAll(
        {
          'Content-Type': 'application/json',
          'X-Auth-Token': authToken!,
          'X-User-Id': userId!,
        },
      );
    print(uri.toString());
    StreamedResponse response = await req.send();
    final respStr = await response.stream.bytesToString();
    print('this is response $respStr');
    print('this is response ${response.statusCode}');
    if (response.statusCode >= Const.STATUS_OK && response.statusCode < 300) {
      ChatCreateChannelResponse chatCreateChannelResponse =
          ChatCreateChannelResponse.fromJson(json.decode(respStr));
      if (chatCreateChannelResponse.success!) {
        return chatCreateChannelResponse;
      } else {
        Utils.showToastMessage(chatCreateChannelResponse.error!);
        throw Exception(response);
      }
    } else if (response.statusCode >= Const.STATUS_BAD_REQUEST &&
        response.statusCode < 500) {
      ChatCreateChannelResponse chatRegisterUserResponse =
          ChatCreateChannelResponse.fromJson(json.decode(respStr));
      Utils.showToastMessage(chatRegisterUserResponse.error!);
      throw Exception(response);
    } else {
      throw Exception(response);
    }
  }

  Future<UsersListResponse> doChatChannelGetUserListApiCall(
      {String? chatUrl, String? authToken, String? userId}) async {
    var uri = Uri.parse(chatUrl! + Url.rocketChatGetUsersList);
    Request req = Request('GET', uri)
      ..headers.addAll(
        {
          'Content-Type': 'application/json',
          'X-Auth-Token': authToken!,
          'X-User-Id': userId!,
        },
      );
    print(uri.toString());
    StreamedResponse response = await req.send();
    final respStr = await response.stream.bytesToString();
    print('this is response $respStr');
    print('this is response ${response.statusCode}');
    if (response.statusCode >= Const.STATUS_OK && response.statusCode < 300) {
      UsersListResponse userListResponse =
          UsersListResponse.fromJson(json.decode(respStr));
      if (userListResponse.success!) {
        return userListResponse;
      } else {
        Utils.showToastMessage(userListResponse.error!);
        throw Exception(response);
      }
    } else if (response.statusCode >= Const.STATUS_BAD_REQUEST &&
        response.statusCode < 500) {
      ChatCreateChannelResponse chatRegisterUserResponse =
          ChatCreateChannelResponse.fromJson(json.decode(respStr));
      Utils.showToastMessage(chatRegisterUserResponse.error!);
      throw Exception(response);
    } else {
      throw Exception(response);
    }
  }

  Future<UsersListResponse> doChatChannelAddUserToChannelApiCall(
      {String? chatUrl,
      Map<String, dynamic>? map,
      String? authToken,
      String? userId}) async {
    print('this is map $map');
    var uri = Uri.parse(chatUrl! + Url.rocketChatAddUserToChannel);
    Request req = Request('POST', uri)
      ..body = Utils.encodeJson(map)
      ..headers.addAll(
        {
          'Content-Type': 'application/json',
          'X-Auth-Token': authToken!,
          'X-User-Id': userId!,
        },
      );
    print(uri.toString());
    StreamedResponse response = await req.send();
    final respStr = await response.stream.bytesToString();
    print('this is response $respStr');
    print('this is response ${response.statusCode}');
    if (response.statusCode >= Const.STATUS_OK && response.statusCode < 300) {
      UsersListResponse chatCreateChannelResponse =
          UsersListResponse.fromJson(json.decode(respStr));
      if (chatCreateChannelResponse.success!) {
        return chatCreateChannelResponse;
      } else {
        Utils.showToastMessage(chatCreateChannelResponse.error!);
        throw Exception(response);
      }
    } else if (response.statusCode >= Const.STATUS_BAD_REQUEST &&
        response.statusCode < 500) {
      ChatCreateChannelResponse chatRegisterUserResponse =
          ChatCreateChannelResponse.fromJson(json.decode(respStr));
      Utils.showToastMessage(chatRegisterUserResponse.error!);
      throw Exception(response);
    } else {
      throw Exception(response);
    }
  }

  Future<MembersListResponse> doChatChannelGetMemberListApiCall(
      {String? chatUrl,
      String? authToken,
      String? userId,
      String? roomId}) async {
    var uri = Uri.parse(
        chatUrl! + Url.rocketChatGetMembersList + "?roomId=" + roomId!);
    Request req = Request('GET', uri)
      ..headers.addAll(
        {
          'Content-Type': 'application/json',
          'X-Auth-Token': authToken!,
          'X-User-Id': userId!,
        },
      );
    print(uri.toString());
    StreamedResponse response = await req.send();
    final respStr = await response.stream.bytesToString();
    print('this is response $respStr');
    print('this is response ${response.statusCode}');
    if (response.statusCode >= Const.STATUS_OK && response.statusCode < 300) {
      MembersListResponse membersListResponse =
          MembersListResponse.fromJson(json.decode(respStr));
      if (membersListResponse.success!) {
        return membersListResponse;
      } else {
        Utils.showToastMessage(membersListResponse.error!);
        throw Exception(response);
      }
    } else if (response.statusCode >= Const.STATUS_BAD_REQUEST &&
        response.statusCode < 500) {
      ChatCreateChannelResponse chatRegisterUserResponse =
          ChatCreateChannelResponse.fromJson(json.decode(respStr));
      Utils.showToastMessage(chatRegisterUserResponse.error!);
      throw Exception(response);
    } else {
      throw Exception(response);
    }
  }

  Future<MembersListResponse> doChatChannelGetGroupMemberListApiCall(
      {String? chatUrl,
      String? authToken,
      String? userId,
      String? roomId}) async {
    var uri = Uri.parse(
        chatUrl! + Url.rocketChatGetGroupMembersList + "?roomId=" + roomId!);
    Request req = Request('GET', uri)
      ..headers.addAll(
        {
          'Content-Type': 'application/json',
          'X-Auth-Token': authToken!,
          'X-User-Id': userId!,
        },
      );
    print(uri.toString());
    StreamedResponse response = await req.send();
    final respStr = await response.stream.bytesToString();
    print('this is response $respStr');
    print('this is response ${response.statusCode}');
    if (response.statusCode >= Const.STATUS_OK && response.statusCode < 300) {
      MembersListResponse membersListResponse =
          MembersListResponse.fromJson(json.decode(respStr));
      if (membersListResponse.success!) {
        return membersListResponse;
      } else {
        Utils.showToastMessage(membersListResponse.error!);
        throw Exception(response);
      }
    } else if (response.statusCode >= Const.STATUS_BAD_REQUEST &&
        response.statusCode < 500) {
      ChatCreateChannelResponse chatRegisterUserResponse =
          ChatCreateChannelResponse.fromJson(json.decode(respStr));
      Utils.showToastMessage(chatRegisterUserResponse.error!);
      throw Exception(response);
    } else {
      throw Exception(response);
    }
  }

  Future<StartVideo> doStartVideoApiCall(
      {String? authToken, String? userId, Map? map}) async {
    var uri = Uri.parse(Config.baseUrl + Url.start_video);
    Request req = Request('POST', uri)
      ..body = Utils.encodeJson(map)
      ..headers.addAll(
        {
          'Content-Type': 'application/json',
          "Authorization":
              'Bearer ' + Prefs.getString(Const.VALUE_HOLDER_ACCESS_TOKEN)!,
        },
      );
    print(uri.toString());
    StreamedResponse response = await req.send();
    final respStr = await response.stream.bytesToString();
    print('this is response $respStr');
    print('this is response ${response.statusCode}');
    if (response.statusCode == Const.STATUS_OK) {
      StartVideo startVideoResponse = StartVideo.fromJson(json.decode(respStr));
      if (int.parse(startVideoResponse.result!.code!) >= 200 &&
          int.parse(startVideoResponse.result!.code!) < 300) {
        Utils.showToastMessage(startVideoResponse.result!.message!);
        return startVideoResponse;
      } else {
        Utils.showToastMessage(startVideoResponse.result!.message!);
        throw Exception(response);
      }
    } else {
      throw Exception(response);
    }
  }

  Future<ResponseAdmin> doAdminsApiCall() async {
    var uri = Uri.parse(Config.baseUrl + Url.admins);
    Request req = Request('POST', uri)
      ..body = "{}"
      ..headers.addAll(
        {
          'Content-Type': 'application/json',
          "Authorization":
              'Bearer ' + Prefs.getString(Const.VALUE_HOLDER_ACCESS_TOKEN)!,
        },
      );
    print(uri.toString());
    StreamedResponse response = await req.send();
    final respStr = await response.stream.bytesToString();
    print('this is response $respStr');
    print('this is response ${response.statusCode}');
    if (response.statusCode == Const.STATUS_OK) {
      ResponseAdmin adminsResponse =
          ResponseAdmin.fromJson(json.decode(respStr));
      if (int.parse(adminsResponse.result!.code!) >= 200 &&
          int.parse(adminsResponse.result!.code!) < 300) {
        Utils.showToastMessage(adminsResponse.result!.message!);
        return adminsResponse;
      } else {
        Utils.showToastMessage(adminsResponse.result!.message!);
        throw Exception(response);
      }
    } else {
      throw Exception(response);
    }
  }

  Future<UsersListResponse> doChatChannelRemoveUserFromChannelApiCall(
      {String? chatUrl,
      Map<String, dynamic>? map,
      String? authToken,
      String? userId}) async {
    print('this is map $map');
    var uri = Uri.parse(chatUrl! + Url.rocketChatRemoveUserFromChannel);
    Request req = Request('POST', uri)
      ..body = Utils.encodeJson(map)
      ..headers.addAll(
        {
          'Content-Type': 'application/json',
          'X-Auth-Token': authToken!,
          'X-User-Id': userId!,
        },
      );
    print(uri.toString());
    StreamedResponse response = await req.send();
    final respStr = await response.stream.bytesToString();
    print('this is response $respStr');
    print('this is response ${response.statusCode}');
    if (response.statusCode >= Const.STATUS_OK && response.statusCode < 300) {
      UsersListResponse chatCreateChannelResponse =
          UsersListResponse.fromJson(json.decode(respStr));
      if (chatCreateChannelResponse.success!) {
        return chatCreateChannelResponse;
      } else {
        Utils.showToastMessage(chatCreateChannelResponse.error!);
        throw Exception(response);
      }
    } else if (response.statusCode >= Const.STATUS_BAD_REQUEST &&
        response.statusCode < 500) {
      ChatCreateChannelResponse chatRegisterUserResponse =
          ChatCreateChannelResponse.fromJson(json.decode(respStr));
      Utils.showToastMessage(chatRegisterUserResponse.error!);
      throw Exception(response);
    } else {
      throw Exception(response);
    }
  }

  Future<ChatChannelJoinedResponse> doChatChannelChannelListApiCall(
      {String? chatUrl, String? authToken, String? userId}) async {
    var uri = Uri.parse(chatUrl! + Url.rocketChatChannelPublicChannelList);
    Request req = Request('GET', uri)
      ..headers.addAll(
        {
          'Content-Type': 'application/json',
          'X-Auth-Token': authToken!,
          'X-User-Id': userId!,
        },
      );
    print(uri.toString());
    StreamedResponse response = await req.send();
    final respStr = await response.stream.bytesToString();
    print('this is response $respStr');
    print('this is response ${response.statusCode}');
    if (response.statusCode >= Const.STATUS_OK && response.statusCode < 300) {
      ChatChannelJoinedResponse chatChannelJoinedResponse =
          ChatChannelJoinedResponse.fromJson(json.decode(respStr));
      if (chatChannelJoinedResponse.success!) {
        return chatChannelJoinedResponse;
      } else {
        Utils.showToastMessage(chatChannelJoinedResponse.error!);
        throw Exception(response);
      }
    } else if (response.statusCode >= Const.STATUS_BAD_REQUEST &&
        response.statusCode < 500) {
      ChatChannelJoinedResponse chatChannelJoinedResponse =
          ChatChannelJoinedResponse.fromJson(json.decode(respStr));
      Utils.showToastMessage(chatChannelJoinedResponse.error!);
      throw Exception(response);
    } else {
      throw Exception(response);
    }
  }

  Future<ChatCreateChannelResponse> doChatChannelJoinPublicChannel(
      {String? chatUrl,
      String? authToken,
      String? userId,
      Map<String, dynamic>? map}) async {
    var uri = Uri.parse(chatUrl! + Url.rocketChatChannelJoinPublicChannel);
    Request req = Request('POST', uri)
      ..body = Utils.encodeJson(map)
      ..headers.addAll(
        {
          'Content-Type': 'application/json',
          'X-Auth-Token': authToken!,
          'X-User-Id': userId!,
        },
      );
    print(uri.toString());
    StreamedResponse response = await req.send();
    final respStr = await response.stream.bytesToString();
    print('this is response $respStr');
    print('this is response ${response.statusCode}');
    if (response.statusCode >= Const.STATUS_OK && response.statusCode < 300) {
      ChatCreateChannelResponse chatCreateChannelResponse =
          ChatCreateChannelResponse.fromJson(json.decode(respStr));
      if (chatCreateChannelResponse.success!) {
        return chatCreateChannelResponse;
      } else {
        Utils.showToastMessage(chatCreateChannelResponse.error!);
        throw Exception(response);
      }
    } else if (response.statusCode >= Const.STATUS_BAD_REQUEST &&
        response.statusCode < 500) {
      ChatCreateChannelResponse chatCreateChannelResponse =
          ChatCreateChannelResponse.fromJson(json.decode(respStr));
      Utils.showToastMessage(chatCreateChannelResponse.error!);
      throw Exception(response);
    } else {
      throw Exception(response);
    }
  }

  Future<UsersListResponse> doChatChannelSetReactionApiCall(
      {String? chatUrl,
      Map<String, dynamic>? map,
      String? authToken,
      String? userId}) async {
    print('this is map $map');
    var uri = Uri.parse(chatUrl! + Url.rocketChatSetReaction);
    Request req = Request('POST', uri)
      ..body = Utils.encodeJson(map)
      ..headers.addAll(
        {
          'Content-Type': 'application/json',
          'X-Auth-Token': authToken!,
          'X-User-Id': userId!,
        },
      );
    print(uri.toString());
    StreamedResponse response = await req.send();
    final respStr = await response.stream.bytesToString();
    print('this is response $respStr');
    print('this is response ${response.statusCode}');
    if (response.statusCode >= Const.STATUS_OK && response.statusCode < 300) {
      UsersListResponse chatCreateChannelResponse =
          UsersListResponse.fromJson(json.decode(respStr));
      if (chatCreateChannelResponse.success!) {
        return chatCreateChannelResponse;
      } else {
        Utils.showToastMessage(chatCreateChannelResponse.error!);
        throw Exception(response);
      }
    } else if (response.statusCode >= Const.STATUS_BAD_REQUEST &&
        response.statusCode < 500) {
      ChatCreateChannelResponse chatRegisterUserResponse =
          ChatCreateChannelResponse.fromJson(json.decode(respStr));
      Utils.showToastMessage(chatRegisterUserResponse.error!);
      throw Exception(response);
    } else {
      throw Exception(response);
    }
  }

  Future doPushTypeApiCall({String? url, Map<String, dynamic>? body}) async {
    var uri = Uri.parse(Config.baseUrl + Url.update_push_notification_detail);
    Request req = Request('POST', uri)
      ..body = Utils.encodeJson(body)
      ..headers.addAll({
        'Content-Type': 'application/json',
        "Authorization":
            'Bearer ' + Prefs.getString(Const.VALUE_HOLDER_ACCESS_TOKEN)!,
      });
    print(uri.toString());
    StreamedResponse response = await req.send();
    final respStr = await response.stream.bytesToString();
    print('this is response $body');
    print('this is response $respStr');
    if (response.statusCode == Const.STATUS_OK) {
      ResponseSignIn responseSignIn =
          ResponseSignIn.fromJson(json.decode(respStr));
      if (int.parse(responseSignIn.result!.code!) >= 200 &&
          int.parse(responseSignIn.result!.code!) < 300) {
        return responseSignIn;
      } else if (int.parse(responseSignIn.result!.code!) >= 400 &&
          int.parse(responseSignIn.result!.code!) < 500) {
        return responseSignIn;
      } else {
        throw Exception(response);
      }
    } else {
      throw Exception(response);
    }
  }
}
