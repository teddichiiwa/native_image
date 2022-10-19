import 'dart:async';

import 'package:flutter/services.dart';

/// [NativeImage]
class NativeImage {
  static const MethodChannel _channel = MethodChannel('native_image');

  /// return platform version
  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
