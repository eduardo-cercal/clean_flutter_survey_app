import 'package:clean_flutter_login_app/domain/entities/survey_answer_entity.dart';

import '../http/http.error.dart';

class LocalSurveyAnswerModel extends SurveyAnswerEntity {
  const LocalSurveyAnswerModel({
    super.image,
    required super.answer,
    required super.isCurrentAnswer,
    required super.percent,
  });

  factory LocalSurveyAnswerModel.fromJson(Map<String, dynamic> json) {
    if (!json.keys
        .toSet()
        .containsAll(['answer', 'isCurrentAnswer', 'percent'])) {
      throw HttpError.invalidData;
    }
    return LocalSurveyAnswerModel(
      image: json['image'],
      answer: json['answer'],
      isCurrentAnswer: json['isCurrentAnswer'] == 'true' ? true : false,
      percent: int.parse(json['percent']),
    );
  }

  factory LocalSurveyAnswerModel.fromEntity(SurveyAnswerEntity entity) =>
      LocalSurveyAnswerModel(
        image: entity.image,
        answer: entity.answer,
        isCurrentAnswer: entity.isCurrentAnswer,
        percent: entity.percent,
      );

  SurveyAnswerEntity toEntity() => SurveyAnswerEntity(
        image: image,
        answer: answer,
        isCurrentAnswer: isCurrentAnswer,
        percent: percent,
      );

  Map<String, dynamic> toJson() => {
        'image': image,
        'answer': answer,
        'isCurrentAnswer': isCurrentAnswer.toString(),
        'percent': percent.toString(),
      };
}
