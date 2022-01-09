import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:live/config/Config.dart';
import 'package:live/config/CustomColors.dart';
import 'package:live/constant/Dimens.dart';
import 'package:live/utils/Utils.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PsProgressDialog
{
  PsProgressDialog._();

  static ProgressDialog? _progressDialog;

  static void showDialog(BuildContext context, {String? message})
  {
    if (_progressDialog == null)
    {
      _progressDialog = ProgressDialog(
          context,
          type: ProgressDialogType.Normal,
          isDismissible: false,
          showLogs: true
      );

      _progressDialog?.style(
          message: message ?? Utils.getString('pleaseWait'),
          borderRadius: 5.0,
          backgroundColor: Utils.isLightMode() ? CustomColors.background_bg01 : CustomColors.background_bg01,
          elevation: 10.0,
          insetAnimCurve: Curves.easeInOut,
          progress: 0.0,
          maxProgress: 100.0,
          progressTextStyle: Theme.of(context)
              .textTheme
              .bodyText1!
              .copyWith(
              color: CustomColors.title_active,
              fontFamily: Config.heeboRegular,
              fontSize: Dimens.space14.sp,
              fontWeight: FontWeight.normal,
              fontStyle: FontStyle.normal
          ),
          messageTextStyle: Theme.of(context)
              .textTheme
              .bodyText1!
              .copyWith(
              color: CustomColors.title_active,
              fontFamily: Config.heeboRegular,
              fontSize: Dimens.space14.sp,
              fontWeight: FontWeight.normal,
              fontStyle: FontStyle.normal
          ),
      );
    }

    if (message != null)
    {
      _progressDialog?.update(message: message);
    }

    _progressDialog?.show();
  }

  static void dismissDialog()
  {
    if (_progressDialog != null)
    {
      _progressDialog?.hide();
      _progressDialog = null;
    }
  }

  static bool? isShowing()
  {
    if (_progressDialog != null)
    {
      return _progressDialog?.isShowing();
    }
    else
    {
      return false;
    }
  }

  static void showDownloadDialog(BuildContext context, double progress, {required String message})
  {
    if (_progressDialog == null)
    {
      _progressDialog = ProgressDialog(context,
          type: ProgressDialogType.Download,
          isDismissible: false,
          showLogs: true
      );

      _progressDialog?.style(
          message: message,
          borderRadius: 5.0,
          backgroundColor: CustomColors.title_active,
          progressWidget: Container(
              padding: const EdgeInsets.all(10.0),
              child: const CupertinoActivityIndicator()
          ),
          elevation: 10.0,
          insetAnimCurve: Curves.easeInOut,
          progress: progress,
          maxProgress: 100.0,
          progressTextStyle: Theme.of(context).textTheme.bodyText2,
          messageTextStyle: Theme.of(context).textTheme.bodyText2);
    }

    _progressDialog?.update(
        message: message,
        progress: progress);

    if (!_progressDialog!.isShowing())
    {
      _progressDialog?.show();
    }
  }

  static void dismissDownloadDialog()
  {
    if (_progressDialog != null)
    {
      _progressDialog?.hide();
      _progressDialog = null;
    }
  }
}
