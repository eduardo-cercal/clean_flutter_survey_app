import 'package:clean_flutter_login_app/domain/entities/authentication_params_entity.dart';
import 'package:clean_flutter_login_app/domain/usecases/authentication_usecase.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class RemoteAuthentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({
    required this.httpClient,
    required this.url,
  });

  Future<void> auth(AuthenticationParamsEntity params) async {
    final body = {'email': params.email, 'password': params.password};
    await httpClient.request(url: url, method: 'post', body: body);
  }
}

abstract class HttpClient {
  Future<void> request({
    required String url,
    required String method,
    Map<String, dynamic> body,
  });
}

class MockHttpClient extends Mock implements HttpClient {}

void main() {
  late HttpClient httpClient;
  late String url;
  late RemoteAuthentication systemUnderTest;

  setUp(() {
    httpClient = MockHttpClient();
    url = faker.internet.httpUrl();
    systemUnderTest = RemoteAuthentication(
      httpClient: httpClient,
      url: url,
    );
  });

  test('should call http client with the current values', () async {
    final params = AuthenticationParamsEntity(
        email: faker.internet.email(), password: faker.internet.password());

    when(() => httpClient.request(
        url: any(named: 'url'),
        method: any(named: 'method'),
        body: any(named: 'body'))).thenAnswer((_) async {});

    await systemUnderTest.auth(params);

    verify(() => httpClient.request(url: url, method: 'post', body: {
          'email': params.email,
          'password': params.password,
        }));
  });
}
