import 'package:clean_flutter_login_app/data/http/http.error.dart';
import 'package:clean_flutter_login_app/data/models/authentication_params_model.dart';
import 'package:clean_flutter_login_app/utils/domain_error.dart';

import '../../domain/entities/authentication_params_entity.dart';
import '../http/http_client.dart';

class RemoteAuthentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({
    required this.httpClient,
    required this.url,
  });

  Future<void> auth(AuthenticationParamsEntity params) async {
    final AuthenticationParamsModel model =
        AuthenticationParamsModel.fromEntity(params);

    try {
      await httpClient.request(
        url: url,
        method: 'post',
        body: model.toJson(),
      );
    } on HttpError {
      throw DomainError.unexpected;
    }
  }
}
