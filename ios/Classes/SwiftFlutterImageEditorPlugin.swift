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
        let argsMap = call.arguments as! NSDictionary
        let foto:FlutterStandardTypedData = argsMap.value(forKey: "foto") as! FlutterStandardTypedData
        let brilho:Double = argsMap.value(forKey: "brilho") as! Double
        let contraste:Double = argsMap.value(forKey: "contraste") as! Double        
        let image = UIImage(data: foto.data)!

        result(self.changeBitmapContrastBrightness(imagem: image, brightness: brilho, contrast: contraste))

    } else if(call.method == "rotacionarImagem"){
      result("erro")
    } else {
      result("erro")
    }    
  }

  private func changeBitmapContrastBrightness(imagem: UIImage, brightness: Double, contrast: Double) -> FlutterStandardTypedData{
    let inputImage = CIImage(image: imagem)!
    let parameters = [
        "inputBrightness": NSNumber(value: brightness),
        "inputContrast": NSNumber(value: contrast)
    ]
    let outputImage = inputImage.applyingFilter("CIColorControls", parameters: parameters)

    let context = CIContext(options: nil)
    let img = context.createCGImage(outputImage, from: outputImage.extent)!
    let uimg = UIImage(cgImage: img)
    
    return FlutterStandardTypedData.init(bytes: uimg.jpegData(compressionQuality: 1)!)

  }
}
