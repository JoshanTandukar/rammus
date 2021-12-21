import 'package:flutter/services.dart';
import 'package:rammus/src/common_callback_result.dart';

class RammusPlugin {
  static const MethodChannel methodChannel = MethodChannel('Rammus');

  static const EventChannel initCloudChannel = EventChannel('Rammus/initCloudChannel');

  static const EventChannel notificationChannel = EventChannel('Rammus/notificationChannel');

  static CommonCallbackResult convertException(PlatformException err)
  {
    return CommonCallbackResult(
      errorCode: err.code,
      errorMessage: err.message,
      iosError: err.message,
      isSuccessful: false,
      response: err.details,
    );
  }
}