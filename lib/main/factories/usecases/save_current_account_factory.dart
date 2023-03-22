import 'package:clean_flutter_login_app/data/usecases/save_current_account/local_save_current_account.dart';
import 'package:clean_flutter_login_app/domain/usecases/save_current_account.dart';

import '../cache/secure_storage_adapter_factory.dart';

SaveCurrentAccount makeLocalSaveCurrentAccount() =>
    LocalSaveCurrentAccount(saveSecureCacheStorage: makeSecureStorageAdapter());
