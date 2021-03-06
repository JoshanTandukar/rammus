import 'dart:async';

import 'package:flutter/services.dart';
import 'package:rammus/src/NotificationChannel.dart';
import 'package:rammus/src/RammusPlugin.dart';
import 'package:rammus/src/cloud_push_message.dart';

import 'common_callback_result.dart';

class RammusClient {
  /// Stream for the registration events.
  late StreamSubscription<dynamic> initCloudStream;
  final StreamController<CommonCallbackResult>
      _initCloudChannelResultController = StreamController.broadcast();
  late Stream<CommonCallbackResult> initCloudChannelResult;

  late StreamSubscription<dynamic> notificationStream;
  final StreamController<CloudPushMessage> _notificationResultStreamController =
      StreamController.broadcast();
  late Stream<CloudPushMessage> notificationResultStream;

  RammusClient() {
    initCloudStream = RammusPlugin.initCloudChannel
        .receiveBroadcastStream(0)
        .listen(_parseRegistrationEvent);
    notificationStream = RammusPlugin.notificationChannel
        .receiveBroadcastStream(0)
        .listen(_parseNotificationEvent);

    initCloudChannelResult = _initCloudChannelResultController.stream;
    notificationResultStream = _notificationResultStreamController.stream;
  }

  /// Cleanly shuts down the messaging client when you are done with it.
  ///
  /// It will dispose() the client after shutdown, so it could not be reused.
  Future<void> shutdown() async {
    try {
      await initCloudStream.cancel();
      await notificationStream.cancel();

      await _initCloudChannelResultController.close();
      await _notificationResultStreamController.close();

      return await RammusPlugin.methodChannel
          .invokeMethod('RammusClient#shutdown', null);
    } on PlatformException catch (err) {
      throw RammusPlugin.convertException(err);
    }
  }

  Future<CommonCallbackResult> initPushService() async {
    try {
      final data =
          await RammusPlugin.methodChannel.invokeMethod('initPushService');
      return CommonCallbackResult(
        isSuccessful: data["isSuccessful"],
        response: data["response"],
        errorCode: data["errorCode"],
        errorMessage: data["errorMessage"],
      );
    } on PlatformException catch (err) {
      throw RammusPlugin.convertException(err);
    }
  }

  ///??????????????????android??????
  ///????????????????????????????????????Android 8???????????????????????????
  ///?????????????????????????????????????????????????????????NotificationChannel???
  ///?????????????????????????????????????????????????????????[null]???
  ///[id]??????????????????????????????????????????????????????????????????Android8.0?????????????????????????????????
  ///For Android 8 and above use notification channel
  Future<CommonCallbackResult> setupNotificationManager(
      List<NotificationChannel> channels) async {
    try {
      final data = await RammusPlugin.methodChannel
          .invokeMethod('setupNotificationManager');

      return CommonCallbackResult(
        isSuccessful: data["isSuccessful"],
        response: data["response"],
        errorCode: data["errorCode"],
        errorMessage: data["errorMessage"],
      );
    } on PlatformException catch (err) {
      throw RammusPlugin.convertException(err);
    }
  }

  ///????????????????????????????????????[deviceId]
  Future<String?> get deviceId async {
    return await RammusPlugin.methodChannel.invokeMethod('deviceId');
  }

  void _parseRegistrationEvent(dynamic event) {
    final String eventName = event['name'];
    final data = Map<String, dynamic>.from(event['data']);

    switch (eventName) {
      case 'initCloudChannel':
        _initCloudChannelResultController.add(
          CommonCallbackResult(
            isSuccessful: data["isSuccessful"],
            response: data["response"],
            errorCode: data["errorCode"],
            errorMessage: data["errorMessage"],
          ),
        );
        break;
      default:
        break;
    }
  }

  void _parseNotificationEvent(dynamic event) {
    final String eventName = event['name'];
    final data = Map<String, dynamic>.from(event['data']);

    switch (eventName) {
      case 'onNotification':
        _notificationResultStreamController.add(
          CloudPushMessage(
            title: data["title"],
            summary: data["summary"],
            extras: data["extras"],
            appId: null,
            content: null,
            messageId: null,
            traceInfo: null,
          ),
        );
        break;
      case 'onMessage':
        _notificationResultStreamController.add(
          CloudPushMessage(
            title: data["title"],
            traceInfo: data["traceInfo"],
            appId: data["appId"],
            content: data["content"],
            messageId: data["messageId"],
            summary: null,
            extras: null,
          ),
        );
        break;
      default:
        break;
    }
  }
}

//
// final MethodChannel _channel = const MethodChannel('com.jarvanmo/rammus')
//   ..setMethodCallHandler(_handler);
//
//
// ///???????????????????????????????????????
// ///?????????????????????????????????????????????
// StreamController<CloudPushMessage> _onMessageArrivedController = StreamController.broadcast();
//
// Stream<CloudPushMessage> get onMessageArrived => _onMessageArrivedController.stream;
//
// ///????????????????????????????????????????????????
// ///?????????????????????????????????????????????
// StreamController<OnNotification> _onNotificationController = StreamController.broadcast();
//
// Stream<OnNotification> get onNotification => _onNotificationController.stream;
//
// ///?????????????????????????????????????????????????????????SDK???????????????
// StreamController<OnNotificationOpened> _onNotificationOpenedController = StreamController.broadcast();
//
// Stream<OnNotificationOpened> get onNotificationOpened => _onNotificationOpenedController.stream;
//
// ///??????????????????????????????????????????????????????SDK???????????????
// StreamController<String> _onNotificationRemovedController = StreamController.broadcast();
//
// Stream<String> get onNotificationRemoved => _onNotificationRemovedController.stream;
//
// ///?????????????????????(open=4)????????????????????????(v2.3.2?????????????????????)????????????????????????SDK???????????????
// StreamController<OnNotificationClickedWithNoAction>_onNotificationClickedWithNoActionController = StreamController.broadcast();
//
// Stream<OnNotificationClickedWithNoAction> get onNotificationClickedWithNoAction => _onNotificationClickedWithNoActionController.stream;
//
// ///????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????onNotification??????(v2.3.3?????????????????????)
// StreamController<OnNotificationReceivedInApp> _onNotificationReceivedInAppController = StreamController.broadcast();
//
// Stream<OnNotificationReceivedInApp> get onNotificationReceivedInApp => _onNotificationReceivedInAppController.stream;
//
//
// Future<CommonCallbackResult> get pushChannelStatus async {
//   var result = await _channel.invokeMethod("checkPushChannelStatus");
//
//   return CommonCallbackResult(
//     isSuccessful: result["isSuccessful"],
//     response: result["response"],
//     errorCode: result["errorCode"],
//     errorMessage: result["errorMessage"],
//   );
// }
//
// //  static Future<String> get platformVersion async {
// //    final String version = await _channel.invokeMethod('getPlatformVersion');
// //    return version;
// //  }
//
// ///??????????????????????????????[true]????????????SDK???????????????
// ///????????????????????????[initCloudChannelResult]
// ///???????????????ios
// //Future<bool> initCloudChannel({String appKey, String appSecret}) async {
// //  return await _channel.invokeMethod(
// //      "initCloudChannel", {"appKey": appKey, "appSecret": appSecret});
// //}
//
// Future<CommonCallbackResult> turnOnPushChannel() async {
//   var result = await _channel.invokeMethod("turnOnPushChannel");
//
//   return CommonCallbackResult(
//     isSuccessful: result["isSuccessful"],
//     response: result["response"],
//     errorCode: result["errorCode"],
//     errorMessage: result["errorMessage"],
//   );
// }
//
// Future<CommonCallbackResult> turnOffPushChannel() async {
//   var result = await _channel.invokeMethod("turnOffPushChannel");
//   return CommonCallbackResult(
//     isSuccessful: result["isSuccessful"],
//     response: result["response"],
//     errorCode: result["errorCode"],
//     errorMessage: result["errorMessage"],
//   );
// }
//
// /// Android ??????
// ///??????????????????????????????????????????????????????????????????????????????????????????
// ///???????????????????????????????????????????????????????????????????????????
// ///???????????????????????????????????????????????????????????????????????????????????????????????????
// ///????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????
// ///?????????????????????64?????????
// Future<CommonCallbackResult> bindAccount(String account) async {
//   assert(account != null);
//
//   var result = await _channel.invokeMethod("bindAccount", account);
//   return CommonCallbackResult(
//       isSuccessful: result["isSuccessful"],
//       response: result["response"],
//       errorCode: result["errorCode"],
//       errorMessage: result["errorMessage"],
//       iosError: result["iosError"]);
// }
//
// Future<CommonCallbackResult> unbindAccount() async {
//   var result = await _channel.invokeMethod("unbindAccount");
//   return CommonCallbackResult(
//       isSuccessful: result["isSuccessful"],
//       response: result["response"],
//       errorCode: result["errorCode"],
//       errorMessage: result["errorMessage"],
//       iosError: result["iosError"]);
// }
//
// ///Android only
// Future<CommonCallbackResult> bindPhoneNumber(String phoneNumber) async {
//   var result = await _channel.invokeMethod("bindPhoneNumber", phoneNumber);
//   return CommonCallbackResult(
//       isSuccessful: result["isSuccessful"],
//       response: result["response"],
//       errorCode: result["errorCode"],
//       errorMessage: result["errorMessage"],
//       iosError: result["iosError"]);
// }
//
// ///Android only
//
// Future<CommonCallbackResult> unbindPhoneNumber() async {
//   var result = await _channel.invokeMethod("unbindPhoneNumber");
//   return CommonCallbackResult(
//       isSuccessful: result["isSuccessful"],
//       response: result["response"],
//       errorCode: result["errorCode"],
//       errorMessage: result["errorMessage"],
//       iosError: result["iosError"]);
// }
//
// //void bindTag(int target, String[] tags, String alias, CommonCallback callback);
// ///Android ??????
// ///??????????????????????????????
// ///?????????????????????????????????????????????????????????????????????target?????????
// ///???????????????10??????????????????
// ///App??????????????????1???????????????????????????????????????128?????????
// ///target ???????????????1??????????????? 2??????????????????????????? 3?????????
// ///target(V2.3.5???????????????) ???????????????CloudPushService.DEVICE_TARGET??????????????? CloudPushService.ACCOUNT_TARGET??????????????? CloudPushService.ALIAS_TARGET?????????
// ///tags ????????????????????????
// ///alias ???????????????target = 3????????????
// ///callback ??????
// Future<CommonCallbackResult> bindTag(
//     {@required CloudPushServiceTarget? target,
//     List<String>? tags,
//     String? alias}) async {
//   var result = await _channel.invokeMethod("bindTag", {
//     "target": target!.index + 1,
//     "tags": tags ?? <String>[],
//     "alias": alias
//   });
//
//   return CommonCallbackResult(
//       isSuccessful: result["isSuccessful"],
//       response: result["response"],
//       errorCode: result["errorCode"],
//       errorMessage: result["errorMessage"],
//       iosError: result["iosError"]);
// }
//
// ///Android ??????
// ///???????????????????????????
// ///??????????????????????????????????????????????????????????????????target?????????
// ///???????????????10??????????????????
// ///??????????????????????????????????????????????????????????????????????????????????????????APP???????????????????????????????????????????????????????????????
// ///target ???????????????1??????????????? 2??????????????????????????? 3?????????
// ///target(V2.3.5???????????????) ???????????????CloudPushService.DEVICE_TARGET??????????????? CloudPushService.ACCOUNT_TARGET??????????????? CloudPushService.ALIAS_TARGET?????????
// ///tags ????????????????????????
// ///alias ???????????????target = 3????????????
// ///callback ??????
// Future<CommonCallbackResult> unbindTag(
//     {@required CloudPushServiceTarget? target,
//     List<String>? tags,
//     String? alias}) async {
//   var result = await _channel.invokeMethod("unbindTag", {
//     "target": target!.index + 1,
//     "tags": tags ?? <String>[],
//     "alias": alias
//   });
//
//   return CommonCallbackResult(
//       isSuccessful: result["isSuccessful"],
//       response: result["response"],
//       errorCode: result["errorCode"],
//       errorMessage: result["errorMessage"],
//       iosError: result["iosError"]);
// }
//
// ///Android ??????
// ///???????????????????????????????????????????????????????????????
// ///????????????????????????onSuccess(response)???response?????????
// ///??????????????????????????????10??????????????????????????????
// Future<CommonCallbackResult> listTags(CloudPushServiceTarget target) async {
//   var result = await _channel.invokeMethod("listTags", target.index + 1);
//   return CommonCallbackResult(
//       isSuccessful: result["isSuccessful"],
//       response: result["response"],
//       errorCode: result["errorCode"],
//       errorMessage: result["errorMessage"],
//       iosError: result["iosError"]);
// }
//
// ///Android ??????
// ///????????????
// ///?????????????????????
// ///????????????????????????128??????????????????????????????????????????128????????????
// ///????????????128?????????
// Future<CommonCallbackResult> addAlias(String alias) async {
//   var result = await _channel.invokeMethod("addAlias", alias);
//   return CommonCallbackResult(
//       isSuccessful: result["isSuccessful"],
//       response: result["response"],
//       errorCode: result["errorCode"],
//       errorMessage: result["errorMessage"],
//       iosError: result["iosError"]);
// }
//
// ///Android ??????
// ///????????????
// ///?????????????????????
// ///????????????????????????????????????????????????alias = null || alias.length = 0??????
// Future<CommonCallbackResult> removeAlias(String alias) async {
//   var result = await _channel.invokeMethod("removeAlias", alias);
//   return CommonCallbackResult(
//       isSuccessful: result["isSuccessful"],
//       response: result["response"],
//       errorCode: result["errorCode"],
//       errorMessage: result["errorMessage"],
//       iosError: result["iosError"]);
// }
//
// ///Android ??????
// ///?????????????????????
// ///????????????????????????onSuccess(response)???response????????????
// ///???V3.0.9???????????????????????????????????????5s????????????5s?????????????????????????????????????????????
// Future<CommonCallbackResult> listAliases() async {
//   var result = await _channel.invokeMethod("listAliases");
//   return CommonCallbackResult(
//       isSuccessful: result["isSuccessful"],
//       response: result["response"],
//       errorCode: result["errorCode"],
//       errorMessage: result["errorMessage"],
//       iosError: result["iosError"]);
// }
//
//
//
// ///?????????????????????iOS
// ///??????????????????????????????
// ///    completionHandler(UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionBadge);
// Future configureNotificationPresentationOption(
//     {bool none: false,
//     bool sound: true,
//     bool alert: true,
//     bool badge: true}) async {
//   return _channel.invokeMethod("configureNotificationPresentationOption",
//       {"none": none, "sound": sound, "alert": alert, "badge": badge});
// }
//
// Future badgeClean({int num: 0}) async {
//   return _channel.invokeMethod("badgeClean", {"num": num});
// }
//
// Future<dynamic> _handler(MethodCall methodCall)
// {
//   print(_channel.name.toString());
//   print(_channel.binaryMessenger.toString());
//   print(_channel.binaryMessenger.toString());
//
//   print("Method "+methodCall.method.toString());
//   if ("initCloudChannelResult" == methodCall.method)
//   {
//     // _initCloudChannelResultController.add(
//     //   CommonCallbackResult(
//     //     isSuccessful: methodCall.arguments["isSuccessful"],
//     //     response: methodCall.arguments["response"],
//     //     errorCode: methodCall.arguments["errorCode"],
//     //     errorMessage: methodCall.arguments["errorMessage"],
//     //   ),
//     // );
//   }
//   else if ("onMessageArrived" == methodCall.method)
//   {
//     _onMessageArrivedController.add(
//       CloudPushMessage(
//         messageId: methodCall.arguments["messageId"],
//         appId: methodCall.arguments["appId"],
//         title: methodCall.arguments["title"],
//         content: methodCall.arguments["content"],
//         traceInfo: methodCall.arguments["traceInfo"],
//       ),
//     );
//   }
//   else if ("onNotification" == methodCall.method)
//   {
//     _onNotificationController.add(
//       OnNotification(
//         methodCall.arguments["title"],
//         methodCall.arguments["summary"],
//         methodCall.arguments["extras"],
//       ),
//     );
//   }
//   else if ("onNotificationOpened" == methodCall.method)
//   {
//     _onNotificationOpenedController.add(
//       OnNotificationOpened(
//         methodCall.arguments["title"],
//         methodCall.arguments["summary"],
//         methodCall.arguments["extras"],
//         methodCall.arguments["subtitle"],
//         methodCall.arguments["badge"],
//       ),
//     );
//   }
//   else if ("onNotificationRemoved" == methodCall.method)
//   {
//     _onNotificationRemovedController.add(methodCall.arguments);
//   }
//   else if ("onNotificationClickedWithNoAction" == methodCall.method)
//   {
//     _onNotificationClickedWithNoActionController.add(
//       OnNotificationClickedWithNoAction(
//         methodCall.arguments["title"],
//         methodCall.arguments["summary"],
//         methodCall.arguments["extras"],
//       ),
//     );
//   }
//   else if ("onNotificationReceivedInApp" == methodCall.method)
//   {
//     _onNotificationReceivedInAppController.add(
//       OnNotificationReceivedInApp(
//         methodCall.arguments["title"],
//         methodCall.arguments["summary"],
//         methodCall.arguments["extras"],
//         methodCall.arguments["openType"],
//         methodCall.arguments["openActivity"],
//         methodCall.arguments["openUrl"],
//       ),
//     );
//   }
//   else
//   {
//     ///DO nothing
//   }
//
//   return Future.value(true);
// }
//
// dispose() {
//   // _initCloudChannelResultController.close();
//   _onMessageArrivedController.close();
//   _onNotificationController.close();
//   _onNotificationRemovedController.close();
//   _onNotificationClickedWithNoActionController.close();
//   _onNotificationReceivedInAppController.close();
// }
