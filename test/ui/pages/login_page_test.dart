import 'package:clean_flutter_login_app/ui/pages/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    "Should load with correct initial state",
    (WidgetTester tester) async {
      const loginPage = MaterialApp(
        home: LoginPage(),
      );
      await tester.pumpWidget(loginPage);

      final emailTextChilfren = find.descendant(
          of: find.bySemanticsLabel('Email'), matching: find.byType(Text));

      expect(emailTextChilfren, findsOneWidget);

      final passwordTextChilfren = find.descendant(
          of: find.bySemanticsLabel('Senha'), matching: find.byType(Text));

      expect(passwordTextChilfren, findsOneWidget);

      final buttom = tester.widget<ElevatedButton>(find.byType(ElevatedButton));

      expect(buttom.onPressed, null);
    },
  );
}
