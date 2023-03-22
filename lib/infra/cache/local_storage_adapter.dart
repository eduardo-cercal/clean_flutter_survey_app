import 'package:localstorage/localstorage.dart';

import '../../data/cache/cache_storage.dart';

class LocalStorageAdapter implements CacheStorage {
  final LocalStorage localStorage;

  LocalStorageAdapter(this.localStorage);

  @override
  Future<void> delete(String key) async {
    await localStorage.deleteItem(key);
  }

  @override
  Future fetch(String key) async {
    return await localStorage.getItem(key);
  }

  @override
  Future<void> save({required String key, required value}) async {
    await localStorage.deleteItem(key);
    await localStorage.setItem(key, value);
  }
}
