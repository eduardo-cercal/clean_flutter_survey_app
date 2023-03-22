import '../../../data/usecases/load_current_account/local_load_current_account.dart';
import '../../../domain/usecases/load_current_account.dart';
import '../cache/secure_storage_adapter_factory.dart';

LoadCurrentAccount makeLocalLoadCurrentAccount() =>
    LocalLoadCurrentAccount(makeSecureStorageAdapter());
