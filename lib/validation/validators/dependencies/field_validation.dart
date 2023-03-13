import 'package:equatable/equatable.dart';

abstract class FieldValidation {
  String get field;

  String? validate(String? value);
}
