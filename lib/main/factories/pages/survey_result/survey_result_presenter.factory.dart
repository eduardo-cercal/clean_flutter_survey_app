import 'package:clean_flutter_login_app/presentation/presenters/survey_result/getx_survey_result_presenter.dart';

import '../../../../ui/pages/survey_result/survey_result_presenter.dart';
import '../../usecases/load_survey_result_factory.dart';

SurveyResultPresenter makeGetxSurveyResultPresenter(String surveyId) =>
    GetxSurveyResultPresenter(
      loadSurveyResult: makeRemoteLoadSurveyResult(surveyId),
      surveyId: surveyId,
    );
