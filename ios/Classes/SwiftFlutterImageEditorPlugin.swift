import Flutter
import UIKit

public class SwiftFlutterImageEditorPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_image_editor", binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterImageEditorPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if(call.method == "aplicarBrilho"){

      guard let args = call.arguments else {
        return
      }
      if let myArgs = args as? [String: Any],
         let foto = myArgs["foto"] as? Float,
         let brilho = myArgs["brilho"] as? Float ,
         let contraste = myArgs["contraste"] as? Float {
          let data = NSData.FromArray (foto)
          let uiimage = UIImage.LoadFromData (data)
          result.success(changeBitmapContrastBrightness(result, uiimage, brilho, contraste))
      } else {
        result("iOS could not extract flutter arguments in method: (aplicarBrilho)")
      }       
    } else if(call.method == "rotacionarImagem"){
      result("erro")
    } else {
      result("erro")
    }    
  }

  private func changeBitmapContrastBrightness(result: FlutterResult, imagem: UIImage, brightness: Float, contrast: Float) {
    let inputImage = CIImage(image: imagem)!
    let parameters = [
        "inputBrightness": NSNumber(value: brightness),
        "inputContrast": NSNumber(value: contrast)
    ]
    let outputImage = inputImage.applyingFilter("CIColorControls", parameters: parameters)

    let context = CIContext(options: nil)
    let img = context.createCGImage(outputImage, from: outputImage.extent)!
    result(UIImage(cgImage: img).jpegData(compressionQuality: 1.0)) 
  }
}
