import 'package:clean_flutter_login_app/data/http/http.error.dart';
import 'package:clean_flutter_login_app/data/models/authentication_params_model.dart';
import 'package:clean_flutter_login_app/domain/entities/account_entity.dart';
import 'package:clean_flutter_login_app/domain/usecases/authentication_usecase.dart';
import 'package:clean_flutter_login_app/utils/domain_error.dart';

import '../../domain/entities/authentication_params_entity.dart';
import '../http/http_client.dart';
import '../models/account_model.dart';

class RemoteAuthentication implements AuthenticationUseCase {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({
    required this.httpClient,
    required this.url,
  });

  @override
  Future<AccountEntity> auth(AuthenticationParamsEntity params) async {
    final AuthenticationParamsModel model =
        AuthenticationParamsModel.fromEntity(params);

    try {
      final result = await httpClient.request(
        url: url,
        method: 'post',
        body: model.toJson(),
      );

      return AccountModel.fromJson(result);
    } on HttpError catch (error) {
      throw error == HttpError.unauthorized
          ? DomainError.invalidCredentials
          : DomainError.unexpected;
    }
  }
}
