import 'package:clean_flutter_login_app/data/http/http.error.dart';
import 'package:clean_flutter_login_app/domain/entities/account_entity.dart';
import 'package:clean_flutter_login_app/domain/entities/add_account_params_entity.dart';
import 'package:clean_flutter_login_app/domain/usecases/add_account_usecase.dart';
import 'package:clean_flutter_login_app/domain/helpers/errors/domain_error.dart';

import '../../http/http_client.dart';
import '../../models/account_model.dart';
import '../../models/add_account_params_model.dart';

class RemoteAddAccount implements AddAccountUseCase {
  final HttpClient httpClient;
  final String url;

  RemoteAddAccount({
    required this.httpClient,
    required this.url,
  });

  @override
  Future<AccountEntity> add(AddAccountParamsEntity params) async {
    final AddAccountParamsModel model =
        AddAccountParamsModel.fromEntity(params);

    try {
      final result = await httpClient.request(
        url: url,
        method: 'post',
        body: model.toJson(),
      );

      return AccountModel.fromJson(result!);
    } on HttpError catch (error) {
      throw error == HttpError.forbiden
          ? DomainError.emailInUse
          : DomainError.unexpected;
    }
  }
}
