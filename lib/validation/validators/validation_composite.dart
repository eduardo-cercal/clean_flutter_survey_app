import '../../presentation/dependecies/validation.dart';
import '../dependencies/field_validation.dart';

class ValidationComposite implements Validation {
  final List<FieldValidation> validations;

  ValidationComposite(this.validations);

  @override
  ValidationError? validate({required String field, required String value}) {
    for (FieldValidation validation
        in validations.where((element) => element.field == field)) {
      final ValidationError? error = validation.validate(value);
      if (error != null) return error;
    }
    return null;
  }
}
