import 'package:equatable/equatable.dart';

import '../../presentation/dependecies/validation.dart';
import '../dependencies/field_validation.dart';

class MinLengthValidation extends Equatable implements FieldValidation {
  final String fieldValidate;
  final int size;

  const MinLengthValidation({required this.fieldValidate, required this.size});

  @override
  String get field => fieldValidate;

  @override
  ValidationError? validate(Map? input) {
    return input?[fieldValidate] != null && input?[fieldValidate].length >= size
        ? null
        : ValidationError.invalidField;
  }

  @override
  List<Object?> get props => [
        fieldValidate,
        size,
      ];
}
