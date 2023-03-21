import 'package:clean_flutter_login_app/data/http/http.error.dart';
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
      throw HttpError.invalidData;
    }
    return LocalSurveyModel(
      id: json['id'],
      question: json['question'],
      dateTime: DateTime.parse(json['date']),
      didAnswer: bool.fromEnvironment(json['didAnswer']),
    );
  }

  SurveyEntity toEntity() => SurveyEntity(
        id: id,
        question: question,
        dateTime: dateTime,
        didAnswer: didAnswer,
      );
}
