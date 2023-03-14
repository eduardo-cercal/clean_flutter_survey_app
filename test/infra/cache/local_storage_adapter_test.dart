import 'package:clean_flutter_login_app/data/cache/save_secure_cache_storage.dart';
import 'package:clean_flutter_login_app/infra/cache/local_storage_adapter.dart';
import 'package:faker/faker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  late FlutterSecureStorage storage;
  late SaveSecureCacheStorage systemUnderTest;
  final key = faker.lorem.word();
  final value = faker.guid.guid();

  setUp(() {
    storage = MockFlutterSecureStorage();
    systemUnderTest = LocalStorageAdapter(storage);
  });

  test('should call save secure with correct values', () async {
    when(() =>
            storage.write(key: any(named: 'key'), value: any(named: 'value')))
        .thenAnswer((_) async {});

    await systemUnderTest.saveSecure(key: key, value: value);

    verify(() => storage.write(key: key, value: value)).called(1);
  });

  test(
      'should throw a error message when try to call the method without the current values',
      () async {
    when(() =>
            storage.write(key: any(named: 'key'), value: any(named: 'value')))
        .thenThrow(Exception());

    final future = systemUnderTest.saveSecure(key: key, value: value);

    expect(future, throwsA(const TypeMatcher<Exception>()));
  });
}
