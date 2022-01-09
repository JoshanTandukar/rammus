// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:image_cropper/image_cropper.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:live/config/Config.dart';
// import 'package:live/config/CustomColors.dart';
// import 'package:live/constant/Dimens.dart';
// import 'package:live/ui/common/ButtonWidget.dart';
// import 'package:live/ui/common/CustomImageHolder.dart';
// import 'package:live/ui/common/dialog/GalleryCameraDialog.dart';
// import 'package:live/ui/dashboard/DashboardPage.dart';
// import 'package:live/utils/Utils.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// class HostProfileLanguagePage extends StatefulWidget
// {
//   @override
//   HostProfileLanguagePageState createState() => HostProfileLanguagePageState();
// }
//
// class HostProfileLanguagePageState extends State<HostProfileLanguagePage>
// {
//   GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
//   TextEditingController controllerEmail = TextEditingController();
//   final ImagePicker _picker = ImagePicker();
//   XFile? image;
//   File? croppedFile;
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
//       resizeToAvoidBottomInset: true,
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
//                   color: CustomColors.title_deactive!,
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
//           Utils.getString("hostProfile"),
//           textAlign: TextAlign.center,
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
//         margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space24.h, Dimens.space0.w, Dimens.space0.h),
//         padding: EdgeInsets.fromLTRB(Dimens.space24.w, Dimens.space0.h, Dimens.space24.w, Dimens.space0.h),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisSize: MainAxisSize.max,
//           children: [
//             Container(
//                 alignment: Alignment.center,
//                 margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space34.h, Dimens.space0.w, Dimens.space0.h),
//                 padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
//                 child: Stack(
//                   alignment: Alignment.center,
//                   children: [
//                     Container(
//                       alignment: Alignment.center,
//                       margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
//                       padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
//                       child: PlainAssetImageHolder(
//                         height: Dimens.space120,
//                         width: Dimens.space120,
//                         assetWidth: Dimens.space120,
//                         assetHeight: Dimens.space120,
//                         assetUrl: "assets/images/icon_image_border.png",
//                         outerCorner: Dimens.space300,
//                         innerCorner: Dimens.space0,
//                         iconSize: Dimens.space22,
//                         iconUrl: Icons.camera_alt_outlined,
//                         iconColor: Colors.transparent,
//                         boxDecorationColor: Colors.transparent,
//                         boxFit: BoxFit.contain,
//                         onTap: () {},
//                       ),
//                     ),
//                     Container(
//                       alignment: Alignment.center,
//                       margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
//                       padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
//                       child: PlainFileImageHolder(
//                         height: Dimens.space96,
//                         width: Dimens.space96,
//                         fileUrl: croppedFile!=null?croppedFile!.path:"",
//                         outerCorner: Dimens.space300,
//                         innerCorner: Dimens.space0,
//                         iconSize: Dimens.space22,
//                         iconUrl: Icons.camera_alt_outlined,
//                         iconColor: CustomColors.white!,
//                         boxDecorationColor: CustomColors.blue!,
//                         corner: Dimens.space300,
//                         containerAlignment: Alignment.center,
//                         boxFit: BoxFit.cover,
//                         onTap: ()
//                         {
//                           showGalleryCameraDialog();
//                         },
//                       ),
//                     ),
//                   ],
//                 )
//             ),
//             Container(
//               alignment: Alignment.center,
//               margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space24.h, Dimens.space0.w, Dimens.space0.h),
//               padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
//               child: Text(
//                   Utils.getString("tapAboveToAddImage"),
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
//                   Utils.getString("setYourLanguage").toUpperCase(),
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
//                 controller: controllerEmail,
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
//               margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space32.h, Dimens.space0.w, Dimens.space0.h),
//               padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
//               child: Text(
//                   Utils.getString("yourPrimaryLanguage").toUpperCase(),
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
//                 controller: controllerEmail,
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
//                     alignment: Alignment.topCenter,
//                     margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space35.h, Dimens.space0.w, Dimens.space35.h),
//                     padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       mainAxisSize: MainAxisSize.max,
//                       children: [
//                         Expanded(
//                           child: Container(
//                             alignment: Alignment.center,
//                             margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
//                             padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
//                             child: RoundedButtonWidget(
//                               width: Dimens.space246,
//                               height: Dimens.space54,
//                               onPressed: ()
//                               {
//                                 Utils.closeActivity(context);
//                               },
//                               corner: Dimens.space30.r,
//                               buttonTextColor: CustomColors.title_deactive!,
//                               buttonBorderColor: Colors.transparent,
//                               buttonBackgroundColor: Colors.transparent,
//                               buttonText: Utils.getString("back"),
//                               fontStyle: FontStyle.normal,
//                               titleTextAlign: TextAlign.center,
//                               buttonFontSize: Dimens.space14,
//                               buttonFontWeight: FontWeight.normal,
//                               buttonFontFamily: Config.InterBold,
//                               hasShadow: false,
//                             ),
//                           ),
//                         ),
//                         Expanded(
//                           child: Container(
//                             alignment: Alignment.center,
//                             margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
//                             padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
//                             child: RoundedButtonWidget(
//                               width: Dimens.space246,
//                               height: Dimens.space54,
//                               onPressed: ()
//                               {
//                                 Utils.openActivity(context, DashboardPage());
//                               },
//                               corner: Dimens.space30.r,
//                               buttonTextColor: CustomColors.white!,
//                               buttonBorderColor: CustomColors.blue!,
//                               buttonBackgroundColor: CustomColors.blue!,
//                               buttonText: Utils.getString("next").toUpperCase(),
//                               fontStyle: FontStyle.normal,
//                               titleTextAlign: TextAlign.center,
//                               buttonFontSize: Dimens.space14,
//                               buttonFontWeight: FontWeight.normal,
//                               buttonFontFamily: Config.InterBold,
//                               hasShadow: false,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void showGalleryCameraDialog() async
//   {
//     await showModalBottomSheet(
//         context: context,
//         isScrollControlled: true,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(Dimens.space12.r),
//         ),
//         backgroundColor: Colors.transparent,
//         builder: (BuildContext context)
//         {
//           return GalleryCameraDialog(
//             onCameraPick: () async
//             {
//               Utils.closeActivity(context);
//               image = await _picker.pickImage(
//                 source: ImageSource.camera,
//                 imageQuality: 100,
//                 preferredCameraDevice: CameraDevice.front,
//               );
//               croppedFile = await ImageCropper.cropImage(
//                   sourcePath: image!.path,
//                   aspectRatioPresets: [
//                     CropAspectRatioPreset.original,
//                     CropAspectRatioPreset.square,
//                     CropAspectRatioPreset.ratio3x2,
//                     CropAspectRatioPreset.ratio4x3,
//                     CropAspectRatioPreset.ratio5x3,
//                     CropAspectRatioPreset.ratio4x3,
//                     CropAspectRatioPreset.ratio7x5,
//                     CropAspectRatioPreset.ratio16x9,
//                   ],
//                   androidUiSettings: AndroidUiSettings(
//                       toolbarTitle: 'Cropper',
//                       toolbarColor: Colors.pink,
//                       toolbarWidgetColor: Colors.white,
//                       initAspectRatio: CropAspectRatioPreset.original,
//                       lockAspectRatio: false),
//                   iosUiSettings: IOSUiSettings(
//                     minimumAspectRatio: 1.0,
//                   )
//               );
//               setState(() {});
//             },
//             onGalleryPick: () async
//             {
//               Utils.closeActivity(context);
//               image = await _picker.pickImage(
//                 source: ImageSource.gallery,
//                 imageQuality: 100,
//                 preferredCameraDevice: CameraDevice.front,
//               );
//               croppedFile = await ImageCropper.cropImage(
//                   sourcePath: image!.path,
//                   aspectRatioPresets: [
//                     CropAspectRatioPreset.original,
//                     CropAspectRatioPreset.square,
//                     CropAspectRatioPreset.ratio3x2,
//                     CropAspectRatioPreset.ratio4x3,
//                     CropAspectRatioPreset.ratio5x3,
//                     CropAspectRatioPreset.ratio4x3,
//                     CropAspectRatioPreset.ratio7x5,
//                     CropAspectRatioPreset.ratio16x9,
//                   ],
//                   androidUiSettings: AndroidUiSettings(
//                       toolbarTitle: 'Cropper',
//                       toolbarColor: Colors.pink,
//                       toolbarWidgetColor: Colors.white,
//                       initAspectRatio: CropAspectRatioPreset.original,
//                       lockAspectRatio: false),
//                   iosUiSettings: IOSUiSettings(
//                     minimumAspectRatio: 1.0,
//                   )
//               );
//               setState(() {});
//             },
//           );
//         });
//   }
// }
