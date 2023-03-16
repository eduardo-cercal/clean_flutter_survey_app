import 'package:clean_flutter_login_app/main/factories/pages/login/login_validation_factory.dart';
import 'package:clean_flutter_login_app/validation/validators/email_validation.dart';
import 'package:clean_flutter_login_app/validation/validators/min_length_validation.dart';
import 'package:clean_flutter_login_app/validation/validators/required_field_validation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('should return the correct validation', () async {
    final result = makeLoginValidations();

    expect(result, const [
      RequiredFieldValidation('email'),
      EmailValidation('email'),
      RequiredFieldValidation('password'),
      MinLengthValidation(
        fieldValidate: 'password',
        size: 3,
      ),
    ]);
  });
}
