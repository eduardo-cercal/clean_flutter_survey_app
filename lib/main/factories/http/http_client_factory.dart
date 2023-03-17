import 'package:clean_flutter_login_app/data/http/http_client.dart';
import 'package:clean_flutter_login_app/infra/http/http_adapter.dart';
import 'package:http/http.dart';

HttpClient<Map<String, dynamic>?> makeHttpAdapter() => HttpAdapter(Client());
