import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:live/bloc/chat_create_channel/ChatCreateChannelBloc.dart';
import 'package:live/bloc/chat_create_channel/ChatCreateChannelEvent.dart';
import 'package:live/bloc/chat_create_channel/ChatCreateChannelState.dart';
import 'package:live/config/Config.dart';
import 'package:live/config/CustomColors.dart';
import 'package:live/constant/Dimens.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:live/ui/common/ButtonWidget.dart';
import 'package:live/utils/Utils.dart';
import 'package:live/utils/Validation.dart';
import 'package:lottie/lottie.dart';

class CreateChannelDialog extends StatefulWidget
{
  final int urlIndex;
  final VoidCallback onChannelCreateSuccess;

  CreateChannelDialog({
    Key? key,
    required this.urlIndex,
    required this.onChannelCreateSuccess,
  }) : super(key: key);

  @override
  CreateChannelDialogState createState() => CreateChannelDialogState();
}

class CreateChannelDialogState extends State<CreateChannelDialog>
{

  ChatCreateChannelBloc chatCreateChannelBloc = ChatCreateChannelBloc(InitialChatCreateChannelState());
  TextEditingController controllerChannelName = TextEditingController();
  bool isPrivate = false;
  bool isReadOnly = false;
  bool isEncrypted = false;
  bool isValid = true;
  bool isLoading =false;

  @override
  void initState()
  {
    super.initState();
    chatCreateChannelBloc = BlocProvider.of<ChatCreateChannelBloc>(context, listen: false);
  }

  @override
  void dispose()
  {
    controllerChannelName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context)
  {
    return BlocConsumer(
      bloc: chatCreateChannelBloc,
      listener: (context, state)
      {
        print("this is state $state");
        if (state is ChatCreateChannelProgressState)
        {
          isLoading = true;
        }
        else if (state is ChatCreateChannelSuccessState)
        {
          isLoading = false;
          widget.onChannelCreateSuccess();
          Utils.closeActivity(context);
        }
        else if (state is ChatCreateChannelErrorState)
        {
          isLoading = false;
          Utils.showToastMessage(state.errorMessage);
        }
      },
      builder: (context, state)
      {
        return Stack(
          alignment: Alignment.center,
          children: [
            Scaffold(
              backgroundColor: Colors.transparent,
              resizeToAvoidBottomInset: true,
              bottomSheet: Container(
                decoration: BoxDecoration(
                  color: Color(0xff181A20),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(Dimens.space12.r),
                    topRight: Radius.circular(Dimens.space12.r),
                  ),
                ),
                height: Dimens.space500.h,
                alignment: Alignment.bottomCenter,
                margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children:
                  [
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.fromLTRB(Dimens.space20.w, Dimens.space10.h, Dimens.space10.w, Dimens.space20.h),
                      padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children:
                        [
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                            padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                            child: Text(
                              Utils.getString("createRoom"),
                              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                color: Color(0xffffffff),
                                fontFamily: Config.PoppinsSemiBold,
                                fontSize: Dimens.space18.sp,
                                fontWeight: FontWeight.normal,
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                            padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                            child: TextButton(
                              onPressed: ()
                              {
                                Utils.closeActivity(context);
                              },
                              child: Text(
                                Utils.getString("cancel"),
                                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                  color: Color(0xff5E6272),
                                  fontFamily: Config.InterRegular,
                                  fontSize: Dimens.space14.sp,
                                  fontWeight: FontWeight.normal,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.fromLTRB(Dimens.space20.w, Dimens.space0.h, Dimens.space20.w, Dimens.space10.h),
                      padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      child: Text(Utils.getString("name").toUpperCase(),
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color: Color(0xff5E6272),
                          fontFamily: Config.InterBold,
                          fontSize: Dimens.space12.sp,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.fromLTRB(Dimens.space20.w, Dimens.space0.h, Dimens.space20.w, Dimens.space10.h),
                      padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      child: TextField(
                        maxLines: 1,
                        controller: controllerChannelName,
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
                          color: Color(0xffffffff),
                          fontFamily: Config.InterSemiBold,
                          fontSize: Dimens.space16.sp,
                          fontWeight: FontWeight.normal,
                        ),
                        textAlign: TextAlign.left,
                        textAlignVertical: TextAlignVertical.center,
                        onChanged: (value)
                        {
                          setState(() {});
                        },
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space5.h, Dimens.space0.w, Dimens.space5.h),
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: CustomColors.title_deactive!,
                                width: Dimens.space1.w),
                            borderRadius: BorderRadius.all(
                              Radius.circular(Dimens.space0.w),
                            ),
                          ),
                          disabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: CustomColors.title_deactive!,
                                width: Dimens.space1.w),
                            borderRadius: BorderRadius.all(
                              Radius.circular(Dimens.space0.w),
                            ),
                          ),
                          errorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: CustomColors.title_deactive!,
                                width: Dimens.space1.w),
                            borderRadius: BorderRadius.all(
                              Radius.circular(Dimens.space0.w),
                            ),
                          ),
                          focusedErrorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: CustomColors.title_deactive!,
                                width: Dimens.space1.w),
                            borderRadius: BorderRadius.all(
                              Radius.circular(Dimens.space0.w),
                            ),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: CustomColors.title_deactive!,
                                width: Dimens.space1.w),
                            borderRadius: BorderRadius.all(
                              Radius.circular(Dimens.space0.w),
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: CustomColors.title_deactive!,
                              width: Dimens.space1.w,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(Dimens.space0.w),
                            ),
                          ),
                          suffixIcon: controllerChannelName.text.length > 0 ?
                          IconButton(
                            icon: Icon(
                              Icons.clear,
                              color: CustomColors.title_deactive,
                              size: Dimens.space14.w,
                            ),
                            onPressed: ()
                            {
                              setState(()
                              {
                                controllerChannelName.text = "";
                              });
                            },
                          ):
                          Container(
                            height: 1,
                            width: 1,
                          ),
                          filled: true,
                          fillColor: Colors.transparent,
                          hintText: Utils.getString("name"),
                          hintStyle: Theme.of(context)
                              .textTheme
                              .bodyText2!
                              .copyWith(
                            color: Color(0xffffffff),
                            fontFamily: Config.InterSemiBold,
                            fontSize: Dimens.space16.sp,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.fromLTRB(Dimens.space20.w, Dimens.space10.h, Dimens.space10.w, Dimens.space20.h),
                      padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children:
                        [
                          Expanded(
                            child:  Container(
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                              padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children:
                                [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space10.h),
                                    padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                                    child: Text(Utils.getString("private"),
                                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                        color: Colors.white,
                                        fontFamily: Config.InterBold,
                                        fontSize: Dimens.space14.sp,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.normal,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                                    padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                                    child: Text(Utils.getString("privateDesc"),
                                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                        color: Color(0xff5E6272),
                                        fontFamily: Config.InterBold,
                                        fontSize: Dimens.space12.sp,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.normal,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                            padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                            child: FlutterSwitch(
                              width: Dimens.space40.w,
                              height: Dimens.space25.w,
                              toggleSize: Dimens.space20.w,
                              value: isPrivate,
                              onToggle: (value)
                              {
                                isPrivate = value;
                                setState(() {});
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.fromLTRB(Dimens.space20.w, Dimens.space10.h, Dimens.space10.w, Dimens.space20.h),
                      padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children:
                        [
                          Expanded(
                            child: Container(
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                              padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children:
                                [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space10.h),
                                    padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                                    child: Text(Utils.getString("readyOnly"),
                                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                        color: Colors.white,
                                        fontFamily: Config.InterBold,
                                        fontSize: Dimens.space14.sp,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.normal,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                                    padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                                    child: Text(Utils.getString("readyOnlyDesc"),
                                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                        color: Color(0xff5E6272),
                                        fontFamily: Config.InterBold,
                                        fontSize: Dimens.space12.sp,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.normal,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                            padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                            child: FlutterSwitch(
                              width: Dimens.space40.w,
                              height: Dimens.space25.w,
                              toggleSize: Dimens.space20.w,
                              value: isReadOnly,
                              onToggle: (value)
                              {
                                isReadOnly = value;
                                setState(() {});
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.fromLTRB(Dimens.space20.w, Dimens.space10.h, Dimens.space10.w, Dimens.space20.h),
                      padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children:
                        [
                          Expanded(
                            child: Container(
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                              padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children:
                                [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space10.h),
                                    padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                                    child: Text(Utils.getString("encrypted"),
                                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                        color: Colors.white,
                                        fontFamily: Config.InterBold,
                                        fontSize: Dimens.space14.sp,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.normal,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                                    padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                                    child: Text(Utils.getString("encryptedDesc"),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                        color: Color(0xff5E6272),
                                        fontFamily: Config.InterBold,
                                        fontSize: Dimens.space12.sp,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.normal,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                            padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                            child: FlutterSwitch(
                              width: Dimens.space40.w,
                              height: Dimens.space25.w,
                              toggleSize: Dimens.space20.w,
                              value: isEncrypted,
                              onToggle: (value)
                              {
                                isEncrypted = value;
                                setState(() {});
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.fromLTRB(Dimens.space20.w, Dimens.space10.h, Dimens.space10.w, Dimens.space20.h),
                      padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      child: RoundedButtonWidget(
                        width: Dimens.space170.w,
                        height: Dimens.space48.h,
                        onPressed: ()
                        {
                          Utils.unFocusKeyboard(context);
                          String validation = ChannelNameValidation.idValidChannelName(controllerChannelName.text);
                          if(validation.isNotEmpty)
                          {
                            Utils.showToastMessage(validation);
                          }
                          else
                          {
                            isLoading = true;
                            setState(() {});
                            chatCreateChannelBloc.add(
                              ChatCreateChannelResponseEvent(
                                map: {
                                  "name": controllerChannelName.text.trim().replaceAll(" ", "_"),
                                  "type": isPrivate?1:0,
                                  "room": {
                                    "readOnly": isReadOnly,
                                  },
                                },
                                urlIndex: widget.urlIndex,
                              ),
                            );
                          }
                        },
                        corner: Dimens.space24.r,
                        buttonTextColor:isValid ?CustomColors.button_textActive: CustomColors.button_deactiveButtonText,
                        buttonBorderColor: isValid ? CustomColors.button_active! : CustomColors.button_deactive,
                        buttonBackgroundColor: isValid ? CustomColors.button_active! : CustomColors.button_deactive,
                        buttonText: Utils.getString("create"),
                        fontStyle: FontStyle.normal,
                        titleTextAlign: TextAlign.center,
                        buttonFontSize: Dimens.space14.sp,
                        buttonFontWeight: FontWeight.normal,
                        buttonFontFamily: Config.InterBold,
                        hasShadow: false,
                      ),
                    ),
                  ],
                ),
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
    );
  }
}
