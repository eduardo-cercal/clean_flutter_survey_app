import 'dart:convert';

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

    if (response.statusCode != 200) return null;

    return response.body.isEmpty ? null : jsonDecode(response.body);
  }
}
