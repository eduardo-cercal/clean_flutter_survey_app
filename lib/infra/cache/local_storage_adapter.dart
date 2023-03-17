import 'package:clean_flutter_login_app/data/cache/fetch_secure_cache_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../data/cache/save_secure_cache_storage.dart';

class LocalStorageAdapter
    implements SaveSecureCacheStorage, FetchSecureCacheStorage {
  final FlutterSecureStorage secureStorage;

  LocalStorageAdapter(this.secureStorage);

  @override
  Future<void> saveSecure({required String key, required String? value}) async {
    await secureStorage.write(key: key, value: value);
  }

  @override
  Future<String> fetchSecure(String key) async {
    final result = await secureStorage.read(key: key);
    return result!;
  }
}
