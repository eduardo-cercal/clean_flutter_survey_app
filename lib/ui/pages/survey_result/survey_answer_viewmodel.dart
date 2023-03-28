import 'package:clean_flutter_login_app/domain/entities/survey_answer_entity.dart';
import 'package:equatable/equatable.dart';

class SurveyAnswerViewModel extends Equatable {
  final String? image;
  final String answer;
  final bool isCurrentAnswer;
  final String percent;

  const SurveyAnswerViewModel({
    this.image,
    required this.answer,
    required this.isCurrentAnswer,
    required this.percent,
  });

  factory SurveyAnswerViewModel.fromEntity(SurveyAnswerEntity entity) =>
      SurveyAnswerViewModel(
        image: entity.image,
        answer: entity.answer,
        isCurrentAnswer: entity.isCurrentAnswer,
        percent: '${entity.percent}%',
      );

  @override
  List<Object?> get props => [
        image,
        answer,
        isCurrentAnswer,
        percent,
      ];
}
