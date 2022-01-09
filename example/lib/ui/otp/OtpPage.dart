import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:live/bloc/otp_bloc/OtpBloc.dart';
import 'package:live/bloc/otp_bloc/OtpEvent.dart';
import 'package:live/bloc/otp_bloc/OtpState.dart';
import 'package:live/config/Config.dart';
import 'package:live/config/CustomColors.dart';
import 'package:live/constant/Constants.dart';
import 'package:live/constant/Dimens.dart';
import 'package:live/ui/common/AuthAppBar.dart';
import 'package:live/ui/common/ErrorToastWidget.dart';
import 'package:live/ui/common/NextBackWidget.dart';
import 'package:live/ui/otp_verification/OtpVerificationPage.dart';
import 'package:live/utils/Prefs.dart';
import 'package:live/utils/Utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:live/utils/Validation.dart';
import 'package:lottie/lottie.dart';

class OtpPage extends StatefulWidget {
  @override
  OtpPageState createState() => OtpPageState();
}

class OtpPageState extends State<OtpPage> with TickerProviderStateMixin {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  TextEditingController controllerNumber = TextEditingController();
  OtpBloc otpBloc = OtpBloc(InitialOtpState());
  String initialCountry = 'US';
  PhoneNumber number = PhoneNumber(isoCode: 'US');
  bool isLoading = false;
  String validationMessage = "";
  bool isValid = false;
  String phoneNumber = "";

  @override
  void initState()
  {
    super.initState();
    otpBloc = BlocProvider.of<OtpBloc>(context, listen: false);
  }

  @override
  void dispose()
  {
    controllerNumber.dispose();
    super.dispose();
  }

  submitMobileNo(BuildContext context, Map<String, dynamic> map)
  {
    otpBloc.add(OtpResponseEvent(map: map));
  }

  @override
  Widget build(BuildContext context)
  {

    // david+figma@peeq.live
    // spay_rik!scal4TUH
    return BlocConsumer(
      bloc: otpBloc,
      listener: (context, state)
      {
        if (state is OtpProgressState)
        {
          isLoading = true;
        }
        else if (state is OtpSuccessState)
        {
          isLoading = false;
          if(int.parse(state.otpResponse.result!.code!)>=200  && int.parse(state.otpResponse.result!.code!)<300)
          {
            validationMessage = "";
            Utils.showToastMessage(state.otpResponse.result!.message!);
            // Prefs.setString(Const.VALUE_HOLDER_USER_ID, state.otpResponse.result!.data!.userId!.toString());
            Prefs.setString(Const.VALUE_HOLDER_USER_PHONE, phoneNumber);
            Prefs.setString(Const.VALUE_HOLDER_SIGN_UP_ACCESS_TOKEN, state.otpResponse.result!.data!.accessToken!.toString());
            Utils.openActivity(context, OtpVerificationPage());
          }
          else if(int.parse(state.otpResponse.result!.code!)>=400  && int.parse(state.otpResponse.result!.code!)<500)
          {
            validationMessage = state.otpResponse.result!.message!;
          }
          else
          {
            validationMessage = Utils.getString("serverError");
          }
        }
        else if (state is OtpErrorState)
        {
          isLoading = false;
          validationMessage = state.errorMessage;
        }
      },
      builder: (context, state)
      {
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
                      child: Text(Utils.getString("yourNumber"),
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(
                            color: CustomColors.title_active,
                            fontFamily: Config.PoppinsSemiBold,
                            fontSize: Dimens.space32.sp,
                            fontWeight: FontWeight.normal,
                            fontStyle: FontStyle.normal,
                          )),
                    ),
                    // Container(
                    //   alignment: Alignment.centerLeft,
                    //   margin: EdgeInsets.fromLTRB(
                    //       Dimens.space0.w,
                    //       Dimens.space32.h,
                    //       Dimens.space0.w,
                    //       Dimens.space0.h),
                    //   padding: EdgeInsets.fromLTRB(
                    //       Dimens.space0.w,
                    //       Dimens.space0.h,
                    //       Dimens.space0.w,
                    //       Dimens.space0.h),
                    //   child: Text(Utils.getString("phoneNumber").toUpperCase(),
                    //       style: Theme.of(context)
                    //           .textTheme
                    //           .bodyText1!
                    //           .copyWith(
                    //         color: CustomColors.title_deactive,
                    //         fontFamily: Config.PoppinsSemiBold,
                    //         fontSize: Dimens.space10.sp,
                    //         fontWeight: FontWeight.bold,
                    //         fontStyle: FontStyle.normal,
                    //       )),
                    // ),
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.fromLTRB(
                          Dimens.space0.w,
                          Dimens.space44.h,
                          Dimens.space0.w,
                          Dimens.space0.h),
                      padding: EdgeInsets.fromLTRB(
                          Dimens.space0.w,
                          Dimens.space0.h,
                          Dimens.space0.w,
                          Dimens.space0.h),
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: CustomColors.field_line!,width: Dimens.space1.w)),
                      ),
                      child: InternationalPhoneNumberInput(
                        textStyle: TextStyle(color: CustomColors.field_textActive),
                        onInputChanged: (PhoneNumber number)
                        {
                          phoneNumber = number.phoneNumber.toString();
                          validationMessage = "";
                          setState(() {});
                        },
                        onInputValidated: (bool value)
                        {
                          isValid = value;
                          setState(() {});
                        },
                        spaceBetweenSelectorAndTextField: 0,
                        selectorConfig: SelectorConfig(selectorType: PhoneInputSelectorType.DIALOG,useEmoji: true),
                        ignoreBlank: false,
                        autoValidateMode: AutovalidateMode.disabled,
                        selectorTextStyle: TextStyle(color: CustomColors.text_active),
                        initialValue: number,
                        textFieldController: controllerNumber,
                        formatInput: false,
                        keyboardType: TextInputType.phone,
                        inputDecoration: InputDecoration(
                          hintText: Utils.getString("enterNumber").toUpperCase(),
                          hintStyle: TextStyle(color: CustomColors.text_deactive01, fontSize: 10),
                          //When the TextFormField is NOT on focus
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          //When the TextFormField is ON focus
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                        ),
                        onSaved: (PhoneNumber number)
                        {
                          print('On Saved: $number');
                        },
                      ),
                    ),
                    validationMessage.isEmpty
                        ? Container()
                        : ErrorToastWidget(message: validationMessage,),
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
                  String validation = SignUpValidation.isValidPhoneNumber(phoneNumber);
                  if (validation.isNotEmpty)
                  {
                    validationMessage = validation;
                    setState(() {});
                  }
                  else
                  {
                    validationMessage = validation;
                    setState(() {});
                    validationMessage.isNotEmpty
                        ? print('invalid number')
                        : submitMobileNo(context,
                      {
                        "params":
                        {
                          "mobileNumber": phoneNumber,
                        }
                      },
                    );
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
