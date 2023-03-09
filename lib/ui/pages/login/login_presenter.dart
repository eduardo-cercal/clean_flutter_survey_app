abstract class LoginPresenter {
  Stream<String?> get emailErrorStream;

  Stream<String?> get passwordErrorStream;

  Stream<bool> get formValidStream;

  void validateEmail(String email);

  void validatePassword(String password);
}
