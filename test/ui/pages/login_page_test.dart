import 'package:clean_flutter_login_app/ui/pages/login/login_page.dart';
import 'package:clean_flutter_login_app/ui/pages/login/login_presenter.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockLoginPresenter extends Mock implements LoginPresenter {}

void main() {
  late LoginPresenter presenter;
  Future<void> loadPage(WidgetTester tester) async {
    presenter = MockLoginPresenter();
    final loginPage = MaterialApp(
      home: LoginPage(
        presenter: presenter,
      ),
    );
    await tester.pumpWidget(loginPage);
  }

  testWidgets(
    "Should load with correct initial state",
    (WidgetTester tester) async {
      await loadPage(tester);

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

  testWidgets(
    "Should call validate with correct values",
    (WidgetTester tester) async {
      await loadPage(tester);

      final email = faker.internet.email();
      await tester.enterText(find.bySemanticsLabel('Email'), email);
      verify(() => presenter.validateEmail(email));

      final password = faker.internet.password();
      await tester.enterText(find.bySemanticsLabel('Senha'), password);
      verify(() => presenter.validatePassword(password));
    },
  );
}
