import 'dart:async';

import 'package:clean_flutter_login_app/ui/helpers/errors/ui_error.dart';
import 'package:clean_flutter_login_app/ui/pages/surveys/survey_viewmodel.dart';
import 'package:clean_flutter_login_app/ui/pages/surveys/surveys_page.dart';
import 'package:clean_flutter_login_app/ui/pages/surveys/surveys_presenter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/fake_surveys_factory.dart';
import '../helpers/helpers.dart';

class MockSurveysPresenter extends Mock implements SurveysPresenter {}

void main() {
  late SurveysPresenter presenter;
  late StreamController<bool> isLoadingController;
  late StreamController<List<SurveyViewModel>> loadSurveysController;
  late StreamController<String?> navigateToController;
  late StreamController<bool?> isSessionExpiredController;

  void initStreams() {
    isLoadingController = StreamController<bool>();
    loadSurveysController = StreamController<List<SurveyViewModel>>();
    navigateToController = StreamController<String?>();
    isSessionExpiredController = StreamController<bool?>();
  }

  void mockStreams() {
    when(() => presenter.isLoadingStream)
        .thenAnswer((_) => isLoadingController.stream);
    when(() => presenter.surveysStream)
        .thenAnswer((_) => loadSurveysController.stream);
    when(() => presenter.navigateToStream)
        .thenAnswer((_) => navigateToController.stream);
    when(() => presenter.isSessionExpiredStream)
        .thenAnswer((_) => isSessionExpiredController.stream);
  }

  void closeStreams() {
    isLoadingController.close();
    loadSurveysController.close();
    navigateToController.close();
    isSessionExpiredController.close();
  }

  void mockPresenter() {
    when(() => presenter.loadData()).thenAnswer((_) async {});
  }

  Future<void> loadPage(WidgetTester tester) async {
    presenter = MockSurveysPresenter();

    initStreams();

    mockStreams();

    mockPresenter();

    await tester.pumpWidget(
      makePage(
        path: '/surveys',
        page: () => SurveysPage(
          presenter: presenter,
        ),
      ),
    );
  }

  tearDown(() {
    closeStreams();
  });

  testWidgets('should call LoadSuveys on page load', (tester) async {
    await loadPage(tester);

    verify(() => presenter.loadData()).called(1);
  });

  testWidgets('should call LoadSuveys on page reload', (tester) async {
    await loadPage(tester);
    navigateToController.add('/any_route');
    await tester.pumpAndSettle();
    await tester.pageBack();

    verify(() => presenter.loadData()).called(2);
  });

  testWidgets(
    "Should handle loading correctly",
    (WidgetTester tester) async {
      await loadPage(tester);

      isLoadingController.add(true);
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      isLoadingController.add(false);
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsNothing);
    },
  );

  testWidgets('should present error if surveysStream fails', (tester) async {
    await loadPage(tester);

    loadSurveysController.addError(UiError.unexpected.description);
    await tester.pump();
    expect(find.text('Algo inesperado aconteceu. Tente novamente em breve'),
        findsOneWidget);
    expect(find.text('Recarregar'), findsOneWidget);
    expect(find.text('Question 1'), findsNothing);
  });

  testWidgets('should present list if surveysStream succeeds', (tester) async {
    await loadPage(tester);

    loadSurveysController.add(FakeSurveysFactory.makeViewModel());
    await tester.pump();
    expect(find.text('Algo inesperado aconteceu. Tente novamente em breve'),
        findsNothing);
    expect(find.text('Recarregar'), findsNothing);
    expect(find.text('Question 1'), findsWidgets);
    expect(find.text('Question 2'), findsWidgets);
    expect(find.text('Date 1'), findsWidgets);
    expect(find.text('Date 2'), findsWidgets);
  });

  testWidgets('should call LoadSuveys on realod buttom click', (tester) async {
    await loadPage(tester);

    loadSurveysController.addError(UiError.unexpected.description);
    await tester.pump();
    await tester.tap(find.text('Recarregar'));

    verify(() => presenter.loadData()).called(2);
  });

  testWidgets(
    "Should call goToSurveyResult on survey click",
    (WidgetTester tester) async {
      await loadPage(tester);
      loadSurveysController.add(FakeSurveysFactory.makeViewModel());
      await tester.pump();

      await tester.tap(find.text('Question 1'));
      await tester.pump();

      verify(() => presenter.goToSurveyResult('1')).called(1);
    },
  );

  testWidgets(
    "Should change page",
    (WidgetTester tester) async {
      await loadPage(tester);

      navigateToController.add('any_route');
      await tester.pumpAndSettle();

      expect(currentRoute, 'any_route');
      expect(find.text('fake page'), findsOneWidget);
    },
  );

  testWidgets(
    "Should logout",
    (WidgetTester tester) async {
      await loadPage(tester);

      isSessionExpiredController.add(true);
      await tester.pumpAndSettle();

      expect(currentRoute, '/login');
      expect(find.text('fake login'), findsOneWidget);
    },
  );

  testWidgets(
    "Should not logout",
    (WidgetTester tester) async {
      await loadPage(tester);

      isSessionExpiredController.add(false);
      await tester.pumpAndSettle();
      expect(currentRoute, '/surveys');

      isSessionExpiredController.add(null);
      await tester.pumpAndSettle();
      expect(currentRoute, '/surveys');
    },
  );
}
