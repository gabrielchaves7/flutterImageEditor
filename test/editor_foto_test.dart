import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:editor_foto/editor_foto.dart';

void main() {
  const MethodChannel channel = MethodChannel('editor_foto');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });
}
