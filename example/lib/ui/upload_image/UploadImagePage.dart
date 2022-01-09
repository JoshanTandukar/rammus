// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:image_cropper/image_cropper.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:live/config/Config.dart';
// import 'package:live/config/CustomColors.dart';
// import 'package:live/constant/Dimens.dart';
// import 'package:live/ui/common/ButtonWidget.dart';
// import 'package:live/ui/common/CustomImageHolder.dart';
// import 'package:live/ui/common/ErrorToastWidget.dart';
// import 'package:live/ui/common/dialog/GalleryCameraDialog.dart';
// import 'package:live/ui/host_profile_label/HostProfileLabelPage.dart';
// import 'package:live/utils/Utils.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// class UploadImagePage extends StatefulWidget
// {
//   @override
//   UploadImagePageState createState() => UploadImagePageState();
// }
//
// class UploadImagePageState extends State<UploadImagePage>
// {
//   GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
//   TextEditingController controllerBio = TextEditingController();
//   final ImagePicker _picker = ImagePicker();
//   XFile? image;
//   File? croppedFile;
//   String validationMessage = Utils.getString("bioMustBe");
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
//     controllerBio.dispose();
//     super.dispose();
//   }
//
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
//         title: Container(
//           alignment: Alignment.center,
//           margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
//           padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
//           child: Text(
//             Utils.getString("profile"),
//             style: Theme.of(context).textTheme.bodyText1!.copyWith(
//               color: CustomColors.title_active,
//               fontFamily: Config.PoppinsSemiBold,
//               fontSize: Dimens.space18.sp,
//               fontWeight: FontWeight.normal,
//               fontStyle: FontStyle.normal,
//             ),
//           ),
//         ),
//         actions:
//         [
//           Container(
//             alignment: Alignment.center,
//             margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space17.w, Dimens.space0.h),
//             padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
//             child: RoundedButtonWidget(
//               width: Dimens.space76,
//               height: Dimens.space40,
//               onPressed: ()
//               {
//                 // Utils.uploadToS3(croppedFile!);
//                 Utils.openActivity(context, HostProfileLabelPage());
//               },
//               corner: Dimens.space24,
//               buttonTextColor: CustomColors.white!,
//               buttonBorderColor: CustomColors.blue!,
//               buttonBackgroundColor: CustomColors.blue!,
//               buttonText: Utils.getString("done"),
//               fontStyle: FontStyle.normal,
//               titleTextAlign: TextAlign.center,
//               buttonFontSize: Dimens.space14,
//               buttonFontWeight: FontWeight.normal,
//               buttonFontFamily: Config.InterBold,
//               hasShadow: false,
//             ),
//           ),
//         ],
//       ),
//       body: Container(
//         height: MediaQuery.of(context).size.height,
//         width: MediaQuery.of(context).size.width,
//         color: CustomColors.background_bg01,
//         margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
//         padding: EdgeInsets.fromLTRB(Dimens.space24.w, Dimens.space0.h, Dimens.space24.w, Dimens.space0.h),
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisSize: MainAxisSize.max,
//             children: [
//               Container(
//                 alignment: Alignment.center,
//                 margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space34.h, Dimens.space0.w, Dimens.space0.h),
//                 padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
//                 child: PlainFileImageHolder(
//                   height: Dimens.space136,
//                   width: Dimens.space136,
//                   fileUrl: croppedFile!=null?croppedFile!.path:"",
//                   outerCorner: Dimens.space300,
//                   innerCorner: Dimens.space0,
//                   iconSize: Dimens.space22,
//                   iconUrl: Icons.camera_alt_outlined,
//                   iconColor: CustomColors.white!,
//                   boxDecorationColor: CustomColors.blue!,
//                   corner: Dimens.space300,
//                   containerAlignment: Alignment.center,
//                   boxFit: BoxFit.cover,
//                   onTap: ()
//                   {
//                     showGalleryCameraDialog();
//                   },
//                 ),
//               ),
//               Container(
//                 alignment: Alignment.center,
//                 margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space24.h, Dimens.space0.w, Dimens.space0.h),
//                 padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
//                 child: Text(
//                     Utils.getString("tapAboveToAddImage"),
//                     style: Theme.of(context).textTheme.bodyText1!.copyWith(
//                       color: CustomColors.title_deactive,
//                       fontFamily: Config.InterRegular,
//                       fontSize: Dimens.space13.sp,
//                       fontWeight: FontWeight.normal,
//                       fontStyle: FontStyle.normal,
//                     )
//                 ),
//               ),
//               Container(
//                 alignment: Alignment.centerLeft,
//                 margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space32.h, Dimens.space0.w, Dimens.space0.h),
//                 padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
//                 child: Text(
//                     Utils.getString("bio").toUpperCase(),
//                     style: Theme.of(context).textTheme.bodyText1!.copyWith(
//                       color: CustomColors.title_deactive,
//                       fontFamily: Config.InterBold,
//                       fontSize: Dimens.space10.sp,
//                       fontWeight: FontWeight.bold,
//                       fontStyle: FontStyle.normal,
//                     )
//                 ),
//               ),
//               Container(
//                 alignment: Alignment.center,
//                 margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space8.h, Dimens.space0.w, Dimens.space0.h),
//                 padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
//                 child: TextField(
//                   controller: controllerBio,
//                   style: Theme.of(context).textTheme.bodyText2!.copyWith(
//                       color: CustomColors.title_active,
//                       fontFamily: Config.InterSemiBold,
//                       fontSize: Dimens.space16.sp,
//                       fontWeight: FontWeight.normal
//                   ),
//                   onChanged: (value)
//                   {
//                     if(value.length>50 && value.length<500)
//                     {
//                       validationMessage="";
//                     }
//                     setState(() {});
//                   },
//                   textAlign: TextAlign.left,
//                   textAlignVertical: TextAlignVertical.center,
//                   keyboardType: TextInputType.multiline,
//                   textInputAction: TextInputAction.newline,
//                   maxLength: 500,
//                   maxLines: 5,
//                   decoration: InputDecoration(
//                     contentPadding:EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space12.h, Dimens.space0.w, Dimens.space12.h),
//                     border: UnderlineInputBorder(
//                       borderSide: BorderSide(color: CustomColors.title_active!, width: Dimens.space1.w),
//                       borderRadius: BorderRadius.all(Radius.circular(Dimens.space0.w)),
//                     ),
//                     disabledBorder: UnderlineInputBorder(
//                       borderSide: BorderSide(color: CustomColors.title_active!, width: Dimens.space1.w),
//                       borderRadius: BorderRadius.all(Radius.circular(Dimens.space0.w)),
//                     ),
//                     errorBorder: UnderlineInputBorder(
//                       borderSide: BorderSide(color: CustomColors.title_active!, width: Dimens.space1.w),
//                       borderRadius: BorderRadius.all(Radius.circular(Dimens.space0.w)),
//                     ),
//                     focusedErrorBorder: UnderlineInputBorder(
//                       borderSide: BorderSide(color: CustomColors.title_active!, width: Dimens.space1.w),
//                       borderRadius: BorderRadius.all(Radius.circular(Dimens.space0.w)),
//                     ),
//                     enabledBorder:UnderlineInputBorder(
//                       borderSide: BorderSide(color: CustomColors.title_active!, width: Dimens.space1.w),
//                       borderRadius: BorderRadius.all(Radius.circular(Dimens.space0.w)),
//                     ),
//                     focusedBorder: UnderlineInputBorder(
//                       borderSide: BorderSide(color: CustomColors.title_active!, width: Dimens.space1.w),
//                       borderRadius: BorderRadius.all(Radius.circular(Dimens.space0.w)),
//                     ),
//                     filled: true,
//                     fillColor: Colors.transparent,
//                     hintText: Utils.getString("bio"),
//                     hintStyle: Theme.of(context).textTheme.bodyText2!.copyWith(
//                         color: CustomColors.title_active,
//                         fontFamily: Config.InterSemiBold,
//                         fontSize: Dimens.space16.sp,
//                         fontWeight: FontWeight.normal
//                     ),
//                   ),
//                 ),
//               ),
//               validationMessage.isEmpty
//                   ? Container()
//                   : ErrorToastWidget(message: validationMessage,),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   void showGalleryCameraDialog() async
//   {
//     await showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(Dimens.space12.r),
//       ),
//       backgroundColor: Colors.transparent,
//       builder: (BuildContext context)
//       {
//         return GalleryCameraDialog(
//           onCameraPick: () async
//           {
//             Utils.closeActivity(context);
//             image = await _picker.pickImage(
//               source: ImageSource.camera,
//               imageQuality: 100,
//               preferredCameraDevice: CameraDevice.front,
//             );
//             croppedFile = await ImageCropper.cropImage(
//                 sourcePath: image!.path,
//                 aspectRatioPresets: [
//                   CropAspectRatioPreset.original,
//                   CropAspectRatioPreset.square,
//                   CropAspectRatioPreset.ratio3x2,
//                   CropAspectRatioPreset.ratio4x3,
//                   CropAspectRatioPreset.ratio5x3,
//                   CropAspectRatioPreset.ratio4x3,
//                   CropAspectRatioPreset.ratio7x5,
//                   CropAspectRatioPreset.ratio16x9,
//                 ],
//                 androidUiSettings: AndroidUiSettings(
//                     toolbarTitle: 'Cropper',
//                     toolbarColor: Colors.pink,
//                     toolbarWidgetColor: Colors.white,
//                     initAspectRatio: CropAspectRatioPreset.original,
//                     lockAspectRatio: false),
//                 iosUiSettings: IOSUiSettings(
//                   minimumAspectRatio: 1.0,
//                 )
//             );
//             setState(() {});
//           },
//           onGalleryPick: () async
//           {
//             Utils.closeActivity(context);
//             image = await _picker.pickImage(
//               source: ImageSource.gallery,
//               imageQuality: 100,
//               preferredCameraDevice: CameraDevice.front,
//             );
//             croppedFile = await ImageCropper.cropImage(
//               sourcePath: image!.path,
//               aspectRatioPresets: [
//                 CropAspectRatioPreset.original,
//                 CropAspectRatioPreset.square,
//                 CropAspectRatioPreset.ratio3x2,
//                 CropAspectRatioPreset.ratio4x3,
//                 CropAspectRatioPreset.ratio5x3,
//                 CropAspectRatioPreset.ratio4x3,
//                 CropAspectRatioPreset.ratio7x5,
//                 CropAspectRatioPreset.ratio16x9,
//               ],
//               androidUiSettings: AndroidUiSettings(
//                   toolbarTitle: 'Cropper',
//                   toolbarColor: Colors.pink,
//                   toolbarWidgetColor: Colors.white,
//                   initAspectRatio: CropAspectRatioPreset.original,
//                   lockAspectRatio: false),
//               iosUiSettings: IOSUiSettings(
//                 minimumAspectRatio: 1.0,
//               ),
//             );
//             setState(() {});
//           },
//         );
//       },);
//   }
// }
