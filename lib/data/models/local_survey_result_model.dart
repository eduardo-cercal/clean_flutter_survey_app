import 'package:clean_flutter_login_app/domain/entities/survey_result_entity.dart';

import '../../domain/entities/survey_answer_entity.dart';
import 'local_survey_answer_model.dart';

class LocalSurveyResultModel extends SurveyResultEntity {
  const LocalSurveyResultModel({
    required super.surveyId,
    required super.question,
    required super.answers,
  });

  factory LocalSurveyResultModel.fromJson(Map<String, dynamic> json) {
    if (!json.keys.toSet().containsAll(['surveyId', 'question', 'answers'])) {
      throw Exception();
    }
    return LocalSurveyResultModel(
      surveyId: json['surveyId'],
      question: json['question'],
      answers: json['answers']
          .map<SurveyAnswerEntity>(
              (element) => LocalSurveyAnswerModel.fromJson(element).toEntity())
          .toList(),
    );
  }

  factory LocalSurveyResultModel.fromEntity(SurveyResultEntity entity) =>
      LocalSurveyResultModel(
        surveyId: entity.surveyId,
        question: entity.question,
        answers: entity.answers,
      );

  SurveyResultEntity toEntity() => SurveyResultEntity(
        surveyId: surveyId,
        question: question,
        answers: answers,
      );

  Map<String, dynamic> toJson() => {
        'surveyId': surveyId,
        'question': question,
        'answers': answers
            .map((element) =>
                LocalSurveyAnswerModel.fromEntity(element).toJson())
            .toList()
      };
}
