import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:editor_foto/editor_foto.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async{
  await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);
  final directory = await getExternalStorageDirectory();
  runApp(WidgetEditableImage(imagem: File('${directory.path}/naruto.jpg'),));
}

class WidgetEditableImage extends StatefulWidget {
  final File imagem;

  WidgetEditableImage(
      {Key key,
        @required this.imagem,})
      : super(key: key);

  @override
  _WidgetEditableImage createState() => _WidgetEditableImage();
}

class _WidgetEditableImage extends State<WidgetEditableImage> {

  StreamController<Uint8List> _pictureStream;
  double _contrast;
  double _brithness;
  ByteData pictureByteData;
  Uint8List picture;

  @override
  void initState() {
    super.initState();
    _pictureStream = new StreamController<Uint8List>();
    _brithness = 0;
    _contrast = 1;
    Uint8List bytes = widget.imagem.readAsBytesSync() as Uint8List;
    pictureByteData = ByteData.view(bytes.buffer);
    picture = pictureByteData.buffer.asUint8List(pictureByteData.offsetInBytes, pictureByteData.lengthInBytes);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: containerEditableImage(_pictureStream, picture, _contrast, _brithness, setBrithness,
              setContrast, updatePicutre)
      ),
    );
  }


  void updatePicutre(double contrast, double brithness) async {
    var retorno = await PictureEditor.rotateImage(picture, 180);
    _pictureStream.add(retorno);
  }

  void setBrithness(double valor){
    setState(() {
      _brithness = valor;
    });
  }

  void setContrast(double valor){
    setState(() {
      _contrast = valor;
    });
  }
}

Widget containerEditableImage(StreamController picutreStream, Uint8List picture,
    double contrast, double brithness, Function setBrithness,
    Function setContrast, Function updatePicutre){
  var novaFoto = picture;
  return Center(
    child: Row(
      children: <Widget>[
        Column(
          children: <Widget>[
            Text(' Edição de imagem: '),
            Container(
                height: 300,
                width: 300,
                child: StreamBuilder(
                  stream: picutreStream.stream,
                  builder: (BuildContext context, snapshot) {
                    if(snapshot.connectionState == ConnectionState.active){
                      novaFoto = snapshot.data;
                      return Image.memory(snapshot.data, gaplessPlayback: true, fit: BoxFit.contain,);
                    } else{
                      return Image.memory(picture,  gaplessPlayback: true, fit: BoxFit.contain,);
                    }
                  },
                ),
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0)
            ),
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
                        updatePicutre(contrast, brithness);
                      },
                    ),
                    Text("Brilho"),
                    Slider(
                      label: 'Brilho',
                      min: -255,
                      max: 255,
                      value: brithness,
                      onChanged: (valor) {
                        setBrithness(valor);
                        updatePicutre(contrast, brithness);
                      },
                    )
                  ],
                )
              ],
            ),
            IconButton(
              color: Colors.black,
              icon: Icon(Icons.save),
              onPressed: () async {
                final directory = await getExternalStorageDirectory();
                PictureEditor.saveImage(novaFoto, '${directory.path}/naruto.jpg');
              },
            ),
          ],
        )
      ],
    ),
  );
}