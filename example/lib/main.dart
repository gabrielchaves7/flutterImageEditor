import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:flutter_image_editor/flutter_image_editor.dart';
import 'package:flutter/services.dart';

void main() async {
  ByteData bytes = await rootBundle.load('assets/naruto.jpg');
  final buffer = bytes.buffer;
  var image = buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);

  runApp(WidgetEditableImage(imagem: image));
}

class WidgetEditableImage extends StatefulWidget {
  final Uint8List imagem;

  WidgetEditableImage({
    Key key,
    @required this.imagem,
  }) : super(key: key);

  @override
  _WidgetEditableImage createState() => _WidgetEditableImage();
}

class _WidgetEditableImage extends State<WidgetEditableImage> {
  StreamController<Uint8List> _pictureStream;
  double _contrast;
  double _brightness;
  ByteData pictureByteData;
  Uint8List picture;

  @override
  void initState() {
    super.initState();
    _pictureStream = new StreamController<Uint8List>();
    _brightness = 0;
    _contrast = 1;
    pictureByteData = ByteData.view(widget.imagem.buffer);
    picture = pictureByteData.buffer.asUint8List(
        pictureByteData.offsetInBytes, pictureByteData.lengthInBytes);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: containerEditableImage(_pictureStream, picture, _contrast,
              _brightness, setBrightness, setContrast, updatePicutre)),
    );
  }

  void updatePicutre(double contrast, double brightness) async {
    var retorno = await PictureEditor.editImage(picture, contrast, brightness);
    _pictureStream.add(retorno);
  }

  void setBrightness(double valor) {
    setState(() {
      _brightness = valor;
    });
  }

  void setContrast(double valor) {
    setState(() {
      _contrast = valor;
    });
  }
}

Widget rotateImage(Uint8List picture, StreamController picutreStream) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    children: <Widget>[
      Text("If you want to rotate the image, use this on sccafold body"),
      Container(
          height: 300,
          width: 300,
          child: StreamBuilder(
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
          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0)),
      RaisedButton(
        onPressed: () async {
          var retorno = await PictureEditor.rotateImage(picture, 90);
           picutreStream.add(retorno);
        },
      )
    ],
  );
}

Widget containerEditableImage(
    StreamController picutreStream,
    Uint8List picture,
    double contrast,
    double brightness,
    Function setBrightness,
    Function setContrast,
    Function updatePicutre) {
  return Container(
    padding: EdgeInsets.only(top: 50),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text("If you want to change the brightness and contrast of the image, use this on the body of sccafold"),
        Container(
            height: 300,
            width: 300,
            child: StreamBuilder(
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
            padding:
            EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0)),
        Row(
          children: <Widget>[
            Column(
              children: <Widget>[
                Text("Contraste"),
                Slider(
                  label: 'Contraste',
                  min: 0,
                  max: 10,
                  value: contrast,
                  onChanged: (valor) {
                    setContrast(valor);
                    updatePicutre(contrast, brightness);
                  },
                ),
                Text("Brilho"),
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
