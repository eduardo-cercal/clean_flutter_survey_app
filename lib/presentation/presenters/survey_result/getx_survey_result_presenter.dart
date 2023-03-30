import 'package:clean_flutter_login_app/domain/usecases/save_survey_result.dart';
import 'package:clean_flutter_login_app/presentation/minixs/loading_manager.dart';
import 'package:clean_flutter_login_app/presentation/minixs/session_manager.dart';
import 'package:get/get.dart';

import '../../../domain/entities/survey_result_entity.dart';
import '../../../domain/helpers/errors/domain_error.dart';
import '../../../domain/usecases/load_survey_result.dart';
import '../../../ui/helpers/errors/ui_error.dart';
import '../../../ui/pages/survey_result/survey_result_presenter.dart';
import '../../../ui/pages/survey_result/survey_result_viewmodel.dart';

class GetxSurveyResultPresenter extends GetxController
    with LoadingManager, SessionManager
    implements SurveyResultPresenter {
  final LoadSurveyResult loadSurveyResult;
  final SaveSurveyResult saveSurveyResult;
  final String surveyId;
  final _surveyResult = Rxn<SurveyResultViewModel>();

  GetxSurveyResultPresenter({
    required this.loadSurveyResult,
    required this.saveSurveyResult,
    required this.surveyId,
  });

  @override
  Stream<SurveyResultViewModel?> get surveyResultStream => _surveyResult.stream;

  @override
  Future<void> loadData() async {
    await _showResultOnAction(() => loadSurveyResult.loadBySurvey());
  }

  @override
  Future<void> save({required String answer}) async {
    await _showResultOnAction(() => saveSurveyResult.save(answer: answer));
  }

  Future<void> _showResultOnAction(
      Future<SurveyResultEntity> Function() action) async {
    try {
      isLoading = true;
      final result = await action();
      _surveyResult.subject.add(SurveyResultViewModel.fromEntity(result));
    } on DomainError catch (error) {
      if (error == DomainError.accessDenied) {
        isSessionExpired = true;
      } else {
        _surveyResult.subject.addError(UiError.unexpected.description);
      }
    } finally {
      isLoading = false;
    }
  }
}
