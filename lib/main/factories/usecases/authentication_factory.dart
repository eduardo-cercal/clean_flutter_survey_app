import 'package:clean_flutter_login_app/data/usecases/authentication/remote_authentication_usecase.dart';
import 'package:clean_flutter_login_app/domain/usecases/authentication_usecase.dart';
import 'package:clean_flutter_login_app/main/factories/http/api_url_factory.dart';
import 'package:clean_flutter_login_app/main/factories/http/http_client_factory.dart';

AuthenticationUseCase makeRemoteAuthentication() => RemoteAuthentication(
    httpClient: makeHttpAdapter(), url: makeApiUrl('login'));
