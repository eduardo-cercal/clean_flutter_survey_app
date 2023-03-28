import 'package:clean_flutter_login_app/ui/pages/survey_result/survey_result_viewmodel.dart';

abstract class SurveyResultPresenter {
  Stream<bool>? get isLoadingStream;

  Stream<SurveyResultViewModel?> get surveyResultStream;

  Stream<bool?> get isSessionExpiredStream;

  Future<void> loadData();
}
