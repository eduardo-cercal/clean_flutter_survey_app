import 'package:clean_flutter_login_app/presentation/minixs/loading_manager.dart';
import 'package:clean_flutter_login_app/presentation/minixs/navigation_manager.dart';
import 'package:clean_flutter_login_app/presentation/minixs/session_manager.dart';
import 'package:get/get.dart';

import '../../../domain/helpers/errors/domain_error.dart';
import '../../../domain/usecases/load_surveys_use_case.dart';
import '../../../ui/helpers/errors/ui_error.dart';
import '../../../ui/pages/surveys/survey_viewmodel.dart';
import '../../../ui/pages/surveys/surveys_presenter.dart';

class GetxSurveysPresenter extends GetxController
    with LoadingManager, SessionManager, NavigationManager
    implements SurveysPresenter {
  final LoadSurveys loadSurveys;
  final _surveys = Rxn<List<SurveyViewModel>>();

  GetxSurveysPresenter(this.loadSurveys);

  @override
  Stream<List<SurveyViewModel>?> get surveysStream => _surveys.stream;

  @override
  Future<void> loadData() async {
    try {
      isLoading = true;
      final result = await loadSurveys.load();
      _surveys.value =
          result.map((element) => SurveyViewModel.fromEntity(element)).toList();
    } on DomainError catch (error) {
      if (error == DomainError.accessDenied) {
        isSessionExpired = true;
      } else {
        _surveys.subject.addError(UiError.unexpected.description);
      }
    } finally {
      isLoading = false;
    }
  }

  @override
  void goToSurveyResult(String surveyId) {
    navigateTo = '/survey_result/$surveyId';
  }
}
