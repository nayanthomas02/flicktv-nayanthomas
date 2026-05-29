import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flicktv/main.dart';

void main() {
  testWidgets('FlickTV smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const FlickTvApp());
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
