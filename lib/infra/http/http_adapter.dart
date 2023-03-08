import 'dart:convert';

import 'package:clean_flutter_login_app/data/http/http.error.dart';

import '../../data/http/http_client.dart';
import 'package:http/http.dart' as http;

class HttpAdapter implements HttpClient {
  final http.Client client;

  HttpAdapter(this.client);

  @override
  Future<Map<String, dynamic>?> request({
    required String url,
    required String method,
    Map<String, dynamic>? body,
  }) async {
    final headers = {
      'content-type': 'application/json',
      'accept': 'application/json',
    };
    final response = await client.post(
      Uri.parse(url),
      headers: headers,
      body: body != null ? jsonEncode(body) : null,
    );

    return _handleResponse(response);
  }

  Map<String, dynamic>? _handleResponse(http.Response response) {
    switch (response.statusCode) {
      case 204:
        return null;
      case 400:
        throw HttpError.badRequest;
      case 500:
        throw HttpError.serverError;
      default:
        return response.body.isEmpty ? null : jsonDecode(response.body);
    }
  }
}
