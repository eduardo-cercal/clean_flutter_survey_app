import 'dart:convert';

import 'package:clean_flutter_login_app/data/http/http_client.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

class HttpAdapter implements HttpClient {
  final http.Client client;

  HttpAdapter(this.client);

  @override
  Future<Map<String, dynamic>> request({
    required String url,
    required String method,
    Map<String, dynamic>? body,
  }) async {
    final headers = {
      'content-type': 'application/json',
      'accept': 'application/json',
    };
    await client.post(Uri.parse(url), headers: headers, body: jsonEncode(body));
    return {};
  }
}

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late http.Client client;
  late HttpAdapter systemUnderTest;
  final String url = faker.internet.httpUrl();

  setUp(() {
    client = MockHttpClient();
    systemUnderTest = HttpAdapter(client);
    registerFallbackValue(Uri.parse(url));
  });

  group('post', () {
    test('should call post with correct values', () async {
      when(() => client.post(any(),
              headers: any(named: 'headers'), body: any(named: 'body')))
          .thenAnswer((_) async => http.Response('', 200));

      await systemUnderTest.request(url: url, method: 'post', body: {});

      verify(() => client.post(Uri.parse(url),
          headers: {
            'content-type': 'application/json',
            'accept': 'application/json',
          },
          body: '{}'));
    });
  });
}
