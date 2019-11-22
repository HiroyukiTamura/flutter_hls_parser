import 'dart:async';

import 'package:flutter/services.dart';

class FlutterHlsParser {
  static const MethodChannel _channel = MethodChannel('flutter_hls_parser');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
