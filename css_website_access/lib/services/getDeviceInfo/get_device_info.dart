import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:html' as html;
import 'package:device_info_plus/device_info_plus.dart';

Future<void> getDeviceInfo() async {
  if (kIsWeb) {
    var userAgent = html.window.navigator.userAgent;
    var platform = html.window.navigator.platform;
    var language = html.window.navigator.language;

    print('User Agent: $userAgent');
    print('Platform: $platform');
    print('Language: $language');
  } else {
    var deviceInfo = await DeviceInfoPlugin().deviceInfo;

    if (deviceInfo is AndroidDeviceInfo) {
      print('Android Device Info: $deviceInfo');
    } else if (deviceInfo is IosDeviceInfo) {
      print('iOS Device Info: $deviceInfo');
    } else {
      print('Unknown platform');
    }
  }
}
