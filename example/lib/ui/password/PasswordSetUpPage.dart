import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ios_voip_kit/flutter_ios_voip_kit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:live/bloc/chat_bloc/ChatBloc.dart';
import 'package:live/bloc/chat_bloc/ChatEvent.dart';
import 'package:live/bloc/chat_bloc/ChatState.dart';
import 'package:live/bloc/register_bloc/RegisterBloc.dart';
import 'package:live/bloc/register_bloc/RegisterEvent.dart';
import 'package:live/bloc/register_bloc/RegisterState.dart';
import 'package:live/bloc/signin_bloc/SignInBloc.dart';
import 'package:live/bloc/signin_bloc/SignInEvent.dart';
import 'package:live/bloc/signin_bloc/SignInState.dart';
import 'package:live/config/Config.dart';
import 'package:live/config/CustomColors.dart';
import 'package:live/constant/Constants.dart';
import 'package:live/constant/Dimens.dart';
import 'package:live/ui/common/AuthAppBar.dart';
import 'package:live/ui/common/CustomImageHolder.dart';
import 'package:live/ui/common/ErrorToastWidget.dart';
import 'package:live/ui/common/NextBackWidget.dart';
import 'package:live/ui/notification_permission/NotificationPermissionPage.dart';
import 'package:live/utils/Prefs.dart';
import 'package:live/utils/Utils.dart';
import 'package:live/utils/Validation.dart';
import 'package:lottie/lottie.dart';

class PasswordSetUpPage extends StatefulWidget {
  @override
  PasswordSetUpPageState createState() => PasswordSetUpPageState();
}

class PasswordSetUpPageState extends State<PasswordSetUpPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  TextEditingController controllerPassword = TextEditingController();
  RegisterBloc registerBloc = RegisterBloc(InitialRegisterState());
  SignInBloc signInBloc = SignInBloc(InitialSignInState());
  ChatBloc chatBloc = ChatBloc(InitialChatState());

  final _controller = ScrollController();

  bool isLoading = false;

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  String validationMessage = "";

  String healthRecordsRoomId = "";
  String healthRecordsRoomName = "";
  String? token;

  @override
  void initState() {
    super.initState();
    registerBloc = BlocProvider.of<RegisterBloc>(context, listen: false);
    signInBloc = BlocProvider.of<SignInBloc>(context, listen: false);
    chatBloc = BlocProvider.of<ChatBloc>(context, listen: false);
    getToken();
  }

  submitForm(BuildContext context, Map<String, dynamic> body) {
    registerBloc.add(RegisterResponseEvent(body: body));
  }

  @override
  void dispose() {
    controllerPassword.dispose();
    super.dispose();
  }

  getToken() async {
    if (Platform.isIOS) {
      token = await FlutterIOSVoIPKit.instance.getVoIPToken();
    } else {
      token = await FirebaseMessaging.instance.getToken();
    }
    return token;
  }

  @override
  Widget build(BuildContext context) {
    // david+figma@peeq.live
    // spay_rik!scal4TUH
    return MultiBlocListener(
      listeners: [
        BlocListener<RegisterBloc, RegisterState>(
          bloc: registerBloc,
          listener: (context, state) {
            if (state is RegisterProgressState) {
              isLoading = true;
            } else if (state is RegisterSuccessState) {
              Prefs.setString(
                  Const.VALUE_HOLDER_USER_PASSWORD, controllerPassword.text);
              if (int.parse(state.registerResponse.result!.code!) >= 200 &&
                  int.parse(state.registerResponse.result!.code!) < 300) {
                validationMessage = "";

                ///TODO fcm notification
                signInBloc.add(
                  SignInResponseEvent(
                    map: {
                      "params": {
                        "email": Prefs.getString(Const.VALUE_HOLDER_USER_EMAIL),
                        "password":
                            Prefs.getString(Const.VALUE_HOLDER_USER_PASSWORD),
                        "signInMobileOs": Platform.isIOS ? "IOS" : "ANDROID",
                        "callNotificationToken": token,
                      }
                    },
                  ),
                );
              } else if (int.parse(state.registerResponse.result!.code!) >=
                      400 &&
                  int.parse(state.registerResponse.result!.code!) < 500) {
                validationMessage = state.registerResponse.result!.message!;
              } else {
                validationMessage = "serverError";
              }
            } else if (state is RegisterErrorState) {
              isLoading = false;
              validationMessage = state.errorMessage;
            }
          },
        ),
        BlocListener<SignInBloc, SignInState>(
          bloc: signInBloc,
          listener: (context, state) {
            if (state is SignInSuccessState) {
              if (int.parse(state.responseSignIn.result!.code!) >= 200 &&
                  int.parse(state.responseSignIn.result!.code!) < 300) {
                validationMessage = "";
                Prefs.setString(Const.VALUE_HOLDER_USER_ID,
                    state.responseSignIn.result!.data!.userId!.toString());
                Prefs.setString(Const.VALUE_HOLDER_USER_EMAIL,
                    state.responseSignIn.result!.data!.userEmail!.toString());
                Prefs.setString(Const.VALUE_HOLDER_USER_PHONE,
                    state.responseSignIn.result!.data!.phonenumber!.toString());
                Prefs.setString(Const.VALUE_HOLDER_DOB,
                    state.responseSignIn.result!.data!.birthday!.toString());
                Prefs.setString(Const.VALUE_HOLDER_ACCESS_TOKEN,
                    state.responseSignIn.result!.data!.accessToken!.toString());
                Prefs.setString(
                    Const.VALUE_HOLDER_REFRESH_TOKEN,
                    state.responseSignIn.result!.data!.refreshToken!
                        .toString());
                Prefs.setString(Const.VALUE_HOLDER_USERNAME,
                    state.responseSignIn.result!.data!.username!.toString());
                chatBloc.add(
                  ChatRegisterEvent(
                    map: {
                      "email": Prefs.getString(Const.VALUE_HOLDER_USER_EMAIL),
                      "pass": Prefs.getString(Const.VALUE_HOLDER_USER_PASSWORD),
                      "name": Prefs.getString(Const.VALUE_HOLDER_USER_NAME),
                      "username": Prefs.getString(Const.VALUE_HOLDER_USERNAME),
                    },
                  ),
                );
              } else if (int.parse(state.responseSignIn.result!.code!) >= 400 &&
                  int.parse(state.responseSignIn.result!.code!) < 500) {
                validationMessage = state.responseSignIn.result!.data!.message!;
              } else {
                validationMessage = "serverError";
              }
            } else if (state is SignInErrorState) {
              isLoading = false;
              validationMessage = state.errorMessage;
            }
          },
        ),
        BlocListener<ChatBloc, ChatState>(
          bloc: chatBloc,
          listener: (context, state) {
            if (state is ChatRegisterSuccessState) {
              chatBloc.add(
                ChatLoginEvent(
                  map: {
                    "user": Prefs.getString(Const.VALUE_HOLDER_USER_EMAIL),
                    "password":
                        Prefs.getString(Const.VALUE_HOLDER_USER_PASSWORD),
                  },
                ),
              );
            } else if (state is ChatLoginSuccessState) {
              List<String> chatAuthToken = [];
              List<String> chatUserID = [];
              List<String> chatProfileImage = [];
              state.chatLoginUserResponse!.forEach((element) {
                chatAuthToken.add(element.data!.authToken!);
                chatUserID.add(element.data!.userId!);
                chatProfileImage.add(element.data!.me!.avatarUrl!);
              });

              Prefs.setStringList(
                  Const.VALUE_HOLDER_CHAT_AUTH_TOKEN, chatAuthToken);
              Prefs.setStringList(Const.VALUE_HOLDER_CHAT_USER_ID, chatUserID);
              Prefs.setStringList(
                  Const.VALUE_HOLDER_CHAT_PROFILE_IMAGE, chatProfileImage);

              /// Add user to all available public channels
              chatBloc.add(
                ChatChannelChannelListResponseEvent(),
              );
            }

            /// join public video channel for each user
            else if (state is ChatChannelListSuccessState) {
              List<String> mapList = [];
              for (int i = 0; i < state.chatChannelJoinedResponse.length; i++) {
                final index = state.chatChannelJoinedResponse[i].channels!
                    .indexWhere(
                        (element) => element.name!.toLowerCase() == "video");
                mapList.add(
                    state.chatChannelJoinedResponse[i].channels![index].sId!);
              }

              chatBloc
                  .add(ChatChannelJoinPublicChannelResponseEvent(map: mapList));
            }

            /// join success state
            else if (state is ChatChannelJoinSuccessState) {
              chatBloc.add(
                ChatChannelCreateHealthRecordChannelResponseEvent(
                  map: {
                    "name": Prefs.getString(Const.VALUE_HOLDER_USERNAME)!
                            .split(" ")[0]
                            .trim() +
                        "_Health_Records",
                    "readOnly": false,
                  },
                ),
              );
            }

            /// state for successful chat channel create state
            else if (state
                is ChatChannelCreateHealthRecordChannelSuccessState) {
              healthRecordsRoomId =
                  state.chatCreateChannelResponse!.channel!.sId!;
              healthRecordsRoomName =
                  state.chatCreateChannelResponse!.channel!.name!;
              chatBloc.add(
                ChatChannelSetDescriptionResponseEvent(
                  chatUrl: Config.listChatUrl[0],
                  authToken: Prefs.getStringList(
                      Const.VALUE_HOLDER_CHAT_AUTH_TOKEN)![0],
                  userId:
                      Prefs.getStringList(Const.VALUE_HOLDER_CHAT_USER_ID)![0],
                  map: {
                    "roomId": state.chatCreateChannelResponse!.channel!.sId!,
                    "description":
                        Prefs.getString(Const.VALUE_HOLDER_USER_NAME)!
                                .split(" ")[0]
                                .trim() +
                            " Health Records",
                  },
                ),
              );
            } else if (state is ChatChannelSetDescriptionSuccessState) {
              chatBloc.add(
                ChatChannelMakePrivateEvent(
                  chatUrl: Config.listChatUrl[0],
                  authToken: Prefs.getStringList(
                      Const.VALUE_HOLDER_CHAT_AUTH_TOKEN)![0],
                  userId:
                      Prefs.getStringList(Const.VALUE_HOLDER_CHAT_USER_ID)![0],
                  map: {
                    "roomId": healthRecordsRoomId,
                    "roomName": healthRecordsRoomName,
                    "type": "p"
                  },
                ),
              );
            }
            // else if(state is ChatChannelUsersListSuccessState)
            // {
            //   // int index = state.usersListResponse!.users!.indexWhere((element) => element.roles!.length>1);
            //   /// preparing static userID whom to join no roles fetched for user.
            //   chatBloc.add(
            //     ChatChannelAddUserToChannelResponseEvent(
            //         urlIndex: 1,
            //         map: {
            //           "roomId": healthRecordsRoomId,
            //           "userId": "XvNMRP7tivCG5rj5j",
            //         }
            //     ),
            //   );
            // }
            // else if(state is ChatChannelAddUserToChannelSuccessState)
            // {
            //   chatBloc.add(
            //     ChatChannelMakePrivateEvent(
            //       chatUrl: Config.listChatUrl[1],
            //       authToken: Prefs.getStringList(Const.VALUE_HOLDER_CHAT_AUTH_TOKEN)![1],
            //       userId: Prefs.getStringList(Const.VALUE_HOLDER_CHAT_USER_ID)![1],
            //       map: {
            //         "roomId": healthRecordsRoomId,
            //         "roomName": healthRecordsRoomName,
            //         "type": "p"
            //       },
            //     ),
            //   );
            // }
            else if (state is ChatChannelMakePrivateSuccessState) {
              isLoading = false;
              validationMessage = "";
              Utils.openActivity(context, NotificationPermissionPage());
            } else if (state is ChatErrorState) {
              isLoading = false;
              validationMessage = state.errorMessage;
            } else {
              isLoading = false;
              validationMessage = "Error Occurred";
            }
          },
        ),
      ],
      child: Scaffold(
        body: BlocBuilder(
          bloc: registerBloc,
          builder: (context, state) {
            print(
                "this is password validation ${ContactValidation.hasUpperCase(controllerPassword.text)} ${ContactValidation.hasLowerCase(controllerPassword.text)} ${ContactValidation.hasNumber(controllerPassword.text)} ${ContactValidation.hasSpecial(controllerPassword.text)}");
            return Stack(
              alignment: Alignment.center,
              children: [
                Scaffold(
                  key: _scaffoldKey,
                  backgroundColor: CustomColors.background_bg01,
                  resizeToAvoidBottomInset: true,
                  appBar: customAppBar(
                    context,
                    leading: true,
                    centerTitle: false,
                    backgroundColor: CustomColors.background_bg01,
                  ),
                  body: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    color: CustomColors.background_bg01,
                    margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    padding: EdgeInsets.fromLTRB(Dimens.space24.w,
                        Dimens.space0.h, Dimens.space24.w, Dimens.space0.h),
                    child: ListView(
                      controller: _controller,
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.fromLTRB(
                              Dimens.space0.w,
                              Dimens.space32.h,
                              Dimens.space0.w,
                              Dimens.space0.h),
                          padding: EdgeInsets.fromLTRB(
                              Dimens.space0.w,
                              Dimens.space0.h,
                              Dimens.space0.w,
                              Dimens.space0.h),
                          child: Text(
                            Utils.getString("setPassword"),
                            style:
                                Theme.of(context).textTheme.bodyText1!.copyWith(
                                      color: CustomColors.title_active,
                                      fontFamily: Config.PoppinsSemiBold,
                                      fontSize: Dimens.space32.sp,
                                      fontWeight: FontWeight.normal,
                                      fontStyle: FontStyle.normal,
                                    ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.fromLTRB(
                              Dimens.space0.w,
                              Dimens.space32.h,
                              Dimens.space0.w,
                              Dimens.space0.h),
                          padding: EdgeInsets.fromLTRB(
                              Dimens.space0.w,
                              Dimens.space0.h,
                              Dimens.space0.w,
                              Dimens.space0.h),
                          child: Text(
                            Utils.getString("password").toUpperCase(),
                            style:
                                Theme.of(context).textTheme.bodyText1!.copyWith(
                                      color: CustomColors.title_deactive,
                                      fontFamily: Config.InterBold,
                                      fontSize: Dimens.space10.sp,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.normal,
                                    ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.fromLTRB(
                              Dimens.space0.w,
                              Dimens.space8.h,
                              Dimens.space0.w,
                              Dimens.space0.h),
                          padding: EdgeInsets.fromLTRB(
                              Dimens.space0.w,
                              Dimens.space0.h,
                              Dimens.space0.w,
                              Dimens.space0.h),
                          child: TextField(
                            maxLines: 1,
                            controller: controllerPassword,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2!
                                .copyWith(
                                    color: CustomColors.title_active,
                                    fontFamily: Config.InterSemiBold,
                                    fontSize: Dimens.space16.sp,
                                    fontWeight: FontWeight.normal),
                            textAlign: TextAlign.left,
                            textAlignVertical: TextAlignVertical.center,
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: obscurePassword,
                            onChanged: (value) {
                              validationMessage = "";
                              setState(() {});
                            },
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.fromLTRB(
                                  Dimens.space0.w,
                                  Dimens.space12.h,
                                  Dimens.space0.w,
                                  Dimens.space12.h),
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: CustomColors.title_deactive!,
                                    width: Dimens.space1.w),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(Dimens.space0.w)),
                              ),
                              disabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: CustomColors.title_deactive!,
                                    width: Dimens.space1.w),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(Dimens.space0.w)),
                              ),
                              errorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: CustomColors.title_deactive!,
                                    width: Dimens.space1.w),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(Dimens.space0.w)),
                              ),
                              focusedErrorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: CustomColors.title_deactive!,
                                    width: Dimens.space1.w),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(Dimens.space0.w)),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: CustomColors.title_deactive!,
                                    width: Dimens.space1.w),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(Dimens.space0.w)),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: CustomColors.title_deactive!,
                                    width: Dimens.space1.w),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(Dimens.space0.w)),
                              ),
                              suffixIcon: controllerPassword.text.length > 0
                                  ? IconButton(
                                      icon: Icon(
                                        obscurePassword
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: CustomColors.title_deactive,
                                        size: Dimens.space14.w,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          obscurePassword = !obscurePassword;
                                        });
                                      },
                                    )
                                  : Container(
                                      height: 1,
                                      width: 1,
                                    ),
                              filled: true,
                              fillColor: Colors.transparent,
                              hintText: Utils.getString("password"),
                              hintStyle: Theme.of(context)
                                  .textTheme
                                  .bodyText2!
                                  .copyWith(
                                      color: CustomColors.title_active,
                                      fontFamily: Config.InterSemiBold,
                                      fontSize: Dimens.space16.sp,
                                      fontWeight: FontWeight.normal),
                            ),
                          ),
                        ),
                        validationMessage.isEmpty
                            ? Container()
                            : (validationMessage == "atLeast8Characters" ||
                                    validationMessage ==
                                        "atLeastOneCapitalLetter" ||
                                    validationMessage == "atLeastOneNumber" ||
                                    validationMessage ==
                                        "atLeastOneSpecialLetter" ||
                                    validationMessage == "invalidPassword")
                                ? Container(
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.fromLTRB(
                                        Dimens.space0.w,
                                        Dimens.space24.h,
                                        Dimens.space0.w,
                                        Dimens.space0.h),
                                    padding: EdgeInsets.fromLTRB(
                                        Dimens.space0.w,
                                        Dimens.space0.h,
                                        Dimens.space0.w,
                                        Dimens.space0.h),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          margin: EdgeInsets.fromLTRB(
                                              Dimens.space2.w,
                                              Dimens.space8.h,
                                              Dimens.space0.w,
                                              Dimens.space0.h),
                                          padding: EdgeInsets.fromLTRB(
                                              Dimens.space0.w,
                                              Dimens.space0.h,
                                              Dimens.space0.w,
                                              Dimens.space0.h),
                                          child: Text(
                                            Utils.getString(
                                                "yourPasswordMustHave"),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1!
                                                .copyWith(
                                                  color: CustomColors
                                                      .toast_text01!,
                                                  fontFamily:
                                                      Config.InterRegular,
                                                  fontSize: Dimens.space14.sp,
                                                  fontWeight: FontWeight.w600,
                                                  fontStyle: FontStyle.normal,
                                                ),
                                          ),
                                        ),
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          margin: EdgeInsets.fromLTRB(
                                              Dimens.space0.w,
                                              Dimens.space14.h,
                                              Dimens.space0.w,
                                              Dimens.space0.h),
                                          padding: EdgeInsets.fromLTRB(
                                              Dimens.space0.w,
                                              Dimens.space0.h,
                                              Dimens.space0.w,
                                              Dimens.space0.h),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Container(
                                                alignment: Alignment.center,
                                                margin: EdgeInsets.fromLTRB(
                                                    Dimens.space0.w,
                                                    Dimens.space0.h,
                                                    Dimens.space0.w,
                                                    Dimens.space0.h),
                                                padding: EdgeInsets.fromLTRB(
                                                    Dimens.space0.w,
                                                    Dimens.space0.h,
                                                    Dimens.space0.w,
                                                    Dimens.space0.h),
                                                child: Stack(
                                                  children: [
                                                    Positioned(
                                                      left: 3,
                                                      top: 3,
                                                      child: Container(
                                                        height: 12,
                                                        width: 12,
                                                        decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            50))),
                                                      ),
                                                    ),
                                                    RoundedNetworkImageHolder(
                                                        imageUrl: "",
                                                        width: Dimens.space16,
                                                        height: Dimens.space16,
                                                        iconUrl: controllerPassword
                                                                    .text
                                                                    .length <
                                                                8
                                                            ? Icons.cancel
                                                            : Icons
                                                                .check_circle,
                                                        iconSize:
                                                            Dimens.space16,
                                                        boxFit: BoxFit.contain,
                                                        boxDecorationColor:
                                                            Colors.transparent,
                                                        iconColor: controllerPassword
                                                                    .text
                                                                    .length <
                                                                8
                                                            ? CustomColors
                                                                .toast_error!
                                                            : CustomColors
                                                                .toast_success!,
                                                        onTap: () {}),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                alignment: Alignment.center,
                                                margin: EdgeInsets.fromLTRB(
                                                    Dimens.space5.w,
                                                    Dimens.space0.h,
                                                    Dimens.space0.w,
                                                    Dimens.space0.h),
                                                padding: EdgeInsets.fromLTRB(
                                                    Dimens.space0.w,
                                                    Dimens.space0.h,
                                                    Dimens.space0.w,
                                                    Dimens.space0.h),
                                                child: Text(
                                                  Utils.getString(
                                                      "atLeastCharacters"),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1!
                                                      .copyWith(
                                                        color: controllerPassword
                                                                    .text
                                                                    .length <
                                                                8
                                                            ? CustomColors
                                                                .toast_error!
                                                            : CustomColors
                                                                .toast_success!,
                                                        fontFamily:
                                                            Config.InterRegular,
                                                        fontSize:
                                                            Dimens.space14.sp,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontStyle:
                                                            FontStyle.normal,
                                                      ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          margin: EdgeInsets.fromLTRB(
                                              Dimens.space0.w,
                                              Dimens.space10.h,
                                              Dimens.space0.w,
                                              Dimens.space0.h),
                                          padding: EdgeInsets.fromLTRB(
                                              Dimens.space0.w,
                                              Dimens.space0.h,
                                              Dimens.space0.w,
                                              Dimens.space0.h),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Container(
                                                alignment: Alignment.center,
                                                margin: EdgeInsets.fromLTRB(
                                                    Dimens.space0.w,
                                                    Dimens.space0.h,
                                                    Dimens.space0.w,
                                                    Dimens.space0.h),
                                                padding: EdgeInsets.fromLTRB(
                                                    Dimens.space0.w,
                                                    Dimens.space0.h,
                                                    Dimens.space0.w,
                                                    Dimens.space0.h),
                                                child: Stack(
                                                  children: [
                                                    Positioned(
                                                      left: 3,
                                                      top: 3,
                                                      child: Container(
                                                        height: 12,
                                                        width: 12,
                                                        decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            50))),
                                                      ),
                                                    ),
                                                    RoundedNetworkImageHolder(
                                                        imageUrl: "",
                                                        width: Dimens.space16,
                                                        height: Dimens.space16,
                                                        iconUrl: !ContactValidation.hasUpperCase(controllerPassword.text) &&
                                                                !ContactValidation.hasLowerCase(
                                                                    controllerPassword
                                                                        .text) &&
                                                                !ContactValidation.hasNumber(
                                                                    controllerPassword
                                                                        .text) &&
                                                                !ContactValidation.hasSpecial(
                                                                    controllerPassword
                                                                        .text)
                                                            ? Icons.check_circle
                                                            : Icons.cancel,
                                                        iconSize:
                                                            Dimens.space16,
                                                        boxFit: BoxFit.contain,
                                                        boxDecorationColor:
                                                            Colors.transparent,
                                                        iconColor: ContactValidation.hasUpperCase(controllerPassword.text) &&
                                                                ContactValidation.hasLowerCase(
                                                                    controllerPassword
                                                                        .text) &&
                                                                ContactValidation.hasNumber(
                                                                    controllerPassword.text) &&
                                                                ContactValidation.hasSpecial(controllerPassword.text)
                                                            ? CustomColors.toast_success!
                                                            : CustomColors.toast_error!,
                                                        onTap: () {}),
                                                  ],
                                                ),
                                              ),
                                              Flexible(
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  margin: EdgeInsets.fromLTRB(
                                                      Dimens.space5.w,
                                                      Dimens.space0.h,
                                                      Dimens.space0.w,
                                                      Dimens.space0.h),
                                                  padding: EdgeInsets.fromLTRB(
                                                      Dimens.space0.w,
                                                      Dimens.space0.h,
                                                      Dimens.space0.w,
                                                      Dimens.space0.h),
                                                  child: Text(
                                                    Utils.getString(
                                                        "lettersNumbersCharacters"),
                                                    style:
                                                        Theme.of(context)
                                                            .textTheme
                                                            .bodyText1!
                                                            .copyWith(
                                                              color: ContactValidation.hasUpperCase(controllerPassword.text) &&
                                                                      ContactValidation.hasLowerCase(
                                                                          controllerPassword
                                                                              .text) &&
                                                                      ContactValidation.hasNumber(
                                                                          controllerPassword
                                                                              .text) &&
                                                                      ContactValidation.hasSpecial(
                                                                          controllerPassword
                                                                              .text)
                                                                  ? CustomColors
                                                                      .toast_success!
                                                                  : CustomColors
                                                                      .toast_error!,
                                                              fontFamily: Config
                                                                  .InterRegular,
                                                              fontSize: Dimens
                                                                  .space14.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              fontStyle:
                                                                  FontStyle
                                                                      .normal,
                                                            ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : ErrorToastWidget(
                                    message:
                                        Utils.getString(validationMessage)),
                      ],
                    ),
                  ),
                  extendBody: true,
                  bottomSheet: NextBackWidget(
                    backOnPress: () {
                      Utils.closeActivity(context);
                    },
                    nextOnPress: () {
                      Utils.unFocusKeyboard(context);
                      if (controllerPassword.text.isEmpty) {
                        validationMessage = "invalidPassword";
                        setState(() {});
                      } else if (controllerPassword.text.length < 8) {
                        validationMessage = "atLeast8Characters";
                        setState(() {});
                      } else if (!ContactValidation.hasUpperCase(
                          controllerPassword.text)) {
                        validationMessage = "atLeastOneCapitalLetter";
                        setState(() {});
                      } else if (!ContactValidation.hasUpperCase(
                          controllerPassword.text)) {
                        validationMessage = "atLeastOneSmallLetter";
                        setState(() {});
                      } else if (!ContactValidation.hasSpecial(
                          controllerPassword.text)) {
                        validationMessage = "atLeastOneSpecialLetter";
                        setState(() {});
                      } else if (!ContactValidation.hasNumber(
                          controllerPassword.text)) {
                        validationMessage = "atLeastOneNumber";
                        setState(() {});
                      } else {
                        validationMessage = "";
                        setState(() {});
                        submitForm(context, {
                          "params": {
                            "password": controllerPassword.text,
                            "user_id":
                                Prefs.getString(Const.VALUE_HOLDER_USER_ID),
                          }
                        });
                      }
                    },
                    isValid: validationMessage.isEmpty &&
                            controllerPassword.text.isNotEmpty
                        ? true
                        : false,
                  ),
                ),
                isLoading
                    ? Container(
                        height: Utils.getScreenHeight(context),
                        width: Utils.getScreenWidth(context),
                        color: CustomColors.title_active!.withOpacity(0.2),
                        child: Center(
                          child: Lottie.asset(
                            'assets/lottie/Peeq_loader.json',
                            height: Utils.getScreenWidth(context) * 0.6,
                          ),
                        ),
                      )
                    : Container(),
              ],
            );
          },
        ),
      ),
    );
  }
}
