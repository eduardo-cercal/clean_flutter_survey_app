import 'package:clean_flutter_login_app/domain/entities/survey_entity.dart';

abstract class LoadSurveys {
  Future<List<SurveyEntity>> load();
}
