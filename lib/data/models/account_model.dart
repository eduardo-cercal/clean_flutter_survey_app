import 'package:clean_flutter_login_app/data/http/http.error.dart';
import 'package:clean_flutter_login_app/domain/entities/account_entity.dart';

import '../../utils/constants.dart';

class AccountModel extends AccountEntity {
  const AccountModel(super.token);

  factory AccountModel.fromJson(Map<String, dynamic> json) {
    if (!json.containsKey(tokenKey)) throw HttpError.invalidResponse;
    return AccountModel(json[tokenKey]);
  }
}
