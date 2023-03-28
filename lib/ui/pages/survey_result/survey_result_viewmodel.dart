import 'package:clean_flutter_login_app/domain/entities/survey_result_entity.dart';
import 'package:clean_flutter_login_app/ui/pages/survey_result/survey_answer_viewmodel.dart';
import 'package:equatable/equatable.dart';

class SurveyResultViewModel extends Equatable {
  final String surveyId;
  final String question;
  final List<SurveyAnswerViewModel> answers;

  const SurveyResultViewModel({
    required this.surveyId,
    required this.question,
    required this.answers,
  });

  factory SurveyResultViewModel.fromEntity(SurveyResultEntity entity) =>
      SurveyResultViewModel(
        surveyId: entity.surveyId,
        question: entity.question,
        answers: entity.answers
            .map((e) => SurveyAnswerViewModel.fromEntity(e))
            .toList(),
      );

  @override
  List<Object?> get props => [
        surveyId,
        question,
        answers,
      ];
}
