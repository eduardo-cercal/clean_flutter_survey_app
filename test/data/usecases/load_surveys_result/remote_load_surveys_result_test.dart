import 'package:clean_flutter_login_app/data/http/http.error.dart';
import 'package:clean_flutter_login_app/data/http/http_client.dart';
import 'package:clean_flutter_login_app/data/usecases/load_surveys_result/remote_load_surveys_result.dart';
import 'package:clean_flutter_login_app/domain/entities/survey_answer_entity.dart';
import 'package:clean_flutter_login_app/domain/entities/survey_result_entity.dart';
import 'package:clean_flutter_login_app/domain/helpers/errors/domain_error.dart';
import 'package:clean_flutter_login_app/domain/usecases/load_survey_result.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockHttpClient extends Mock implements HttpClient {}

void main() {
  late HttpClient httpClient;
  late LoadSurveyResult systemUnderTest;
  late Map<String, dynamic>? surveyResult;
  final url = faker.internet.httpUrl();

  Map<String, dynamic> mockValidData() => {
        'surveyId': faker.guid.guid(),
        'question': faker.randomGenerator.string(50),
        'answers': [
          {
            'image': faker.internet.httpUrl(),
            'answer': faker.randomGenerator.string(20),
            'percent': faker.randomGenerator.integer(100),
            'count': faker.randomGenerator.integer(1000),
            'isCurrentAccountAnswer': faker.randomGenerator.boolean(),
          },
          {
            'answer': faker.randomGenerator.string(20),
            'percent': faker.randomGenerator.integer(100),
            'count': faker.randomGenerator.integer(1000),
            'isCurrentAccountAnswer': faker.randomGenerator.boolean(),
          },
        ],
        'date': faker.date.dateTime().toIso8601String(),
      };

  When mockHttpClientCall() => when(() =>
      httpClient.request(url: any(named: 'url'), method: any(named: 'method')));

  void mockHttpClient() {
    surveyResult = mockValidData();
    mockHttpClientCall().thenAnswer((_) async => surveyResult);
  }

  void mockHttpClientError(HttpError httpError) {
    mockHttpClientCall().thenThrow(httpError);
  }

  setUp(() {
    httpClient = MockHttpClient();
    systemUnderTest = RemoteLoadSurveyResult(httpClient: httpClient, url: url);
    mockHttpClient();
  });

  test('should call HttpClient with correct values', () async {
    await systemUnderTest.loadBySurvey();

    verify(() => httpClient.request(url: url, method: 'get')).called(1);
  });

  test('should return surveysResult on 200', () async {
    final result = await systemUnderTest.loadBySurvey();

    expect(
      result,
      SurveyResultEntity(
          surveyId: surveyResult?['surveyId'],
          question: surveyResult?['question'],
          answers: [
            SurveyAnswerEntity(
              image: surveyResult?['answers'][0]['image'],
              answer: surveyResult?['answers'][0]['answer'],
              isCurrentAnswer: surveyResult?['answers'][0]
                  ['isCurrentAccountAnswer'],
              percent: surveyResult?['answers'][0]['percent'],
            ),
            SurveyAnswerEntity(
              answer: surveyResult?['answers'][1]['answer'],
              isCurrentAnswer: surveyResult?['answers'][1]
                  ['isCurrentAccountAnswer'],
              percent: surveyResult?['answers'][1]['percent'],
            ),
          ]),
    );
  });

  test('should throw an unexpected error if http client return 404', () async {
    mockHttpClientError(HttpError.notFound);

    final future = systemUnderTest.loadBySurvey();

    expect(future, throwsA(DomainError.unexpected));
  });

  test('should throw an unexpected error if http client return 500', () async {
    mockHttpClientError(HttpError.serverError);

    final future = systemUnderTest.loadBySurvey();

    expect(future, throwsA(DomainError.unexpected));
  });

  test('should throw a access deny error if http client return 403', () async {
    mockHttpClientError(HttpError.forbiden);

    final future = systemUnderTest.loadBySurvey();

    expect(future, throwsA(DomainError.accessDenied));
  });

  test(
      'should return an account if http client return 200 with invalid response',
      () async {
    when(() => httpClient.request(
          url: any(named: 'url'),
          method: any(named: 'method'),
          body: any(named: 'body'),
        )).thenAnswer((_) async => {'invalid': 'invalid'});

    final future = systemUnderTest.loadBySurvey();

    expect(future, throwsA(DomainError.unexpected));
  });
}
