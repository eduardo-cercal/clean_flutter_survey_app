import 'package:clean_flutter_login_app/domain/entities/survey_answer_entity.dart';
import 'package:clean_flutter_login_app/domain/entities/survey_result_entity.dart';
import 'package:clean_flutter_login_app/domain/helpers/errors/domain_error.dart';
import 'package:clean_flutter_login_app/domain/usecases/load_survey_result.dart';
import 'package:clean_flutter_login_app/domain/usecases/save_survey_result.dart';
import 'package:clean_flutter_login_app/presentation/presenters/survey_result/getx_survey_result_presenter.dart';
import 'package:clean_flutter_login_app/ui/helpers/errors/ui_error.dart';
import 'package:clean_flutter_login_app/ui/pages/survey_result/survey_answer_viewmodel.dart';
import 'package:clean_flutter_login_app/ui/pages/survey_result/survey_result_presenter.dart';
import 'package:clean_flutter_login_app/ui/pages/survey_result/survey_result_viewmodel.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockLoadSurveyResult extends Mock implements LoadSurveyResult {}

class MockSaveSurveyResult extends Mock implements SaveSurveyResult {}

void main() {
  late LoadSurveyResult loadSurveyResult;
  late SaveSurveyResult saveSurveyResult;
  late SurveyResultPresenter systemUnderTest;
  late SurveyResultEntity loadResult;
  late SurveyResultEntity saveResult;
  late String surveyId;
  late String answer;

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
    loadResult = data;
    mockLoadSurveyResultCall().thenAnswer((_) async => data);
  }

  void mockLoadSurveyResultError(DomainError error) {
    mockLoadSurveyResultCall().thenThrow(error);
  }

  When mockSaveSurveyResultCall() =>
      when(() => saveSurveyResult.save(answer: any(named: 'answer')));

  void mockSaveSurveyResult(SurveyResultEntity data) {
    saveResult = data;
    mockSaveSurveyResultCall().thenAnswer((_) async => saveResult);
  }

  void mockSaveSurveyResultError(DomainError error) {
    mockSaveSurveyResultCall().thenThrow(error);
  }

  SurveyResultViewModel mapToViewModel(SurveyResultEntity entity) =>
      SurveyResultViewModel(
        surveyId: entity.surveyId,
        question: entity.question,
        answers: [
          SurveyAnswerViewModel(
            image: entity.answers[0].image,
            answer: entity.answers[0].answer,
            isCurrentAnswer: entity.answers[0].isCurrentAnswer,
            percent: '${entity.answers[0].percent}%',
          ),
          SurveyAnswerViewModel(
            answer: entity.answers[1].answer,
            isCurrentAnswer: entity.answers[1].isCurrentAnswer,
            percent: '${entity.answers[1].percent}%',
          ),
        ],
      );

  setUp(() {
    loadSurveyResult = MockLoadSurveyResult();
    saveSurveyResult = MockSaveSurveyResult();
    surveyId = faker.guid.guid();
    answer = faker.lorem.sentence();
    systemUnderTest = GetxSurveyResultPresenter(
      loadSurveyResult: loadSurveyResult,
      saveSurveyResult: saveSurveyResult,
      surveyId: surveyId,
    );
    mockLoadSurveyResult(validData());
    mockSaveSurveyResult(validData());
  });

  group('load data', () {
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
            mapToViewModel(loadResult),
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
  });

  group('save', () {
    test('should call SaveSurveyResult on loadData', () async {
      await systemUnderTest.save(answer: answer);

      verify(() => saveSurveyResult.save(answer: answer)).called(1);
    });

    test('should emit correct events on success', () async {
      expectLater(systemUnderTest.isLoadingStream, emitsInOrder([true, false]));
      expectLater(
          systemUnderTest.surveyResultStream,
          emitsInOrder([
            mapToViewModel(loadResult),
            mapToViewModel(saveResult),
          ]));

      await systemUnderTest.loadData();
      await systemUnderTest.save(answer: answer);
    });

    test('should emit correct events on failure', () async {
      mockSaveSurveyResultError(DomainError.unexpected);

      expectLater(systemUnderTest.isLoadingStream, emitsInOrder([true, false]));
      systemUnderTest.surveyResultStream.listen(
        null,
        onError: expectAsync1(
          (error) => expect(error, UiError.unexpected.description),
        ),
      );

      await systemUnderTest.save(answer: answer);
    });

    test('should emit correct events on access denied', () async {
      mockSaveSurveyResultError(DomainError.accessDenied);

      expectLater(systemUnderTest.isLoadingStream, emitsInOrder([true, false]));
      expectLater(systemUnderTest.isSessionExpiredStream, emits(true));

      await systemUnderTest.save(answer: answer);
    });
  });
}
