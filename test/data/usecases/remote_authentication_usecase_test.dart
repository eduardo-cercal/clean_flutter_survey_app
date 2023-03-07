import 'package:clean_flutter_login_app/data/http/http.error.dart';
import 'package:clean_flutter_login_app/data/http/http_client.dart';
import 'package:clean_flutter_login_app/data/usecases/remote_authentication_usecase.dart';
import 'package:clean_flutter_login_app/domain/entities/authentication_params_entity.dart';
import 'package:clean_flutter_login_app/utils/constants.dart';
import 'package:clean_flutter_login_app/utils/domain_error.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockHttpClient extends Mock implements HttpClient {}

void main() {
  late HttpClient httpClient;
  late String url;
  late RemoteAuthentication systemUnderTest;
  late AuthenticationParamsEntity params;

  setUp(() {
    httpClient = MockHttpClient();
    url = faker.internet.httpUrl();
    systemUnderTest = RemoteAuthentication(
      httpClient: httpClient,
      url: url,
    );
    params = AuthenticationParamsEntity(
      email: faker.internet.email(),
      password: faker.internet.password(),
    );
  });

  test('should call http client with the current values', () async {
    when(() => httpClient.request(
          url: any(named: 'url'),
          method: any(named: 'method'),
          body: any(named: 'body'),
        )).thenAnswer((_) async => {
          tokenKey: faker.guid.guid(),
          nameKey: faker.person.name(),
        });

    await systemUnderTest.auth(params);

    verify(() => httpClient.request(
          url: url,
          method: 'post',
          body: {
            emailKey: params.email,
            passwordKey: params.password,
          },
        ));
  });

  test('should throw an unexpected error if http client return 400', () async {
    when(() => httpClient.request(
          url: any(named: 'url'),
          method: any(named: 'method'),
          body: any(named: 'body'),
        )).thenThrow(HttpError.badRequest);

    final future = systemUnderTest.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('should throw an unexpected error if http client return 404', () async {
    when(() => httpClient.request(
          url: any(named: 'url'),
          method: any(named: 'method'),
          body: any(named: 'body'),
        )).thenThrow(HttpError.notFound);

    final future = systemUnderTest.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('should throw an unexpected error if http client return 500', () async {
    when(() => httpClient.request(
          url: any(named: 'url'),
          method: any(named: 'method'),
          body: any(named: 'body'),
        )).thenThrow(HttpError.serverError);

    final future = systemUnderTest.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('should throw a invalid credentials error if http client return 401',
      () async {
    when(() => httpClient.request(
          url: any(named: 'url'),
          method: any(named: 'method'),
          body: any(named: 'body'),
        )).thenThrow(HttpError.unauthorized);

    final future = systemUnderTest.auth(params);

    expect(future, throwsA(DomainError.invalidCredentials));
  });

  test('should return an account if http client return 200', () async {
    final token = faker.guid.guid();

    when(() => httpClient.request(
          url: any(named: 'url'),
          method: any(named: 'method'),
          body: any(named: 'body'),
        )).thenAnswer((_) async => {
          tokenKey: token,
          nameKey: faker.person.name(),
        });

    final result = await systemUnderTest.auth(params);

    expect(result.token, token);
  });
}
