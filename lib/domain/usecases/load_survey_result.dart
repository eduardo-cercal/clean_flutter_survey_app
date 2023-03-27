import 'package:clean_flutter_login_app/domain/entities/survey_result_entity.dart';

abstract class LoadSurveyResult {
  Future<SurveyResultEntity> loadBySurvey({String? surveyId});
}
