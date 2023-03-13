import 'package:equatable/equatable.dart';

import 'dependencies/field_validation.dart';

class RequiredFieldValidation extends Equatable implements FieldValidation {
  final String fieldValidator;

  const RequiredFieldValidation(this.fieldValidator);

  @override
  String get field => fieldValidator;

  @override
  String? validate(String? value) {
    return value?.isNotEmpty == true ? null : 'campo obrigatorio';
  }

  @override
  List<Object?> get props => [field];
}
