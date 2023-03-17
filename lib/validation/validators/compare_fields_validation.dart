import 'package:equatable/equatable.dart';

import '../../presentation/dependecies/validation.dart';
import '../dependencies/field_validation.dart';

class CompareFieldsValidation extends Equatable implements FieldValidation {
  final String fieldValidate;
  final String fieldToCompare;

  const CompareFieldsValidation(
      {required this.fieldValidate, required this.fieldToCompare});

  @override
  String get field => fieldValidate;

  @override
  ValidationError? validate(Map? input) {
    return input?[fieldValidate] != null &&
            input?[fieldValidate] == input?[fieldToCompare]
        ? null
        : ValidationError.invalidField;
  }

  @override
  List<Object?> get props => [
        fieldValidate,
        fieldToCompare,
      ];
}
