import 'package:clean_flutter_login_app/data/usecases/load_surveys/remote_load_surveys.dart';
import 'package:clean_flutter_login_app/domain/usecases/load_surveys_use_case.dart';
import 'package:clean_flutter_login_app/main/composites/remote_load_surveys_with_local_fallback.dart';
import 'package:clean_flutter_login_app/main/factories/http/api_url_factory.dart';
import 'package:clean_flutter_login_app/main/factories/http/authorize_http_client_decorator_factory.dart';

import '../../../data/usecases/load_surveys/local_load_surveys.dart';
import '../cache/local_storage_adapter_factory.dart';

RemoteLoadSurveys makeRemoteLoadSurveys() => RemoteLoadSurveys(
      httpClient: makeAuthorizeHttpClientDecorator(),
      url: makeApiUrl('surveys'),
    );

LocalLoadSurveys makeLocalLoadSurveys() =>
    LocalLoadSurveys(makeLocalStorageAdapter());

LoadSurveys makeRemoteLoadSurveysWithLocalFallback() =>
    RemoteLoadSurveysWithLocalFallback(
      remoteLoadSurveys: makeRemoteLoadSurveys(),
      localLoadSurveys: makeLocalLoadSurveys(),
    );
