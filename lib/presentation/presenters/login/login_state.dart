import '../../../ui/helpers/errors/ui_error.dart';

class LoginState {
  UiError? emailError;
  String? email;
  UiError? passwordError;
  String? password;
  bool isLoading = false;
  UiError? mainError;

  bool get isFormValid =>
      emailError == null &&
      passwordError == null &&
      email != null &&
      password != null;
}
