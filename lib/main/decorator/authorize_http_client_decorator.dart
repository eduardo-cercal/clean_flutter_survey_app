import 'package:clean_flutter_login_app/data/cache/delete_secure_cache_storage.dart';

import '../../data/cache/fetch_secure_cache_storage.dart';
import '../../data/http/http.error.dart';
import '../../data/http/http_client.dart';

class AuthorizeHttpClientDecorator implements HttpClient {
  final FetchSecureCacheStorage fetchSecureCacheStorage;
  final DeleteSecureCacheStorage deleteSecureCacheStorage;
  final HttpClient decoratee;

  AuthorizeHttpClientDecorator({
    required this.fetchSecureCacheStorage,
    required this.deleteSecureCacheStorage,
    required this.decoratee,
  });

  @override
  Future request({
    required String url,
    required String method,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    try {
      final token = await fetchSecureCacheStorage.fetch('token');
      final authorizedHeaders = headers ?? {}
        ..addAll({'x-access-token': token});
      return await decoratee.request(
        url: url,
        method: method,
        body: body,
        headers: authorizedHeaders,
      );
    } catch (error) {
      if (error is HttpError && error != HttpError.forbiden) {
        rethrow;
      }
      await deleteSecureCacheStorage.delete('token');
      throw HttpError.forbiden;
    }
  }
}
