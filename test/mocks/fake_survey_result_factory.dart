import 'package:clean_flutter_login_app/domain/entities/survey_answer_entity.dart';
import 'package:clean_flutter_login_app/domain/entities/survey_result_entity.dart';
import 'package:clean_flutter_login_app/ui/pages/survey_result/survey_answer_viewmodel.dart';
import 'package:clean_flutter_login_app/ui/pages/survey_result/survey_result_viewmodel.dart';
import 'package:faker/faker.dart';

class FakeSurveyResultFactory {
  static Map<String, dynamic> makeCacheJson() => {
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

  static Map<String, dynamic> makeInvalidCacheJson() => {
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
      };

  static Map<String, dynamic> makeIncompletedCacheJson() => {
        "surveyId": faker.guid.guid(),
      };

  static SurveyResultEntity makeEntity() => SurveyResultEntity(
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

  static SurveyResultViewModel makeViewModel() => const SurveyResultViewModel(
        surveyId: 'Any id',
        question: 'Question',
        answers: [
          SurveyAnswerViewModel(
            image: 'Image 0',
            answer: 'Answer 0',
            isCurrentAnswer: true,
            percent: '60%',
          ),
          SurveyAnswerViewModel(
            answer: 'Answer 1',
            isCurrentAnswer: false,
            percent: '40%',
          ),
        ],
      );

  static Map<String, dynamic> makeApiJson() => {
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

  static Map<String, dynamic> makeInvalidApiJson() => {'invalid': 'invalid'};
}
