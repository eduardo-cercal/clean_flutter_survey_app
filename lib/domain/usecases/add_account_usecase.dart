import 'package:clean_flutter_login_app/domain/entities/account_entity.dart';

import '../entities/add_account_params_entity.dart';

abstract class AddAccountUseCase {
  Future<AccountEntity> add(AddAccountParamsEntity params);
}
