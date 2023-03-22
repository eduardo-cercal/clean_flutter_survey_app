import 'package:clean_flutter_login_app/data/http/http_client.dart';
import 'package:clean_flutter_login_app/main/decorator/authorize_http_client_decorator.dart';
import 'package:clean_flutter_login_app/main/factories/http/http_client_factory.dart';

import '../cache/secure_storage_adapter_factory.dart';

HttpClient makeAuthorizeHttpClientDecorator() => AuthorizeHttpClientDecorator(
      fetchSecureCacheStorage: makeSecureStorageAdapter(),
      decoratee: makeHttpAdapter(),
    );
