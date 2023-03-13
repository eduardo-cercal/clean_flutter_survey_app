import 'package:clean_flutter_login_app/data/http/http.error.dart';
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

  group('shared', () {
    test('should thros a server error if invalid method is provided', () async {
      when(() => client.post(any(),
              headers: any(named: 'headers'), body: any(named: 'body')))
          .thenAnswer((_) async => http.Response('{}', 200));

      final future =
          systemUnderTest.request(url: url, method: 'invalid', body: {});

      expect(future, throwsA(HttpError.serverError));
    });
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
          .thenAnswer((_) async => http.Response('<!DOCTYPE html>', 200));

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

    test('should return null if post returns 204', () async {
      when(() => client.post(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response('', 204));

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

    test('should return null if post returns 204 with data', () async {
      when(() => client.post(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response('{}', 204));

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

    test('should return bad request erro if post returns 400', () async {
      when(() => client.post(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response('{}', 400));

      final future = systemUnderTest.request(url: url, method: 'post');

      expect(future, throwsA(HttpError.badRequest));

      verify(() => client.post(
            Uri.parse(url),
            headers: {
              'content-type': 'application/json',
              'accept': 'application/json',
            },
          ));
    });

    test('should return unauthorized error if post returns 401', () async {
      when(() => client.post(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response('{}', 401));

      final future = systemUnderTest.request(url: url, method: 'post');

      expect(future, throwsA(HttpError.unauthorized));

      verify(() => client.post(
            Uri.parse(url),
            headers: {
              'content-type': 'application/json',
              'accept': 'application/json',
            },
          ));
    });

    test('should return forbiden error if post returns 403', () async {
      when(() => client.post(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response('{}', 403));

      final future = systemUnderTest.request(url: url, method: 'post');

      expect(future, throwsA(HttpError.forbiden));

      verify(() => client.post(
            Uri.parse(url),
            headers: {
              'content-type': 'application/json',
              'accept': 'application/json',
            },
          ));
    });

    test('should return not found error if post returns 404', () async {
      when(() => client.post(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response('{}', 404));

      final future = systemUnderTest.request(url: url, method: 'post');

      expect(future, throwsA(HttpError.notFound));

      verify(() => client.post(
            Uri.parse(url),
            headers: {
              'content-type': 'application/json',
              'accept': 'application/json',
            },
          ));
    });

    test('should return server error erro if post returns 500', () async {
      when(() => client.post(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response('{}', 500));

      final future = systemUnderTest.request(url: url, method: 'post');

      expect(future, throwsA(HttpError.serverError));

      verify(() => client.post(
            Uri.parse(url),
            headers: {
              'content-type': 'application/json',
              'accept': 'application/json',
            },
          ));
    });

    test('should return server error if post throws', () async {
      when(() => client.post(any(), headers: any(named: 'headers')))
          .thenThrow(Exception());

      final future = systemUnderTest.request(url: url, method: 'post');

      expect(future, throwsA(HttpError.serverError));

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
