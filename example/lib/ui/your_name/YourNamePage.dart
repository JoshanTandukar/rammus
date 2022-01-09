import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live/bloc/yourName_bloc/YourNameBloc.dart';
import 'package:live/bloc/yourName_bloc/YourNameEvent.dart';
import 'package:live/bloc/yourName_bloc/YourNameState.dart';
import 'package:live/config/Config.dart';
import 'package:live/config/CustomColors.dart';
import 'package:live/constant/Constants.dart';
import 'package:live/constant/Dimens.dart';
import 'package:live/ui/birthday/BrithdayPage.dart';
import 'package:live/ui/common/AuthAppBar.dart';
import 'package:live/ui/common/ErrorToastWidget.dart';
import 'package:live/ui/common/NextBackWidget.dart';
import 'package:live/utils/Prefs.dart';
import 'package:live/utils/Utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:live/utils/Validation.dart';
import 'package:lottie/lottie.dart';

class YourNamePage extends StatefulWidget {
  @override
  YourNamePageState createState() => YourNamePageState();
}

class YourNamePageState extends State<YourNamePage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  TextEditingController controllerName = TextEditingController();
  YourNameBloc yourNameBloc = YourNameBloc(InitialYourNameState());
  bool isLoading = false;
  String validationMessage = "";

  @override
  void initState() {
    super.initState();
    yourNameBloc = BlocProvider.of<YourNameBloc>(context, listen: false);
  }

  @override
  void dispose() {
    controllerName.dispose();
    super.dispose();
  }

  submitForm(BuildContext context, Map<String, dynamic> map) {
    yourNameBloc.add(YourNameResponseEvent(map: map));
  }

  @override
  Widget build(BuildContext context) {
    // david+figma@peeq.live
    // spay_rik!scal4TUH
    return BlocConsumer(
      bloc: yourNameBloc,
      listener: (context, state) {
        print("this is state $state");
        if (state is YourNameProgressState) {
          isLoading = true;
        } else if (state is YourNameSuccessState) {
          isLoading = false;
          Prefs.setString(Const.VALUE_HOLDER_USER_NAME, controllerName.text);
          Utils.openActivity(context, BirthdayPage());
        } else if (state is YourNameErrorState) {
          isLoading = false;
          validationMessage = state.errorMessage;
          Utils.showToastMessage("Somethings went wrong.");
          // Utils.openActivity(context, BirthdayPage());
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
                margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                    Dimens.space0.w, Dimens.space0.h),
                padding: EdgeInsets.fromLTRB(Dimens.space24.w, Dimens.space0.h,
                    Dimens.space24.w, Dimens.space0.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space32.h, Dimens.space0.w, Dimens.space0.h),
                      padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      child: Text(Utils.getString("whatsYourName"),
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
                      child: Text(
                          Utils.getString("fullName").toUpperCase(),
                          style:
                              Theme.of(context).textTheme.bodyText1!.copyWith(
                                    color: CustomColors.field_nameActive,
                                    fontFamily: Config.PoppinsSemiBold,
                                    fontSize: Dimens.space10.sp,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.normal,
                                  )),
                    ),
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space8.h, Dimens.space0.w, Dimens.space0.h),
                      padding: EdgeInsets.fromLTRB(Dimens.space0.w,
                          Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      child: TextField(
                        maxLines: 1,
                        controller: controllerName,
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
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
                                color:
                                    CustomColors.field_line!,
                                width: Dimens.space1.w),
                            borderRadius: BorderRadius.all(
                                Radius.circular(Dimens.space0.w)),
                          ),
                          disabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color:
                                    CustomColors.field_line!,
                                width: Dimens.space1.w),
                            borderRadius: BorderRadius.all(
                                Radius.circular(Dimens.space0.w)),
                          ),
                          errorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color:
                                    CustomColors.field_line!,
                                width: Dimens.space1.w),
                            borderRadius: BorderRadius.all(
                                Radius.circular(Dimens.space0.w)),
                          ),
                          focusedErrorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color:
                                    CustomColors.field_line!,
                                width: Dimens.space1.w),
                            borderRadius: BorderRadius.all(
                                Radius.circular(Dimens.space0.w)),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color:
                                    CustomColors.field_line!,
                                width: Dimens.space1.w),
                            borderRadius: BorderRadius.all(
                                Radius.circular(Dimens.space0.w)),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color:
                                    CustomColors.field_line!,
                                width: Dimens.space1.w),
                            borderRadius: BorderRadius.all(
                                Radius.circular(Dimens.space0.w)),
                          ),
                          suffixIcon: controllerName.text.length > 0
                              ? IconButton(
                                  icon: Icon(
                                    Icons.clear,
                                    color: CustomColors.icon_bg02,
                                    size: Dimens.space14.w,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      controllerName.text = "";
                                    });
                                  },
                                )
                              : Container(
                                  height: 1,
                                  width: 1,
                                ),
                          filled: true,
                          fillColor: Colors.transparent,
                          hintText: Utils.getString("yourName"),
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
                        : ErrorToastWidget(
                            message: validationMessage,
                          ),
                  ],
                ),
              ),
              extendBody: true,
              bottomSheet: NextBackWidget(
                backOnPress: () {
                  Utils.closeActivity(context);
                },
                nextOnPress: () {
                  if (controllerName.text.isNotEmpty) {
                    String validation =
                        SignUpValidation.isValidName(controllerName.text);
                    if (validation.isNotEmpty) {
                      validationMessage = validation;
                      setState(() {});
                    } else {
                      validationMessage = validation;
                      setState(() {});
                    }
                  } else {
                    validationMessage = "";
                    setState(() {});
                  }
                  Utils.unFocusKeyboard(context);
                  if (validationMessage.isEmpty &&
                      controllerName.text.isNotEmpty) {
                    submitForm(context, {
                      "params": {
                        "name": controllerName.text,
                      }
                    });
                  }
                },
                isValid:
                    validationMessage.isEmpty && controllerName.text.isNotEmpty
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
                      child:Lottie.asset('assets/lottie/Peeq_loader.json',height: Utils.getScreenWidth(context) * 0.6,),                    ),
                  )
                : Container(),
          ],
        );
      },
    );
  }
}
