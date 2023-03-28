import '../../helpers/errors/ui_error.dart';

abstract class LoginPresenter {
  Stream<UiError?>? get emailErrorStream;

  Stream<UiError?>? get passwordErrorStream;

  Stream<bool>? get isFormValidStream;

  Stream<bool>? get isLoadingStream;

  Stream<UiError?>? get mainErrorStream;

  Stream<String?>? get navigateToStream;

  void validateEmail(String email);

  void validatePassword(String password);

  Future<void> auth();

  UiError? validateField(String field);

  void dispose();

  void goToSignUp();
}
