import 'package:clean_flutter_login_app/main/factories/pages/login/login_validation_factory.dart';
import 'package:clean_flutter_login_app/main/factories/pages/sign_up/sign_up_validation_factory.dart';
import 'package:clean_flutter_login_app/validation/validators/compare_fields_validation.dart';
import 'package:clean_flutter_login_app/validation/validators/email_validation.dart';
import 'package:clean_flutter_login_app/validation/validators/min_length_validation.dart';
import 'package:clean_flutter_login_app/validation/validators/required_field_validation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('should return the correct validation', () async {
    final result = makeSignUpValidations();

    expect(result, const [
      RequiredFieldValidation('name'),
      MinLengthValidation(fieldValidate: 'name', size: 3),
      RequiredFieldValidation('email'),
      EmailValidation('email'),
      RequiredFieldValidation('password'),
      MinLengthValidation(
        fieldValidate: 'password',
        size: 3,
      ),
      RequiredFieldValidation('passwordConfirmation'),
      CompareFieldsValidation(
          fieldValidate: 'passwordConfirmation', fieldToCompare: 'password'),
    ]);
  });
}
