import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/services.dart';

class PictureEditor {
  static const MethodChannel _channel =
      const MethodChannel('editor_foto');

  static Future<List<int>> editImage(Uint8List fotoInput, double contraste, double brilho) async {
    final Uint8List foto = await _channel.invokeMethod('aplicarBrilho', <String, dynamic>{
      'foto': fotoInput,
      'contraste': contraste,
      'brilho' : brilho
    });
    return foto;
  }
}
