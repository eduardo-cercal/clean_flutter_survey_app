import 'package:clean_flutter_login_app/domain/usecases/load_survey_result.dart';
import 'package:clean_flutter_login_app/main/composites/remote_load_survey_result_with_local_fallback.dart';
import 'package:clean_flutter_login_app/main/factories/http/api_url_factory.dart';
import 'package:clean_flutter_login_app/main/factories/http/authorize_http_client_decorator_factory.dart';

import '../../../data/usecases/load_surveys_result/local_load_survey_result.dart';
import '../../../data/usecases/load_surveys_result/remote_load_survey_result.dart';
import '../cache/local_storage_adapter_factory.dart';

RemoteLoadSurveyResult makeRemoteLoadSurveyResult(String surveyId) =>
    RemoteLoadSurveyResult(
      httpClient: makeAuthorizeHttpClientDecorator(),
      url: makeApiUrl('surveys/$surveyId/results'),
    );

LocalLoadSurveyResult makeLocalLoadSurveyResult(String surveyId) =>
    LocalLoadSurveyResult(makeLocalStorageAdapter());

LoadSurveyResult makeRemoteLoadSurveyResultWithLocalFallback(String surveyId) =>
    RemoteLoadSurveyResultWithLocalFallback(
      remote: makeRemoteLoadSurveyResult(surveyId),
      local: makeLocalLoadSurveyResult(surveyId),
    );
