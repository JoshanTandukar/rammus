import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:live/config/Config.dart';
import 'package:live/config/CustomColors.dart';
import 'package:live/constant/Constants.dart';
import 'package:live/constant/Dimens.dart';
import 'package:live/utils/Prefs.dart';

class Utils {
  Utils._();

  static String getString(String key, {onTap}) {
    if (key != '') {
      return tr(key);
    } else {
      return '';
    }
  }

  static String encodeJson(dynamic jsonData) {
    return json.encode(jsonData);
  }

  static dynamic decodeJson(String jsonString) {
    return json.decode(jsonString);
  }

  static DateTime? previous;

  static void psPrint(String msg) {
    final DateTime now = DateTime.now();
    if (previous == null) {
      previous = now;
    } else {
      previous = now;
    }
  }

  static bool isLightMode() {
    bool? value = Prefs.getBool(Const.THEME_IS_LIGHT_THEME);
    if (value != null) {
      return value;
    } else {
      return true;
    }
  }

  static Brightness getBrightnessForAppBar(BuildContext context) {
    if (Platform.isAndroid) {
      return Brightness.dark;
    } else {
      return Theme.of(context).brightness;
    }
  }

  static Future<bool> checkInternetConnectivity() async {
    return await InternetConnectionChecker().hasConnection;
  }

  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height.h;
  }

  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width.w;
  }

  static double getStatusBarHeight(BuildContext context) {
    return MediaQuery.of(context).padding.top;
  }

  static double getBottomNotchHeight(BuildContext context) {
    return MediaQuery.of(context).padding.bottom;
  }

  static void showToastMessage(String message) async {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: CustomColors.background_bg01,
        textColor: CustomColors.title_active,
        fontSize: Dimens.space16);
  }

  static String dateFullMonthYearTimeWithAt(String dateFormat, String input) {
    try {
      return DateFormat(Config.dateFullMonthYearAndTimeFormat).format(
              DateTime.parse(DateFormat(dateFormat).parse(input).toString())) +
          " " +
          Utils.getString("at") +
          " " +
          Utils.convertDateToTime(input);
    } catch (e) {
      return "";
    }
  }

  static int formDateToUnixTimeStamp(String dateFormat, String input) {
    return DateFormat(dateFormat).parse(input).millisecondsSinceEpoch;
  }

  static String convertMessageDateTime(
      String? callTime, String inputFormat, String outputFormat) {
    if (callTime != null) {
      String now = "";
      try {
        var dateFormat = DateFormat(outputFormat);
        String createdDate =
            dateFormat.format(DateTime.parse(callTime + 'Z').toLocal());
        now = createdDate;
        var date = dateFormat.parse(callTime);
        now = DateFormat('dd MMM').format(date);
      } on Exception catch (_) {}
      return now;
    } else {
      return "";
    }
  }

  static String readTimestamp(String? timestamp, DateFormat inputFormat) {
    if (timestamp != null) {
      try {
        var now = DateTime.now();
        var date = inputFormat.parse(timestamp.split("+")[0]);
        var strToDateTime = DateTime.parse(timestamp.split("+")[0] + 'Z');
        final convertLocal = strToDateTime.toLocal();
        date = convertLocal;
        var diff = now.difference(date);
        var time = '';
        if (diff.inSeconds <= 0 ||
            diff.inSeconds > 0 && diff.inMinutes == 0 ||
            diff.inMinutes > 0 && diff.inHours == 0 ||
            diff.inHours > 0 && diff.inDays == 0) {
          time = DateFormat('hh:mm a').format(date);
        } else if (diff.inDays > 0 && diff.inDays < 7) {
          if (diff.inDays == 1) {
            time = "Yesterday";
          } else if (diff.inDays == 2) {
            time = "2d";
          } else if (diff.inDays == 3) {
            time = "3d";
          } else if (diff.inDays == 4) {
            time = "4d";
          } else if (diff.inDays == 5) {
            time = "5d";
          } else if (diff.inDays == 6) {
            time = "6d";
          } else if (diff.inDays == 7) {
            time = "1W";
          } else if (diff.inDays <= 14) {
            time = "2W";
          } else if (diff.inDays <= 21) {
            time = "3W";
          } else if (diff.inDays <= 28) {
            time = "4W";
          } else {
            var date = inputFormat.parse(timestamp);
            time = DateFormat('dd MMM').format(date);
          }
        } else {
          var date = inputFormat.parse(timestamp);
          time = DateFormat('dd MMM').format(date);
        }
        return time;
      } catch (e) {
        return "";
      }
    } else {
      return "";
    }
  }

  static String convertCallTime(
      String? callTime, String inputFormat, String outputFormat) {
    if (callTime != null) {
      String date = "";
      try {
        var dateFormat = DateFormat(outputFormat);
        String createdDate =
            dateFormat.format(DateTime.parse(callTime + 'Z').toLocal());
        date = createdDate;
      } on Exception catch (_) {}
      return date;
    } else {
      return "";
    }
  }

  static String convertDateTime(String? timestamp, DateFormat inputFormat) {
    if (timestamp != null) {
      try {
        var now = DateTime.now();
        var date = inputFormat.parse(timestamp.split("+")[0]);
        var diff = now.difference(date);
        var time = '';
        if (diff.inSeconds <= 0 ||
            diff.inSeconds > 0 && diff.inMinutes == 0 ||
            diff.inMinutes > 0 && diff.inHours == 0 ||
            diff.inHours > 0 && diff.inDays == 0) {
          time = "Today";
        } else if (diff.inDays > 0 && diff.inDays < 7) {
          if (diff.inDays == 1) {
            time = "Yesterday";
          } else {
            var date = inputFormat.parse(timestamp);
            time = DateFormat('dd MMM').format(date);
          }
        } else {
          var date = inputFormat.parse(timestamp);
          time = DateFormat('dd MMM').format(date);
        }
        return time;
      } catch (e) {
        return "";
      }
    } else {
      return "";
    }
  }

  static String formatTimeStamp(DateFormat dateFormat, String timestamp) {
    try {
      var date =
          DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp) * 1000);
      return DateFormat('HH:mm a').format(date);
    } catch (e) {
      return "";
    }
  }

  static String formatTimeStampToReadableDate(
      int timeStamp, String outputFormat) {
    var date = DateTime.fromMillisecondsSinceEpoch(timeStamp);
    var formattedDate = DateFormat(outputFormat).format(date);
    return formattedDate.toString();
  }

  static Map<String, String> convertImageToBase64String(
      String key, File imageFile) {
    Map<String, String> base64ImageMap = Map();
    List<int> imageBytes = imageFile.readAsBytesSync();
    print(imageBytes);
    String base64Image = base64Encode(imageBytes);
    log(base64Image);
    base64ImageMap.putIfAbsent(key, () => "data:image/png;base64,$base64Image");
    return base64ImageMap;
  }

  static void customPrint(String? object) async {
    int defaultPrintLength = 1020;
    if (object == null || object.toString().length <= defaultPrintLength) {
      print(object);
    } else {
      String log = object.toString();
      int start = 0;
      int endIndex = defaultPrintLength;
      int logLength = log.length;
      int tmpLogLength = log.length;
      while (endIndex < logLength) {
        print(log.substring(start, endIndex));
        endIndex += defaultPrintLength;
        start += defaultPrintLength;
        tmpLogLength -= defaultPrintLength;
      }
      if (tmpLogLength > 0) {
        print(log.substring(start, logLength));
      }
    }
  }

  static String convertCamelCasing(String value) {
    return value
        .replaceAll(RegExp(' +'), ' ')
        .split(" ")
        .map((str) => convertCamelCasingFirst(str))
        .join(" ");
  }

  static String convertCamelCasingFirst(String value) {
    return value.length > 0
        ? '${value[0].toUpperCase()}${value.substring(1)}'
        : '';
  }

  static String convertDateToTime(String? dateTime) {
    String time = "";
    if (dateTime != null) {
      try {
        var strToDateTime = DateTime.parse(dateTime);
        final convertLocal = strToDateTime.toLocal();
        time = DateFormat.jm().format(convertLocal);
        // time = DateFormat.jm().format(DateTime.parse(convertLocal));
      } catch (e) {
        print(e);
      }
    }
    return time;
  }

  static void removeKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  static void closeActivity(context) {
    Navigator.pop(context);
  }

  static Future<Null> openActivity(context, object) async {
    return await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => object),
    );
  }

  static void replaceActivity(context, object) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => object),
    );
  }

  static void removeStackActivity(context, object) {
    Navigator.pushAndRemoveUntil(
        context, MaterialPageRoute(builder: (context) => object), (r) => false);
  }

  static void unFocusKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  static dynamic showCallNotification(
      {String? title,
      String? body,
      String? serverUrl,
      String? channelName,
      String? uid}) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: Const.NOTIFICATION_CHANNEL_ID_VIDEO_CALL,
        channelKey: Const.NOTIFICATION_CHANNEL_VIDEO_CALL,
        title: title,
        body: body,
        criticalAlert: true,
        autoDismissible: false,
        payload: {
          'title': '$title',
          'body': '$body',
          'username': 'Little Mary',
          'serverUrl': serverUrl!,
          'channelName': channelName!,
          'uid': uid!,
        },
        locked: true,
        showWhen: true,
        category: NotificationCategory.Alarm,
        displayOnBackground: true,
        displayOnForeground: true,
        fullScreenIntent: true,
        wakeUpScreen: true,
        notificationLayout: NotificationLayout.Default,
      ),
      actionButtons: [
        NotificationActionButton(
            key: 'accept',
            label: 'Accept Call',
            color: Colors.green,
            autoDismissible: true),
        NotificationActionButton(
            key: 'reject',
            label: 'Reject',
            isDangerousOption: true,
            autoDismissible: true),
      ],
    );
  }

  static dynamic cancelVideoCallNotification() async {
    AwesomeNotifications().cancel(Const.NOTIFICATION_CHANNEL_ID_VIDEO_CALL);
  }
}
