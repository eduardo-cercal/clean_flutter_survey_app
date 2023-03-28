import 'dart:async';

import 'package:clean_flutter_login_app/ui/helpers/errors/ui_error.dart';
import 'package:clean_flutter_login_app/ui/pages/signup/signup_page.dart';
import 'package:clean_flutter_login_app/ui/pages/signup/signup_presenter.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';

class MockSignUpPresenter extends Mock implements SignUpPresenter {}

void main() {
  late SignUpPresenter presenter;
  late StreamController<UiError?> nameErrorController;
  late StreamController<UiError?> emailErrorController;
  late StreamController<UiError?> passwordErrorController;
  late StreamController<UiError?> passwordConfirmationErrorController;
  late StreamController<UiError?> mainErrorController;
  late StreamController<String?> navigateToController;
  late StreamController<bool> isFormValidController;
  late StreamController<bool> isLoadingController;

  void initStreams() {
    nameErrorController = StreamController<UiError?>();
    emailErrorController = StreamController<UiError?>();
    passwordErrorController = StreamController<UiError?>();
    passwordConfirmationErrorController = StreamController<UiError?>();
    isFormValidController = StreamController<bool>();
    isLoadingController = StreamController<bool>();
    mainErrorController = StreamController<UiError?>();
    navigateToController = StreamController<String?>();
  }

  void mockStreams() {
    when(() => presenter.nameErrorStream)
        .thenAnswer((_) => nameErrorController.stream);
    when(() => presenter.emailErrorStream)
        .thenAnswer((_) => emailErrorController.stream);
    when(() => presenter.passwordErrorStream)
        .thenAnswer((_) => passwordErrorController.stream);
    when(() => presenter.passwordConfirmationErrorStream)
        .thenAnswer((_) => passwordConfirmationErrorController.stream);
    when(() => presenter.isFormValidStream)
        .thenAnswer((_) => isFormValidController.stream);
    when(() => presenter.isLoadingStream)
        .thenAnswer((_) => isLoadingController.stream);
    when(() => presenter.mainErrorStream)
        .thenAnswer((_) => mainErrorController.stream);
    when(() => presenter.navigateToStream)
        .thenAnswer((_) => navigateToController.stream);
  }

  void closeStreams() {
    nameErrorController.close();
    emailErrorController.close();
    passwordErrorController.close();
    passwordConfirmationErrorController.close();
    isFormValidController.close();
    isLoadingController.close();
    mainErrorController.close();
    navigateToController.close();
  }

  Future<void> loadPage(WidgetTester tester) async {
    presenter = MockSignUpPresenter();

    initStreams();

    mockStreams();

    final signUpPage = GetMaterialApp(
      initialRoute: '/signup',
      getPages: [
        GetPage(
          name: '/signup',
          page: () => SignUpPage(
            presenter: presenter,
          ),
        ),
        GetPage(
          name: '/any_route',
          page: () => const Scaffold(
            body: Text('fake page'),
          ),
        ),
      ],
    );
    await tester.pumpWidget(signUpPage);
  }

  tearDown(() {
    closeStreams();
  });

  testWidgets(
    "Should load with correct initial state",
    (WidgetTester tester) async {
      await loadPage(tester);

      final nameTextChilfren = find.descendant(
          of: find.bySemanticsLabel('Nome'), matching: find.byType(Text));
      expect(nameTextChilfren, findsOneWidget);

      final emailTextChilfren = find.descendant(
          of: find.bySemanticsLabel('Email'), matching: find.byType(Text));
      expect(emailTextChilfren, findsOneWidget);

      final passwordTextChilfren = find.descendant(
          of: find.bySemanticsLabel('Senha'), matching: find.byType(Text));
      expect(passwordTextChilfren, findsOneWidget);

      final passwordConfirmationTextChilfren = find.descendant(
          of: find.bySemanticsLabel('Confirmar senha'),
          matching: find.byType(Text));
      expect(passwordConfirmationTextChilfren, findsOneWidget);

      final buttom = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(buttom.onPressed, null);

      expect(find.byType(CircularProgressIndicator), findsNothing);
    },
  );

  testWidgets(
    "Should call validate with correct values",
    (WidgetTester tester) async {
      await loadPage(tester);

      final name = faker.person.name();
      await tester.enterText(find.bySemanticsLabel('Nome'), name);
      verify(() => presenter.validateName(name));

      final email = faker.internet.email();
      await tester.enterText(find.bySemanticsLabel('Email'), email);
      verify(() => presenter.validateEmail(email));

      final password = faker.internet.password();
      await tester.enterText(find.bySemanticsLabel('Senha'), password);
      verify(() => presenter.validatePassword(password));

      await tester.enterText(
          find.bySemanticsLabel('Confirmar senha'), password);
      verify(() => presenter.validatePasswordConfirmation(password));
    },
  );

  testWidgets(
    "Should present name error if name is invalid",
    (WidgetTester tester) async {
      await loadPage(tester);

      nameErrorController.add(UiError.invalidField);
      await tester.pump();
      expect(find.text('Campo invalido'), findsOneWidget);

      nameErrorController.add(UiError.requiredField);
      await tester.pump();
      expect(find.text('Campo obrigatorio'), findsOneWidget);
    },
  );

  testWidgets(
    "Should present no error if name is valid",
    (WidgetTester tester) async {
      await loadPage(tester);

      nameErrorController.add(null);
      await tester.pump();

      final emailTextChilfren = find.descendant(
          of: find.bySemanticsLabel('Nome'), matching: find.byType(Text));

      expect(emailTextChilfren, findsOneWidget);
    },
  );

  testWidgets(
    "Should present error if email is invalid",
    (WidgetTester tester) async {
      await loadPage(tester);

      emailErrorController.add(UiError.invalidField);
      await tester.pump();
      expect(find.text('Campo invalido'), findsOneWidget);

      emailErrorController.add(UiError.requiredField);
      await tester.pump();
      expect(find.text('Campo obrigatorio'), findsOneWidget);
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
    "Should present error if password is empty",
    (WidgetTester tester) async {
      await loadPage(tester);

      passwordErrorController.add(UiError.requiredField);
      await tester.pump();

      expect(find.text('Campo obrigatorio'), findsOneWidget);
    },
  );

  testWidgets(
    "Should present no error if password confimation is valid",
    (WidgetTester tester) async {
      await loadPage(tester);

      passwordConfirmationErrorController.add(null);
      await tester.pump();

      final passwordConfimationTextChilfren = find.descendant(
          of: find.bySemanticsLabel('Confirmar senha'),
          matching: find.byType(Text));

      expect(passwordConfimationTextChilfren, findsOneWidget);
    },
  );

  testWidgets(
    "Should present error if password confirmation is empty",
    (WidgetTester tester) async {
      await loadPage(tester);

      passwordConfirmationErrorController.add(UiError.requiredField);
      await tester.pump();

      expect(find.text('Campo obrigatorio'), findsOneWidget);
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
    "Should call signup on form submit",
    (WidgetTester tester) async {
      await loadPage(tester);

      final buttom = find.byType(ElevatedButton);

      when(() => presenter.signUp()).thenAnswer((_) async {});

      isFormValidController.add(true);
      await tester.pump();
      await tester.ensureVisible(buttom);
      await tester.tap(buttom);
      await tester.pump();

      verify(() => presenter.signUp()).called(1);
    },
  );

  testWidgets(
    "Should present loading",
    (WidgetTester tester) async {
      await loadPage(tester);

      isLoadingController.add(true);
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    },
  );

  testWidgets(
    "Should hide loading",
    (WidgetTester tester) async {
      await loadPage(tester);

      isLoadingController.add(true);
      await tester.pump();
      isLoadingController.add(false);
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsNothing);
    },
  );

  testWidgets(
    "Should present error message if signup fails",
    (WidgetTester tester) async {
      await loadPage(tester);

      mainErrorController.add(UiError.emailInUse);
      await tester.pump();

      expect(find.text('Email em uso'), findsOneWidget);
    },
  );

  testWidgets(
    "Should present error message if signup throws",
    (WidgetTester tester) async {
      await loadPage(tester);

      mainErrorController.add(UiError.unexpected);
      await tester.pump();

      expect(find.text('Algo inesperado aconteceu. Tente novamente em breve'),
          findsOneWidget);
    },
  );

  testWidgets(
    "Should change page",
    (WidgetTester tester) async {
      await loadPage(tester);

      navigateToController.add('any_route');
      await tester.pumpAndSettle();

      expect(Get.currentRoute, 'any_route');
      expect(find.text('fake page'), findsOneWidget);
    },
  );

  testWidgets(
    "Should call goToLogin on link click",
    (WidgetTester tester) async {
      await loadPage(tester);
      when(() => presenter.signUp()).thenAnswer((_) async {});

      final buttom = find.text('Login');
      await tester.pump();
      await tester.ensureVisible(buttom);
      await tester.tap(buttom);
      await tester.pump();

      verify(() => presenter.goToLogin()).called(1);
    },
  );
}
