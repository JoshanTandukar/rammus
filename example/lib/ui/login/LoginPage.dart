import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ios_voip_kit/flutter_ios_voip_kit.dart';
import 'package:live/bloc/chat_bloc/ChatBloc.dart';
import 'package:live/bloc/chat_bloc/ChatEvent.dart';
import 'package:live/bloc/chat_bloc/ChatState.dart';
import 'package:live/bloc/signin_bloc/SignInBloc.dart';
import 'package:live/bloc/signin_bloc/SignInEvent.dart';
import 'package:live/bloc/signin_bloc/SignInState.dart';
import 'package:live/config/Config.dart';
import 'package:live/config/CustomColors.dart';
import 'package:live/constant/Constants.dart';
import 'package:live/constant/Dimens.dart';
import 'package:live/ui/bottom_nav_bar/bottomNavBar.dart';
import 'package:live/ui/common/AuthAppBar.dart';
import 'package:live/ui/common/ErrorToastWidget.dart';
import 'package:live/ui/common/NextBackWidget.dart';
import 'package:live/ui/forget_password/ForgetPasswordPage.dart';
import 'package:live/utils/Prefs.dart';
import 'package:live/utils/Utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:live/utils/Validation.dart';
import 'package:lottie/lottie.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();
  bool isLoading = false;
  bool isValid = false;
  String validationMessage = "";
  SignInBloc signInBloc = SignInBloc(InitialSignInState());
  ChatBloc chatBloc = ChatBloc(InitialChatState());
  bool obscurePassword = true;
  String? voipToken;

  @override
  void initState() {
    super.initState();
    signInBloc = BlocProvider.of<SignInBloc>(context, listen: false);
    chatBloc = BlocProvider.of<ChatBloc>(context, listen: false);
    getToken();

  }

  getToken()async{
    voipToken = await FlutterIOSVoIPKit.instance.getVoIPToken();
    print("this is token $voipToken");
  }

  @override
  void dispose() {
    controllerEmail.dispose();
    super.dispose();
  }

  submitForm(BuildContext context, Map<String, dynamic> map) {
    ///In case of odoo down for now
    // chatBloc.add(
    //   ChatLoginEvent(
    //     map:
    //     {
    //       "user": controllerEmail.text,
    //       "password": controllerPassword.text,
    //     },
    //   ),
    // );
    ///In case of odoo down for now
    signInBloc.add(SignInResponseEvent(map: map));
  }

  @override
  Widget build(BuildContext context) {
    // david+figma@peeq.live
    // spay_rik!scal4TUH

    return MultiBlocListener(
      listeners: [
        BlocListener<SignInBloc, SignInState>(
          bloc: signInBloc,
          listener: (context, state)
          {
            if (state is SignInProgressState)
            {
              print("this is chat progress state");
              isLoading = true;
            }
            else if (state is SignInSuccessState)
            {
              print("this is chat success state");
              Prefs.setString(Const.VALUE_HOLDER_USER_EMAIL, controllerEmail.text);
              Prefs.setString(Const.VALUE_HOLDER_USER_PASSWORD, controllerPassword.text);
              if (int.parse(state.responseSignIn.result!.code!) >= 200 && int.parse(state.responseSignIn.result!.code!) < 300)
              {
                Prefs.setString(Const.VALUE_HOLDER_ACCESS_TOKEN, state.responseSignIn.result!.data!.accessToken!.toString());
                Prefs.setString(Const.VALUE_HOLDER_USER_ID, state.responseSignIn.result!.data!.userId!.toString());
                validationMessage = "";
                chatBloc.add(
                  ChatLoginEvent(
                    map: {
                      "user": Prefs.getString(Const.VALUE_HOLDER_USER_EMAIL),
                      "password": Prefs.getString(Const.VALUE_HOLDER_USER_PASSWORD),
                    },
                  ),
                );
              }
              else if (int.parse(state.responseSignIn.result!.code!) >= 400 && int.parse(state.responseSignIn.result!.code!) < 500)
              {
                print("this is chat state 400-500");
                isLoading = false;
                validationMessage = state.responseSignIn.result!.message!;
              }
              else
              {
                print("this is chat server s state");
                isLoading = false;
                validationMessage = "serverError";
              }
            }
            else if (state is SignInErrorState)
            {
              print("this is chat error state");
              isLoading = false;
              validationMessage = state.errorMessage;
            }
          },
        ),
        BlocListener<ChatBloc, ChatState>(
          bloc: chatBloc,
          listener: (context, state)
          {
            if (state is ChatProgressState)
            {
              print("this is chat progress state");
              isLoading = true;
            }
            else if (state is ChatLoginSuccessState)
            {
              print("this is chat success state");
              isLoading = false;
              validationMessage = "";

              List<String> chatAuthToken = [];
              List<String> chatUserID = [];
              List<String> chatProfileImage = [];
              List<String> chatFullName = [];
              List<String> chatUsername = [];

              state.chatLoginUserResponse!.forEach((element)
              {
                if(element.data!=null)
                {
                  chatAuthToken.add(element.data!.authToken!);
                  chatUserID.add(element.data!.userId!);
                  chatProfileImage.add(element.data!.me!.avatarUrl!);
                  chatFullName.add(element.data!.me!.name!);
                  chatUsername.add(element.data!.me!.username!);
                }
                else
                {
                  chatAuthToken.add("abc");
                  chatUserID.add("abc");
                  chatProfileImage.add("abc");
                  chatFullName.add("abc");
                  chatUsername.add("abc");
                }
              });

              print(chatFullName[0]);
              print(chatUsername[0]);
              Prefs.setStringList(Const.VALUE_HOLDER_CHAT_AUTH_TOKEN, chatAuthToken);
              Prefs.setStringList(Const.VALUE_HOLDER_CHAT_USER_ID, chatUserID);
              Prefs.setStringList(Const.VALUE_HOLDER_CHAT_PROFILE_IMAGE, chatProfileImage);
              Prefs.setString(Const.VALUE_HOLDER_USER_NAME, chatFullName[0]);
              Prefs.setString(Const.VALUE_HOLDER_USERNAME, chatUsername[0]);

              Utils.openActivity(context, TopLevel());
            }
            else if (state is ChatErrorState)
            {
              print("this is chat error state");
              isLoading = false;
              validationMessage = state.errorMessage;
            }
          },
        ),
      ],
      child: BlocBuilder(
        bloc: signInBloc,
        builder: (context, state)
        {
          print("this is password validation ${ContactValidation.hasUpperCase(controllerPassword.text)} ${ContactValidation.hasLowerCase(controllerPassword.text)} ${ContactValidation.hasNumber(controllerPassword.text)} ${ContactValidation.hasSpecial(controllerPassword.text)}");
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
                body: SafeArea(
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    color: CustomColors.background_bg01,
                    margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                        Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    padding: EdgeInsets.fromLTRB(Dimens.space24.w,
                        Dimens.space0.h, Dimens.space24.w, Dimens.space0.h),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
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
                            Utils.getString("login"),
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
                          margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                              Dimens.space32.h, Dimens.space0.w, Dimens.space0.h),
                          padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                              Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                          child: Text(Utils.getString("email").toUpperCase(),
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
                            controller: controllerEmail,
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
                              suffixIcon: controllerEmail.text.length > 0
                                  ? IconButton(
                                      icon: Icon(
                                        Icons.clear,
                                        color: CustomColors.title_deactive,
                                        size: Dimens.space14.w,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          controllerEmail.text = "";
                                        });
                                      },
                                    )
                                  : Container(
                                      height: 1,
                                      width: 1,
                                    ),
                              filled: true,
                              fillColor: Colors.transparent,
                              hintText: Utils.getString("yourEmail"),
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
                        Container(
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.fromLTRB(
                              Dimens.space0.w,
                              Dimens.space48.h,
                              Dimens.space0.w,
                              Dimens.space0.h),
                          padding: EdgeInsets.fromLTRB(
                              Dimens.space0.w,
                              Dimens.space0.h,
                              Dimens.space0.w,
                              Dimens.space0.h),
                          child: Text(Utils.getString("password").toUpperCase(),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
                                    color: CustomColors.title_deactive,
                                    fontFamily: Config.InterBold,
                                    fontSize: Dimens.space10.sp,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.normal,
                                  )),
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
                                      // fontSizee: Dimens.space16.sp,
                                      fontWeight: FontWeight.normal),
                            ),
                          ),
                        ),
                        TextButton(
                          style: ButtonStyle(
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            overlayColor: MaterialStateColor.resolveWith(
                                (states) => Colors.transparent),
                          ),
                          onPressed: () {
                            Utils.openActivity(context, ForgetPasswordPage());
                          },
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.only(top: Dimens.space22.h),
                              child: Text(
                                Utils.getString("forgotPwd"),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                      color: CustomColors.button_active,
                                      fontFamily: Config.InterBold,
                                      fontSize: Dimens.space11.sp,
                                      fontWeight: FontWeight.w800,
                                      fontStyle: FontStyle.normal,
                                    ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                        ),
                        validationMessage.isEmpty
                            ? Container()
                            : ErrorToastWidget(
                                message: validationMessage,
                              ),
                      ],
                    ),
                  ),
                ),
                extendBody: true,
                bottomSheet: NextBackWidget(
                  backOnPress: () {
                    Utils.closeActivity(context);
                  },
                  nextOnPress: () async
                  {
                    Utils.unFocusKeyboard(context);
                    String validation =
                    SignUpValidation.isValidEmail(controllerEmail.text);
                    if (controllerPassword.text.isEmpty) {
                      validationMessage = "invalidPassword";
                      setState(() {});
                    } else if (validation.isNotEmpty) {
                      validationMessage = validation;
                      setState(() {});
                    } else {
                      validationMessage = validation;
                      String? fcmToken = await FirebaseMessaging.instance.getToken();
                      setState(() {});
                      submitForm(context, {
                        "params": {
                          "email": controllerEmail.text,
                          "password": controllerPassword.text,
                          "signInMobileOs": Platform.isIOS? "IOS": "ANDROID",
                          "callNotificationToken": Platform.isIOS? voipToken: fcmToken,
                        }
                      });
                    }
                  },
                  isValid: validationMessage.isEmpty &&
                      controllerEmail.text.isNotEmpty &&
                      controllerPassword.text.isNotEmpty
                      ? true
                      : false,
                ),
              ),
              isLoading ?
              Container(
                height: Utils.getScreenHeight(context),
                width: Utils.getScreenWidth(context),
                color: CustomColors.title_active!.withOpacity(0.2),
                child: Center(
                  child: Lottie.asset(
                    'assets/lottie/Peeq_loader.json',
                    height: Utils.getScreenWidth(context) * 0.6,
                  ),
                ),
              ) : Container(),
            ],
          );
        },
      ),
    );
  }
}
