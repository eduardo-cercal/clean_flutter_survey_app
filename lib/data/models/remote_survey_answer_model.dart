import 'package:clean_flutter_login_app/domain/entities/survey_answer_entity.dart';

import '../http/http.error.dart';

class RemoteSurveyAnswerModel extends SurveyAnswerEntity {
  const RemoteSurveyAnswerModel({
    super.image,
    required super.answer,
    required super.isCurrentAnswer,
    required super.percent,
  });

  factory RemoteSurveyAnswerModel.fromJson(Map<String, dynamic> json) {
    if (!json.keys
        .toSet()
        .containsAll(['answer', 'isCurrentAccountAnswer', 'percent'])) {
      throw HttpError.invalidData;
    }
    return RemoteSurveyAnswerModel(
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
