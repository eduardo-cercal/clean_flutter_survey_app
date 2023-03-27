import 'package:clean_flutter_login_app/data/cache/cache_storage.dart';
import 'package:clean_flutter_login_app/data/usecases/load_surveys/local_load_surveys.dart';
import 'package:clean_flutter_login_app/domain/entities/survey_entity.dart';
import 'package:clean_flutter_login_app/domain/helpers/errors/domain_error.dart';
import 'package:clean_flutter_login_app/domain/usecases/load_surveys_use_case.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCacheStorage extends Mock implements CacheStorage {}

void main() {
  group('load', () {
    late CacheStorage cacheStorage;
    late LoadSurveys systemUnderTest;
    late List<Map<String, dynamic>>? validData;

    List<Map<String, dynamic>> mockValidData() => [
          {
            "id": faker.guid.guid(),
            "question": faker.randomGenerator.string(10),
            "date": "2022-02-27T19:00:00Z",
            "didAnswer": "false",
          },
          {
            "id": faker.guid.guid(),
            "question": faker.randomGenerator.string(10),
            "date": "2020-04-27T19:00:00Z",
            "didAnswer": "true",
          }
        ];

    When mockCacheStorageCall() => when(() => cacheStorage.fetch(any()));

    void mockCacheStorage(List<Map<String, dynamic>>? data) {
      validData = data;
      mockCacheStorageCall().thenAnswer((_) async => validData);
    }

    void mockCacheStorageError() =>
        mockCacheStorageCall().thenThrow(Exception());

    setUp(() {
      cacheStorage = MockCacheStorage();
      systemUnderTest = LocalLoadSurveys(cacheStorage);
      mockCacheStorage(mockValidData());
    });

    test('should call CacheStorage with correct key', () async {
      await systemUnderTest.load();

      verify(() => cacheStorage.fetch('surveys')).called(1);
    });

    test('should return a surveys list on successs', () async {
      final result = await systemUnderTest.load();

      expect(result, [
        SurveyEntity(
          id: validData?[0]['id'],
          question: validData?[0]['question'],
          dateTime: DateTime.parse(validData?[0]['date']),
          didAnswer: false,
        ),
        SurveyEntity(
          id: validData?[1]['id'],
          question: validData?[1]['question'],
          dateTime: DateTime.parse(validData?[1]['date']),
          didAnswer: true,
        ),
      ]);
    });

    test('should throw  UnexpectedError if cache is empty', () async {
      mockCacheStorage([]);

      final future = systemUnderTest.load();

      expect(future, throwsA(DomainError.unexpected));
    });

    test('should throw  UnexpectedError if cache is null', () async {
      mockCacheStorage(null);

      final future = systemUnderTest.load();

      expect(future, throwsA(DomainError.unexpected));
    });

    test('should throw  UnexpectedError if cache is invalid', () async {
      mockCacheStorage([
        {
          "id": faker.guid.guid(),
          "question": faker.randomGenerator.string(10),
          "date": "invalid date",
          "didAnswer": "false",
        }
      ]);

      final future = systemUnderTest.load();

      expect(future, throwsA(DomainError.unexpected));
    });

    test('should throw  UnexpectedError if cache is incomplete', () async {
      mockCacheStorage([
        {
          "date": "2020-04-27T19:00:00Z",
          "didAnswer": "false",
        }
      ]);

      final future = systemUnderTest.load();

      expect(future, throwsA(DomainError.unexpected));
    });

    test('should throw  UnexpectedError if cache throws', () async {
      mockCacheStorageError();

      final future = systemUnderTest.load();

      expect(future, throwsA(DomainError.unexpected));
    });
  });

  group('validate', () {
    late CacheStorage cacheStorage;
    late LocalLoadSurveys systemUnderTest;
    late List<Map<String, dynamic>>? validData;

    List<Map<String, dynamic>> mockValidData() => [
          {
            "id": faker.guid.guid(),
            "question": faker.randomGenerator.string(10),
            "date": "2022-02-27T19:00:00Z",
            "didAnswer": "false",
          },
          {
            "id": faker.guid.guid(),
            "question": faker.randomGenerator.string(10),
            "date": "2020-04-27T19:00:00Z",
            "didAnswer": "true",
          }
        ];

    When mockCacheStorageFetchCall() => when(() => cacheStorage.fetch(any()));

    When mockCacheStorageDeleteCall() => when(() => cacheStorage.delete(any()));

    void mockCacheStorage(List<Map<String, dynamic>>? data) {
      validData = data;
      mockCacheStorageFetchCall().thenAnswer((_) async => validData);
      mockCacheStorageDeleteCall().thenAnswer((_) async {});
    }

    void mockCacheStorageError() {
      mockCacheStorageFetchCall().thenThrow(Exception());
    }

    setUp(() {
      cacheStorage = MockCacheStorage();
      systemUnderTest = LocalLoadSurveys(cacheStorage);
      mockCacheStorage(mockValidData());
    });

    test('should call CacheStorage with correct key', () async {
      await systemUnderTest.validate();

      verify(() => cacheStorage.fetch('surveys')).called(1);
    });

    test('should delete cache if it is invalid', () async {
      mockCacheStorage([
        {
          "id": faker.guid.guid(),
          "question": faker.randomGenerator.string(10),
          "date": "invalid date",
          "didAnswer": "false",
        },
      ]);

      await systemUnderTest.validate();

      verify(() => cacheStorage.delete('surveys')).called(1);
    });

    test('should delete cache if it is incomplete', () async {
      mockCacheStorage([
        {
          "date": "2022-02-27T19:00:00Z",
          "didAnswer": "false",
        },
      ]);

      await systemUnderTest.validate();

      verify(() => cacheStorage.delete('surveys')).called(1);
    });

    test('should delete cache if fetch throws', () async {
      mockCacheStorageError();

      await systemUnderTest.validate();

      verify(() => cacheStorage.delete('surveys')).called(1);
    });
  });

  group('save', () {
    late CacheStorage cacheStorage;
    late LocalLoadSurveys systemUnderTest;
    late List<SurveyEntity> surveys;

    List<SurveyEntity> mockSurveys() => [
          SurveyEntity(
            id: faker.guid.guid(),
            question: faker.randomGenerator.string(10),
            dateTime: DateTime.utc(2020, 2, 2),
            didAnswer: true,
          ),
          SurveyEntity(
            id: faker.guid.guid(),
            question: faker.randomGenerator.string(10),
            dateTime: DateTime.utc(2020, 12, 20),
            didAnswer: false,
          ),
        ];

    When mockCacheStorageCall() => when(() =>
        cacheStorage.save(key: any(named: 'key'), value: any(named: 'value')));

    void mockCacheStorage() {
      mockCacheStorageCall().thenAnswer((_) async {});
    }

    void mockCacheStorageError() {
      mockCacheStorageCall().thenThrow(Exception());
    }

    setUp(() {
      cacheStorage = MockCacheStorage();
      systemUnderTest = LocalLoadSurveys(cacheStorage);
      surveys = mockSurveys();
      mockCacheStorage();
    });

    test('should call CacheStorage with correct values', () async {
      final list = [
        {
          'id': surveys[0].id,
          'question': surveys[0].question,
          'date': surveys[0].dateTime.toIso8601String(),
          'didAnswer': surveys[0].didAnswer.toString(),
        },
        {
          'id': surveys[1].id,
          'question': surveys[1].question,
          'date': surveys[1].dateTime.toIso8601String(),
          'didAnswer': surveys[1].didAnswer.toString(),
        },
      ];
      await systemUnderTest.save(surveys);

      verify(() => cacheStorage.save(key: 'surveys', value: list)).called(1);
    });

    test('should throw UnexpectedError if save throws', () async {
      mockCacheStorageError();

      final future = systemUnderTest.save(surveys);

      expect(future, throwsA(DomainError.unexpected));
    });
  });
}
