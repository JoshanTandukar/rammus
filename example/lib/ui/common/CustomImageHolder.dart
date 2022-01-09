import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:live/config/Config.dart';
import 'package:live/constant/Constants.dart';
import 'package:live/constant/Dimens.dart';
import 'package:live/utils/Prefs.dart';

class PlainAssetImageHolder extends StatelessWidget {
  const PlainAssetImageHolder({
    Key? key,
    required this.assetUrl,
    required this.width,
    required this.height,
    required this.iconUrl,
    required this.iconSize,
    required this.assetWidth,
    required this.assetHeight,
    required this.onTap,
    this.outerCorner = Dimens.space16,
    this.innerCorner = Dimens.space16,
    this.iconColor = const Color(0xFF613494),
    this.boxFit = BoxFit.cover,
    this.boxDecorationColor = const Color(0xFFF3F2F4),
  }) : super(key: key);

  final String assetUrl;
  final double width;
  final double height;
  final double assetWidth;
  final double assetHeight;
  final double iconSize;
  final VoidCallback onTap;
  final BoxFit boxFit;
  final IconData iconUrl;
  final Color? iconColor;
  final double outerCorner;
  final double innerCorner;
  final Color? boxDecorationColor;

  @override
  Widget build(BuildContext context)
  {
    if (assetUrl == '')
    {
      return InkWell(
        onTap: onTap,
        child: Container(
          width: width.w,
          height: height.w,
          alignment: Alignment.center,
          margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
          decoration: BoxDecoration(
            color: boxDecorationColor,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(outerCorner.r)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(innerCorner.r),
            clipBehavior: Clip.antiAlias,
            child: Icon(
              iconUrl,
              size: iconSize.w,
              color: iconColor,
            ),
          ),
        ),
      );
    }
    else
    {
      return InkWell(
        onTap: onTap,
        child: Container(
          width: width.w,
          height: height.w,
          alignment: Alignment.center,
          margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
          decoration: BoxDecoration(
            color: boxDecorationColor,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(outerCorner.r),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(innerCorner.r),
            clipBehavior: Clip.antiAlias,
            child: Image.asset(
              assetUrl,
              fit: boxFit,
              width: assetWidth.w,
              height: assetHeight.w,
              cacheHeight: 500,
            ),
          ),
        ),
      );
    }
  }
}

class RoundedAssetSvgHolder extends StatelessWidget {
  const RoundedAssetSvgHolder({
    Key? key,
    required this.assetUrl,
    required this.containerWidth,
    required this.containerHeight,
    required this.imageWidth,
    required this.imageHeight,
    required this.iconUrl,
    required this.iconSize,
    required this.onTap,
    this.outerCorner = Dimens.space16,
    this.innerCorner = Dimens.space16,
    this.iconColor = Colors.white,
    this.boxFit = BoxFit.cover,
    this.boxDecorationColor = Colors.white,
  }) : super(key: key);

  final String assetUrl;
  final double containerWidth;
  final double containerHeight;
  final double imageWidth;
  final double imageHeight;
  final double iconSize;
  final VoidCallback onTap;
  final BoxFit boxFit;
  final IconData iconUrl;
  final Color iconColor;
  final double outerCorner;
  final double innerCorner;
  final Color boxDecorationColor;

  @override
  Widget build(BuildContext context) {
    if (assetUrl == '') {
      return InkWell(
        onTap: onTap,
        child: Container(
          width: containerWidth.w,
          height: containerHeight.w,
          margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
              Dimens.space0.w, Dimens.space0.h),
          padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
              Dimens.space0.w, Dimens.space0.h),
          decoration: BoxDecoration(
            color: boxDecorationColor,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(outerCorner.r)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(innerCorner.r),
            clipBehavior: Clip.antiAlias,
            child: Icon(
              iconUrl,
              size: iconSize.w,
              color: iconColor,
            ),
          ),
        ),
      );
    } else {
      return InkWell(
        onTap: onTap,
        child: Container(
          width: containerWidth.w,
          height: containerHeight.w,
          alignment: Alignment.center,
          margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
              Dimens.space0.w, Dimens.space0.h),
          padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
              Dimens.space0.w, Dimens.space0.h),
          decoration: BoxDecoration(
            color: boxDecorationColor,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(outerCorner.r)),
          ),
          child: Container(
            alignment: Alignment.center,
            width: imageWidth.w,
            height: imageHeight.w,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(innerCorner.r),
              clipBehavior: Clip.antiAlias,
              child: SvgPicture.asset(
                assetUrl,
                fit: boxFit,
                alignment: Alignment.center,
                clipBehavior: Clip.antiAlias,
                allowDrawingOutsideViewBox: false,
                cacheColorFilter: true,
                placeholderBuilder: (BuildContext context) => Icon(
                  iconUrl,
                  size: iconSize.w,
                  color: iconColor,
                ),
              ),
            ),
          ),
        ),
      );
    }
  }
}

class RoundedAssetSvgWithColorHolder extends StatelessWidget {
  const RoundedAssetSvgWithColorHolder({
    Key? key,
    required this.assetUrl,
    required this.containerWidth,
    required this.containerHeight,
    required this.imageWidth,
    required this.imageHeight,
    required this.iconUrl,
    required this.iconSize,
    required this.svgColor,
    required this.onTap,
    this.outerCorner = Dimens.space16,
    this.innerCorner = Dimens.space16,
    this.iconColor = Colors.white,
    this.boxFit = BoxFit.cover,
    this.boxDecorationColor = Colors.white,
  }) : super(key: key);

  final String assetUrl;
  final double containerWidth;
  final double containerHeight;
  final double imageWidth;
  final double imageHeight;
  final double iconSize;
  final VoidCallback onTap;
  final BoxFit boxFit;
  final IconData iconUrl;
  final Color? iconColor;
  final Color? svgColor;
  final double outerCorner;
  final double innerCorner;
  final Color? boxDecorationColor;

  @override
  Widget build(BuildContext context) {
    if (assetUrl == '') {
      return InkWell(
        splashColor: Colors.transparent,
        onTap: onTap,
        child: Container(
          width: containerWidth.w,
          height: containerHeight.w,
          margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
              Dimens.space0.w, Dimens.space0.h),
          padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
              Dimens.space0.w, Dimens.space0.h),
          decoration: BoxDecoration(
            color: boxDecorationColor,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(outerCorner.r)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(innerCorner.r),
            clipBehavior: Clip.antiAlias,
            child: Icon(
              iconUrl,
              size: iconSize.w,
              color: iconColor,
            ),
          ),
        ),
      );
    } else {
      return InkWell(
        splashColor: Colors.transparent,
        onTap: onTap,
        child: Container(
          width: containerWidth.w,
          height: containerHeight.w,
          alignment: Alignment.center,
          margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
              Dimens.space0.w, Dimens.space0.h),
          padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
              Dimens.space0.w, Dimens.space0.h),
          decoration: BoxDecoration(
            color: boxDecorationColor,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(outerCorner.r)),
          ),
          child: Container(
            alignment: Alignment.center,
            width: imageWidth.w,
            height: imageHeight.w,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(innerCorner.r),
              clipBehavior: Clip.antiAlias,
              child: SvgPicture.asset(
                assetUrl,
                fit: boxFit,
                color: svgColor,
                alignment: Alignment.center,
                clipBehavior: Clip.antiAlias,
                allowDrawingOutsideViewBox: false,
                cacheColorFilter: true,
                placeholderBuilder: (BuildContext context) => Icon(
                  iconUrl,
                  size: iconSize.w,
                  color: iconColor,
                ),
              ),
            ),
          ),
        ),
      );
    }
  }
}

class RoundedNetworkImageHolder extends StatelessWidget {
  const RoundedNetworkImageHolder({
    Key? key,
    required this.imageUrl,
    required this.width,
    required this.height,
    required this.iconUrl,
    required this.iconSize,
    required this.onTap,
    this.outerCorner = Dimens.space16,
    this.innerCorner = Dimens.space16,
    this.iconColor = const Color(0xFF613494),
    this.boxFit = BoxFit.cover,
    this.boxDecorationColor = const Color(0xFFF3F2F4),
    this.containerAlignment = Alignment.center,
  }) : super(key: key);

  final String imageUrl;
  final double width;
  final double height;
  final double iconSize;
  final VoidCallback onTap;
  final BoxFit boxFit;
  final IconData iconUrl;
  final Color iconColor;
  final double outerCorner;
  final double innerCorner;
  final Color boxDecorationColor;
  final Alignment containerAlignment;

  @override
  Widget build(BuildContext context) {
    if (imageUrl == '')
    {
      return InkWell(
        splashColor: Colors.transparent,
        onTap: onTap,
        child: Container(
          width: width.w,
          height: height.w,
          alignment: containerAlignment,
          margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
              Dimens.space0.w, Dimens.space0.h),
          decoration: BoxDecoration(
            color: boxDecorationColor,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(outerCorner.r)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(innerCorner.r),
            clipBehavior: Clip.antiAlias,
            child: Icon(
              iconUrl,
              size: iconSize.w,
              color: iconColor,
            ),
          ),
        ),
      );
    } else {
      return InkWell(
        splashColor: Colors.transparent,
        onTap: onTap,
        child: Container(
          width: width.w,
          height: height.w,
          alignment: Alignment.center,
          margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
              Dimens.space0.w, Dimens.space0.h),
          decoration: BoxDecoration(
              color: boxDecorationColor,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(Radius.circular(outerCorner.r))),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(innerCorner.r),
            clipBehavior: Clip.antiAlias,
            child: CachedNetworkImage(
              placeholder: (BuildContext context, String url)
              {
                return Icon(
                  iconUrl,
                  size: iconSize.w,
                  color: iconColor,
                );
              },
              httpHeaders: {
                'X-Auth-Token': Prefs.getStringList(Const.VALUE_HOLDER_CHAT_AUTH_TOKEN)![0],
                'X-User-Id': Prefs.getStringList(Const.VALUE_HOLDER_CHAT_USER_ID)![0],
              },
              fit: boxFit,
              imageUrl: imageUrl,
              height: height.w,
              width: width.w,
              memCacheHeight: 500,
              errorWidget: (BuildContext context, String? url, Object? error) =>
                  Icon(
                iconUrl,
                size: iconSize.w,
                color: iconColor,
              ),
            ),
          ),
        ),
      );
    }
  }
}

class RoundedFileImageHolderWithText extends StatelessWidget
{
  const RoundedFileImageHolderWithText({
    Key? key,
    required this.fileUrl,
    required this.text,
    required this.textColor,
    required this.width,
    required this.height,
    required this.onTap,
    required this.outerCorner,
    required this.innerCorner,
    this.fontFamily = Config.heeboRegular,
    this.fontWeight = FontWeight.normal,
    this.fontSize = Dimens.space14,
    this.iconColor = Colors.white,
    this.iconSize = Dimens.space20,
    this.iconUrl = Icons.ac_unit,
    this.corner = Dimens.space16,
    this.boxFit = BoxFit.cover,
    this.boxDecorationColor = const Color(0xFFF3F2F4),
  }) : super(key: key);

  final String fileUrl;
  final String text;
  final Color textColor;
  final String fontFamily;
  final FontWeight fontWeight;
  final double fontSize;
  final double width;
  final double height;
  final VoidCallback onTap;
  final double outerCorner;
  final double innerCorner;
  final BoxFit boxFit;
  final double corner;
  final Color boxDecorationColor;
  final IconData iconUrl;
  final Color iconColor;
  final double iconSize;

  @override
  Widget build(BuildContext context)
  {
    if (fileUrl.isEmpty)
    {
      if (text.isEmpty)
      {
        return InkWell(
          onTap: onTap,
          child: Container(
            width: width.w,
            height: height.w,
            alignment: Alignment.center,
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
            decoration: BoxDecoration(
              color: boxDecorationColor,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(Radius.circular(corner.r)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(corner.r),
              clipBehavior: Clip.antiAlias,
              child: Icon(
                iconUrl,
                size: iconSize.r,
                color: iconColor,
              ),
            ),
          ),
        );
      }
      else
      {
        return InkWell(
          splashColor: Colors.transparent,
          onTap: onTap,
          child: Container(
            width: width.w,
            height: height.w,
            alignment: Alignment.center,
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            decoration: BoxDecoration(
              color: boxDecorationColor,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(Radius.circular(outerCorner.r)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(innerCorner.r),
              clipBehavior: Clip.antiAlias,
              child: Text(
                text.toUpperCase(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyText1?.copyWith(
                  color: textColor,
                  fontFamily: fontFamily,
                  fontSize: fontSize.sp,
                  fontWeight: fontWeight,
                ),
              ),
            ),
          ),
        );
      }
    }
    else
    {
      return InkWell(
        onTap: onTap,
        child: Container(
          width: width.w,
          height: height.w,
          alignment: Alignment.center,
          margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
              Dimens.space0.w, Dimens.space0.h),
          decoration: BoxDecoration(
              color: boxDecorationColor,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(Radius.circular(outerCorner.r))),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(innerCorner.r),
            clipBehavior: Clip.antiAlias,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(corner),
              clipBehavior: Clip.antiAlias,
              child: Image.file(
                File(fileUrl),
                width: width,
                height: height,
                fit: boxFit,
                cacheWidth: 500,
              ),
            ),
          ),
        ),
      );
    }
  }
}

class RoundedNetworkImageHolderWithCustomBorder extends StatelessWidget {
  const RoundedNetworkImageHolderWithCustomBorder({
    Key? key,
    required this.imageUrl,
    required this.width,
    required this.height,
    required this.iconUrl,
    required this.iconSize,
    required this.onTap,
    this.outerCorner = Dimens.space16,
    this.innerCorner = Dimens.space16,
    this.iconColor = const Color(0xFF613494),
    this.boxFit = BoxFit.cover,
    this.boxDecorationColor = const Color(0xFFF3F2F4),
    this.containerAlignment = Alignment.center,
    required this.topLeftRadius,
    required this.bottomLeftRadius,
    required this.topRightRadius,
    required this.bottomRightRadius,
    required this.innerTopLeftRadius,
    required this.innerBottomLeftRadius,
    required this.innerTopRightRadius,
    required this.innerBottomRightRadius,
  }) : super(key: key);

  final String imageUrl;
  final double width;
  final double height;
  final double iconSize;
  final VoidCallback onTap;
  final BoxFit boxFit;
  final IconData iconUrl;
  final Color iconColor;
  final double outerCorner;
  final double innerCorner;
  final Color boxDecorationColor;
  final Alignment containerAlignment;
  final double topLeftRadius;
  final double bottomLeftRadius;
  final double topRightRadius;
  final double bottomRightRadius;
  final double innerTopLeftRadius;
  final double innerBottomLeftRadius;
  final double innerTopRightRadius;
  final double innerBottomRightRadius;

  @override
  Widget build(BuildContext context) {
    if (imageUrl == '') {
      return InkWell(
        splashColor: Colors.transparent,
        onTap: onTap,
        child: Container(
          width: width.w,
          height: height.w,
          alignment: containerAlignment,
          margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
              Dimens.space0.w, Dimens.space0.h),
          decoration: BoxDecoration(
            color: boxDecorationColor,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(topLeftRadius),
                topRight: Radius.circular(topRightRadius),
                bottomLeft: Radius.circular(bottomLeftRadius),
                bottomRight: Radius.circular(bottomRightRadius)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(innerTopLeftRadius),
                topRight: Radius.circular(innerTopRightRadius),
                bottomLeft: Radius.circular(innerBottomLeftRadius),
                bottomRight: Radius.circular(innerBottomRightRadius)),
            clipBehavior: Clip.antiAlias,
            child: Icon(
              iconUrl,
              size: iconSize.w,
              color: iconColor,
            ),
          ),
        ),
      );
    } else {
      return InkWell(
        splashColor: Colors.transparent,
        onTap: onTap,
        child: Container(
          width: width.w,
          height: height.w,
          alignment: Alignment.center,
          margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
              Dimens.space0.w, Dimens.space0.h),
          decoration: BoxDecoration(
              color: boxDecorationColor,
              shape: BoxShape.rectangle,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(topLeftRadius),
                topRight: Radius.circular(topRightRadius),
                bottomLeft: Radius.circular(bottomLeftRadius),
                bottomRight: Radius.circular(bottomRightRadius)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(innerTopLeftRadius),
                topRight: Radius.circular(innerTopRightRadius),
                bottomLeft: Radius.circular(innerBottomLeftRadius),
                bottomRight: Radius.circular(innerBottomRightRadius)),
            clipBehavior: Clip.antiAlias,
            child: CachedNetworkImage(
              placeholder: (BuildContext context, String url) {
                return Icon(
                  iconUrl,
                  size: iconSize.w,
                  color: iconColor,
                );
              },
              fit: boxFit,
              imageUrl: imageUrl,
              height: height.w,
              width: width.w,
              memCacheHeight: 500,
              errorWidget: (BuildContext context, String? url, Object? error) =>
                  Icon(
                iconUrl,
                size: iconSize.w,
                color: iconColor,
              ),
            ),
          ),
        ),
      );
    }
  }
}

class CustomCheckBox extends StatelessWidget {
  const CustomCheckBox({
    Key? key,
    required this.assetUrl,
    required this.width,
    required this.height,
    required this.iconUrl,
    required this.iconSize,
    required this.assetWidth,
    required this.assetHeight,
    required this.onTap,
    required this.boxDecorationColorOne,
    required this.boxDecorationColorTwo,
    this.outerCorner = Dimens.space16,
    this.innerCorner = Dimens.space16,
    this.iconColor = const Color(0xFF613494),
    this.boxFit = BoxFit.cover,
  }) : super(key: key);

  final String assetUrl;
  final double width;
  final double height;
  final double assetWidth;
  final double assetHeight;
  final double iconSize;
  final VoidCallback onTap;
  final BoxFit boxFit;
  final IconData iconUrl;
  final Color? iconColor;
  final double outerCorner;
  final double innerCorner;
  final Color? boxDecorationColorOne;
  final Color? boxDecorationColorTwo;

  @override
  Widget build(BuildContext context) {
    if (assetUrl == '') {
      return InkWell(
        splashColor: Colors.transparent,
        onTap: onTap,
        child: Container(
          width: width.w,
          height: height.w,
          alignment: Alignment.center,
          margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
              Dimens.space0.w, Dimens.space0.h),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                boxDecorationColorOne!,
                boxDecorationColorTwo!,
              ],
            ),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(outerCorner.r)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(innerCorner.r),
            clipBehavior: Clip.antiAlias,
            child: Icon(
              iconUrl,
              size: iconSize.w,
              color: iconColor,
            ),
          ),
        ),
      );
    } else {
      return InkWell(
        splashColor: Colors.transparent,
        onTap: onTap,
        child: Container(
          width: width.w,
          height: height.w,
          alignment: Alignment.center,
          margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
              Dimens.space0.w, Dimens.space0.h),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                boxDecorationColorOne!,
                boxDecorationColorTwo!,
              ],
            ),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(outerCorner.r)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(innerCorner.r),
            clipBehavior: Clip.antiAlias,
            child: Image.asset(
              assetUrl,
              fit: boxFit,
              width: assetWidth.w,
              height: assetHeight.h,
              cacheHeight: 500,
            ),
          ),
        ),
      );
    }
  }
}

class PlainFileImageHolder extends StatelessWidget {
  const PlainFileImageHolder({
    Key? key,
    required this.width,
    required this.height,
    required this.fileUrl,
    required this.iconUrl,
    required this.iconSize,
    required this.onTap,
    required this.outerCorner,
    required this.innerCorner,
    this.iconColor = const Color(0xFF613494),
    this.boxDecorationColor = const Color(0xFFF3F2F4),
    this.containerAlignment = Alignment.center,
    this.corner = Dimens.space16,
    this.boxFit = BoxFit.cover,
  }) : super(key: key);

  final double width;
  final double height;
  final BoxFit boxFit;
  final String fileUrl;
  final IconData iconUrl;
  final double iconSize;
  final Color iconColor;
  final VoidCallback onTap;
  final double corner;
  final double outerCorner;
  final double innerCorner;
  final Color boxDecorationColor;
  final Alignment containerAlignment;

  @override
  Widget build(BuildContext context) {
    if (fileUrl == '') {
      return InkWell(
        onTap: onTap,
        child: Container(
          width: width.w,
          height: height.w,
          alignment: containerAlignment,
          margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
              Dimens.space0.w, Dimens.space0.h),
          decoration: BoxDecoration(
            color: boxDecorationColor,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(outerCorner.r)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(innerCorner.r),
            clipBehavior: Clip.antiAlias,
            child: Icon(
              iconUrl,
              size: iconSize.w,
              color: iconColor,
            ),
          ),
        ),
      );
    } else {
      return InkWell(
        onTap: onTap,
        child: Container(
          width: width.w,
          height: height.w,
          alignment: Alignment.center,
          margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
              Dimens.space0.w, Dimens.space0.h),
          decoration: BoxDecoration(
              color: boxDecorationColor,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(Radius.circular(outerCorner.r))),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(innerCorner.r),
            clipBehavior: Clip.antiAlias,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(corner),
              clipBehavior: Clip.antiAlias,
              child: Image.file(
                File(fileUrl),
                width: width,
                height: height,
                fit: boxFit,
                cacheWidth: 500,
              ),
            ),
          ),
        ),
      );
    }
  }
}
