import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live/bloc/forgetPassword_bloc/ForgetPasswordBloc.dart';
import 'package:live/bloc/forgetPassword_bloc/ForgetPasswordEvent.dart';
import 'package:live/bloc/forgetPassword_bloc/ForgetPasswordState.dart';
import 'package:live/config/Config.dart';
import 'package:live/config/CustomColors.dart';
import 'package:live/constant/Dimens.dart';
import 'package:live/ui/common/AuthAppBar.dart';
import 'package:live/ui/common/ErrorToastWidget.dart';
import 'package:live/ui/common/NextBackWidget.dart';
import 'package:live/utils/Utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:live/utils/Validation.dart';
import 'package:lottie/lottie.dart';

class ForgetPasswordPage extends StatefulWidget
{
  @override
  ForgetPasswordPageState createState() => ForgetPasswordPageState();
}

class ForgetPasswordPageState extends State<ForgetPasswordPage>
{
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  TextEditingController controllerEmail = TextEditingController();
  ForgetPasswordBloc forgetPasswordBloc = ForgetPasswordBloc(InitialForgetPasswordState());
  bool isLoading = false;
  String validationMessage = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose()
  {
    controllerEmail.dispose();
    super.dispose();
  }

  submitForm(BuildContext context, Map<String, dynamic> map)
  {
    forgetPasswordBloc.add(ForgetPasswordResponseEvent(map: map));
  }

  @override
  Widget build(BuildContext context)
  {
    // david+figma@peeq.live
    // spay_rik!scal4TUH
    return BlocConsumer(
      bloc: forgetPasswordBloc,
      listener: (context, state)
      {
        print("this is state $state");
        if (state is ForgetPasswordProgressState)
        {
          isLoading = true;
        }
        else if (state is ForgetPasswordSuccessState)
        {
          isLoading = false;
          if(int.parse(state.forgetPassword.result!.code!)>=200  && int.parse(state.forgetPassword.result!.code!)<300)
          {
            validationMessage = state.forgetPassword.result!.data![0].message!;
          }
          else if(int.parse(state.forgetPassword.result!.code!)>=400  && int.parse(state.forgetPassword.result!.code!)<500)
          {
            validationMessage = state.forgetPassword.result!.data![0].message!;
          }
          else
          {
            validationMessage = Utils.getString("serverError");
          }
        }
        else if (state is ForgetPasswordErrorState)
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
                      margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space32.h, Dimens.space0.w, Dimens.space0.h),
                      padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      child: Text(Utils.getString("forgotPassword"),
                          style:
                          Theme.of(context).textTheme.bodyText1!.copyWith(
                            color: CustomColors.title_active,
                            fontFamily: Config.PoppinsSemiBold,
                            fontSize: Dimens.space32.sp,
                            fontWeight: FontWeight.normal,
                            fontStyle: FontStyle.normal,
                          )),
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
                            fontFamily: Config.PoppinsSemiBold,
                            fontSize: Dimens.space10.sp,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.normal,
                          ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space8.h, Dimens.space0.w, Dimens.space0.h),
                      padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      child: TextField(
                        maxLines: 1,
                        controller: controllerEmail,
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
                            color: CustomColors.title_active,
                            fontFamily: Config.InterSemiBold,
                            fontSize: Dimens.space16.sp,
                            fontWeight: FontWeight.normal),
                        textAlign: TextAlign.left,
                        textAlignVertical: TextAlignVertical.center,
                        onChanged: (value)
                        {
                          validationMessage ="";
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
                          suffixIcon: controllerEmail.text.length > 0? IconButton(
                            icon: Icon(
                              Icons.clear,
                              color: CustomColors.title_deactive,
                              size: Dimens.space14.w,
                            ),
                            onPressed: ()
                            {
                              setState(() {
                                controllerEmail.text = "";
                              });
                            },
                          ):Container(height: 1,width: 1,),
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
                    validationMessage.isEmpty
                        ? Container()
                        : ErrorToastWidget(message: validationMessage,),
                  ],
                ),
              ),
              extendBody: true,
              bottomSheet: NextBackWidget(
                nextButtonText: Utils.getString("resetPassword"),
                backOnPress: ()
                {
                  Utils.closeActivity(context);
                },
                nextOnPress: ()
                {
                  Utils.unFocusKeyboard(context);
                  String validation = SignUpValidation.isValidEmail(controllerEmail.text);
                  if (validation.isNotEmpty)
                  {
                    validationMessage = validation;
                    setState(() {});
                  }
                  else
                  {
                    validationMessage = validation;
                    setState(() {});
                    submitForm(
                        context,
                        {
                          "params":{
                            "email": controllerEmail.text,
                          }
                        });
                  }
                },
                isValid: validationMessage.isEmpty && controllerEmail.text.isNotEmpty?true:false,
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
