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

  Future<void> auth() async {
    await httpClient.request(url: url);
  }
}

abstract class HttpClient {
  Future<void> request({required String url});
}

class MockHttpClient extends Mock implements HttpClient {}

void main() {
  test('should call http client with the current URL', () async {
    final httpClient = MockHttpClient();
    final url = faker.internet.httpUrl();
    final systemUnderTest = RemoteAuthentication(
      httpClient: httpClient,
      url: url,
    );

    when(() => httpClient.request(url: any(named: 'url')))
        .thenAnswer((_) async {});

    await systemUnderTest.auth();

    verify(() => httpClient.request(url: url));
  });
}
