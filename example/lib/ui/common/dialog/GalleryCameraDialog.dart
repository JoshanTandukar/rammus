// import 'package:live/config/Config.dart';
// import 'package:live/config/CustomColors.dart';
// import 'package:live/constant/Dimens.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:live/utils/Utils.dart';
//
// class GalleryCameraDialog extends StatelessWidget
// {
//   final VoidCallback onCameraPick;
//   final VoidCallback onGalleryPick;
//
//   const GalleryCameraDialog({
//     Key? key,
//     required this.onCameraPick,
//     required this.onGalleryPick,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context)
//   {
//     return Container(
//       alignment: Alignment.center,
//       height: Dimens.space215.h,
//       padding: EdgeInsets.fromLTRB(Dimens.space16.w, Dimens.space0.h, Dimens.space16.w, Dimens.space0.h),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisSize: MainAxisSize.max,
//         children: <Widget>[
//           Container(
//             width: MediaQuery.of(context).size.width,
//             height: Dimens.space110.h,
//             decoration: BoxDecoration(
//                 color: CustomColors.title_deactive,
//                 borderRadius: BorderRadius.circular(Dimens.space16.r)
//             ),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisSize: MainAxisSize.max,
//               children: [
//                 Container(
//                   height: Dimens.space54.h,
//                   alignment: Alignment.center,
//                   margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
//                   padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
//                   decoration: BoxDecoration(
//                     border: Border(
//                       bottom: BorderSide(
//                         color: CustomColors.background_bg01!,
//                         width: 0.5,
//                       ),
//                     ),
//                   ),
//                   child: TextButton(
//                     style: TextButton.styleFrom(
//                       alignment: Alignment.center,
//                       padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
//                       tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                     ),
//                     onPressed: () async
//                     {
//                       onCameraPick();
//                     },
//                     child: Container(
//                       height: Dimens.space54.h,
//                       alignment: Alignment.center,
//                       margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
//                       padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
//                       child: Text(
//                         Utils.getString("takePhoto"),
//                         style: Theme.of(context).textTheme.bodyText2?.copyWith(
//                           color: CustomColors.title_active,
//                           fontFamily: Config.InterSemiBold,
//                           fontSize: Dimens.space14.sp,
//                           fontWeight: FontWeight.normal,
//                           fontStyle: FontStyle.normal,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Container(
//                   height: Dimens.space54.h,
//                   alignment: Alignment.center,
//                   margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
//                   padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
//                   child: TextButton(
//                     style: TextButton.styleFrom(
//                       alignment: Alignment.center,
//                       padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
//                       tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                     ),
//                     onPressed: () async
//                     {
//                       onGalleryPick();
//                     },
//                     child: Container(
//                       height: Dimens.space54.h,
//                       alignment: Alignment.center,
//                       margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
//                       padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
//                       child: Text(
//                         Utils.getString("choosePhoto"),
//                         style: Theme.of(context).textTheme.bodyText2?.copyWith(
//                           color: CustomColors.title_active,
//                           fontFamily: Config.InterSemiBold,
//                           fontSize: Dimens.space14.sp,
//                           fontWeight: FontWeight.normal,
//                           fontStyle: FontStyle.normal,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Container(
//             height: Dimens.space54.h,
//             alignment: Alignment.center,
//             margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space16.h, Dimens.space0.w, Dimens.space32.h),
//             padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
//             decoration: BoxDecoration(
//               color: CustomColors.title_deactive,
//               borderRadius: BorderRadius.circular(Dimens.space16.r),
//             ),
//             child: TextButton(
//               style: TextButton.styleFrom(
//                 alignment: Alignment.center,
//                 padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
//                 tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//               ),
//               onPressed: ()
//               {
//                 Utils.closeActivity(context);
//               },
//               child: Container(
//                 height: Dimens.space54.h,
//                 alignment: Alignment.center,
//                 margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
//                 padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
//                 child: Text(
//                   Utils.getString('cancel'),
//                   style: Theme.of(context).textTheme.bodyText2?.copyWith(
//                     color: CustomColors.textPrimaryErrorColor,
//                     fontFamily: Config.InterSemiBold,
//                     fontSize: Dimens.space14.sp,
//                     fontWeight: FontWeight.normal,
//                     fontStyle: FontStyle.normal,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }