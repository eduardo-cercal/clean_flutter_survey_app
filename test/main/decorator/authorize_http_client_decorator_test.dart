import 'package:clean_flutter_login_app/data/cache/delete_secure_cache_storage.dart';
import 'package:clean_flutter_login_app/data/cache/fetch_secure_cache_storage.dart';
import 'package:clean_flutter_login_app/data/http/http.error.dart';
import 'package:clean_flutter_login_app/data/http/http_client.dart';
import 'package:clean_flutter_login_app/main/decorator/authorize_http_client_decorator.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFetchSecureCacheStorage extends Mock
    implements FetchSecureCacheStorage {}

class MockDeleteSecureCacheStorage extends Mock
    implements DeleteSecureCacheStorage {}

class MockHttpClient extends Mock implements HttpClient {}

void main() {
  late FetchSecureCacheStorage fetchSecureCacheStorage;
  late DeleteSecureCacheStorage deleteSecureCacheStorage;
  late HttpClient httpClient;
  late HttpClient systemUnderTest;
  final url = faker.internet.httpUrl();
  final method = faker.randomGenerator.string(10);
  final body = {'any_key': 'any_value'};
  final token = faker.guid.guid();
  final httpResponse = faker.randomGenerator.string(10);

  When mockFetchSecureCacheStorageCall() =>
      when(() => fetchSecureCacheStorage.fetch(any()));

  void mockFetchSecureCacheStorage() =>
      mockFetchSecureCacheStorageCall().thenAnswer((_) async => token);

  void mockFetchSecureCacheStorageError() =>
      mockFetchSecureCacheStorageCall().thenThrow(Exception());

  When mockDeleteSecureCacheStorageCall() =>
      when(() => deleteSecureCacheStorage.delete(any()));

  void mockDeleteSecureCacheStorage() =>
      mockDeleteSecureCacheStorageCall().thenAnswer((_) async => token);

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
    deleteSecureCacheStorage = MockDeleteSecureCacheStorage();
    httpClient = MockHttpClient();
    systemUnderTest = AuthorizeHttpClientDecorator(
      fetchSecureCacheStorage: fetchSecureCacheStorage,
      deleteSecureCacheStorage: deleteSecureCacheStorage,
      decoratee: httpClient,
    );
    mockFetchSecureCacheStorage();
    mockDeleteSecureCacheStorage();
    mockDecoratee();
  });

  test('should call FetchSecureCacheStorage with correct value', () async {
    await systemUnderTest.request(
      url: url,
      method: method,
      body: body,
    );

    verify(() => fetchSecureCacheStorage.fetch('token')).called(1);
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
    verify(() => deleteSecureCacheStorage.delete('token')).called(1);
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

  test('should delete cache if request throws Forbidden error', () async {
    mockDecorateeError(HttpError.forbiden);

    final future = systemUnderTest.request(
      url: url,
      method: method,
      body: body,
    );
    await untilCalled(() => deleteSecureCacheStorage.delete('token'));

    expect(future, throwsA(HttpError.forbiden));
    verify(() => deleteSecureCacheStorage.delete('token')).called(1);
  });
}
