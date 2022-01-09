import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live/bloc/yourEmail_bloc/YourEmailBloc.dart';
import 'package:live/bloc/yourEmail_bloc/YourEmailEvent.dart';
import 'package:live/bloc/yourEmail_bloc/YourEmailState.dart';
import 'package:live/config/Config.dart';
import 'package:live/config/CustomColors.dart';
import 'package:live/constant/Constants.dart';
import 'package:live/constant/Dimens.dart';
import 'package:live/ui/common/AuthAppBar.dart';
import 'package:live/ui/common/ErrorToastWidget.dart';
import 'package:live/ui/common/NextBackWidget.dart';
import 'package:live/ui/password/PasswordSetUpPage.dart';
import 'package:live/utils/Utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:live/utils/Validation.dart';
import 'package:live/utils/Prefs.dart';
import 'package:lottie/lottie.dart';

class YourEmailPage extends StatefulWidget
{
  @override
  YourEmailPageState createState() => YourEmailPageState();
}

class YourEmailPageState extends State<YourEmailPage>
{
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  TextEditingController controllerEmail = TextEditingController();
  YourEmailBloc yourEmailBloc = YourEmailBloc(InitialYourEmailState());
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
    yourEmailBloc.add(YourEmailResponseEvent(map: map));
  }

  @override
  Widget build(BuildContext context)
  {
    // david+figma@peeq.live
    // spay_rik!scal4TUH
    return BlocConsumer(
      bloc: yourEmailBloc,
      listener: (context, state)
      {
        print("this is state $state");
        if (state is YourEmailProgressState)
        {
          isLoading = true;
        }
        else if (state is YourEmailSuccessState)
        {
          isLoading = false;
          if(int.parse(state.responseYourEmail.result!.code!)>=200  && int.parse(state.responseYourEmail.result!.code!)<300)
          {
            validationMessage = "";
            Prefs.setString(Const.VALUE_HOLDER_USER_EMAIL, controllerEmail.text);
            Utils.openActivity(context, PasswordSetUpPage());
          }
          else if(int.parse(state.responseYourEmail.result!.code!)>=400  && int.parse(state.responseYourEmail.result!.code!)<500)
          {
            validationMessage = state.responseYourEmail.result!.message!;
          }
          else
          {
            validationMessage = Utils.getString("serverError");
          }
        }
        else if (state is YourEmailErrorState)
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
                margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                    Dimens.space0.w, Dimens.space0.h),
                padding: EdgeInsets.fromLTRB(Dimens.space24.w, Dimens.space0.h,
                    Dimens.space24.w, Dimens.space0.h),
                child: ListView(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space32.h, Dimens.space0.w, Dimens.space0.h),
                      padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      child: Text(Utils.getString("whatsYourEmail"),
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
                      child: Text(Utils.getString("yourEmail").toUpperCase(),
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
                            "user_id": Prefs.getString(Const.VALUE_HOLDER_USER_ID),
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
