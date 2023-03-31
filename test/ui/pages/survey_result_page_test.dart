import 'dart:async';

import 'package:clean_flutter_login_app/ui/helpers/errors/ui_error.dart';
import 'package:clean_flutter_login_app/ui/pages/survey_result/components/active_icon.dart';
import 'package:clean_flutter_login_app/ui/pages/survey_result/components/disable_icon.dart';
import 'package:clean_flutter_login_app/ui/pages/survey_result/survey_result_page.dart';
import 'package:clean_flutter_login_app/ui/pages/survey_result/survey_result_presenter.dart';
import 'package:clean_flutter_login_app/ui/pages/survey_result/survey_result_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_image_mock/network_image_mock.dart';

import '../../mocks/fake_survey_result_factory.dart';
import '../helpers/helpers.dart';

class MockSurveyResultPresenter extends Mock implements SurveyResultPresenter {}

void main() {
  late SurveyResultPresenter presenter;
  late StreamController<bool> isLoadingController;
  late StreamController<SurveyResultViewModel> loadSurveyResultController;
  late StreamController<bool?> isSessionExpiredController;

  void initStreams() {
    isLoadingController = StreamController<bool>();
    loadSurveyResultController = StreamController<SurveyResultViewModel>();
    isSessionExpiredController = StreamController<bool?>();
  }

  void mockStreams() {
    when(() => presenter.isLoadingStream)
        .thenAnswer((_) => isLoadingController.stream);
    when(() => presenter.surveyResultStream)
        .thenAnswer((_) => loadSurveyResultController.stream);
    when(() => presenter.isSessionExpiredStream)
        .thenAnswer((_) => isSessionExpiredController.stream);
  }

  void closeStreams() {
    isLoadingController.close();
    loadSurveyResultController.close();
    isSessionExpiredController.close();
  }

  void mockPresenter() {
    when(() => presenter.loadData()).thenAnswer((_) async {});
    when(() => presenter.save(answer: any(named: 'answer')))
        .thenAnswer((_) async {});
  }

  Future<void> loadPage(WidgetTester tester) async {
    presenter = MockSurveyResultPresenter();

    initStreams();

    mockStreams();

    mockPresenter();

    await mockNetworkImagesFor(
      () async => await tester.pumpWidget(
        makePage(
          path: '/survey_result/any_survey_id',
          page: () => SurveyResultPage(
            presenter: presenter,
          ),
        ),
      ),
    );
  }

  tearDown(() {
    closeStreams();
  });

  testWidgets('should call LoadSuveyResult on page load', (tester) async {
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

  testWidgets('should present error if surveyResultStream fails',
      (tester) async {
    await loadPage(tester);

    loadSurveyResultController.addError(UiError.unexpected.description);
    await tester.pump();
    expect(find.text('Algo inesperado aconteceu. Tente novamente em breve'),
        findsOneWidget);
    expect(find.text('Recarregar'), findsOneWidget);
    expect(find.text('Question'), findsNothing);
  });

  testWidgets('should call LoadSuveyResult on realod buttom click',
      (tester) async {
    await loadPage(tester);

    loadSurveyResultController.addError(UiError.unexpected.description);
    await tester.pump();
    await tester.tap(find.text('Recarregar'));

    verify(() => presenter.loadData()).called(2);
  });

  testWidgets('should present valid data surveyResultStream succeeds',
      (tester) async {
    await loadPage(tester);

    loadSurveyResultController.add(FakeSurveyResultFactory.makeViewModel());
    await mockNetworkImagesFor(() async => await tester.pump());

    expect(find.text('Algo inesperado aconteceu. Tente novamente em breve'),
        findsNothing);
    expect(find.text('Recarregar'), findsNothing);
    expect(find.text('Question'), findsOneWidget);
    expect(find.text('Answer 0'), findsOneWidget);
    expect(find.text('Answer 1'), findsOneWidget);
    expect(find.text('60%'), findsOneWidget);
    expect(find.text('40%'), findsOneWidget);
    expect(find.byType(ActiveIcon), findsOneWidget);
    expect(find.byType(DisableIcon), findsOneWidget);
    final image =
        tester.widget<Image>(find.byType(Image)).image as NetworkImage;
    expect(image.url, 'Image 0');
  });

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
      expect(currentRoute, '/survey_result/any_survey_id');

      isSessionExpiredController.add(null);
      await tester.pumpAndSettle();
      expect(currentRoute, '/survey_result/any_survey_id');
    },
  );

  testWidgets('should call save on list item click', (tester) async {
    await loadPage(tester);

    loadSurveyResultController.add(FakeSurveyResultFactory.makeViewModel());
    await mockNetworkImagesFor(() async => await tester.pump());

    await tester.tap(find.text('Answer 1'));

    verify(() => presenter.save(answer: 'Answer 1')).called(1);
  });

  testWidgets('should not call save on current answer item click',
      (tester) async {
    await loadPage(tester);

    loadSurveyResultController.add(FakeSurveyResultFactory.makeViewModel());
    await mockNetworkImagesFor(() async => await tester.pump());

    await tester.tap(find.text('Answer 0'));

    verifyNever(() => presenter.save(answer: 'Answer 0'));
  });
}
