import 'package:clean_flutter_login_app/presentation/dependecies/validation.dart';
import 'package:clean_flutter_login_app/validation/dependencies/field_validation.dart';
import 'package:clean_flutter_login_app/validation/validators/min_length_validation.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late FieldValidation systemUnderTest;

  setUp(() {
    systemUnderTest = MinLengthValidation(fieldValidate: 'any_field', size: 5);
  });

  test('should return error if value is empty', () async {
    final result = systemUnderTest.validate({'any_field': ''});

    expect(result, ValidationError.invalidField);
  });

  test('should return error if value is null', () async {
    final result = systemUnderTest.validate({'any_field': null});

    expect(result, ValidationError.invalidField);
  });

  test('should return error if value is less then min size', () async {
    final result = systemUnderTest
        .validate({'any_field': faker.randomGenerator.string(4, min: 1)});

    expect(result, ValidationError.invalidField);
  });

  test('should return null if value is equal then min size', () async {
    final result = systemUnderTest
        .validate({'any_field': faker.randomGenerator.string(5, min: 5)});

    expect(result, null);
  });

  test('should return null if value is higther then min size', () async {
    final result = systemUnderTest
        .validate({'any_field': faker.randomGenerator.string(8, min: 6)});

    expect(result, null);
  });
}
