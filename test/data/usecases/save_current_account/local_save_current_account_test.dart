import 'package:clean_flutter_login_app/data/cache/save_secure_cache_storage.dart';
import 'package:clean_flutter_login_app/data/usecases/save_current_account/local_save_current_account.dart';
import 'package:clean_flutter_login_app/domain/entities/account_entity.dart';
import 'package:clean_flutter_login_app/domain/usecases/save_current_account.dart';
import 'package:clean_flutter_login_app/domain/helpers/errors/domain_error.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSaveSecureCacheStorage extends Mock
    implements SaveSecureCacheStorage {}

void main() {
  late SaveSecureCacheStorage saveSecureCacheStorage;
  late SaveCurrentAccount systemUnderTest;
  late AccountEntity mockAccount;

  setUp(() {
    saveSecureCacheStorage = MockSaveSecureCacheStorage();
    systemUnderTest =
        LocalSaveCurrentAccount(saveSecureCacheStorage: saveSecureCacheStorage);
    mockAccount = AccountEntity(faker.guid.guid());
  });

  test('should call SaveSecureCacheStorage with correct values', () async {
    when(() => saveSecureCacheStorage.save(
          key: any(named: 'key'),
          value: any(named: 'value'),
        )).thenAnswer((_) async {});

    await systemUnderTest.save(mockAccount);

    verify(() =>
        saveSecureCacheStorage.save(key: 'token', value: mockAccount.token));
  });

  test('should throw a unexpected error if SaveSecureCacheStorage throws',
      () async {
    when(() => saveSecureCacheStorage.save(
          key: any(named: 'key'),
          value: any(named: 'value'),
        )).thenThrow(Exception());

    final future = systemUnderTest.save(mockAccount);

    expect(future, throwsA(DomainError.unexpected));

    verify(() =>
        saveSecureCacheStorage.save(key: 'token', value: mockAccount.token));
  });
}
