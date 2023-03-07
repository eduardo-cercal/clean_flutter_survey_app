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
    await httpClient.request(url: url, method: 'post');
  }
}

abstract class HttpClient {
  Future<void> request({required String url, required String method});
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
    when(() => httpClient.request(
        url: any(named: 'url'),
        method: any(named: 'method'))).thenAnswer((_) async {});

    await systemUnderTest.auth();

    verify(() => httpClient.request(url: url, method: 'post'));
  });
}
