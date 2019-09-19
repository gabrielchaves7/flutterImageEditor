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

        result(self.changeUimageContrastBrightness(imagem: image, brightness: brilho, contrast: contraste))

    } else if(call.method == "rotacionarImagem"){
        let argsMap = call.arguments as! NSDictionary
        let foto:FlutterStandardTypedData = argsMap.value(forKey: "foto") as! FlutterStandardTypedData
        let degrees:Float = argsMap.value(forKey: "degrees") as! Float
        let image = UIImage(data: foto.data)!
    
        result(self.rotateBitmap(imagem: image, degrees: degrees))
    } else {
      result("erro")
    }    
  }

    private func changeUimageContrastBrightness(imagem: UIImage, brightness: Double, contrast: Double) -> FlutterStandardTypedData{
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
    
    private func rotateBitmap(imagem: UIImage, degrees: Float) -> FlutterStandardTypedData{
        let radianos = ((degrees * 3.14) / 180)
        let uimg = imagem.rotate(radians: radianos)!
        return FlutterStandardTypedData.init(bytes: uimg.jpegData(compressionQuality: 1)!)
    }
}

extension UIImage {
    func rotate(radians: Float) -> UIImage? {
        var newSize = CGRect(origin: CGPoint.zero, size: self.size).applying(CGAffineTransform(rotationAngle: CGFloat(radians))).size
        // Trim off the extremely small float value to prevent core graphics from rounding it up
        newSize.width = floor(newSize.width)
        newSize.height = floor(newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
        let context = UIGraphicsGetCurrentContext()!
        
        // Move origin to middle
        context.translateBy(x: newSize.width/2, y: newSize.height/2)
        // Rotate around middle
        context.rotate(by: CGFloat(radians))
        // Draw the image at its center
        self.draw(in: CGRect(x: -self.size.width/2, y: -self.size.height/2, width: self.size.width, height: self.size.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
