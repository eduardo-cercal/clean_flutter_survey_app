import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../data/cache/save_secure_cache_storage.dart';

class LocalStorageAdapter implements SaveSecureCacheStorage {
  final FlutterSecureStorage storage;

  LocalStorageAdapter(this.storage);

  @override
  Future<void> saveSecure({required String key, required String value}) async {
    await storage.write(key: key, value: value);
  }
}
