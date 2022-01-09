// import 'package:flutter/material.dart';
// import 'package:live/config/Config.dart';
// import 'package:live/config/CustomColors.dart';
// import 'package:live/constant/Dimens.dart';
// import 'package:live/ui/common/ButtonWidget.dart';
// import 'package:live/ui/dashboard/DashboardPage.dart';
// import 'package:live/utils/Utils.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// class CreateRoomPage extends StatefulWidget
// {
//   @override
//   CreateRoomPageState createState() => CreateRoomPageState();
// }
//
// class CreateRoomPageState extends State<CreateRoomPage>
// {
//   GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
//   TextEditingController controllerPublic = TextEditingController();
//   TextEditingController controllerPrivate = TextEditingController();
//
//   @override
//   void initState()
//   {
//     super.initState();
//     controllerPublic.text = Utils.getString("shopping");
//     controllerPrivate.text = Utils.getString("general");
//   }
//
//   @override
//   void dispose()
//   {
//     controllerPublic.dispose();
//     controllerPrivate.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context)
//   {
//     // david+figma@peeq.live
//     // spay_rik!scal4TUH
//     return Scaffold(
//       key: _scaffoldKey,
//       backgroundColor: CustomColors.background_bg01,
//       appBar: AppBar(
//         toolbarHeight: kToolbarHeight,
//         backgroundColor: CustomColors.background_bg01,
//         elevation: 0,
//         leading: Container(
//           height: kToolbarHeight,
//           width: kToolbarHeight,
//           alignment: Alignment.center,
//           margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
//           child: Container(
//             alignment: Alignment.center,
//             height: Dimens.space26.w,
//             width: Dimens.space26.w,
//             margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.all(
//                 Radius.circular(Dimens.space8.w),
//               ),
//               color: Colors.transparent,
//               border: Border.all(
//                 width: Dimens.space2,
//                 color: CustomColors.title_deactive!,
//               )
//             ),
//             child: TextButton(
//               style: TextButton.styleFrom(
//                 alignment: Alignment.center,
//                 tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                 padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
//               ),
//               onPressed: ()
//               {
//                 Utils.closeActivity(context);
//               },
//               child: Icon(
//                 Icons.arrow_back,
//                 color: CustomColors.title_active,
//                 size: Dimens.space16.w,
//               ),
//             ),
//           ),
//         ),
//       ),
//       body: Container(
//         height: MediaQuery.of(context).size.height,
//         width: MediaQuery.of(context).size.width,
//         color: CustomColors.background_bg01,
//         margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
//         padding: EdgeInsets.fromLTRB(Dimens.space24.w, Dimens.space0.h, Dimens.space24.w, Dimens.space0.h),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisSize: MainAxisSize.max,
//           children: [
//             Container(
//               alignment: Alignment.centerLeft,
//               margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space32.h, Dimens.space0.w, Dimens.space0.h),
//               padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
//               child: Text(
//                   Utils.getString("rooms"),
//                   style: Theme.of(context).textTheme.bodyText1!.copyWith(
//                     color: CustomColors.title_active,
//                     fontFamily: Config.PoppinsSemiBold,
//                     fontSize: Dimens.space32.sp,
//                     fontWeight: FontWeight.normal,
//                     fontStyle: FontStyle.normal,
//                   )
//               ),
//             ),
//             Container(
//               alignment: Alignment.centerLeft,
//               margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space32.h, Dimens.space0.w, Dimens.space0.h),
//               padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
//               child: Text(
//                   Utils.getString("fewVirtualRoom"),
//                   style: Theme.of(context).textTheme.bodyText1!.copyWith(
//                     color: CustomColors.title_deactive,
//                     fontFamily: Config.InterRegular,
//                     fontSize: Dimens.space13.sp,
//                     fontWeight: FontWeight.normal,
//                     fontStyle: FontStyle.normal,
//                   )
//               ),
//             ),
//             Container(
//               alignment: Alignment.centerLeft,
//               margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space32.h, Dimens.space0.w, Dimens.space0.h),
//               padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
//               child: Text(
//                   Utils.getString("publicRoom").toUpperCase(),
//                   style: Theme.of(context).textTheme.bodyText1!.copyWith(
//                     color: CustomColors.title_deactive,
//                     fontFamily: Config.InterBold,
//                     fontSize: Dimens.space10.sp,
//                     fontWeight: FontWeight.bold,
//                     fontStyle: FontStyle.normal,
//                   )
//               ),
//             ),
//             Container(
//               alignment: Alignment.center,
//               margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space8.h, Dimens.space0.w, Dimens.space0.h),
//               padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
//               child: TextField(
//                 maxLines: 1,
//                 controller: controllerPublic,
//                 readOnly: true,
//                 enabled: false,
//                 style: Theme.of(context).textTheme.bodyText2!.copyWith(
//                     color: CustomColors.title_active,
//                     fontFamily: Config.InterSemiBold,
//                     fontSize: Dimens.space16.sp,
//                     fontWeight: FontWeight.normal
//                 ),
//                 textAlign: TextAlign.left,
//                 textAlignVertical: TextAlignVertical.center,
//                 onChanged: (value)
//                 {
//
//                 },
//                 decoration: InputDecoration(
//                   contentPadding:EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space12.h, Dimens.space0.w, Dimens.space12.h),
//                   border: UnderlineInputBorder(
//                     borderSide: BorderSide(color: CustomColors.title_active!, width: Dimens.space1.w),
//                     borderRadius: BorderRadius.all(Radius.circular(Dimens.space0.w)),
//                   ),
//                   disabledBorder: UnderlineInputBorder(
//                     borderSide: BorderSide(color: CustomColors.title_active!, width: Dimens.space1.w),
//                     borderRadius: BorderRadius.all(Radius.circular(Dimens.space0.w)),
//                   ),
//                   errorBorder: UnderlineInputBorder(
//                     borderSide: BorderSide(color: CustomColors.title_active!, width: Dimens.space1.w),
//                     borderRadius: BorderRadius.all(Radius.circular(Dimens.space0.w)),
//                   ),
//                   focusedErrorBorder: UnderlineInputBorder(
//                     borderSide: BorderSide(color: CustomColors.title_active!, width: Dimens.space1.w),
//                     borderRadius: BorderRadius.all(Radius.circular(Dimens.space0.w)),
//                   ),
//                   enabledBorder:UnderlineInputBorder(
//                     borderSide: BorderSide(color: CustomColors.title_active!, width: Dimens.space1.w),
//                     borderRadius: BorderRadius.all(Radius.circular(Dimens.space0.w)),
//                   ),
//                   focusedBorder: UnderlineInputBorder(
//                     borderSide: BorderSide(color: CustomColors.title_active!, width: Dimens.space1.w),
//                     borderRadius: BorderRadius.all(Radius.circular(Dimens.space0.w)),
//                   ),
//                   suffixIcon: IconButton(
//                     icon: Icon(
//                       Icons.clear,
//                       color: CustomColors.title_deactive,
//                       size: Dimens.space14.w,
//                     ),
//                     onPressed: ()
//                     {
//                     },
//                   ),
//                   filled: true,
//                   fillColor: Colors.transparent,
//                   hintText: Utils.getString("shopping"),
//                   hintStyle: Theme.of(context).textTheme.bodyText2!.copyWith(
//                       color: CustomColors.title_active,
//                       fontFamily: Config.InterSemiBold,
//                       fontSize: Dimens.space16.sp,
//                       fontWeight: FontWeight.normal
//                   ),
//                 ),
//               ),
//             ),
//             Container(
//               alignment: Alignment.centerLeft,
//               margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space48.h, Dimens.space0.w, Dimens.space0.h),
//               padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
//               child: Text(
//                   Utils.getString("privateRoom").toUpperCase(),
//                   style: Theme.of(context).textTheme.bodyText1!.copyWith(
//                     color: CustomColors.title_deactive,
//                     fontFamily: Config.InterBold,
//                     fontSize: Dimens.space10.sp,
//                     fontWeight: FontWeight.bold,
//                     fontStyle: FontStyle.normal,
//                   )
//               ),
//             ),
//             Container(
//               alignment: Alignment.center,
//               margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space8.h, Dimens.space0.w, Dimens.space0.h),
//               padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
//               child: TextField(
//                 maxLines: 1,
//                 controller: controllerPrivate,
//                 readOnly: true,
//                 enabled: false,
//                 style: Theme.of(context).textTheme.bodyText2!.copyWith(
//                     color: CustomColors.title_active,
//                     fontFamily: Config.InterSemiBold,
//                     fontSize: Dimens.space16.sp,
//                     fontWeight: FontWeight.normal
//                 ),
//                 textAlign: TextAlign.left,
//                 textAlignVertical: TextAlignVertical.center,
//                 onChanged: (value)
//                 {
//
//                 },
//                 decoration: InputDecoration(
//                   contentPadding:EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space12.h, Dimens.space0.w, Dimens.space12.h),
//                   border: UnderlineInputBorder(
//                     borderSide: BorderSide(color: CustomColors.title_active!, width: Dimens.space1.w),
//                     borderRadius: BorderRadius.all(Radius.circular(Dimens.space0.w)),
//                   ),
//                   disabledBorder: UnderlineInputBorder(
//                     borderSide: BorderSide(color: CustomColors.title_active!, width: Dimens.space1.w),
//                     borderRadius: BorderRadius.all(Radius.circular(Dimens.space0.w)),
//                   ),
//                   errorBorder: UnderlineInputBorder(
//                     borderSide: BorderSide(color: CustomColors.title_active!, width: Dimens.space1.w),
//                     borderRadius: BorderRadius.all(Radius.circular(Dimens.space0.w)),
//                   ),
//                   focusedErrorBorder: UnderlineInputBorder(
//                     borderSide: BorderSide(color: CustomColors.title_active!, width: Dimens.space1.w),
//                     borderRadius: BorderRadius.all(Radius.circular(Dimens.space0.w)),
//                   ),
//                   enabledBorder:UnderlineInputBorder(
//                     borderSide: BorderSide(color: CustomColors.title_active!, width: Dimens.space1.w),
//                     borderRadius: BorderRadius.all(Radius.circular(Dimens.space0.w)),
//                   ),
//                   focusedBorder: UnderlineInputBorder(
//                     borderSide: BorderSide(color: CustomColors.title_active!, width: Dimens.space1.w),
//                     borderRadius: BorderRadius.all(Radius.circular(Dimens.space0.w)),
//                   ),
//                   suffixIcon: IconButton(
//                     icon: Icon(
//                       Icons.clear,
//                       color: CustomColors.title_deactive,
//                       size: Dimens.space14.w,
//                     ),
//                     onPressed: ()
//                     {
//                     },
//                   ),
//                   filled: true,
//                   fillColor: Colors.transparent,
//                   hintText: Utils.getString("general"),
//                   hintStyle: Theme.of(context).textTheme.bodyText2!.copyWith(
//                       color: CustomColors.title_active,
//                       fontFamily: Config.InterSemiBold,
//                       fontSize: Dimens.space16.sp,
//                       fontWeight: FontWeight.normal
//                   ),
//                 ),
//               ),
//             ),
//             Container(
//               alignment: Alignment.centerLeft,
//               margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space32.h, Dimens.space0.w, Dimens.space0.h),
//               padding: EdgeInsets.fromLTRB(Dimens.space40.w, Dimens.space18.h, Dimens.space40.w, Dimens.space18.h),
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.all(
//                     Radius.circular(Dimens.space0.w),
//                   ),
//                   color: CustomColors.blueTeal,
//                   border: Border.all(
//                     width: Dimens.space0,
//                     color: Colors.transparent,
//                   )
//               ),
//               child: Text(
//                 Utils.getString("yourInvitationEmail"),
//                 style: Theme.of(context).textTheme.bodyText1!.copyWith(
//                   color: CustomColors.white,
//                   fontFamily: Config.InterRegular,
//                   fontSize: Dimens.space14.sp,
//                   fontWeight: FontWeight.normal,
//                   fontStyle: FontStyle.normal,
//                 ),
//               ),
//             ),
//             Expanded(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisSize: MainAxisSize.max,
//                 children: [
//                   Container(
//                       alignment: Alignment.topCenter,
//                       margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space35.h, Dimens.space0.w, Dimens.space35.h),
//                       padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.end,
//                         mainAxisSize: MainAxisSize.max,
//                         children: [
//                           Expanded(
//                             child: Container(
//                               alignment: Alignment.center,
//                               margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
//                               padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
//                               child: RoundedButtonWidget(
//                                 width: Dimens.space246,
//                                 height: Dimens.space54,
//                                 onPressed: ()
//                                 {
//                                   Utils.closeActivity(context);
//                                 },
//                                 corner: Dimens.space30.r,
//                                 buttonTextColor: CustomColors.title_deactive!,
//                                 buttonBorderColor: Colors.transparent,
//                                 buttonBackgroundColor: Colors.transparent,
//                                 buttonText: Utils.getString("back"),
//                                 fontStyle: FontStyle.normal,
//                                 titleTextAlign: TextAlign.center,
//                                 buttonFontSize: Dimens.space14,
//                                 buttonFontWeight: FontWeight.normal,
//                                 buttonFontFamily: Config.InterBold,
//                                 hasShadow: false,
//                               ),
//                             ),
//                           ),
//                           Expanded(
//                             child: Container(
//                               alignment: Alignment.center,
//                               margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
//                               padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
//                               child: RoundedButtonWidget(
//                                 width: Dimens.space246,
//                                 height: Dimens.space54,
//                                 onPressed: ()
//                                 {
//                                   Utils.openActivity(context, DashboardPage());
//                                 },
//                                 corner: Dimens.space30.r,
//                                 buttonTextColor: CustomColors.white!,
//                                 buttonBorderColor: CustomColors.blue!,
//                                 buttonBackgroundColor: CustomColors.blue!,
//                                 buttonText: Utils.getString("next").toUpperCase(),
//                                 fontStyle: FontStyle.normal,
//                                 titleTextAlign: TextAlign.center,
//                                 buttonFontSize: Dimens.space14,
//                                 buttonFontWeight: FontWeight.normal,
//                                 buttonFontFamily: Config.InterBold,
//                                 hasShadow: false,
//                               ),
//                             ),
//                           ),
//                         ],
//                       )
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
