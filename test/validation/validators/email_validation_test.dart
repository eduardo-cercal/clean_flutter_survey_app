import 'package:clean_flutter_login_app/presentation/dependecies/validation.dart';
import 'package:clean_flutter_login_app/validation/dependencies/field_validation.dart';
import 'package:clean_flutter_login_app/validation/validators/email_validation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late FieldValidation systemUderTest;

  setUp(() {
    systemUderTest = const EmailValidation('any_field');
  });

  test('should return null if email is empty', () async {
    final result = systemUderTest.validate({'any_field': ''});

    expect(result, null);
  });

  test('should return null if email is null', () async {
    final result = systemUderTest.validate({'any_field': null});

    expect(result, null);
  });

  test('should return null if email is valid', () async {
    final result =
        systemUderTest.validate({'any_field': 'eddy-dudu@hotmail.com'});

    expect(result, null);
  });

  test('should return error if email is invalid', () async {
    final result = systemUderTest.validate({'any_field': 'eddy-dudu'});

    expect(result, ValidationError.invalidField);
  });
}
