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
    When mockHttpAdapterCall() => when(() => client.post(any(),
        headers: any(named: 'headers'), body: any(named: 'body')));

    void mockHttpAdapter() =>
        mockHttpAdapterCall().thenAnswer((_) async => http.Response('{}', 200));

    setUp(() => mockHttpAdapter());

    test('should call post with correct values', () async {
      await systemUnderTest.request(
        url: url,
        method: 'post',
        body: {},
      );
      verify(
        () => client.post(
          Uri.parse(url),
          headers: {
            'content-type': 'application/json',
            'accept': 'application/json',
          },
          body: '{}',
        ),
      );

      await systemUnderTest.request(
        url: url,
        method: 'post',
        body: {},
        headers: {'any_header': 'any_value'},
      );
      verify(
        () => client.post(
          Uri.parse(url),
          headers: {
            'content-type': 'application/json',
            'accept': 'application/json',
            'any_header': 'any_value',
          },
          body: '{}',
        ),
      );
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

  group('get', () {
    When mockRequestCall() =>
        when(() => client.get(any(), headers: any(named: 'headers')));

    void mockRequest(int statusCode,
        {String body = '{"any_key":"any_value"}'}) {
      mockRequestCall()
          .thenAnswer((_) async => http.Response(body, statusCode));
    }

    test('should call get with correct values', () async {
      mockRequest(200);

      await systemUnderTest.request(url: url, method: 'get');
      verify(
        () => client.get(
          Uri.parse(url),
          headers: {
            'content-type': 'application/json',
            'accept': 'application/json',
          },
        ),
      );

      await systemUnderTest.request(
          url: url, method: 'get', headers: {'any_header': 'any_value'});
      verify(
        () => client.get(
          Uri.parse(url),
          headers: {
            'content-type': 'application/json',
            'accept': 'application/json',
            'any_header': 'any_value',
          },
        ),
      );
    });

    test('should return data if get returns 200', () async {
      mockRequest(200);

      final result = await systemUnderTest.request(url: url, method: 'get');

      expect(result, {"any_key": "any_value"});

      verify(() => client.get(
            Uri.parse(url),
            headers: {
              'content-type': 'application/json',
              'accept': 'application/json',
            },
          ));
    });

    test('should return null if get returns 200 with null data', () async {
      mockRequest(200, body: '<!DOCTYPE html>');

      final result = await systemUnderTest.request(url: url, method: 'get');

      expect(result, {});

      verify(() => client.get(
            Uri.parse(url),
            headers: {
              'content-type': 'application/json',
              'accept': 'application/json',
            },
          ));
    });

    test('should return null if get returns 204', () async {
      mockRequest(204, body: '');

      final result = await systemUnderTest.request(url: url, method: 'get');

      expect(result, {});

      verify(() => client.get(
            Uri.parse(url),
            headers: {
              'content-type': 'application/json',
              'accept': 'application/json',
            },
          ));
    });

    test('should return null if get returns 204 with data', () async {
      mockRequest(204, body: '{}');

      final result = await systemUnderTest.request(url: url, method: 'get');

      expect(result, {});

      verify(() => client.get(
            Uri.parse(url),
            headers: {
              'content-type': 'application/json',
              'accept': 'application/json',
            },
          ));
    });

    test('should return bad request error if get returns 400 with a null body',
        () async {
      mockRequest(400, body: '');

      final future = systemUnderTest.request(url: url, method: 'get');

      expect(future, throwsA(HttpError.badRequest));

      verify(() => client.get(
            Uri.parse(url),
            headers: {
              'content-type': 'application/json',
              'accept': 'application/json',
            },
          ));
    });

    test('should return bad request error if get returns 400', () async {
      mockRequest(400);

      final future = systemUnderTest.request(url: url, method: 'get');

      expect(future, throwsA(HttpError.badRequest));

      verify(() => client.get(
            Uri.parse(url),
            headers: {
              'content-type': 'application/json',
              'accept': 'application/json',
            },
          ));
    });

    test('should return unauthorized error if get returns 401', () async {
      mockRequest(401, body: '{}');

      final future = systemUnderTest.request(url: url, method: 'get');

      expect(future, throwsA(HttpError.unauthorized));

      verify(() => client.get(
            Uri.parse(url),
            headers: {
              'content-type': 'application/json',
              'accept': 'application/json',
            },
          ));
    });

    test('should return forbiden error if get returns 403', () async {
      mockRequest(403, body: '{}');

      final future = systemUnderTest.request(url: url, method: 'get');

      expect(future, throwsA(HttpError.forbiden));

      verify(() => client.get(
            Uri.parse(url),
            headers: {
              'content-type': 'application/json',
              'accept': 'application/json',
            },
          ));
    });

    test('should return not found error if get returns 404', () async {
      mockRequest(404, body: '{}');

      final future = systemUnderTest.request(url: url, method: 'get');

      expect(future, throwsA(HttpError.notFound));

      verify(() => client.get(
            Uri.parse(url),
            headers: {
              'content-type': 'application/json',
              'accept': 'application/json',
            },
          ));
    });

    test('should return server error erro if get returns 500', () async {
      mockRequest(500, body: '{}');

      final future = systemUnderTest.request(url: url, method: 'get');

      expect(future, throwsA(HttpError.serverError));

      verify(() => client.get(
            Uri.parse(url),
            headers: {
              'content-type': 'application/json',
              'accept': 'application/json',
            },
          ));
    });

    test('should return server error if get throws', () async {
      when(() => client.get(any(), headers: any(named: 'headers')))
          .thenThrow(Exception());

      final future = systemUnderTest.request(url: url, method: 'get');

      expect(future, throwsA(HttpError.serverError));

      verify(() => client.get(
            Uri.parse(url),
            headers: {
              'content-type': 'application/json',
              'accept': 'application/json',
            },
          ));
    });
  });

  group('put', () {
    When mockHttpAdapterCall() => when(() => client.put(any(),
        headers: any(named: 'headers'), body: any(named: 'body')));

    void mockHttpAdapter() =>
        mockHttpAdapterCall().thenAnswer((_) async => http.Response('{}', 200));

    setUp(() => mockHttpAdapter());

    test('should call put with correct values', () async {
      await systemUnderTest.request(
        url: url,
        method: 'put',
        body: {},
      );
      verify(
        () => client.put(
          Uri.parse(url),
          headers: {
            'content-type': 'application/json',
            'accept': 'application/json',
          },
          body: '{}',
        ),
      );

      await systemUnderTest.request(
        url: url,
        method: 'put',
        body: {},
        headers: {'any_header': 'any_value'},
      );
      verify(
        () => client.put(
          Uri.parse(url),
          headers: {
            'content-type': 'application/json',
            'accept': 'application/json',
            'any_header': 'any_value',
          },
          body: '{}',
        ),
      );
    });

    test('should call put without the body', () async {
      when(() => client.put(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response('{}', 200));

      await systemUnderTest.request(url: url, method: 'put');

      verify(() => client.put(
            Uri.parse(url),
            headers: {
              'content-type': 'application/json',
              'accept': 'application/json',
            },
          ));
    });

    test('should return data if put returns 200', () async {
      when(() => client.put(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response('{}', 200));

      final result = await systemUnderTest.request(url: url, method: 'put');

      expect(result, {});

      verify(() => client.put(
            Uri.parse(url),
            headers: {
              'content-type': 'application/json',
              'accept': 'application/json',
            },
          ));
    });

    test('should return null if put returns 200 with null data', () async {
      when(() => client.put(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response('<!DOCTYPE html>', 200));

      final result = await systemUnderTest.request(url: url, method: 'put');

      expect(result, {});

      verify(() => client.put(
            Uri.parse(url),
            headers: {
              'content-type': 'application/json',
              'accept': 'application/json',
            },
          ));
    });

    test('should return null if put returns 204', () async {
      when(() => client.put(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response('', 204));

      final result = await systemUnderTest.request(url: url, method: 'put');

      expect(result, {});

      verify(() => client.put(
            Uri.parse(url),
            headers: {
              'content-type': 'application/json',
              'accept': 'application/json',
            },
          ));
    });

    test('should return null if put returns 204 with data', () async {
      when(() => client.put(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response('{}', 204));

      final result = await systemUnderTest.request(url: url, method: 'put');

      expect(result, {});

      verify(() => client.put(
            Uri.parse(url),
            headers: {
              'content-type': 'application/json',
              'accept': 'application/json',
            },
          ));
    });

    test('should return bad request erro if put returns 400', () async {
      when(() => client.put(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response('{}', 400));

      final future = systemUnderTest.request(url: url, method: 'put');

      expect(future, throwsA(HttpError.badRequest));

      verify(() => client.put(
            Uri.parse(url),
            headers: {
              'content-type': 'application/json',
              'accept': 'application/json',
            },
          ));
    });

    test('should return unauthorized error if put returns 401', () async {
      when(() => client.put(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response('{}', 401));

      final future = systemUnderTest.request(url: url, method: 'put');

      expect(future, throwsA(HttpError.unauthorized));

      verify(() => client.put(
            Uri.parse(url),
            headers: {
              'content-type': 'application/json',
              'accept': 'application/json',
            },
          ));
    });

    test('should return forbiden error if put returns 403', () async {
      when(() => client.put(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response('{}', 403));

      final future = systemUnderTest.request(url: url, method: 'put');

      expect(future, throwsA(HttpError.forbiden));

      verify(() => client.put(
            Uri.parse(url),
            headers: {
              'content-type': 'application/json',
              'accept': 'application/json',
            },
          ));
    });

    test('should return not found error if put returns 404', () async {
      when(() => client.put(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response('{}', 404));

      final future = systemUnderTest.request(url: url, method: 'put');

      expect(future, throwsA(HttpError.notFound));

      verify(() => client.put(
            Uri.parse(url),
            headers: {
              'content-type': 'application/json',
              'accept': 'application/json',
            },
          ));
    });

    test('should return server error erro if put returns 500', () async {
      when(() => client.put(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response('{}', 500));

      final future = systemUnderTest.request(url: url, method: 'put');

      expect(future, throwsA(HttpError.serverError));

      verify(() => client.put(
            Uri.parse(url),
            headers: {
              'content-type': 'application/json',
              'accept': 'application/json',
            },
          ));
    });

    test('should return server error if put throws', () async {
      when(() => client.put(any(), headers: any(named: 'headers')))
          .thenThrow(Exception());

      final future = systemUnderTest.request(url: url, method: 'put');

      expect(future, throwsA(HttpError.serverError));

      verify(() => client.put(
            Uri.parse(url),
            headers: {
              'content-type': 'application/json',
              'accept': 'application/json',
            },
          ));
    });
  });
}
