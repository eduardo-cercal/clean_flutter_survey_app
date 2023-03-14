import 'package:clean_flutter_login_app/domain/entities/account_entity.dart';

abstract class LoadCurrentAccount {
  Future<AccountEntity?> load();
}
