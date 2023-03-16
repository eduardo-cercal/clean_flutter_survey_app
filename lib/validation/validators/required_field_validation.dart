import 'package:clean_flutter_login_app/presentation/dependecies/validation.dart';
import 'package:equatable/equatable.dart';

import '../dependencies/field_validation.dart';

class RequiredFieldValidation extends Equatable implements FieldValidation {
  final String fieldValidator;

  const RequiredFieldValidation(this.fieldValidator);

  @override
  String get field => fieldValidator;

  @override
  ValidationError? validate(Map? input) {
    return input?[fieldValidator]?.isNotEmpty == true
        ? null
        : ValidationError.requiredField;
  }

  @override
  List<Object?> get props => [field];
}
