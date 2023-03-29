import 'package:clean_flutter_login_app/data/cache/cache_storage.dart';
import 'package:clean_flutter_login_app/data/usecases/load_surveys/local_load_surveys.dart';
import 'package:clean_flutter_login_app/data/usecases/load_surveys_result/local_load_survey_result.dart';
import 'package:clean_flutter_login_app/domain/entities/survey_answer_entity.dart';
import 'package:clean_flutter_login_app/domain/entities/survey_entity.dart';
import 'package:clean_flutter_login_app/domain/entities/survey_result_entity.dart';
import 'package:clean_flutter_login_app/domain/helpers/errors/domain_error.dart';
import 'package:clean_flutter_login_app/domain/usecases/load_survey_result.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCacheStorage extends Mock implements CacheStorage {}

void main() {
  late CacheStorage cacheStorage;
  late LocalLoadSurveyResult systemUnderTest;
  late Map<String, dynamic>? validData;
  late String surveyId;

  Map<String, dynamic> mockValidData() => {
        "surveyId": faker.guid.guid(),
        "question": faker.lorem.sentence(),
        "answers": [
          {
            'image': faker.internet.httpUrl(),
            'answer': faker.lorem.sentence(),
            'isCurrentAnswer': 'true',
            'percent': '40',
          },
          {
            'answer': faker.lorem.sentence(),
            'isCurrentAnswer': 'false',
            'percent': '60',
          }
        ]
      };

  When mockCacheStorageCall() => when(() => cacheStorage.fetch(any()));

  void mockCacheStorage(Map<String, dynamic>? data) {
    validData = data;
    mockCacheStorageCall().thenAnswer((_) async => validData);
  }

  void mockCacheStorageError() => mockCacheStorageCall().thenThrow(Exception());

  setUp(() {
    cacheStorage = MockCacheStorage();
    systemUnderTest = LocalLoadSurveyResult(cacheStorage);
    mockCacheStorage(mockValidData());
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
      mockCacheStorage({
        "surveyId": faker.guid.guid(),
        "question": faker.lorem.sentence(),
        "answers": [
          {
            'image': faker.internet.httpUrl(),
            'answer': faker.lorem.sentence(),
            'isCurrentAnswer': 'invalid bool',
            'percent': 'invalid int',
          },
        ]
      });

      final future = systemUnderTest.loadBySurvey(surveyId: surveyId);

      expect(future, throwsA(DomainError.unexpected));
    });

    test('should throw  UnexpectedError if cache is incomplete', () async {
      mockCacheStorage({
        "surveyId": faker.guid.guid(),
      });

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
      mockCacheStorage({
        "surveyId": faker.guid.guid(),
        "question": faker.lorem.sentence(),
        "answers": [
          {
            'image': faker.internet.httpUrl(),
            'answer': faker.lorem.sentence(),
            'isCurrentAnswer': 'invalid bool',
            'percent': 'invalid int',
          },
        ]
      });

      await systemUnderTest.validate(surveyId);

      verify(() => cacheStorage.delete('survey_result/$surveyId')).called(1);
    });

    test('should delete cache if it is incomplete', () async {
      mockCacheStorage({
        "surveyId": faker.guid.guid(),
      });

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

    SurveyResultEntity mockSurveyResult() => SurveyResultEntity(
          surveyId: faker.guid.guid(),
          question: faker.lorem.sentence(),
          answers: [
            SurveyAnswerEntity(
              image: faker.internet.httpUrl(),
              answer: faker.lorem.sentence(),
              isCurrentAnswer: true,
              percent: 40,
            ),
            SurveyAnswerEntity(
              answer: faker.lorem.sentence(),
              isCurrentAnswer: false,
              percent: 60,
            ),
          ],
        );

    When mockCacheStorageSaveCall() => when(() =>
        cacheStorage.save(key: any(named: 'key'), value: any(named: 'value')));

    void mockCacheStorageSave() {
      mockCacheStorageSaveCall().thenAnswer((_) async {});
    }

    void mockCacheStorageSaveError() {
      mockCacheStorageSaveCall().thenThrow(Exception());
    }

    setUp(() {
      surveyResult = mockSurveyResult();
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

      await systemUnderTest.save(key: surveyId, value: surveyResult);

      verify(() =>
              cacheStorage.save(key: 'survey_result/$surveyId', value: map))
          .called(1);
    });

    test('should throw UnexpectedError if save throws', () async {
      mockCacheStorageSaveError();

      final future = systemUnderTest.save(key: surveyId, value: surveyResult);

      expect(future, throwsA(DomainError.unexpected));
    });
  });
}
