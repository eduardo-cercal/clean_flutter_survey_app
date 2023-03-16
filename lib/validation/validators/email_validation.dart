import 'package:clean_flutter_login_app/presentation/dependecies/validation.dart';
import 'package:equatable/equatable.dart';

import '../dependencies/field_validation.dart';

class EmailValidation extends Equatable implements FieldValidation {
  final String fieldValidator;

  const EmailValidation(this.fieldValidator);

  @override
  String get field => fieldValidator;

  @override
  ValidationError? validate(Map? input) {
    final regex = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

    if (input?[fieldValidator] == null) return null;

    if (input?[fieldValidator].isEmpty) return null;

    return regex.hasMatch(input?[fieldValidator])
        ? null
        : ValidationError.invalidField;
  }

  @override
  List<Object?> get props => [fieldValidator];
}
