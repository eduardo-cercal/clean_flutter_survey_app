class LoginState {
  String? emailError;
  String? email;
  String? passwordError;
  String? password;
  bool isLoading = false;
  String? mainError;

  bool get isFormValid =>
      emailError == null &&
      passwordError == null &&
      email != null &&
      password != null;
}
