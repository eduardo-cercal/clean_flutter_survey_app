import 'package:get/get.dart';

import '../../../domain/helpers/errors/domain_error.dart';
import '../../../domain/usecases/load_surveys_use_case.dart';
import '../../../ui/helpers/errors/ui_error.dart';
import '../../../ui/pages/surveys/survey_viewmodel.dart';
import '../../../ui/pages/surveys/surveys_presenter.dart';

class GetxSurveysPresenter implements SurveysPresenter {
  final LoadSurveys loadSurveys;
  final _isLoading = true.obs;
  final _surveys = Rxn<List<SurveyViewModel>>();

  GetxSurveysPresenter(this.loadSurveys);

  @override
  Stream<bool> get isLoadingStream => _isLoading.stream;

  @override
  Stream<List<SurveyViewModel>?> get surveysStream => _surveys.stream;

  @override
  Future<void> loadData() async {
    try {
      _isLoading.value = true;
      final result = await loadSurveys.load();
      _surveys.value =
          result.map((element) => SurveyViewModel.fromEntity(element)).toList();
    } on DomainError {
      _surveys.subject.addError(UiError.unexpected.description);
    } finally {
      _isLoading.value = false;
    }
  }
}
