import 'package:clean_flutter_login_app/data/models/local_survey_model.dart';
import 'package:clean_flutter_login_app/domain/entities/survey_entity.dart';
import 'package:clean_flutter_login_app/domain/usecases/load_surveys_use_case.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

abstract class FetchCacheStorage {
  Future fetch(String key);
}

class LocalLoadSurveys implements LoadSurveys {
  final FetchCacheStorage fetchCacheStorage;

  LocalLoadSurveys(this.fetchCacheStorage);

  @override
  Future<List<SurveyEntity>> load() async {
    final data = await fetchCacheStorage.fetch('surveys');
    return data
        .map<SurveyEntity>((json) => LocalSurveyModel.fromJson(json).toEntity())
        .toList();
  }
}

class MockFetchCacheStorage extends Mock implements FetchCacheStorage {}

void main() {
  late FetchCacheStorage fetchCacheStorage;
  late LoadSurveys systemUnderTest;
  late List<Map<String, dynamic>> validData;

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

  When mockFetchCacheStorageCall() =>
      when(() => fetchCacheStorage.fetch(any()));

  void mockFetchCacheStorage() {
    validData = mockValidData();
    mockFetchCacheStorageCall().thenAnswer((_) async => validData);
  }

  setUp(() {
    fetchCacheStorage = MockFetchCacheStorage();
    systemUnderTest = LocalLoadSurveys(fetchCacheStorage);
    mockFetchCacheStorage();
  });

  test('should call FetchCacheStorage with correct key', () async {
    await systemUnderTest.load();

    verify(() => fetchCacheStorage.fetch('surveys')).called(1);
  });

  test('should return a surveys list on successs', () async {
    final result = await systemUnderTest.load();

    expect(result, [
      SurveyEntity(
        id: validData[0]['id'],
        question: validData[0]['question'],
        dateTime: DateTime.utc(2022, 02, 27),
        didAnswer: false,
      ),
      SurveyEntity(
        id: validData[1]['id'],
        question: validData[1]['question'],
        dateTime: DateTime.utc(2020, 04, 27),
        didAnswer: true,
      ),
    ]);
  });
}
