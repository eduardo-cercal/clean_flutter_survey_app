import 'package:clean_flutter_login_app/presentation/dependecies/validation.dart';
import 'package:clean_flutter_login_app/validation/validators/dependencies/field_validation.dart';
import 'package:clean_flutter_login_app/validation/validators/validation_composite.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFieldValidation extends Mock implements FieldValidation {}

void main() {
  late FieldValidation validation1;
  late FieldValidation validation2;
  late FieldValidation validation3;
  late Validation systemUnderTest;

  void mockValidation1({String? error}) {
    when(() => validation1.validate(any())).thenReturn(error);
  }

  void mockValidation2({String? error}) {
    when(() => validation2.validate(any())).thenReturn(error);
  }

  void mockValidation3({String? error}) {
    when(() => validation3.validate(any())).thenReturn(error);
  }

  void mockValidators() {
    when(() => validation1.field).thenReturn('other_field');
    when(() => validation2.field).thenReturn('any_field');
    when(() => validation3.field).thenReturn('any_field');
  }

  setUp(() {
    validation1 = MockFieldValidation();
    validation2 = MockFieldValidation();
    validation3 = MockFieldValidation();
    systemUnderTest = ValidationComposite([
      validation1,
      validation2,
      validation3,
    ]);

    mockValidators();
    mockValidation1();
    mockValidation2();
    mockValidation3();
  });

  test('should return null if all validations returns null or empty', () async {
    mockValidation2(error: '');

    final result =
        systemUnderTest.validate(field: 'any_field', value: 'any_value');

    expect(result, null);
  });

  test('should return the first error on the list', () async {
    mockValidation1(error: 'error_1');
    mockValidation2(error: 'error_2');
    mockValidation3(error: 'error_3');

    final result =
        systemUnderTest.validate(field: 'any_field', value: 'any_value');

    expect(result, 'error_2');
  });
}
