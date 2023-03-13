import '../../../domain/entities/account_entity.dart';
import '../../../domain/usecases/save_current_account.dart';
import '../../../utils/domain_error.dart';
import '../../cache/save_secure_cache_storage.dart';

class LocalSaveCurrentAccount implements SaveCurrentAccount {
  final SaveSecureCacheStorage saveSecureCacheStorage;

  LocalSaveCurrentAccount({required this.saveSecureCacheStorage});

  @override
  Future<void> save(AccountEntity accountEntity) async {
    try {
      await saveSecureCacheStorage.saveSecure(
        key: 'token',
        value: accountEntity.token,
      );
    } catch (e) {
      throw DomainError.unexpected;
    }
  }
}
