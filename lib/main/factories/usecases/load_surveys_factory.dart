import 'package:clean_flutter_login_app/data/usecases/load_surveys/remote_load_surveys.dart';
import 'package:clean_flutter_login_app/domain/usecases/load_surveys_use_case.dart';
import 'package:clean_flutter_login_app/main/factories/http/api_url_factory.dart';
import 'package:clean_flutter_login_app/main/factories/http/http_client_factory.dart';

LoadSurveys makeRemoteLoadSurveys() => RemoteLoadSurveys(
    httpClient: makeHttpAdapter(), url: makeApiUrl('surveys'));
