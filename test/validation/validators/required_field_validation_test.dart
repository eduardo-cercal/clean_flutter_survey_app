import 'package:clean_flutter_login_app/presentation/dependecies/validation.dart';
import 'package:clean_flutter_login_app/validation/dependencies/field_validation.dart';
import 'package:clean_flutter_login_app/validation/validators/required_field_validation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late FieldValidation systerUnderTest;

  setUp(() {
    systerUnderTest = const RequiredFieldValidation('any_field');
  });

  test('should return null if value is not empty', () async {
    final result = systerUnderTest.validate({'any_field': 'any_value'});

    expect(result, null);
  });

  test('should return error if value is empty', () async {
    final result = systerUnderTest.validate({'any_field': ''});

    expect(result, ValidationError.requiredField);
  });

  test('should return error if value null', () async {
    final result = systerUnderTest.validate(null);

    expect(result, ValidationError.requiredField);
  });
}
