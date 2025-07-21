// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myjudo_flutter/main.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:flutter/foundation.dart';

void main() {
  setUpAll(() {
    // Initialize SQLite FFI for tests only on desktop platforms
    if (kIsWeb == false) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }
  });

  testWidgets('MyJudo app builds without crashing',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyJudoApp());

    // Verify that the app loads without crashing
    expect(find.byType(MaterialApp), findsOneWidget);

    // Verify that the home screen is present (even if still loading)
    expect(find.byType(Scaffold), findsOneWidget);

    // Verify that the app bar is present
    expect(find.byType(AppBar), findsOneWidget);
  });
}
