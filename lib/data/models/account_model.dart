import 'package:clean_flutter_login_app/domain/entities/account_entity.dart';

import '../../utils/constants.dart';

class AccountModel extends AccountEntity {
  AccountModel(super.token);

  factory AccountModel.fromJson(Map<String, dynamic> json) =>
      AccountModel(json[tokenKey]);
}
