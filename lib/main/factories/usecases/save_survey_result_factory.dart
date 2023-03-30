import 'package:clean_flutter_login_app/domain/usecases/load_survey_result.dart';
import 'package:clean_flutter_login_app/main/composites/remote_load_survey_result_with_local_fallback.dart';
import 'package:clean_flutter_login_app/main/factories/http/api_url_factory.dart';
import 'package:clean_flutter_login_app/main/factories/http/authorize_http_client_decorator_factory.dart';

import '../../../data/usecases/load_surveys_result/local_load_survey_result.dart';
import '../../../data/usecases/load_surveys_result/remote_load_survey_result.dart';
import '../../../data/usecases/save_surveys_result/remote_load_survey_result.dart';
import '../../../domain/usecases/save_survey_result.dart';
import '../cache/local_storage_adapter_factory.dart';

SaveSurveyResult makeRemoteSaveSurveyResult(String surveyId) =>
    RemoteSaveSurveyResult(
      httpClient: makeAuthorizeHttpClientDecorator(),
      url: makeApiUrl('surveys/$surveyId/results'),
    );
