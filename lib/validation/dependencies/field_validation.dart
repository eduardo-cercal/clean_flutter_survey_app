import 'package:clean_flutter_login_app/presentation/dependecies/validation.dart';

abstract class FieldValidation {
  String get field;

  ValidationError? validate(String? value);
}
