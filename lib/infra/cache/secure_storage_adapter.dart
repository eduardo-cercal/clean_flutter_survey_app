import 'package:clean_flutter_login_app/data/cache/delete_secure_cache_storage.dart';
import 'package:clean_flutter_login_app/data/cache/fetch_secure_cache_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../data/cache/save_secure_cache_storage.dart';

class SecureStorageAdapter
    implements
        SaveSecureCacheStorage,
        FetchSecureCacheStorage,
        DeleteSecureCacheStorage {
  final FlutterSecureStorage secureStorage;

  SecureStorageAdapter(this.secureStorage);

  @override
  Future<void> save({required String key, required String? value}) async {
    await secureStorage.write(key: key, value: value);
  }

  @override
  Future<String> fetch(String key) async {
    final result = await secureStorage.read(key: key);
    return result!;
  }

  @override
  Future<void> delete(String key) async {
    await secureStorage.delete(key: key);
  }
}
