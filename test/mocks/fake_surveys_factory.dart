import 'package:clean_flutter_login_app/domain/entities/survey_entity.dart';
import 'package:clean_flutter_login_app/ui/pages/surveys/survey_viewmodel.dart';
import 'package:faker/faker.dart';

class FakeSurveysFactory {
  static List<Map<String, dynamic>> makeCacheJson() => [
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

  static List<Map<String, dynamic>> makeInvalidCacheJson() => [
        {
          "id": faker.guid.guid(),
          "question": faker.randomGenerator.string(10),
          "date": "invalid date",
          "didAnswer": "false",
        }
      ];

  static List<Map<String, dynamic>> makeIncompletedCacheJson() => [
        {
          "date": "2020-04-27T19:00:00Z",
          "didAnswer": "false",
        }
      ];

  static List<SurveyEntity> makeEntities() => [
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

  static List<SurveyViewModel> makeViewModel() => [
        SurveyViewModel(
          id: '1',
          question: 'Question 1',
          date: 'Date 1',
          didAnswer: faker.randomGenerator.boolean(),
        ),
        SurveyViewModel(
          id: faker.guid.guid(),
          question: 'Question 2',
          date: 'Date 2',
          didAnswer: faker.randomGenerator.boolean(),
        ),
      ];

  static List<Map<String, dynamic>> makeApiJson() => [
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

  static List<Map<String, dynamic>> makeInvalidApiJson() => [
        {'invalid': 'invalid'}
      ];
}
