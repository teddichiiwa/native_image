library native_image_platform_interface;

import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'method_channel_native_image.dart';

/// The interface that implementations of native image must implement.
///
/// Platform implementations should extend this class rather than implement it as `NativeImage`
/// does not consider newly added methods to be breaking changes. Extending this class
/// (using `extends`) ensures that the subclass will get the default implementation, while
/// platform implementations that `implements` this interface will be broken by newly added
/// [NativeImagePlatform] methods.
abstract class NativeImagePlatform extends PlatformInterface {
  /// Constructs a NativeImagePlatform.
  NativeImagePlatform() : super(token: _token);

  static final Object _token = Object();

  static NativeImagePlatform _instance = MethodChannelNativeImage();

  /// The default instance of [NativeImagePlatform] to use.
  ///
  /// Defaults to [MethodChannelNativeImage].
  static NativeImagePlatform get instance => _instance;

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [NativeImagePlatform] when they register themselves.
  static set instance(NativeImagePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }
}
