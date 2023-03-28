import '../../helpers/errors/ui_error.dart';

abstract class SignUpPresenter {
  Stream<UiError?>? get nameErrorStream;

  Stream<UiError?>? get emailErrorStream;

  Stream<UiError?>? get passwordErrorStream;

  Stream<UiError?>? get passwordConfirmationErrorStream;

  Stream<bool>? get isFormValidStream;

  Stream<bool>? get isLoadingStream;

  Stream<UiError?>? get mainErrorStream;

  Stream<String?>? get navigateToStream;

  void validateName(String name);

  void validateEmail(String email);

  void validatePassword(String password);

  void validatePasswordConfirmation(String passwordConfirmation);

  Future<void> signUp();

  UiError? validateField(String field);

  void dispose();

  void goToLogin();
}
