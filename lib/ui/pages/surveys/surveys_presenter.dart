import 'package:clean_flutter_login_app/ui/pages/surveys/survey_viewmodel.dart';

abstract class SurveysPresenter {
  Stream<bool> get isLoadingStream;

  Stream<List<SurveyViewModel>?> get surveysStream;

  Future<void> loadData();
}
