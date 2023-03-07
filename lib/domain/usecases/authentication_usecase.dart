import 'package:clean_flutter_login_app/domain/entities/account_entity.dart';

abstract class Authentication {
  Future<AccountEntity> auth({
    required String email,
    required String password,
  });
}
