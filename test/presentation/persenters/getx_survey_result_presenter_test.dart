import 'package:clean_flutter_login_app/domain/entities/survey_answer_entity.dart';
import 'package:clean_flutter_login_app/domain/entities/survey_result_entity.dart';
import 'package:clean_flutter_login_app/domain/helpers/errors/domain_error.dart';
import 'package:clean_flutter_login_app/domain/usecases/load_survey_result.dart';
import 'package:clean_flutter_login_app/presentation/presenters/survey_result/getx_survey_result_presenter.dart';
import 'package:clean_flutter_login_app/ui/helpers/errors/ui_error.dart';
import 'package:clean_flutter_login_app/ui/pages/survey_result/survey_answer_viewmodel.dart';
import 'package:clean_flutter_login_app/ui/pages/survey_result/survey_result_presenter.dart';
import 'package:clean_flutter_login_app/ui/pages/survey_result/survey_result_viewmodel.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockLoadSurveyResult extends Mock implements LoadSurveyResult {}

void main() {
  late LoadSurveyResult loadSurveyResult;
  late SurveyResultPresenter systemUnderTest;
  late SurveyResultEntity surveyResult;
  late String surveyId;

  SurveyResultEntity validData() => SurveyResultEntity(
          surveyId: faker.guid.guid(),
          question: faker.lorem.sentence(),
          answers: [
            SurveyAnswerEntity(
              image: faker.internet.httpUrl(),
              answer: faker.lorem.sentence(),
              isCurrentAnswer: faker.randomGenerator.boolean(),
              percent: faker.randomGenerator.integer(100),
            ),
            SurveyAnswerEntity(
              answer: faker.lorem.sentence(),
              isCurrentAnswer: faker.randomGenerator.boolean(),
              percent: faker.randomGenerator.integer(100),
            ),
          ]);

  When mockLoadSurveyResultCall() =>
      when(() => loadSurveyResult.loadBySurvey());

  void mockLoadSurveyResult(SurveyResultEntity data) {
    surveyResult = data;
    mockLoadSurveyResultCall().thenAnswer((_) async => data);
  }

  void mockLoadSurveyResultError(DomainError error) {
    mockLoadSurveyResultCall().thenThrow(error);
  }

  setUp(() {
    loadSurveyResult = MockLoadSurveyResult();
    surveyId = faker.guid.guid();
    systemUnderTest = GetxSurveyResultPresenter(
      loadSurveyResult: loadSurveyResult,
      surveyId: surveyId,
    );
    mockLoadSurveyResult(validData());
  });

  test('should call LoadSurveyResult on loadData', () async {
    await systemUnderTest.loadData();

    verify(() => loadSurveyResult.loadBySurvey()).called(1);
  });

  test('should emit correct events on success', () async {
    expectLater(systemUnderTest.isLoadingStream, emitsInOrder([true, false]));
    systemUnderTest.surveyResultStream.listen(
      expectAsync1(
        (expectSurveyResult) => expect(
          expectSurveyResult,
          SurveyResultViewModel(
            surveyId: surveyResult.surveyId,
            question: surveyResult.question,
            answers: [
              SurveyAnswerViewModel(
                image: surveyResult.answers[0].image,
                answer: surveyResult.answers[0].answer,
                isCurrentAnswer: surveyResult.answers[0].isCurrentAnswer,
                percent: '${surveyResult.answers[0].percent}%',
              ),
              SurveyAnswerViewModel(
                answer: surveyResult.answers[1].answer,
                isCurrentAnswer: surveyResult.answers[1].isCurrentAnswer,
                percent: '${surveyResult.answers[1].percent}%',
              ),
            ],
          ),
        ),
      ),
    );

    await systemUnderTest.loadData();
  });

  test('should emit correct events on failure', () async {
    mockLoadSurveyResultError(DomainError.unexpected);

    expectLater(systemUnderTest.isLoadingStream, emitsInOrder([true, false]));
    systemUnderTest.surveyResultStream.listen(
      null,
      onError: expectAsync1(
        (error) => expect(error, UiError.unexpected.description),
      ),
    );

    await systemUnderTest.loadData();
  });

  test('should emit correct events on access denied', () async {
    mockLoadSurveyResultError(DomainError.accessDenied);

    expectLater(systemUnderTest.isLoadingStream, emitsInOrder([true, false]));
    expectLater(systemUnderTest.isSessionExpiredStream, emits(true));

    await systemUnderTest.loadData();
  });
}
