import 'package:clean_flutter_login_app/main/factories/http/api_url_factory.dart';
import 'package:clean_flutter_login_app/main/factories/http/authorize_http_client_decorator_factory.dart';

import '../../../data/usecases/save_surveys_result/remote_load_survey_result.dart';
import '../../../domain/usecases/save_survey_result.dart';

SaveSurveyResult makeRemoteSaveSurveyResult(String surveyId) =>
    RemoteSaveSurveyResult(
      httpClient: makeAuthorizeHttpClientDecorator(),
      url: makeApiUrl('surveys/$surveyId/results'),
    );
