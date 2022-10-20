package com.teddichiiwa.native_image

import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.util.Log
import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.io.ByteArrayOutputStream
import java.io.IOException
import java.nio.ByteBuffer

/** NativeImagePlugin */
class NativeImagePlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "com.teddichiiwa/native_image")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    if (call.method == "cropImage") {
      val contextImage = BitmapFactory.decodeByteArray(
        call.argument("bytes"),
        0,
        call.argument("length")!!
      )
      val cropWidth: Double = call.argument("width") ?: 0.0
      val cropHeight: Double = call.argument("height") ?: 0.0

      var cropX = 0.0
      var cropY = 0.0
      val cropRatio: Double = cropWidth / cropHeight
      val originalRatio: Double = contextImage.width.toDouble() / contextImage.height.toDouble()
      var scaledCropHeight = 0.0
      var scaledCropWidth = 0.0

      // See what size is longer and set crop rect parameters
      if (originalRatio > cropRatio) {
        scaledCropHeight = contextImage.height.toDouble()
        scaledCropWidth = (contextImage.height / cropHeight) * cropWidth
        cropX = (contextImage.width - scaledCropWidth) / 2
        cropY = 0.0
      } else {
        scaledCropWidth = contextImage.width.toDouble()
        scaledCropHeight = (contextImage.width / cropWidth) * cropHeight
        cropY = (contextImage.height - scaledCropHeight) / 2
        cropX = 0.0
      }

      val imageRef = Bitmap.createBitmap(contextImage, cropX.toInt(), cropY.toInt(), scaledCropWidth.toInt(), scaledCropHeight.toInt())
      val croppedImageData = convertBitmapToByteArray(imageRef)
      result.success(croppedImageData)
    } else {
      result.notImplemented()
    }
  }

  private fun convertBitmapToByteArray(bitmap: Bitmap): ByteArray? {
    var byteArrayOutputStream: ByteArrayOutputStream? = null
    return try {
      byteArrayOutputStream = ByteArrayOutputStream()
      bitmap.compress(Bitmap.CompressFormat.PNG, 100, byteArrayOutputStream)
      byteArrayOutputStream.toByteArray()
    } finally {
      if (byteArrayOutputStream != null) {
        try {
          byteArrayOutputStream.close()
        } catch (e: IOException) {
          Log.e("NativeImagePlugin", "ByteArrayOutputStream was not closed")
        }
      }
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
