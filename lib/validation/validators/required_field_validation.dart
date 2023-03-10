import 'dependencies/field_validation.dart';

class RequiredFieldValidation implements FieldValidation {
  final String fieldValidator;

  RequiredFieldValidation(this.fieldValidator);

  @override
  String get field => fieldValidator;

  @override
  String? validate(String? value) {
    return value?.isNotEmpty == true ? null : 'campo obrigatorio';
  }
}
