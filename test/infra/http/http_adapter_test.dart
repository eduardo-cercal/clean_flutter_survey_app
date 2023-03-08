import 'dart:convert';

import 'package:clean_flutter_login_app/data/http/http_client.dart';
import 'package:clean_flutter_login_app/infra/http/http_adapter.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

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
          .thenAnswer((_) async => http.Response('{}', 200));

      await systemUnderTest.request(url: url, method: 'post', body: {});

      verify(() => client.post(Uri.parse(url),
          headers: {
            'content-type': 'application/json',
            'accept': 'application/json',
          },
          body: '{}'));
    });

    test('should call post without the body', () async {
      when(() => client.post(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response('{}', 200));

      await systemUnderTest.request(url: url, method: 'post');

      verify(() => client.post(
            Uri.parse(url),
            headers: {
              'content-type': 'application/json',
              'accept': 'application/json',
            },
          ));
    });

    test('should return data if post returns 200', () async {
      when(() => client.post(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response('{}', 200));

      final result = await systemUnderTest.request(url: url, method: 'post');

      expect(result, {});

      verify(() => client.post(
            Uri.parse(url),
            headers: {
              'content-type': 'application/json',
              'accept': 'application/json',
            },
          ));
    });

    test('should return null if post returns 200 with null data', () async {
      when(() => client.post(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response('', 200));

      final result = await systemUnderTest.request(url: url, method: 'post');

      expect(result, null);

      verify(() => client.post(
            Uri.parse(url),
            headers: {
              'content-type': 'application/json',
              'accept': 'application/json',
            },
          ));
    });

    test('should return null if post returns 204', () async {
      when(() => client.post(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response('', 204));

      final result = await systemUnderTest.request(url: url, method: 'post');

      expect(result, null);

      verify(() => client.post(
            Uri.parse(url),
            headers: {
              'content-type': 'application/json',
              'accept': 'application/json',
            },
          ));
    });

    test('should return null if post returns 204 with data', () async {
      when(() => client.post(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response('{}', 204));

      final result = await systemUnderTest.request(url: url, method: 'post');

      expect(result, null);

      verify(() => client.post(
            Uri.parse(url),
            headers: {
              'content-type': 'application/json',
              'accept': 'application/json',
            },
          ));
    });
  });
}
