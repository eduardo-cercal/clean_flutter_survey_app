import 'dart:convert';

import 'package:clean_flutter_login_app/data/http/http.error.dart';

import '../../data/http/http_client.dart';
import 'package:http/http.dart' as http;

class HttpAdapter implements HttpClient<Map<String, dynamic>?> {
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
    http.Response response = http.Response('', 500);

    try {
      if (method == 'post') {
        response = await client.post(
          Uri.parse(url),
          headers: headers,
          body: body != null ? jsonEncode(body) : null,
        );
      }
    } catch (e) {
      throw HttpError.serverError;
    }

    return _handleResponse(response);
  }

  Map<String, dynamic>? _handleResponse(http.Response response) {
    switch (response.statusCode) {
      case 204:
        return {};
      case 400:
        throw HttpError.badRequest;
      case 401:
        throw HttpError.unauthorized;
      case 403:
        throw HttpError.forbiden;
      case 404:
        throw HttpError.notFound;
      case 500:
        throw HttpError.serverError;
      default:
        return response.body.contains('<!DOCTYPE html>')
            ? {}
            : jsonDecode(response.body);
    }
  }
}
