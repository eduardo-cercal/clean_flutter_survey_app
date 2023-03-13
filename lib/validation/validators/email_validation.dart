import 'package:equatable/equatable.dart';

import 'dependencies/field_validation.dart';

class EmailValidation extends Equatable implements FieldValidation {
  final String fieldValidator;

  const EmailValidation(this.fieldValidator);

  @override
  String get field => fieldValidator;

  @override
  String? validate(String? value) {
    final regex = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

    if (value == null) return null;

    if (value.isEmpty) return null;

    return regex.hasMatch(value) ? null : 'campo invalido';
  }

  @override
  List<Object?> get props => [fieldValidator];
}
