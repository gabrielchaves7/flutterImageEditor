// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_image_editor_example/main.dart';

void main() {
  testWidgets('Verify Platform version', (WidgetTester tester) async {
    ByteData bytes = await rootBundle.load('assets/naruto.jpg');
    final buffer = bytes.buffer;
    var image = buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
    // Build our app and trigger a frame.
    await tester.pumpWidget(WidgetEditableImage(
      imagem: image,
    ));

    // Verify that platform version is retrieved.
    expect(
      find.byWidgetPredicate(
        (Widget widget) =>
            widget is Text && widget.data.startsWith('Running on:'),
      ),
      findsOneWidget,
    );
  });
}
