// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:live/bloc/userNameValidation_bloc/UsernameValidationBloc.dart';
// import 'package:live/bloc/userNameValidation_bloc/UsernameValidationEvent.dart';
// import 'package:live/bloc/userNameValidation_bloc/UsernameValidationState.dart';
// import 'package:live/config/Config.dart';
// import 'package:live/config/CustomColors.dart';
// import 'package:live/constant/Constants.dart';
// import 'package:live/constant/Dimens.dart';
// import 'package:live/ui/common/AuthAppBar.dart';
// import 'package:live/ui/common/ErrorToastWidget.dart';
// import 'package:live/ui/common/NextBackWidget.dart';
// import 'package:live/ui/common/UsernameSuccessToastWidget.dart';
// import 'package:live/ui/password/PasswordSetUpPage.dart';
// import 'package:live/utils/Prefs.dart';
// import 'package:live/utils/Utils.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// class HostUserNamePage extends StatefulWidget
// {
//   @override
//   HostUserNamePageState createState() => HostUserNamePageState();
// }
//
// class HostUserNamePageState extends State<HostUserNamePage>
// {
//   GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
//   TextEditingController controllerUsername = TextEditingController();
//   UserNameValidationBloc usernameValidationBloc = UserNameValidationBloc(InitialUsernameValidationState());
//   bool isValid = false;
//   bool isLoading = false;
//   String validationMessage = "";
//
//   @override
//   void initState()
//   {
//     super.initState();
//     usernameValidationBloc = BlocProvider.of<UserNameValidationBloc>(context, listen: false);
//     controllerUsername.addListener(()
//     {
//       if(controllerUsername.text.isNotEmpty && controllerUsername.text.length>3)
//       {
//         usernameValidationBloc.add(
//             DoUsernameValidationEvent(
//                 map:
//                 {
//                   "params":{
//                     "user_name": controllerUsername.text
//                   }
//                 }));
//       }
//     });
//   }
//
//   @override
//   void dispose()
//   {
//     controllerUsername.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context)
//   {
//     // david+figma@peeq.live
//     // spay_rik!scal4TUH
//     return BlocConsumer(
//       bloc: usernameValidationBloc,
//       listener: (context, state)
//       {
//         print("this is state $state");
//         if (state is UsernameValidationProgressState)
//         {
//           isLoading = true;
//           isValid = false;
//         }
//         else if (state is UsernameValidationSuccessState)
//         {
//           isLoading = false;
//           isValid = true;
//         }
//         else if (state is UsernameValidationErrorState)
//         {
//           isLoading = false;
//           isValid = false;
//         }
//       },
//       builder: (context, state)
//       {
//         return Stack(
//           alignment: Alignment.center,
//           children: [
//             Scaffold(
//               key: _scaffoldKey,
//               backgroundColor: CustomColors.background_bg01,
//               resizeToAvoidBottomInset: true,
//               appBar: customAppBar(
//                 context,
//                 title:Utils.getString("getStarted"),
//                 centerTitle: true,
//                 leading: false,
//                 actions: null,
//               ),
//               body: Container(
//                 height: MediaQuery.of(context).size.height,
//                 width: MediaQuery.of(context).size.width,
//                 color: CustomColors.background_bg01,
//                 margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
//                 padding: EdgeInsets.fromLTRB(Dimens.space24.w, Dimens.space0.h, Dimens.space24.w, Dimens.space0.h),
//                 child: ListView(
//                   children: [
//                     Container(
//                       alignment: Alignment.centerLeft,
//                       margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space32.h,
//                           Dimens.space0.w, Dimens.space0.h),
//                       padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
//                           Dimens.space0.w, Dimens.space0.h),
//                       child: Text(Utils.getString("hostProfile"),
//                           style: Theme.of(context).textTheme.bodyText1!.copyWith(
//                             color: CustomColors.title_active,
//                             fontFamily: Config.PoppinsSemiBold,
//                             fontSize: Dimens.space32.sp,
//                             fontWeight: FontWeight.normal,
//                             fontStyle: FontStyle.normal,
//                           )),
//                     ),
//                     Container(
//                       alignment: Alignment.centerLeft,
//                       margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space11.h,
//                           Dimens.space0.w, Dimens.space0.h),
//                       padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
//                           Dimens.space0.w, Dimens.space0.h),
//                       child: Text(Utils.getString("createYourHostProfile"),
//                         style: Theme.of(context).textTheme.bodyText1!.copyWith(
//                           color: CustomColors.title_deactive,
//                           fontFamily: Config.InterRegular,
//                           fontSize: Dimens.space13.sp,
//                           fontWeight: FontWeight.normal,
//                           fontStyle: FontStyle.normal,
//                         ),
//                       ),
//                     ),
//                     Container(
//                       alignment: Alignment.centerLeft,
//                       margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space32.h, Dimens.space0.w, Dimens.space0.h),
//                       padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
//                       child: Text(
//                         Utils.getString("username").toUpperCase(),
//                         style: Theme.of(context).textTheme.bodyText1!.copyWith(
//                           color: CustomColors.title_deactive,
//                           fontFamily: Config.InterBold,
//                           fontSize: Dimens.space10.sp,
//                           fontWeight: FontWeight.bold,
//                           fontStyle: FontStyle.normal,
//                         ),
//                       ),
//                     ),
//                     Container(
//                       alignment: Alignment.center,
//                       margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space8.h, Dimens.space0.w, Dimens.space0.h),
//                       padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
//                       child: TextField(
//                         maxLines: 1,
//                         controller: controllerUsername,
//                         style: Theme.of(context).textTheme.bodyText2!.copyWith(
//                             color: CustomColors.title_active,
//                             fontFamily: Config.InterSemiBold,
//                             fontSize: Dimens.space16.sp,
//                             fontWeight: FontWeight.normal),
//                         textAlign: TextAlign.left,
//                         textAlignVertical: TextAlignVertical.center,
//                         onChanged: (value)
//                         {
//                           if (value.length > 3)
//                           {
//                             isValid = true;
//                             setState(() {});
//                           }
//                           else
//                           {
//                             isValid = false;
//                             setState(() {});
//                           }
//                         },
//                         decoration: InputDecoration(
//                           contentPadding: EdgeInsets.fromLTRB(Dimens.space0.w,
//                               Dimens.space12.h, Dimens.space0.w, Dimens.space12.h),
//                           border: UnderlineInputBorder(
//                             borderSide: BorderSide(
//                                 color: CustomColors.title_active!,
//                                 width: Dimens.space1.w),
//                             borderRadius:
//                             BorderRadius.all(Radius.circular(Dimens.space0.w)),
//                           ),
//                           disabledBorder: UnderlineInputBorder(
//                             borderSide: BorderSide(
//                                 color: CustomColors.title_active!,
//                                 width: Dimens.space1.w),
//                             borderRadius:
//                             BorderRadius.all(Radius.circular(Dimens.space0.w)),
//                           ),
//                           errorBorder: UnderlineInputBorder(
//                             borderSide: BorderSide(
//                                 color: CustomColors.title_active!,
//                                 width: Dimens.space1.w),
//                             borderRadius:
//                             BorderRadius.all(Radius.circular(Dimens.space0.w)),
//                           ),
//                           focusedErrorBorder: UnderlineInputBorder(
//                             borderSide: BorderSide(
//                                 color: CustomColors.title_active!,
//                                 width: Dimens.space1.w),
//                             borderRadius:
//                             BorderRadius.all(Radius.circular(Dimens.space0.w)),
//                           ),
//                           enabledBorder: UnderlineInputBorder(
//                             borderSide: BorderSide(
//                                 color: CustomColors.title_active!,
//                                 width: Dimens.space1.w),
//                             borderRadius:
//                             BorderRadius.all(Radius.circular(Dimens.space0.w)),
//                           ),
//                           focusedBorder: UnderlineInputBorder(
//                             borderSide: BorderSide(
//                                 color: CustomColors.title_active!,
//                                 width: Dimens.space1.w),
//                             borderRadius:
//                             BorderRadius.all(Radius.circular(Dimens.space0.w)),
//                           ),
//                           suffixIcon: IconButton(
//                             icon: Icon(
//                               Icons.clear,
//                               color: CustomColors.title_deactive,
//                               size: Dimens.space14.w,
//                             ),
//                             onPressed: () {
//                               setState(() {
//                                 controllerUsername.text = "";
//                               });
//                             },
//                           ),
//                           filled: true,
//                           fillColor: Colors.transparent,
//                           hintText: Utils.getString("username"),
//                           hintStyle: Theme.of(context).textTheme.bodyText2!.copyWith(
//                               color: CustomColors.title_active,
//                               fontFamily: Config.InterSemiBold,
//                               fontSize: Dimens.space16.sp,
//                               fontWeight: FontWeight.normal),
//                         ),
//                       ),
//                     ),
//                     isValid
//                         ? UsernameSuccessToastWidget(message: controllerUsername.text+Utils.getString("userNameAvailable"),)
//                         : validationMessage.isNotEmpty?ErrorToastWidget(message: validationMessage,):Container(),
//                   ],
//                 ),
//               ),
//               extendBody: true,
//               bottomSheet: NextBackWidget(
//                 backOnPress: ()
//                 {
//                   Utils.closeActivity(context);
//                 },
//                 nextOnPress: ()
//                 {
//                   if(isValid)
//                   {
//                     Prefs.setString(Const.VALUE_HOLDER_USERNAME, controllerUsername.text);
//                     Utils.openActivity(context, PasswordSetUpPage());
//                   }
//                 },
//                 isValid: isValid,
//               ),
//             ),
//             isLoading ?
//             Container(
//               height: Utils.getScreenHeight(context),
//               width: Utils.getScreenWidth(context),
//               color: CustomColors.title_active!.withOpacity(0.2),
//               child: Center(
//                 child:Lottie.asset('assets/lottie/Peeq_loader.json',height: Utils.getScreenWidth(context) * 0.6,),//               ),
//             ):Container(),
//           ],
//         );
//       },
//     );
//   }
// }
