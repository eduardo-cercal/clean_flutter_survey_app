import 'package:clean_flutter_login_app/data/models/survey_answer_model.dart';
import 'package:clean_flutter_login_app/domain/entities/survey_answer_entity.dart';
import 'package:clean_flutter_login_app/domain/entities/survey_result_entity.dart';

import '../http/http.error.dart';

class RemoteSurveyResultModel extends SurveyResultEntity {
  const RemoteSurveyResultModel(
      {required super.surveyId,
      required super.question,
      required super.answers});

  factory RemoteSurveyResultModel.fromJson(Map<String, dynamic> json) {
    if (!json.keys.toSet().containsAll(['surveyId', 'question', 'answers'])) {
      throw HttpError.invalidData;
    }
    return RemoteSurveyResultModel(
      surveyId: json['surveyId'],
      question: json['question'],
      answers: json['answers']
          .map<SurveyAnswerEntity>(
              (element) => SurveyAnswerModel.fromJson(element).toEntity())
          .toList(),
    );
  }

  SurveyResultEntity toEntity() => SurveyResultEntity(
        surveyId: surveyId,
        question: question,
        answers: answers,
      );
}
