// import 'package:flutter/material.dart';
// import 'package:live/config/Config.dart';
// import 'package:live/config/CustomColors.dart';
// import 'package:live/constant/Dimens.dart';
// import 'package:live/ui/common/ButtonWidget.dart';
// import 'package:live/ui/common/CustomImageHolder.dart';
// import 'package:live/ui/create_room/CreateRoomPage.dart';
// import 'package:live/utils/Utils.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// class NewPeeqPage extends StatefulWidget
// {
//   @override
//   NewPeeqPageState createState() => NewPeeqPageState();
// }
//
// class NewPeeqPageState extends State<NewPeeqPage>
// {
//   GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
//   TextEditingController controllerEmail = TextEditingController();
//   bool isBusinessSelected = false;
//   bool isPersonalSelected = false;
//
//   @override
//   void initState()
//   {
//     super.initState();
//   }
//
//   @override
//   void dispose()
//   {
//     controllerEmail.dispose();
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
//                 borderRadius: BorderRadius.all(
//                   Radius.circular(Dimens.space8.w),
//                 ),
//                 color: Colors.transparent,
//                 border: Border.all(
//                   width: Dimens.space2,
//                   color: CustomColors.title_deactiveLight!,
//                 )
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
//         centerTitle: true,
//         title: Text(
//           Utils.getString("newPeeq"),
//           style: Theme.of(context).textTheme.bodyText1!.copyWith(
//             color: CustomColors.title_active,
//             fontFamily: Config.PoppinsSemiBold,
//             fontSize: Dimens.space18.sp,
//             fontWeight: FontWeight.normal,
//             fontStyle: FontStyle.normal,
//           ),
//         ),
//       ),
//       body: Container(
//         height: MediaQuery.of(context).size.height,
//         width: MediaQuery.of(context).size.width,
//         margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space24.h, Dimens.space0.w, Dimens.space0.h),
//         padding: EdgeInsets.fromLTRB(Dimens.space24.w, Dimens.space0.h, Dimens.space24.w, Dimens.space0.h),
//         decoration: BoxDecoration(
//             borderRadius: BorderRadius.only(
//               topRight: Radius.circular(Dimens.space24.w),
//               topLeft: Radius.circular(Dimens.space24.w),
//             ),
//             color: CustomColors.background_bg01,
//             border: Border.all(
//               width: Dimens.space1,
//               color: CustomColors.title_deactiveLight!,
//             )
//         ),
//         child: Stack(
//           alignment: Alignment.topCenter,
//           children: [
//             SingleChildScrollView(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisSize: MainAxisSize.max,
//                 children: [
//                   Container(
//                     alignment: Alignment.center,
//                     margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space40.h, Dimens.space0.w, Dimens.space16.h),
//                     padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
//                     child: RoundedAssetSvgWithColorHolder(
//                       imageWidth: Dimens.space50,
//                       imageHeight: Dimens.space50,
//                       containerWidth: Dimens.space112,
//                       containerHeight: Dimens.space112,
//                       svgColor: CustomColors.title_active!,
//                       iconColor: CustomColors.title_active!,
//                       boxDecorationColor: CustomColors.pinkDark!,
//                       assetUrl: "assets/svg/icon_app_mono.svg",
//                       boxFit: BoxFit.contain,
//                       iconUrl: Icons.person,
//                       iconSize: Dimens.space50,
//                       outerCorner: Dimens.space300,
//                       innerCorner: Dimens.space0,
//                       onTap: ()
//                       {
//
//                       },
//                     ),
//                   ),
//                   Container(
//                     alignment: Alignment.center,
//                     margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space56.h),
//                     padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
//                     child: Text(
//                       //TODO
//                       "Virani Jewellers",
//                       style: Theme.of(context).textTheme.bodyText1!.copyWith(
//                         color: CustomColors.title_active,
//                         fontFamily: Config.PoppinsSemiBold,
//                         fontSize: Dimens.space24.sp,
//                         fontWeight: FontWeight.normal,
//                         fontStyle: FontStyle.normal,
//                       ),
//                     ),
//                   ),
//                   Container(
//                     alignment: Alignment.centerLeft,
//                     margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
//                     padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
//                     child: Text(
//                       Utils.getString("howManyPeople"),
//                       style: Theme.of(context).textTheme.bodyText1!.copyWith(
//                         color: CustomColors.title_deactive,
//                         fontFamily: Config.InterBold,
//                         fontSize: Dimens.space10.sp,
//                         fontWeight: FontWeight.normal,
//                         fontStyle: FontStyle.normal,
//                       ),
//                     ),
//                   ),
//                   Container(
//                     alignment: Alignment.centerLeft,
//                     margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
//                     padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
//                     child: Text(
//                       Utils.getString("howManyPeople"),
//                       style: Theme.of(context).textTheme.bodyText1!.copyWith(
//                         color: CustomColors.title_deactive,
//                         fontFamily: Config.InterBold,
//                         fontSize: Dimens.space10.sp,
//                         fontWeight: FontWeight.normal,
//                         fontStyle: FontStyle.normal,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Positioned(
//               bottom: Dimens.space0,
//               left: Dimens.space0,
//               right: Dimens.space0,
//               child: Container(
//                 alignment: Alignment.topCenter,
//                 color: CustomColors.background_bg01,
//                 margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
//                 padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space16.h, Dimens.space0.w, Dimens.space35.h),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   mainAxisSize: MainAxisSize.max,
//                   children: [
//                     Expanded(
//                       child: Container(
//                         alignment: Alignment.center,
//                         margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
//                         padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
//                         child: RoundedButtonWidget(
//                           width: Dimens.space246,
//                           height: Dimens.space54,
//                           onPressed: ()
//                           {
//                             Utils.closeActivity(context);
//                           },
//                           corner: Dimens.space30.r,
//                           buttonTextColor: CustomColors.title_deactive!,
//                           buttonBorderColor: Colors.transparent,
//                           buttonBackgroundColor: Colors.transparent,
//                           buttonText: Utils.getString("back"),
//                           fontStyle: FontStyle.normal,
//                           titleTextAlign: TextAlign.center,
//                           buttonFontSize: Dimens.space14,
//                           buttonFontWeight: FontWeight.normal,
//                           buttonFontFamily: Config.InterBold,
//                           hasShadow: false,
//                         ),
//                       ),
//                     ),
//                     Expanded(
//                       child: Container(
//                         alignment: Alignment.center,
//                         margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
//                         padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
//                         child: RoundedButtonWidget(
//                           width: Dimens.space246,
//                           height: Dimens.space54,
//                           onPressed: ()
//                           {
//                             Utils.openActivity(context, CreateRoomPage());
//                           },
//                           corner: Dimens.space30.r,
//                           buttonTextColor: CustomColors.white!,
//                           buttonBorderColor: CustomColors.blue!,
//                           buttonBackgroundColor: CustomColors.blue!,
//                           buttonText: Utils.getString("next").toUpperCase(),
//                           fontStyle: FontStyle.normal,
//                           titleTextAlign: TextAlign.center,
//                           buttonFontSize: Dimens.space14,
//                           buttonFontWeight: FontWeight.normal,
//                           buttonFontFamily: Config.InterBold,
//                           hasShadow: false,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
