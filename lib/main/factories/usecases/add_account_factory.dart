import 'package:clean_flutter_login_app/data/usecases/authentication/remote_authentication_usecase.dart';
import 'package:clean_flutter_login_app/domain/usecases/add_account_usecase.dart';
import 'package:clean_flutter_login_app/domain/usecases/authentication_usecase.dart';
import 'package:clean_flutter_login_app/main/factories/http/api_url_factory.dart';
import 'package:clean_flutter_login_app/main/factories/http/http_client_factory.dart';

import '../../../data/usecases/add_account/remote_add_account.dart';

AddAccountUseCase makeRemoteAddAccount() =>
    RemoteAddAccount(httpClient: makeHttpAdapter(), url: makeApiUrl('signup'));
