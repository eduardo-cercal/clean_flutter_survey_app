
import '../../../data/usecases/load_current_account/local_load_current_account.dart';
import '../../../domain/usecases/load_current_account.dart';
import '../cache/local_storage_adapter_factory.dart';

LoadCurrentAccount makeLocalLoadCurrentAccount() =>
    LocalLoadCurrentAccount(makeLocalStorageAdapter());
