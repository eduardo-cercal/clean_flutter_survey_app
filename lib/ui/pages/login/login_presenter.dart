import '../../helpers/errors/ui_error.dart';

abstract class LoginPresenter {
  Stream<UiError?>? get emailErrorStream;

  Stream<UiError?>? get passwordErrorStream;

  Stream<bool>? get formValidStream;

  Stream<bool>? get loadingStream;

  Stream<UiError?>? get mainErrorStream;

  Stream<String?>? get navigateToStream;

  void validateEmail(String email);

  void validatePassword(String password);

  Future<void> auth();

  UiError? validateField({required String field, required String value});

  void dispose();
}
