import 'dart:async';

import 'package:clean_flutter_login_app/ui/helpers/errors/ui_error.dart';
import 'package:clean_flutter_login_app/ui/pages/surveys/survey_viewmodel.dart';
import 'package:clean_flutter_login_app/ui/pages/surveys/surveys_page.dart';
import 'package:clean_flutter_login_app/ui/pages/surveys/surveys_presenter.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:mocktail/mocktail.dart';

class MockSurveysPresenter extends Mock implements SurveysPresenter {}

void main() {
  late SurveysPresenter presenter;
  late StreamController<bool> isLoadingController;
  late StreamController<List<SurveyViewModel>> loadSurveysController;

  void initStreams() {
    isLoadingController = StreamController<bool>();
    loadSurveysController = StreamController<List<SurveyViewModel>>();
  }

  void mockStreams() {
    when(() => presenter.isLoadingStream)
        .thenAnswer((_) => isLoadingController.stream);
    when(() => presenter.loadSurveysStream)
        .thenAnswer((_) => loadSurveysController.stream);
  }

  void closeStreams() {
    isLoadingController.close();
    loadSurveysController.close();
  }

  void mockPresenter() {
    when(() => presenter.loadData()).thenAnswer((_) async {});
  }

  Future<void> loadPage(WidgetTester tester) async {
    presenter = MockSurveysPresenter();

    initStreams();

    mockStreams();

    mockPresenter();

    final surveysPage = GetMaterialApp(
      initialRoute: '/surveys',
      getPages: [
        GetPage(
          name: '/surveys',
          page: () => SurveysPage(
            presenter: presenter,
          ),
        )
      ],
    );
    await tester.pumpWidget(surveysPage);
  }

  tearDown(() {
    closeStreams();
  });

  List<SurveyViewModel> makeSurveys() => [
        SurveyViewModel(
          id: faker.guid.guid(),
          question: 'Question 1',
          date: 'Date 1',
          didAnswer: faker.randomGenerator.boolean(),
        ),
        SurveyViewModel(
          id: faker.guid.guid(),
          question: 'Question 2',
          date: 'Date 2',
          didAnswer: faker.randomGenerator.boolean(),
        ),
      ];

  testWidgets('should call LoadSuveys on page load', (tester) async {
    await loadPage(tester);

    verify(() => presenter.loadData()).called(1);
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

  testWidgets('should present error if loadSurveysStream fails',
      (tester) async {
    await loadPage(tester);

    loadSurveysController.addError(UiError.unexpected.description);
    await tester.pump();
    expect(find.text('Algo inesperado aconteceu. Tente novamente em breve'),
        findsOneWidget);
    expect(find.text('Recarregar'), findsOneWidget);
    expect(find.text('Question 1'), findsNothing);
  });

  testWidgets('should present list if loadSurveysStream succeeds',
      (tester) async {
    await loadPage(tester);

    loadSurveysController.add(makeSurveys());
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
}
