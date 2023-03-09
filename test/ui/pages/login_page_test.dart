import 'dart:async';

import 'package:clean_flutter_login_app/ui/pages/login/login_page.dart';
import 'package:clean_flutter_login_app/ui/pages/login/login_presenter.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockLoginPresenter extends Mock implements LoginPresenter {}

void main() {
  late LoginPresenter presenter;
  late StreamController<String?> emailErrorController;
  late StreamController<String?> passwordErrorController;
  late StreamController<bool> isFormValidController;

  Future<void> loadPage(WidgetTester tester) async {
    presenter = MockLoginPresenter();
    emailErrorController = StreamController<String?>();
    passwordErrorController = StreamController<String?>();
    isFormValidController = StreamController<bool>();

    when(() => presenter.emailErrorStream)
        .thenAnswer((_) => emailErrorController.stream);
    when(() => presenter.passwordErrorStream)
        .thenAnswer((_) => passwordErrorController.stream);
    when(() => presenter.formValidStream)
        .thenAnswer((_) => isFormValidController.stream);

    final loginPage = MaterialApp(
      home: LoginPage(
        presenter: presenter,
      ),
    );
    await tester.pumpWidget(loginPage);
  }

  tearDown(() {
    emailErrorController.close();
    passwordErrorController.close();
    isFormValidController.close();
  });

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

  testWidgets(
    "Should present error if email is invalid",
    (WidgetTester tester) async {
      await loadPage(tester);

      emailErrorController.add('any error');
      await tester.pump();

      expect(find.text('any error'), findsOneWidget);
    },
  );

  testWidgets(
    "Should present no error if email is valid",
    (WidgetTester tester) async {
      await loadPage(tester);

      emailErrorController.add(null);
      await tester.pump();

      final emailTextChilfren = find.descendant(
          of: find.bySemanticsLabel('Email'), matching: find.byType(Text));

      expect(emailTextChilfren, findsOneWidget);
    },
  );

  testWidgets(
    "Should present no error if email is valid",
    (WidgetTester tester) async {
      await loadPage(tester);

      emailErrorController.add('');
      await tester.pump();

      final emailTextChilfren = find.descendant(
          of: find.bySemanticsLabel('Email'), matching: find.byType(Text));

      expect(emailTextChilfren, findsOneWidget);
    },
  );

  testWidgets(
    "Should present error if password is invalid",
    (WidgetTester tester) async {
      await loadPage(tester);

      passwordErrorController.add('any error');
      await tester.pump();

      expect(find.text('any error'), findsOneWidget);
    },
  );

  testWidgets(
    "Should present no error if password is valid",
    (WidgetTester tester) async {
      await loadPage(tester);

      passwordErrorController.add(null);
      await tester.pump();

      final passwordTextChilfren = find.descendant(
          of: find.bySemanticsLabel('Senha'), matching: find.byType(Text));

      expect(passwordTextChilfren, findsOneWidget);
    },
  );

  testWidgets(
    "Should present no error if password is valid",
    (WidgetTester tester) async {
      await loadPage(tester);

      passwordErrorController.add('');
      await tester.pump();

      final passwordTextChilfren = find.descendant(
          of: find.bySemanticsLabel('Senha'), matching: find.byType(Text));

      expect(passwordTextChilfren, findsOneWidget);
    },
  );

  testWidgets(
    "Should enable buttom if form is valid",
    (WidgetTester tester) async {
      await loadPage(tester);

      isFormValidController.add(true);
      await tester.pump();

      final buttom = tester.widget<ElevatedButton>(find.byType(ElevatedButton));

      expect(buttom.onPressed, isNotNull);
    },
  );

  testWidgets(
    "Should disable buttom if form is invalid",
    (WidgetTester tester) async {
      await loadPage(tester);

      isFormValidController.add(false);
      await tester.pump();

      final buttom = tester.widget<ElevatedButton>(find.byType(ElevatedButton));

      expect(buttom.onPressed, null);
    },
  );

  testWidgets(
    "Should call authentication on form submit",
    (WidgetTester tester) async {
      await loadPage(tester);

      isFormValidController.add(true);
      await tester.pump();
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      verify(() => presenter.auth()).called(1);
    },
  );
}
