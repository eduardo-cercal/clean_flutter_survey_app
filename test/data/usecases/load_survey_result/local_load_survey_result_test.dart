import 'package:clean_flutter_login_app/data/cache/cache_storage.dart';
import 'package:clean_flutter_login_app/data/usecases/load_surveys_result/local_load_survey_result.dart';
import 'package:clean_flutter_login_app/domain/entities/survey_answer_entity.dart';
import 'package:clean_flutter_login_app/domain/entities/survey_result_entity.dart';
import 'package:clean_flutter_login_app/domain/helpers/errors/domain_error.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks/fake_survey_result_factory.dart';

class MockCacheStorage extends Mock implements CacheStorage {}

void main() {
  late CacheStorage cacheStorage;
  late LocalLoadSurveyResult systemUnderTest;
  late Map<String, dynamic>? validData;
  late String surveyId;

  When mockCacheStorageCall() => when(() => cacheStorage.fetch(any()));

  void mockCacheStorage(Map<String, dynamic>? data) {
    validData = data;
    mockCacheStorageCall().thenAnswer((_) async => validData);
  }

  void mockCacheStorageError() => mockCacheStorageCall().thenThrow(Exception());

  setUp(() {
    cacheStorage = MockCacheStorage();
    systemUnderTest = LocalLoadSurveyResult(cacheStorage);
    mockCacheStorage(FakeSurveyResultFactory.makeCacheJson());
    surveyId = faker.guid.guid();
  });

  group('load by survey', () {
    test('should call CacheStorage with correct key', () async {
      await systemUnderTest.loadBySurvey(surveyId: surveyId);

      verify(() => cacheStorage.fetch('survey_result/$surveyId')).called(1);
    });

    test('should return a survey result on successs', () async {
      final result = await systemUnderTest.loadBySurvey(surveyId: surveyId);

      expect(
        result,
        SurveyResultEntity(
          surveyId: validData?['surveyId'],
          question: validData?['question'],
          answers: [
            SurveyAnswerEntity(
              image: validData?['answers'][0]['image'],
              answer: validData?['answers'][0]['answer'],
              isCurrentAnswer: true,
              percent: 40,
            ),
            SurveyAnswerEntity(
              answer: validData?['answers'][1]['answer'],
              isCurrentAnswer: false,
              percent: 60,
            ),
          ],
        ),
      );
    });

    test('should throw  UnexpectedError if cache is empty', () async {
      mockCacheStorage({});

      final future = systemUnderTest.loadBySurvey(surveyId: surveyId);

      expect(future, throwsA(DomainError.unexpected));
    });

    test('should throw  UnexpectedError if cache is null', () async {
      mockCacheStorage(null);

      final future = systemUnderTest.loadBySurvey(surveyId: surveyId);

      expect(future, throwsA(DomainError.unexpected));
    });

    test('should throw  UnexpectedError if cache is invalid', () async {
      mockCacheStorage(FakeSurveyResultFactory.makeInvalidCacheJson());

      final future = systemUnderTest.loadBySurvey(surveyId: surveyId);

      expect(future, throwsA(DomainError.unexpected));
    });

    test('should throw  UnexpectedError if cache is incomplete', () async {
      mockCacheStorage(FakeSurveyResultFactory.makeIncompletedCacheJson());

      final future = systemUnderTest.loadBySurvey(surveyId: surveyId);

      expect(future, throwsA(DomainError.unexpected));
    });

    test('should throw  UnexpectedError if cache throws', () async {
      mockCacheStorageError();

      final future = systemUnderTest.loadBySurvey(surveyId: surveyId);

      expect(future, throwsA(DomainError.unexpected));
    });
  });

  group('validate', () {
    When mockCacheStorageDeleteCall() => when(() => cacheStorage.delete(any()));

    void mockCacheStorageDelete() {
      mockCacheStorageDeleteCall().thenAnswer((_) async {});
    }

    setUp(() {
      mockCacheStorageDelete();
    });

    test('should call CacheStorage with correct key', () async {
      await systemUnderTest.validate(surveyId);

      verify(() => cacheStorage.fetch('survey_result/$surveyId')).called(1);
    });

    test('should delete cache if it is invalid', () async {
      mockCacheStorage(FakeSurveyResultFactory.makeInvalidCacheJson());

      await systemUnderTest.validate(surveyId);

      verify(() => cacheStorage.delete('survey_result/$surveyId')).called(1);
    });

    test('should delete cache if it is incomplete', () async {
      mockCacheStorage(FakeSurveyResultFactory.makeIncompletedCacheJson());

      await systemUnderTest.validate(surveyId);

      verify(() => cacheStorage.delete('survey_result/$surveyId')).called(1);
    });

    test('should delete cache if fetch throws', () async {
      mockCacheStorageError();

      await systemUnderTest.validate(surveyId);

      verify(() => cacheStorage.delete('survey_result/$surveyId')).called(1);
    });
  });

  group('save', () {
    late SurveyResultEntity surveyResult;

    When mockCacheStorageSaveCall() => when(() =>
        cacheStorage.save(key: any(named: 'key'), value: any(named: 'value')));

    void mockCacheStorageSave() {
      mockCacheStorageSaveCall().thenAnswer((_) async {});
    }

    void mockCacheStorageSaveError() {
      mockCacheStorageSaveCall().thenThrow(Exception());
    }

    setUp(() {
      surveyResult = FakeSurveyResultFactory.makeEntity();
      mockCacheStorageSave();
    });

    test('should call CacheStorage with correct values', () async {
      final map = {
        'surveyId': surveyResult.surveyId,
        'question': surveyResult.question,
        'answers': [
          {
            'image': surveyResult.answers[0].image,
            'answer': surveyResult.answers[0].answer,
            'isCurrentAnswer':
                surveyResult.answers[0].isCurrentAnswer.toString(),
            'percent': surveyResult.answers[0].percent.toString(),
          },
          {
            'image': null,
            'answer': surveyResult.answers[1].answer,
            'isCurrentAnswer':
                surveyResult.answers[1].isCurrentAnswer.toString(),
            'percent': surveyResult.answers[1].percent.toString(),
          },
        ],
      };

      await systemUnderTest.save(surveyResult);

      verify(() => cacheStorage.save(
          key: 'survey_result/${surveyResult.surveyId}', value: map)).called(1);
    });

    test('should throw UnexpectedError if save throws', () async {
      mockCacheStorageSaveError();

      final future = systemUnderTest.save(surveyResult);

      expect(future, throwsA(DomainError.unexpected));
    });
  });
}
