// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pet_app/app.dart';

void main() {
  testWidgets('Pet App basic smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const PetApp());

    // Verify that the app bar shows the title.
    expect(find.text('Mis Mascotas'), findsOneWidget);

    // Verify that sample pets are displayed.
    expect(find.text('Max'), findsOneWidget);
    expect(find.text('Luna'), findsOneWidget);
    expect(find.text('Coco'), findsOneWidget);

    // Verify that the add button exists.
    expect(find.byIcon(Icons.add), findsOneWidget);
  });

  testWidgets('Add pet button opens dialog', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const PetApp());

    // Tap the '+' icon to open the add pet dialog.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    // Verify that the dialog is displayed.
    expect(find.text('Agregar Mascota'), findsOneWidget);
    expect(find.text('Nombre'), findsOneWidget);
  });
}
