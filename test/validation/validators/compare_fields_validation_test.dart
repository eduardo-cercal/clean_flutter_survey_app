import 'package:clean_flutter_login_app/presentation/dependecies/validation.dart';
import 'package:clean_flutter_login_app/validation/dependencies/field_validation.dart';
import 'package:clean_flutter_login_app/validation/validators/compare_fields_validation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late FieldValidation systemUnderTest;

  setUp(() {
    systemUnderTest = CompareFieldsValidation(
        fieldValidate: 'any_field', fieldToCompare: 'other_field');
  });

  test('should return error if values are no equal', () async {
    final map = {
      'any_field': 'any_value',
      'other_field': 'other_value',
    };

    final result = systemUnderTest.validate(map);

    expect(result, ValidationError.invalidField);
  });

  test('should return null if values are equal', () async {
    final map = {
      'any_field': 'any_value',
      'other_field': 'any_value',
    };
    final result = systemUnderTest.validate(map);

    expect(result, null);
  });
}
