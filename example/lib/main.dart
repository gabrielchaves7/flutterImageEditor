import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:editor_foto/editor_foto.dart';
import 'package:flutter/services.dart';

void main() => runApp(Teste());

class Teste extends StatefulWidget {
  final Image imagem;

  Teste(
      {Key key,
        @required this.imagem,})
      : super(key: key);

  @override
  _Teste createState() => _Teste();
}

class _Teste extends State<Teste> {

  StreamController<Uint8List> _fotoWdg;
  double _contraste;
  double _brilho;
  Image imageTeste;

  @override
  void initState() {
    super.initState();
    initPlatformState();
    obterImagem();
  }

  Future<void> initPlatformState() async {
    _fotoWdg = new StreamController<Uint8List>();
    _brilho = 0;
    _contraste = 1;
  }

  void obterImagem() async{
    imageTeste = Image.asset('foto/naruto.jpg');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Plugin example app'),
          ),
          body: imagemEditavel(_fotoWdg, imageTeste, _contraste, _brilho, setarBrilho,
              setarContraste, enviarFoto)
      ),
    );
  }


  void enviarFoto(double contraste, double brilho) async {
    ByteData image = await rootBundle.load('foto/naruto.jpg');
    Uint8List foto = image.buffer.asUint8List(image.offsetInBytes, image.lengthInBytes);
    var retorno = await EditorFoto.aplicarBrilho(foto, contraste, brilho);
    _fotoWdg.add(retorno);
  }

  void setarBrilho(double valor){
    setState(() {
      _brilho = valor;
    });
  }

  void setarContraste(double valor){
    setState(() {
      _contraste = valor;
    });
  }
}

Widget imagemEditavel(StreamController imagemController, Image imagem,
    double contraste, double brilho, Function setarBrilho,
    Function setarContraste, Function enviarFoto){
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
                  stream: imagemController.stream,
                  builder: (BuildContext context, snapshot) {
                    if(snapshot.connectionState == ConnectionState.active){
                      return Image.memory(snapshot.data, gaplessPlayback: true, fit: BoxFit.contain,);
                    } else{
                      return Image(image: imagem.image,  gaplessPlayback: true, fit: BoxFit.contain,);
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
                      value: contraste,
                      onChanged: (valor) {
                        setarContraste(valor);
                        /*setState(() {
                          this._contraste = valor;
                        });*/
                        enviarFoto(contraste, brilho);
                      },
                    ),
                    Text("Brilho"),
                    Slider(
                      label: 'Brilho',
                      min: -255,
                      max: 255,
                      value: brilho,
                      onChanged: (valor) {
                        setarBrilho(valor);
                        /*setState(() {
                          this._brilho = valor;
                        });*/
                        enviarFoto(contraste, brilho);
                      },
                    )
                  ],
                )
              ],
            ),
          ],
        )
      ],
    ),
  );
}