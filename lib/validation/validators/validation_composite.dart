import '../../presentation/dependecies/validation.dart';
import 'dependencies/field_validation.dart';

class ValidationComposite implements Validation {
  final List<FieldValidation> validations;

  ValidationComposite(this.validations);

  @override
  String? validate({required String field, required String value}) {
    for (FieldValidation validation
        in validations.where((element) => element.field == field)) {
      final String? error = validation.validate(value);
      if (error != null && error.isNotEmpty) return error;
    }
    return null;
  }
}
