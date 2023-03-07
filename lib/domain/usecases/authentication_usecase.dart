import 'package:clean_flutter_login_app/domain/entities/account_entity.dart';

import '../entities/authentication_params_entity.dart';

abstract class AuthenticationUseCase {
  Future<AccountEntity> auth(AuthenticationParamsEntity params);
}
