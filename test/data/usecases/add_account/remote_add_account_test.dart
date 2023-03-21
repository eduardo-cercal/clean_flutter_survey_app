import 'package:clean_flutter_login_app/data/http/http.error.dart';
import 'package:clean_flutter_login_app/data/http/http_client.dart';
import 'package:clean_flutter_login_app/data/usecases/add_account/remote_add_account.dart';
import 'package:clean_flutter_login_app/domain/entities/add_account_params_entity.dart';
import 'package:clean_flutter_login_app/data/helpers/constants.dart';
import 'package:clean_flutter_login_app/domain/helpers/errors/domain_error.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockHttpClient extends Mock implements HttpClient {}

void main() {
  late HttpClient httpClient;
  late String url;
  late RemoteAddAccount systemUnderTest;
  late AddAccountParamsEntity params;
  final password = faker.internet.password();

  setUp(() {
    httpClient = MockHttpClient();
    url = faker.internet.httpUrl();
    systemUnderTest = RemoteAddAccount(
      httpClient: httpClient,
      url: url,
    );
    params = AddAccountParamsEntity(
      email: faker.internet.email(),
      password: password,
      name: faker.person.name(),
      passwordConfirmation: password,
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

    await systemUnderTest.add(params);

    verify(() => httpClient.request(
          url: url,
          method: 'post',
          body: {
            nameKey: params.name,
            emailKey: params.email,
            passwordKey: params.password,
            passwordConfirmationKey: params.passwordConfirmation,
          },
        ));
  });

  test('should throw an unexpected error if http client return 400', () async {
    when(() => httpClient.request(
          url: any(named: 'url'),
          method: any(named: 'method'),
          body: any(named: 'body'),
        )).thenThrow(HttpError.badRequest);

    final future = systemUnderTest.add(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('should throw an unexpected error if http client return 404', () async {
    when(() => httpClient.request(
          url: any(named: 'url'),
          method: any(named: 'method'),
          body: any(named: 'body'),
        )).thenThrow(HttpError.notFound);

    final future = systemUnderTest.add(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('should throw an unexpected error if http client return 500', () async {
    when(() => httpClient.request(
          url: any(named: 'url'),
          method: any(named: 'method'),
          body: any(named: 'body'),
        )).thenThrow(HttpError.serverError);

    final future = systemUnderTest.add(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('should throw a email in use error if http client return 403', () async {
    when(() => httpClient.request(
          url: any(named: 'url'),
          method: any(named: 'method'),
          body: any(named: 'body'),
        )).thenThrow(HttpError.forbiden);

    final future = systemUnderTest.add(params);

    expect(future, throwsA(DomainError.emailInUse));
  });

  test('should return a account if return 200', () async {
    final token = faker.guid.guid();

    when(() => httpClient.request(
          url: any(named: 'url'),
          method: any(named: 'method'),
          body: any(named: 'body'),
        )).thenAnswer((_) async => {
          tokenKey: token,
          nameKey: faker.person.name(),
        });

    final result = await systemUnderTest.add(params);

    expect(result.token, token);
  });

  test(
      'should return an account if http client return 200 with invalid response',
      () async {
    when(() => httpClient.request(
          url: any(named: 'url'),
          method: any(named: 'method'),
          body: any(named: 'body'),
        )).thenAnswer((_) async => {'invalid': 'invalid'});

    final future = systemUnderTest.add(params);

    expect(future, throwsA(DomainError.unexpected));
  });
}
