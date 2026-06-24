import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:imposter_kerala_edition/main.dart';

void main() {
  testWidgets('App launches correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const ImposterApp());
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
