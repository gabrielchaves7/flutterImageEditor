#import "FlutterImageEditorPlugin.h"

@implementation FlutterImageEditorPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"flutter_image_editor"
            binaryMessenger:[registrar messenger]];
  FlutterImageEditorPlugin* instance = [[FlutterImageEditorPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"aplicarBrilho" isEqualToString:call.method]) {
    var foto = call.argument("foto")
    var contraste = call.argument("contraste")
    var brilho = call.argument("brilho")
    NSData *imageData = [NSData dataWithBytes:foto length:length]
    UIImage *image = [UIImage imageWithData:imageData]
    result.success(changeBitmapContrastBrightness(image, brilho, contraste))
    //result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else if([@"rotacionarImagem" isEqualToString:call.method]){
    var degrees = call.argument("degrees")
    var foto = call.argument("foto")
    //result(FlutterMethodNotImplemented);
  } else {
    result.notImplemented();
  }
}

func changeBitmapContrastBrightness(imagem: UIImage, brightness: float, contrast: float) -> Byte[]{
    let aCGImage = image.cgImage
    aCIImage = CIImage(cgImage: aCGImage!)
    context = CIContext(options: nil)
    filtro = CIFilter(name: "CIColorControls")
    filtro.setValue(aCIImage, forKey: "inputImage")
    filtro.setValue(brightness, forKey: "inputBrightness")
    filtro.setValue(contrast, forKey: "inputContrast")

    outputImage = brightnessFilter.outputImage!
    let cgimg = context.createCGImage(outputImage, from: outputImage.extent)
    filteredImage = UIImage(cgImage: cgimg!)

    guard let retorno = filteredImage?.jpegData(compressionQuality: 1.0) else { return }   ;
}

@end
