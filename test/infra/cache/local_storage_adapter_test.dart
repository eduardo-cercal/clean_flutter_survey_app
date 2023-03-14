import 'package:clean_flutter_login_app/infra/cache/local_storage_adapter.dart';
import 'package:faker/faker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  late FlutterSecureStorage storage;
  late LocalStorageAdapter systemUnderTest;
  final key = faker.lorem.word();
  final value = faker.guid.guid();

  setUp(() {
    storage = MockFlutterSecureStorage();
    systemUnderTest = LocalStorageAdapter(storage);
  });

  group('save secure test', () {
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
  });

  group('fetch secure test', () {
    test('should call fetch secure with correct values', () async {
      when(() => storage.read(key: any(named: 'key')))
          .thenAnswer((_) async => value);

      await systemUnderTest.fetchSecure(key);

      verify(() => storage.read(key: key)).called(1);
    });

    test('should return correct value on success', () async {
      when(() => storage.read(key: any(named: 'key')))
          .thenAnswer((_) async => value);

      final result = await systemUnderTest.fetchSecure(key);

      expect(result, value);
    });

    test(
        'should throw a error message when try to call the method without the current values',
        () async {
      when(() => storage.read(key: any(named: 'key'))).thenThrow(Exception());

      final future = systemUnderTest.fetchSecure(key);

      expect(future, throwsA(const TypeMatcher<Exception>()));
    });
  });
}
