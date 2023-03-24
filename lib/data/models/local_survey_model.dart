import 'package:clean_flutter_login_app/domain/entities/survey_entity.dart';

class LocalSurveyModel extends SurveyEntity {
  const LocalSurveyModel({
    required super.id,
    required super.question,
    required super.dateTime,
    required super.didAnswer,
  });

  factory LocalSurveyModel.fromJson(Map<String, dynamic> json) {
    if (!json.keys
        .toSet()
        .containsAll(['id', 'question', 'date', 'didAnswer'])) {
      throw Exception();
    }
    return LocalSurveyModel(
      id: json['id'],
      question: json['question'],
      dateTime: DateTime.parse(json['date']),
      didAnswer: json['didAnswer'] == "true" ? true : false,
    );
  }

  factory LocalSurveyModel.fromEntity(SurveyEntity entity) => LocalSurveyModel(
        id: entity.id,
        question: entity.question,
        dateTime: entity.dateTime,
        didAnswer: entity.didAnswer,
      );

  SurveyEntity toEntity() => SurveyEntity(
        id: id,
        question: question,
        dateTime: dateTime,
        didAnswer: didAnswer,
      );

  Map<String, String> toJson() => {
        'id': id,
        'question': question,
        'date': dateTime.toIso8601String(),
        'didAnswer': didAnswer.toString(),
      };
}
