import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live/bloc/otpVerification_bloc/OtpVerificationBloc.dart';
import 'package:live/bloc/otpVerification_bloc/OtpVerificationEvent.dart';
import 'package:live/bloc/otpVerification_bloc/OtpVerificationState.dart';
import 'package:live/config/Config.dart';
import 'package:live/config/CustomColors.dart';
import 'package:live/constant/Constants.dart';
import 'package:live/constant/Dimens.dart';
import 'package:live/ui/common/AuthAppBar.dart';
import 'package:live/ui/common/ErrorToastWidget.dart';
import 'package:live/ui/common/NextBackWidget.dart';
import 'package:live/ui/your_name/YourNamePage.dart';
import 'package:live/utils/Prefs.dart';
import 'package:live/utils/Utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:otp_text_field/otp_text_field.dart';

class OtpVerificationPage extends StatefulWidget {
  @override
  OtpVerificationPageState createState() => OtpVerificationPageState();
}

class OtpVerificationPageState extends State<OtpVerificationPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  String code = "";
  OtpVerificationBloc otpVerificationBloc = OtpVerificationBloc(InitialOtpVerificationState());
  String validationMessage = "";
  bool isLoading = false;
  bool isValid = false;

  @override
  void initState()
  {
    super.initState();
    otpVerificationBloc = BlocProvider.of<OtpVerificationBloc>(context, listen: false);
  }

  @override
  void dispose()
  {
    super.dispose();
  }

  submitForm(BuildContext context, Map<String, dynamic> map)
  {
    otpVerificationBloc.add(OtpVerificationResponseEvent(map: map));
  }

  @override
  Widget build(BuildContext context) {
    // david+figma@peeq.live
    // spay_rik!scal4TUH
    return BlocConsumer(
      bloc: otpVerificationBloc,
      listener: (context, state) {
        print("this is state $state");
        if (state is OtpVerificationProgressState)
        {
          isLoading = true;
        }
        else if (state is OtpVerificationSuccessState)
        {
          isLoading = false;
          if(int.parse(state.otpVerificationResponse.result!.code!)>=200  && int.parse(state.otpVerificationResponse.result!.code!)<300)
          {
            validationMessage = "";
            Utils.showToastMessage(state.otpVerificationResponse.result!.message!);
            Utils.openActivity(context, YourNamePage());
          }
          else if(int.parse(state.otpVerificationResponse.result!.code!)>=400  && int.parse(state.otpVerificationResponse.result!.code!)<500)
          {
            validationMessage = state.otpVerificationResponse.result!.message!;
            // Utils.openActivity(context, YourNamePage());
          }
          else
          {
            validationMessage = Utils.getString("serverError");
          }
        }
        else if (state is OtpVerificationErrorState)
        {
          isLoading = false;
          validationMessage = state.errorMessage;
        }
      },
      builder: (context, state) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Scaffold(
              key: _scaffoldKey,
              backgroundColor: CustomColors.background_bg01,
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
                margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                padding: EdgeInsets.fromLTRB(Dimens.space24.w, Dimens.space0.h, Dimens.space24.w, Dimens.space0.h),
                child: ListView(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space32.h, Dimens.space0.w, Dimens.space0.h),
                      padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      child: Text(Utils.getString("verify"),
                          style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            color: CustomColors.title_active,
                            fontFamily: Config.PoppinsSemiBold,
                            fontSize: Dimens.space32.sp,
                            fontWeight: FontWeight.normal,
                            fontStyle: FontStyle.normal,
                          )),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space73.h,
                          Dimens.space0.w, Dimens.space0.h),
                      padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                          Dimens.space0.w, Dimens.space0.h),
                      child: RichText(
                        text: TextSpan(
                         text: Utils.getString("weHaveSend").toUpperCase(),
                          style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            color: CustomColors.title_deactive,
                            fontFamily: Config.PoppinsSemiBold,
                            fontSize: Dimens.space13.sp,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.normal,
                          ),
                          children: [
                        TextSpan(
                        text: Prefs?.getString(Const.VALUE_HOLDER_USER_PHONE)!,
                          style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            color: CustomColors.title_active,
                            fontFamily: Config.PoppinsSemiBold,
                            fontSize: Dimens.space13.sp,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.normal,
                          ),),
                          ]
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space35.h,
                          Dimens.space0.w, Dimens.space0.h),
                      padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                          Dimens.space0.w, Dimens.space0.h),
                      child: OTPTextField(
                        length: 4,
                        width: MediaQuery.of(context).size.width,
                        textFieldAlignment: MainAxisAlignment.spaceAround,
                        outlineBorderRadius: Dimens.space36.h,
                        keyboardType: TextInputType.number,
                        fieldWidth: 50,
                        otpFieldStyle: OtpFieldStyle(
                          backgroundColor: Colors.transparent,
                          borderColor: CustomColors.field_line!,
                          disabledBorderColor: CustomColors.title_active!,
                          enabledBorderColor: CustomColors.title_active!,
                          errorBorderColor: CustomColors.title_active!,
                          focusBorderColor: CustomColors.title_active!,
                        ),
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color:CustomColors.title_active,
                          fontFamily: Config.PoppinsSemiBold,
                          fontSize: Dimens.space36.sp,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.normal,
                        ),
                        onChanged: (pin)
                        {
                          code = pin;
                          if(code.length==4)
                          {
                            isValid = true;
                          }
                          else
                          {
                            isValid = false;
                          }
                          validationMessage = "";
                          setState(() {});
                        },
                        onCompleted: (pin)
                        {
                          print("Completed: " + pin);
                        },
                      ),
                    ),
                    validationMessage.isEmpty
                        ? Container()
                        : ErrorToastWidget(message: validationMessage),
                  ],
                ),
              ),
              extendBody: true,
              bottomSheet: NextBackWidget(
                backOnPress: ()
                {
                  Utils.closeActivity(context);
                },
                nextOnPress: ()
                {
                  Utils.unFocusKeyboard(context);
                  if(isValid)
                  {
                    submitForm(
                        context,
                        {
                          "params":{
                            "verificationCode":code,
                          }
                        });
                  }
                  else
                  {
                    validationMessage = Utils.getString("invalidCode");
                  }
                },
                isValid: isValid,
              ),
            ),
            isLoading ?
            Container(
              height: Utils.getScreenHeight(context),
              width: Utils.getScreenWidth(context),
              color: CustomColors.title_active!.withOpacity(0.2),
              child: Center(
                child:Lottie.asset('assets/lottie/Peeq_loader.json',height: Utils.getScreenWidth(context) * 0.6,),              ),
            ): Container(),
          ],
        );
      },
    );

  }
}
