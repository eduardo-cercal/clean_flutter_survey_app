import 'package:clean_flutter_login_app/data/cache/cache_storage.dart';
import 'package:clean_flutter_login_app/infra/cache/local_storage_adapter.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:localstorage/localstorage.dart';
import 'package:mocktail/mocktail.dart';

class MockLocalStorage extends Mock implements LocalStorage {}

void main() {
  late LocalStorage localStorage;
  late CacheStorage systemUnderTest;
  late String key;
  late dynamic value;

  When mockLocalStorageDeleteItemCall() =>
      when(() => localStorage.deleteItem(any()));

  When mockLocalStorageSetItemCall() =>
      when(() => localStorage.setItem(any(), any()));

  When mockLocalStorageGetItemCall() => when(() => localStorage.getItem(any()));

  void mockLocalStorage() {
    mockLocalStorageDeleteItemCall().thenAnswer((_) async {});
    mockLocalStorageSetItemCall().thenAnswer((_) async {});
    mockLocalStorageGetItemCall().thenAnswer((_) async => value);
  }

  void mockLocalStorageDeleteItemError() =>
      mockLocalStorageDeleteItemCall().thenThrow(Exception());

  void mockLocalStorageSetItemError() =>
      mockLocalStorageSetItemCall().thenThrow(Exception());

  setUp(() {
    localStorage = MockLocalStorage();
    systemUnderTest = LocalStorageAdapter(localStorage);
    key = faker.randomGenerator.string(5);
    value = faker.randomGenerator.string(50);
    mockLocalStorage();
  });

  group('save', () {
    test('should calls local storage with correct values', () async {
      await systemUnderTest.save(key: key, value: value);

      verify(() => localStorage.deleteItem(key)).called(1);
      verify(() => localStorage.setItem(key, value)).called(1);
    });

    test('should throw if deleteItem throws', () async {
      mockLocalStorageDeleteItemError();
      final future = systemUnderTest.save(key: key, value: value);
      expect(future, throwsA(const TypeMatcher<Exception>()));
    });

    test('should throw if setItem throws', () async {
      mockLocalStorageSetItemError();
      final future = systemUnderTest.save(key: key, value: value);
      expect(future, throwsA(const TypeMatcher<Exception>()));
    });
  });

  group('delete', () {
    test('should call local storage with correct values', () async {
      await systemUnderTest.delete(key);

      verify(() => localStorage.deleteItem(key)).called(1);
    });

    test('should throw if deleteItem throws', () async {
      mockLocalStorageDeleteItemError();
      final future = systemUnderTest.save(key: key, value: value);
      expect(future, throwsA(const TypeMatcher<Exception>()));
    });
  });

  group('fetch', () {
    test('should call local storage with correct values', () async {
      await systemUnderTest.fetch(key);

      verify(() => localStorage.getItem(key)).called(1);
    });

    test('should return same value as localStorage', () async {
      final result = await systemUnderTest.fetch(key);

      expect(result, value);
    });

    test('should throw if deleteItem throws', () async {
      mockLocalStorageDeleteItemError();
      final future = systemUnderTest.save(key: key, value: value);
      expect(future, throwsA(const TypeMatcher<Exception>()));
    });
  });
}
