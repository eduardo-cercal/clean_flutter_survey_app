import '../../../domain/entities/account_entity.dart';
import '../../../domain/usecases/load_current_account.dart';
import '../../../domain/helpers/errors/domain_error.dart';
import '../../cache/fetch_secure_cache_storage.dart';

class LocalLoadCurrentAccount implements LoadCurrentAccount {
  final FetchSecureCacheStorage fetchSecureCacheStorage;

  LocalLoadCurrentAccount(this.fetchSecureCacheStorage);

  @override
  Future<AccountEntity> load() async {
    try {
      final token = await fetchSecureCacheStorage.fetch('token');
      return AccountEntity(token);
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}
