import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:live/config/Config.dart';
import 'package:live/constant/Dimens.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:live/utils/Utils.dart';

class DateTimeTextWidget extends StatelessWidget
{
  const DateTimeTextWidget({
    Key? key,
    required this.date,
    required this.format,
    required this.dateFontColor,
    this.dateFontSize = Dimens.space14,
    this.dateFontFamily=Config.PoppinsRegular,
    this.dateFontStyle=FontStyle.normal,
    this.dateFontWeight=FontWeight.normal,
  }) : super(key: key);
  final String date;
  final DateFormat format;
  final String dateFontFamily;
  final double dateFontSize;
  final FontWeight dateFontWeight;
  final FontStyle dateFontStyle;
  final Color dateFontColor;

  @override
  Widget build(BuildContext context)
  {
    return  Text(
      Utils.readTimestamp(date, format),
      overflow: TextOverflow.ellipsis,
      softWrap: true,
      maxLines: 1,
      style: Theme.of(context)
          .textTheme
          .bodyText1
      !.copyWith(
        color: dateFontColor,
        fontFamily: dateFontFamily,
        fontSize: dateFontSize.sp,
        fontWeight: dateFontWeight,
        fontStyle: dateFontStyle,
      ),
    );
  }
}
