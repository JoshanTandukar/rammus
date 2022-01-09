// import 'package:flutter/material.dart';
// import 'package:live/config/Config.dart';
// import 'package:live/config/CustomColors.dart';
// import 'package:live/constant/Dimens.dart';
// import 'package:live/ui/common/CustomImageHolder.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// class PeeqCard extends StatelessWidget {
//   const PeeqCard({Key? key, required this.imageUrl}) : super(key: key);
//
//   final String imageUrl;
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.fromLTRB(Dimens.space10.w, Dimens.space0.h,
//           Dimens.space10.w, Dimens.space25.h),
//       child: Container(
//         height: 365,
//         decoration: BoxDecoration(
//           color: Color(0xff2C3447),
//           borderRadius: BorderRadius.circular(Dimens.space22.r),
//         ),
//         child: Column(
//           children: [
//             Expanded(
//                 child: Container(
//                     child: Stack(
//               children: [
//                 RoundedNetworkImageHolderWithCustomBorder(
//                   imageUrl: imageUrl,
//                   width: double.maxFinite,
//                   height: double.maxFinite,
//                   iconUrl: Icons.image_rounded,
//                   iconSize: double.maxFinite,
//                   onTap: () {},
//                   topLeftRadius: 22,
//                   innerTopLeftRadius: 22,
//                   topRightRadius: 22,
//                   innerTopRightRadius: 22,
//                   bottomRightRadius: 0,
//                   bottomLeftRadius: 0,
//                   innerBottomRightRadius: 0,
//                   innerBottomLeftRadius: 0,
//                 ),
//                 Container(
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [
//                         Color(0xff12121200).withOpacity(0.04),
//                         Color(0xff12121200).withOpacity(1)
//                       ],
//                       begin: Alignment(0, -1),
//                       end: Alignment(0, 1),
//                     ),
//                   ),
//                 ),
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Padding(
//                       padding: EdgeInsets.only(
//                         left: Dimens.space6.w,
//                         top: Dimens.space11.h,
//                         right: Dimens.space6.w,
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Container(
//                             decoration: BoxDecoration(
//                                 border: Border.all(
//                                   color: Colors.white,
//                                 ),
//                                 borderRadius:
//                                     BorderRadius.circular(Dimens.space100.r)),
//                             child: Padding(
//                               padding: EdgeInsets.only(
//                                 left: Dimens.space12.w,
//                                 right: Dimens.space12.w,
//                                 bottom: Dimens.space4.h,
//                                 top: Dimens.space4.h,
//                               ),
//                               child: Text(
//                                 "Shopping",
//                                 style:
//                                 Theme.of(context).textTheme.bodyText1!.copyWith(
//                                   color: CustomColors.whiteFill,
//                                   fontFamily: Config.InterRegular,
//                                   fontSize: Dimens.space10.sp,
//                                   fontWeight: FontWeight.w700,
//                                   fontStyle: FontStyle.normal,
//                                 ),
//                               ),
//                             ),
//                           ),
//                           Container(
//                             decoration: BoxDecoration(
//                               color: Color(0xff0ACF83),
//                               borderRadius:
//                                   BorderRadius.circular(Dimens.space100.r),
//                             ),
//                             child: Padding(
//                               padding: EdgeInsets.only(
//                                 left: Dimens.space12.w,
//                                 right: Dimens.space12.w,
//                                 bottom: Dimens.space5.h,
//                                 top: Dimens.space5.h,
//                               ),
//                               child: Text(
//                                 "2 live sessions",
//                                 style: Theme.of(context)
//                                     .textTheme
//                                     .bodyText1!
//                                     .copyWith(
//                                       color: CustomColors.whiteFill,
//                                       fontFamily: Config.InterRegular,
//                                       fontSize: Dimens.space10.sp,
//                                       fontWeight: FontWeight.w700,
//                                       fontStyle: FontStyle.normal,
//                                     ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Padding(
//                       padding: EdgeInsets.only(
//                         left: Dimens.space10.w,
//                         bottom: Dimens.space16.h,
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "VIRANI JEWELERS  LONG BEACH,CA",
//                             style:
//                                 Theme.of(context).textTheme.bodyText1!.copyWith(
//                                       color: CustomColors.black200,
//                                       fontFamily: Config.InterRegular,
//                                       fontSize: Dimens.space10.sp,
//                                       fontWeight: FontWeight.w400,
//                                       fontStyle: FontStyle.normal,
//                                     ),
//                           ),
//                           Padding(
//                             padding:
//                                 EdgeInsets.symmetric(vertical: Dimens.space2.h),
//                             child: Text(
//                               "Face to face shopping with Virani",
//                               style: Theme.of(context)
//                                   .textTheme
//                                   .bodyText1!
//                                   .copyWith(
//                                     color: CustomColors.white,
//                                     fontFamily: Config.InterRegular,
//                                     fontSize: Dimens.space14.sp,
//                                     fontWeight: FontWeight.w500,
//                                     fontStyle: FontStyle.normal,
//                                   ),
//                             ),
//                           ),
//                           Text(
//                             "Monday - Friday 9AM -7:30PM",
//                             style:
//                                 Theme.of(context).textTheme.bodyText1!.copyWith(
//                                       color: CustomColors.black200,
//                                       fontFamily: Config.InterRegular,
//                                       fontSize: Dimens.space10.sp,
//                                       fontWeight: FontWeight.w400,
//                                       fontStyle: FontStyle.normal,
//                                     ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 )
//               ],
//             ))),
//             Expanded(child: Container(
//               child: Column(
//                 children: [
//                   Row(
//                     children: [
//                       Row(
//                         children: [
//                           Container(
//                             alignment: Alignment.center,
//                             height: Dimens.space21.h,
//                             width: Dimens.space17.w,
//                             padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
//                             margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
//                             decoration: BoxDecoration(
//                               gradient: LinearGradient(
//                                 begin: Alignment.topLeft,
//                                 end: Alignment.bottomRight,
//                                 colors:
//                                 [
//                                   CustomColors.greenExtraLight!,
//                                   CustomColors.seaBlue!,
//                                   CustomColors.lightPurple!,
//                                   CustomColors.pink!,
//                                 ],
//                               ),
//                               borderRadius: BorderRadius.all(
//                                 Radius.circular(Dimens.space3.w),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   )
//                 ],
//               ),
//             )),
//           ],
//         ),
//       ),
//     );
//   }
// }
