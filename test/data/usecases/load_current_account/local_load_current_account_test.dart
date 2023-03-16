import 'package:clean_flutter_login_app/data/cache/fetch_secure_cache_storage.dart';
import 'package:clean_flutter_login_app/data/usecases/load_current_account/local_load_current_account.dart';
import 'package:clean_flutter_login_app/domain/entities/account_entity.dart';
import 'package:clean_flutter_login_app/domain/helpers/errors/domain_error.dart';
import 'package:clean_flutter_login_app/domain/usecases/load_current_account.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFetchSecureCacheStorage extends Mock
    implements FetchSecureCacheStorage {}

void main() {
  late FetchSecureCacheStorage fetchSecureCacheStorage;
  late LoadCurrentAccount systemUnderTest;
  final token = faker.guid.guid();

  setUp(() {
    fetchSecureCacheStorage = MockFetchSecureCacheStorage();
    systemUnderTest = LocalLoadCurrentAccount(fetchSecureCacheStorage);
  });

  test('should call FetchSecureCacheStorage with correct value', () async {
    when(() => fetchSecureCacheStorage.fetchSecure(any()))
        .thenAnswer((_) async => token);

    await systemUnderTest.load();

    verify(() => fetchSecureCacheStorage.fetchSecure('token')).called(1);
  });

  test('should return a account entity', () async {
    when(() => fetchSecureCacheStorage.fetchSecure(any()))
        .thenAnswer((_) async => token);

    final result = await systemUnderTest.load();

    expect(result, AccountEntity(token));
  });

  test('should throw a error when try to fetch without success', () async {
    when(() => fetchSecureCacheStorage.fetchSecure(any()))
        .thenThrow(Exception());

    final future = systemUnderTest.load();

    expect(future, throwsA(DomainError.unexpected));
  });
}
