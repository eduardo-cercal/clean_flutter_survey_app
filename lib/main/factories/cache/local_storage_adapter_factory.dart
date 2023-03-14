import 'package:clean_flutter_login_app/data/http/http_client.dart';
import 'package:clean_flutter_login_app/infra/cache/local_storage_adapter.dart';
import 'package:clean_flutter_login_app/infra/http/http_adapter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

LocalStorageAdapter makeLocalStorageAdapter() =>
    LocalStorageAdapter(const FlutterSecureStorage());
