import 'package:clean_flutter_login_app/domain/entities/survey_answer_entity.dart';

import '../http/http.error.dart';

class SurveyAnswerModel extends SurveyAnswerEntity {
  const SurveyAnswerModel({
    super.image,
    required super.answer,
    required super.isCurrentAnswer,
    required super.percent,
  });

  factory SurveyAnswerModel.fromJson(Map<String, dynamic> json) {
    if (!json.keys
        .toSet()
        .containsAll(['answer', 'isCurrentAccountAnswer', 'percent'])) {
      throw HttpError.invalidData;
    }
    return SurveyAnswerModel(
      image: json['image'],
      answer: json['answer'],
      isCurrentAnswer: json['isCurrentAccountAnswer'],
      percent: json['percent'],
    );
  }

  SurveyAnswerEntity toEntity() => SurveyAnswerEntity(
        image: image,
        answer: answer,
        isCurrentAnswer: isCurrentAnswer,
        percent: percent,
      );
}
