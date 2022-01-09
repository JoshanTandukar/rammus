import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:live/bloc/birthday_bloc/BirthdayBloc.dart';
import 'package:live/bloc/birthday_bloc/BirthdayEvent.dart';
import 'package:live/bloc/birthday_bloc/BirthdayState.dart';
import 'package:live/config/Config.dart';
import 'package:live/config/CustomColors.dart';
import 'package:live/constant/Constants.dart';
import 'package:live/constant/Dimens.dart';
import 'package:live/ui/common/AuthAppBar.dart';
import 'package:live/ui/common/ErrorToastWidget.dart';
import 'package:live/ui/common/NextBackWidget.dart';
import 'package:live/ui/your_email/YourEmailPage.dart';
import 'package:live/utils/Prefs.dart';
import 'package:live/utils/Utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:live/utils/Validation.dart';
import 'package:lottie/lottie.dart';

class BirthdayPage extends StatefulWidget
{
  @override
  BirthdayPageState createState() => BirthdayPageState();
}

class BirthdayPageState extends State<BirthdayPage>
{

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  TextEditingController controllerBirthday = TextEditingController();
  BirthdayBloc  birthdayBloc = BirthdayBloc(InitialBirthdayState());
  bool isLoading = false;
  String validationMessage = "";
  bool isValid = false;

  @override
  void initState()
  {
    super.initState();
    birthdayBloc = BlocProvider.of<BirthdayBloc>(context, listen: false);
  }

  @override
  void dispose()
  {
    controllerBirthday.dispose();
    super.dispose();
  }

  submitForm(BuildContext context, Map<String, dynamic> map)
  {
     birthdayBloc.add(BirthdayResponseEvent(map: map));
  }

  @override
  Widget build(BuildContext context)
  {
    // david+figma@peeq.live
    // spay_rik!scal4TUH
    return BlocConsumer(
      bloc:  birthdayBloc,
      listener: (context, state)
      {
        print("this is state $state");
        if (state is BirthdayProgressState)
        {
          isLoading = true;
        }
        else if (state is BirthdaySuccessState)
        {
          isLoading = false;
          Prefs.setString(Const.VALUE_HOLDER_DOB, controllerBirthday.text.toString());
          Utils.openActivity(context, YourEmailPage());
        }
        else if (state is BirthdayErrorState)
        {
          isLoading = false;
          Utils.showToastMessage("Somethings went wrong.");
          // Utils.openActivity(context, YourEmailPage());
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
                      margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space32.h, Dimens.space0.w, Dimens.space0.h),
                      padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      child: Text(
                          Utils.getString("whatsYourBirthday"),
                          style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            color: CustomColors.title_active,
                            fontFamily: Config.PoppinsSemiBold,
                            fontSize: Dimens.space32.sp,
                            fontWeight: FontWeight.normal,
                            fontStyle: FontStyle.normal,
                          )
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space32.h, Dimens.space0.w, Dimens.space0.h),
                      padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      child: Text(
                          Utils.getString("needForLegalPurpose"),
                          style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            color: CustomColors.title_deactive,
                            fontFamily: Config.InterRegular,
                            fontSize: Dimens.space13.sp,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.normal,
                          )
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space32.h, Dimens.space0.w, Dimens.space0.h),
                      padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      child: Text(
                          Utils.getString("dob").toUpperCase(),
                          style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            color: CustomColors.title_deactive,
                            fontFamily: Config.PoppinsSemiBold,
                            fontSize: Dimens.space10.sp,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.normal,
                          )
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space8.h, Dimens.space0.w, Dimens.space0.h),
                      padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          alignment: Alignment.center,
                          padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                        ),
                        onPressed: ()
                        {
                          showPickerDialog();
                        },
                        child: TextField(
                          maxLines: 1,
                          controller: controllerBirthday,
                          readOnly: true,
                          enabled: false,
                          style: Theme.of(context).textTheme.bodyText2!.copyWith(
                              color: CustomColors.title_active,
                              fontFamily: Config.InterSemiBold,
                              fontSize: Dimens.space16.sp,
                              fontWeight: FontWeight.normal
                          ),
                          textAlign: TextAlign.left,
                          textAlignVertical: TextAlignVertical.center,
                          onChanged: (value)
                          {
                            if (value.isNotEmpty)
                            {
                              String validation = SignUpValidation.isValidName(value);
                              if (validation.isNotEmpty)
                              {
                                validationMessage = validation;
                                setState(() {});
                              }
                              else
                              {
                                validationMessage = validation;
                                setState(() {});
                              }
                            }
                            else
                            {
                              validationMessage = "";
                              setState(() {});
                            }
                          },
                          decoration: InputDecoration(
                            contentPadding:EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space12.h, Dimens.space0.w, Dimens.space12.h),
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(color: CustomColors.title_deactive!, width: Dimens.space1.w),
                              borderRadius: BorderRadius.all(Radius.circular(Dimens.space0.w)),
                            ),
                            disabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: CustomColors.title_deactive!, width: Dimens.space1.w),
                              borderRadius: BorderRadius.all(Radius.circular(Dimens.space0.w)),
                            ),
                            errorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: CustomColors.title_deactive!, width: Dimens.space1.w),
                              borderRadius: BorderRadius.all(Radius.circular(Dimens.space0.w)),
                            ),
                            focusedErrorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: CustomColors.title_deactive!, width: Dimens.space1.w),
                              borderRadius: BorderRadius.all(Radius.circular(Dimens.space0.w)),
                            ),
                            enabledBorder:UnderlineInputBorder(
                              borderSide: BorderSide(color: CustomColors.title_deactive!, width: Dimens.space1.w),
                              borderRadius: BorderRadius.all(Radius.circular(Dimens.space0.w)),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: CustomColors.title_deactive!, width: Dimens.space1.w),
                              borderRadius: BorderRadius.all(Radius.circular(Dimens.space0.w)),
                            ),
                            suffixIcon:controllerBirthday.text.length > 0? IconButton(
                              icon: Icon(
                                Icons.clear,
                                color: CustomColors.title_deactive,
                                size: Dimens.space14.w,
                              ),
                              onPressed: ()
                              {
                                setState(() {
                                  controllerBirthday.text = "";
                                });
                              },
                            ):Container(height: 1,width: 1,),
                            filled: true,
                            fillColor: Colors.transparent,
                            hintText: Utils.getString("dateFormat"),
                            hintStyle: Theme.of(context).textTheme.bodyText2!.copyWith(
                                color: CustomColors.title_active,
                                fontFamily: Config.InterSemiBold,
                                fontSize: Dimens.space16.sp,
                                fontWeight: FontWeight.normal
                            ),
                          ),
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
                  if(isValid)
                  {
                    validationMessage.isNotEmpty
                        ? print('invalid email')
                        : submitForm(
                        context,
                        {
                          "params":{
                            "dob":controllerBirthday.text,
                          }
                        });
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
            ) : Container(),
          ],
        );
      },
    );
  }

  void showPickerDialog()
  {
    LocaleType localType = LocaleType.en;
    for(int i=0; i<3; i++)
    {
      if(EasyLocalization.of(context)?.currentLocale!.languageCode == "zh")
        localType = LocaleType.zh;
      else if(EasyLocalization.of(context)?.currentLocale!.languageCode == "fr")
        localType = LocaleType.fr;
      else
        localType = LocaleType.en;
    }
    DatePicker.showDatePicker(
      context,
        showTitleActions: true,
        minTime: DateTime(1900, 01, 01),
        maxTime: DateTime(DateTime.now().year-18, DateTime.now().month, DateTime.now().day),
        theme: DatePickerTheme(
          backgroundColor: CustomColors.title_deactive!,
          cancelStyle: TextStyle(
            color: CustomColors.title_active,
            fontSize: Dimens.space16.sp,
          ),
          itemStyle: TextStyle(
            color: CustomColors.title_active,
            fontSize: Dimens.space20.sp,
          ),
        ),
        onChanged: (date)
        {
          print('change $date');
        },
        onConfirm: (date)
        {
          setState(()
          {
            isValid = true;
            controllerBirthday.text = DateFormat(Config.dateFormat).format(DateTime.parse(date.toString()));
          });
        },
        currentTime: DateTime.now(),
        locale: localType,
    );
  }
}
