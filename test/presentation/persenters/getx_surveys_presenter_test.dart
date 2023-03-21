import 'package:clean_flutter_login_app/domain/entities/survey_entity.dart';
import 'package:clean_flutter_login_app/domain/helpers/errors/domain_error.dart';
import 'package:clean_flutter_login_app/domain/usecases/load_surveys_use_case.dart';
import 'package:clean_flutter_login_app/presentation/presenters/surveys/getx_surveys_presenter.dart';
import 'package:clean_flutter_login_app/ui/helpers/errors/ui_error.dart';
import 'package:clean_flutter_login_app/ui/pages/surveys/survey_viewmodel.dart';
import 'package:clean_flutter_login_app/ui/pages/surveys/surveys_presenter.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mocktail/mocktail.dart';

class MockLoadSurveys extends Mock implements LoadSurveys {}

void main() {
  late LoadSurveys loadSurveys;
  late SurveysPresenter systemUnderTest;
  late List<SurveyEntity> surveys;

  List<SurveyEntity> validData() => [
        SurveyEntity(
          id: faker.guid.guid(),
          question: faker.lorem.sentence(),
          dateTime: DateTime(2020, 2, 20),
          didAnswer: faker.randomGenerator.boolean(),
        ),
        SurveyEntity(
          id: faker.guid.guid(),
          question: faker.lorem.sentence(),
          dateTime: DateTime(2018, 10, 3),
          didAnswer: faker.randomGenerator.boolean(),
        ),
      ];

  When mockLoadSurveysCall() => when(() => loadSurveys.load());

  void mockLoadSurveys(List<SurveyEntity> data) {
    surveys = data;
    mockLoadSurveysCall().thenAnswer((_) async => data);
  }

  void mockLoadSurveysError() {
    mockLoadSurveysCall().thenThrow(DomainError.unexpected);
  }

  setUp(() {
    loadSurveys = MockLoadSurveys();
    systemUnderTest = GetxSurveysPresenter(loadSurveys);
    mockLoadSurveys(validData());
  });

  test('should call LoadSurveys on loadData', () async {
    await systemUnderTest.loadData();

    verify(() => loadSurveys.load()).called(1);
  });

  test('should emit correct events on success', () async {
    expectLater(systemUnderTest.isLoadingStream, emitsInOrder([true, false]));
    systemUnderTest.surveysStream.listen(
      expectAsync1(
        (expectSurveys) => expect(
          expectSurveys,
          [
            SurveyViewModel(
              id: surveys[0].id,
              question: surveys[0].question,
              date: DateFormat('dd MMM yyyy').format(surveys[0].dateTime),
              didAnswer: surveys[0].didAnswer,
            ),
            SurveyViewModel(
              id: surveys[1].id,
              question: surveys[1].question,
              date: DateFormat('dd MMM yyyy').format(surveys[1].dateTime),
              didAnswer: surveys[1].didAnswer,
            ),
          ],
        ),
      ),
    );

    await systemUnderTest.loadData();
  });

  test('should emit correct events on failure', () async {
    mockLoadSurveysError();

    expectLater(systemUnderTest.isLoadingStream, emitsInOrder([true, false]));
    systemUnderTest.surveysStream.listen(
      null,
      onError: expectAsync1(
        (error) => expect(error, UiError.unexpected.description),
      ),
    );

    await systemUnderTest.loadData();
  });
}
