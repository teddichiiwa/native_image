import Flutter
import UIKit

public class SwiftNativeImagePlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "com.teddichiiwa/native_image", binaryMessenger: registrar.messenger())
    let instance = SwiftNativeImagePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
      switch call.method {
      case "cropImage":
          if let arguments = call.arguments as? [String: Any?] {
              if let bytes = arguments["bytes"] as? FlutterStandardTypedData,
                 let width = arguments["width"] as? Double,
                 let height = arguments["height"] as? Double {
                result(cropImage(withData: bytes, cropWidth: width, cropHeight: height))
              }
          }
      default:
            result(FlutterMethodNotImplemented)
      }
  }
    
    private func cropImage(withData data: FlutterStandardTypedData, cropWidth: CGFloat, cropHeight: CGFloat) -> FlutterStandardTypedData? {
        if let contextImage: UIImage = UIImage(data: data.data) {
            let contextSize: CGSize = contextImage.size
            var cropX: CGFloat = 0.0
            var cropY: CGFloat = 0.0
            let cropRatio: CGFloat = CGFloat(cropWidth / cropHeight)
            let originalRatio: CGFloat = contextSize.width / contextSize.height
            var scaledCropHeight: CGFloat = 0.0
            var scaledCropWidth: CGFloat = 0.0

            // See what size is longer and set crop rect parameters
            if originalRatio > cropRatio {
                scaledCropHeight = contextSize.height
                scaledCropWidth = (contextSize.height / cropHeight) * cropWidth
                cropX = (contextSize.width - scaledCropWidth) / 2
                cropY = 0
            } else {
                scaledCropWidth = contextSize.width
                scaledCropHeight = (contextSize.width / cropWidth) * cropHeight
                cropY = (contextSize.height - scaledCropHeight) / 2
                cropX = 0
            }

            let rect: CGRect = CGRect(x: cropX, y: cropY, width: scaledCropWidth, height: scaledCropHeight)

            // Create bitmap image from context using the rect
            //
            // Create a new image based on the imageRef and rotate back to the original orientation
            if let imageRef: CGImage = contextImage.cgImage?.cropping(to: rect),
               let croppedImageData: Data = UIImage(cgImage: imageRef).pngData() {
                return FlutterStandardTypedData(bytes: croppedImageData)
            }
        }

        return nil
    }
}
