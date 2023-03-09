abstract class LoginPresenter {
  Stream<String?> get emailErrorStream;

  Stream<String?> get passwordErrorStream;

  Stream<bool> get formValidStream;

  Stream<bool> get loadingStream;

  Stream<String?> get mainErrorStream;

  void validateEmail(String email);

  void validatePassword(String password);

  void auth();

  void dispose();
}
