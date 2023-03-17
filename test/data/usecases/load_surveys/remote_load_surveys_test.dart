import 'package:clean_flutter_login_app/data/http/http.error.dart';
import 'package:clean_flutter_login_app/data/http/http_client.dart';
import 'package:clean_flutter_login_app/data/usecases/load_surveys/remote_load_surveys.dart';
import 'package:clean_flutter_login_app/domain/entities/survey_entity.dart';
import 'package:clean_flutter_login_app/domain/helpers/errors/domain_error.dart';
import 'package:clean_flutter_login_app/domain/usecases/load_surveys_use_case.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockHttpClient extends Mock
    implements HttpClient<List<Map<String, dynamic>>?> {}

void main() {
  late HttpClient<List<Map<String, dynamic>>?> httpClient;
  late LoadSurveys systemUnderTest;
  late List<Map<String, dynamic>>? list;
  final url = faker.internet.httpUrl();

  List<Map<String, dynamic>> mockValidData() => [
        {
          'id': faker.guid.guid(),
          'question': faker.randomGenerator.string(50),
          'didAnswer': faker.randomGenerator.boolean(),
          'date': faker.date.dateTime().toIso8601String(),
        },
        {
          'id': faker.guid.guid(),
          'question': faker.randomGenerator.string(50),
          'didAnswer': faker.randomGenerator.boolean(),
          'date': faker.date.dateTime().toIso8601String(),
        }
      ];

  When mockHttpClientCall() => when(() =>
      httpClient.request(url: any(named: 'url'), method: any(named: 'method')));

  void mockHttpClient() {
    list = mockValidData();
    mockHttpClientCall().thenAnswer((_) async => list);
  }

  void mockHttpClientError(HttpError httpError) {
    mockHttpClientCall().thenThrow(httpError);
  }

  setUp(() {
    httpClient = MockHttpClient();
    systemUnderTest = RemoteLoadSurveys(httpClient: httpClient, url: url);
    mockHttpClient();
  });

  test('should call HttpClient with correct values', () async {
    await systemUnderTest.load();

    verify(() => httpClient.request(url: url, method: 'get')).called(1);
  });

  test('should return surveys on 200', () async {
    final result = await systemUnderTest.load();

    expect(result, [
      SurveyEntity(
        id: list?[0]['id'],
        question: list?[0]['question'],
        dateTime: DateTime.parse(list?[0]['date']),
        didAnswer: list?[0]['didAnswer'],
      ),
      SurveyEntity(
        id: list?[1]['id'],
        question: list?[1]['question'],
        dateTime: DateTime.parse(list?[1]['date']),
        didAnswer: list?[1]['didAnswer'],
      ),
    ]);
  });

  test('should throw an unexpected error if http client return 404', () async {
    mockHttpClientError(HttpError.notFound);

    final future = systemUnderTest.load();

    expect(future, throwsA(DomainError.unexpected));
  });

  test('should throw an unexpected error if http client return 500', () async {
    mockHttpClientError(HttpError.serverError);

    final future = systemUnderTest.load();

    expect(future, throwsA(DomainError.unexpected));
  });

  test('should throw a access deny error if http client return 403', () async {
    mockHttpClientError(HttpError.forbiden);

    final future = systemUnderTest.load();

    expect(future, throwsA(DomainError.accessDenied));
  });

  test(
      'should return an account if http client return 200 with invalid response',
      () async {
    when(() => httpClient.request(
          url: any(named: 'url'),
          method: any(named: 'method'),
          body: any(named: 'body'),
        )).thenAnswer((_) async => [
          {'invalid': 'invalid'}
        ]);

    final future = systemUnderTest.load();

    expect(future, throwsA(DomainError.unexpected));
  });
}
