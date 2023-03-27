// ignore_for_file: depend_on_referenced_packages

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_editor/flutter_image_editor.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final bytes = await rootBundle.load('assets/naruto.jpg');
  final buffer = bytes.buffer;
  final image = buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);

  runApp(WidgetEditableImage(imagem: image));
}

/// This widget is an example of how to use the plugin.
class WidgetEditableImage extends StatefulWidget {
  ///
  const WidgetEditableImage({
    @required this.imagem,
    Key key,
  }) : super(key: key);

  /// Image as a byte array to be edited
  final Uint8List imagem;

  @override
  WidgetEditableImageState createState() => WidgetEditableImageState();
}

///
class WidgetEditableImageState extends State<WidgetEditableImage> {
  StreamController<Uint8List> _pictureStream;
  double _contrast;
  double _brightness;
  ByteData _pictureByteData;
  Uint8List _picture;

  @override
  void initState() {
    super.initState();
    _pictureStream = StreamController<Uint8List>();
    _brightness = 0;
    _contrast = 1;
    _pictureByteData = ByteData.view(widget.imagem.buffer);
    _picture = _pictureByteData.buffer.asUint8List(
      _pictureByteData.offsetInBytes,
      _pictureByteData.lengthInBytes,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: _containerEditableImage(
          _pictureStream,
          _picture,
          _contrast,
          _brightness,
          _setBrightness,
          _setContrast,
          _updatePicutre,
        ),
      ),
    );
  }

  Future<void> _updatePicutre(double contrast, double brightness) async {
    final retorno =
        await PictureEditor.editImage(_picture, contrast, brightness);
    _pictureStream.add(retorno as Uint8List);
  }

  void _setBrightness(double valor) {
    setState(() {
      _brightness = valor;
    });
  }

  void _setContrast(double valor) {
    setState(() {
      _contrast = valor;
    });
  }
}

// Widget _rotateImage(
//   Uint8List picture,
//   StreamController<Uint8List> picutreStream,
// ) {
//   return Column(
//     children: <Widget>[
//       const Text('If you want to rotate the
// image, use this on sccafold body'),
//       Container(
//         height: 300,
//         width: 300,
//         padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
//         child: StreamBuilder<Uint8List>(
//           stream: picutreStream.stream,
//           builder: (BuildContext context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.active) {
//               return Image.memory(
//                 snapshot.data,
//                 gaplessPlayback: true,
//                 fit: BoxFit.contain,
//               );
//             } else {
//               return Image.memory(
//                 picture,
//                 gaplessPlayback: true,
//                 fit: BoxFit.contain,
//               );
//             }
//           },
//         ),
//       ),
//       OutlinedButton(
//         onPressed: () async {
//           final retorno = await PictureEditor.rotateImage(picture, 90);
//           picutreStream.add(retorno as Uint8List);
//         },
//         child: const Text('Button'),
//       )
//     ],
//   );
// }

Widget _containerEditableImage(
  StreamController<Uint8List> picutreStream,
  Uint8List picture,
  double contrast,
  double brightness,
  void Function(double brightness) setBrightness,
  void Function(double contrast) setContrast,
  void Function(double brightness, double contrast) updatePicutre,
) {
  return Container(
    padding: const EdgeInsets.only(top: 50),
    child: Column(
      children: <Widget>[
        const Text(
          '''
If you want to change the brightness and contrast of the image, use this on the body of sccafold''',
        ),
        Container(
          height: 300,
          width: 300,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: StreamBuilder<Uint8List>(
            stream: picutreStream.stream,
            builder: (BuildContext context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                return Image.memory(
                  snapshot.data,
                  gaplessPlayback: true,
                  fit: BoxFit.contain,
                );
              } else {
                return Image.memory(
                  picture,
                  gaplessPlayback: true,
                  fit: BoxFit.contain,
                );
              }
            },
          ),
        ),
        Row(
          children: <Widget>[
            Column(
              children: <Widget>[
                const Text('Contraste'),
                Slider(
                  label: 'Contraste',
                  max: 10,
                  value: contrast,
                  onChanged: (valor) {
                    setContrast(valor);
                    updatePicutre(contrast, brightness);
                  },
                ),
                const Text('Brilho'),
                Slider(
                  label: 'Brilho',
                  min: -255,
                  max: 255,
                  value: brightness,
                  onChanged: (valor) {
                    setBrightness(valor);
                    updatePicutre(contrast, brightness);
                  },
                )
              ],
            )
          ],
        ),
      ],
    ),
  );
}
