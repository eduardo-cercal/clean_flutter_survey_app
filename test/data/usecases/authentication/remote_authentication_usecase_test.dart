import 'package:clean_flutter_login_app/data/http/http.error.dart';
import 'package:clean_flutter_login_app/data/http/http_client.dart';
import 'package:clean_flutter_login_app/data/usecases/authentication/remote_authentication_usecase.dart';
import 'package:clean_flutter_login_app/domain/entities/authentication_params_entity.dart';
import 'package:clean_flutter_login_app/data/helpers/constants.dart';
import 'package:clean_flutter_login_app/domain/helpers/errors/domain_error.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks/fake_account_factory.dart';
import '../../../mocks/fake_params_factory.dart';

class MockHttpClient extends Mock implements HttpClient {}

void main() {
  late HttpClient httpClient;
  late String url;
  late RemoteAuthentication systemUnderTest;
  late AuthenticationParamsEntity params;
  late Map<String, dynamic> apiResult;

  When mockHttpDataCall() => when(() => httpClient.request(
        url: any(named: 'url'),
        method: any(named: 'method'),
        body: any(named: 'body'),
      ));

  void mockHttpData(Map<String, dynamic> data) {
    apiResult = data;
    mockHttpDataCall().thenAnswer((_) async => apiResult);
  }

  void mockHttpDataError(HttpError error) =>
      mockHttpDataCall().thenThrow(error);

  setUp(() {
    httpClient = MockHttpClient();
    url = faker.internet.httpUrl();
    systemUnderTest = RemoteAuthentication(
      httpClient: httpClient,
      url: url,
    );
    params = FakeParamsFactory.makeAuthentication();
    mockHttpData(FakeAccountFactory.makeApiJson());
  });

  test('should call http client with the current values', () async {
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
    mockHttpDataError(HttpError.badRequest);

    final future = systemUnderTest.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('should throw an unexpected error if http client return 404', () async {
    mockHttpDataError(HttpError.notFound);

    final future = systemUnderTest.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('should throw an unexpected error if http client return 500', () async {
    mockHttpDataError(HttpError.serverError);

    final future = systemUnderTest.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('should throw a invalid credentials error if http client return 401',
      () async {
    mockHttpDataError(HttpError.unauthorized);

    final future = systemUnderTest.auth(params);

    expect(future, throwsA(DomainError.invalidCredentials));
  });

  test('should unexpected error if http client return 200', () async {
    final result = await systemUnderTest.auth(params);

    expect(result.token, apiResult['accessToken']);
  });

  test(
      'should return an account if http client return 200 with invalid response',
      () async {
    mockHttpData({'invalid': 'invalid'});

    final future = systemUnderTest.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });
}
