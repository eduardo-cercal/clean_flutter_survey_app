import 'package:clean_flutter_login_app/data/cache/fetch_secure_cache_storage.dart';
import 'package:clean_flutter_login_app/data/http/http.error.dart';
import 'package:clean_flutter_login_app/data/http/http_client.dart';
import 'package:clean_flutter_login_app/main/decorator/authorize_http_client_decorator.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFetchSecureCacheStorage extends Mock
    implements FetchSecureCacheStorage {}

class MockHttpClient extends Mock implements HttpClient {}

void main() {
  late FetchSecureCacheStorage fetchSecureCacheStorage;
  late HttpClient httpClient;
  late HttpClient systemUnderTest;
  final url = faker.internet.httpUrl();
  final method = faker.randomGenerator.string(10);
  final body = {'any_key': 'any_value'};
  final token = faker.guid.guid();
  final httpResponse = faker.randomGenerator.string(10);

  When mockFetchSecureCacheStorageCall() =>
      when(() => fetchSecureCacheStorage.fetchSecure(any()));

  void mockFetchSecureCacheStorage() =>
      mockFetchSecureCacheStorageCall().thenAnswer((_) async => token);

  void mockFetchSecureCacheStorageError() =>
      mockFetchSecureCacheStorageCall().thenThrow(Exception());

  When mockDecorateeCall() => when(() => httpClient.request(
        url: any(named: 'url'),
        method: any(named: 'method'),
        body: any(named: 'body'),
        headers: any(named: 'headers'),
      ));

  void mockDecoratee() =>
      mockDecorateeCall().thenAnswer((_) async => httpResponse);

  void mockDecorateeError(HttpError error) =>
      mockDecorateeCall().thenThrow(error);

  setUp(() {
    fetchSecureCacheStorage = MockFetchSecureCacheStorage();
    httpClient = MockHttpClient();
    systemUnderTest = AuthorizeHttpClientDecorator(
      fetchSecureCacheStorage: fetchSecureCacheStorage,
      decoratee: httpClient,
    );
    mockFetchSecureCacheStorage();
    mockDecoratee();
  });

  test('should call FetchSecureCacheStorage with correct value', () async {
    await systemUnderTest.request(
      url: url,
      method: method,
      body: body,
    );

    verify(() => fetchSecureCacheStorage.fetchSecure('token')).called(1);
  });

  test('should call decoratee with access token on header', () async {
    await systemUnderTest.request(
      url: url,
      method: method,
      body: body,
    );
    verify(() => httpClient.request(
          url: url,
          method: method,
          body: body,
          headers: {'x-access-token': token},
        )).called(1);

    await systemUnderTest.request(
      url: url,
      method: method,
      body: body,
      headers: {'any_header': 'any_value'},
    );
    verify(() => httpClient.request(
          url: url,
          method: method,
          body: body,
          headers: {
            'x-access-token': token,
            'any_header': 'any_value',
          },
        )).called(1);
  });

  test('should return same result as decoratee', () async {
    final result = await systemUnderTest.request(
      url: url,
      method: method,
      body: body,
    );

    expect(result, httpResponse);
  });

  test('should throw forbiden error if FetchSecureCacheStorage throws',
      () async {
    mockFetchSecureCacheStorageError();

    final future = systemUnderTest.request(
      url: url,
      method: method,
      body: body,
    );

    expect(future, throwsA(HttpError.forbiden));
  });

  test('should rethrow if decoratee throws', () async {
    mockDecorateeError(HttpError.badRequest);

    final future = systemUnderTest.request(
      url: url,
      method: method,
      body: body,
    );

    expect(future, throwsA(HttpError.badRequest));
  });
}
