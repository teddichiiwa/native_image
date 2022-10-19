import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

import 'native_image_platform_interface.dart';

/// An implementation of [ConnectivityPlatform] that uses method channels.
class MethodChannelNativeImage extends NativeImagePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  MethodChannel methodChannel =
      const MethodChannel('com.teddichiiwa/native_image');

  @override
  Future<Uint8List?> cropImage({
    required Uint8List bytes,
    required double width,
    required double height,
  }) {
    return methodChannel
        .invokeMethod<Uint8List>('cropImage', {
          'bytes': bytes,
          'length': bytes.length,
          'width': width,
          'height': height,
        })
        .then((value) => value)
        .onError((error, stackTrace) => null);
  }
}
