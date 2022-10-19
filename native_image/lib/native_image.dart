import 'dart:typed_data';

import 'package:native_image_platform_interface/native_image_platform_interface.dart';

/// [NativeImage]
class NativeImage {
  /// Constructs a singleton instance of [NativeImage].
  ///
  /// [NativeImage] is designed to work as a singleton.
  // When a second instance is created, the first instance will not be able to listen to the
  // EventChannel because it is overridden. Forcing the class to be a singleton class can prevent
  // misuse of creating a second instance from a programmer.
  factory NativeImage() {
    _singleton ??= NativeImage._();
    return _singleton!;
  }

  NativeImage._();

  static NativeImage? _singleton;

  static NativeImagePlatform get _platform {
    return NativeImagePlatform.instance;
  }

  /// crop image by width and height
  Future<Uint8List?> cropImage({
    required Uint8List bytes,
    required double width,
    required double height,
  }) {
    return _platform.cropImage(
      bytes: bytes,
      width: width,
      height: height,
    );
  }
}
