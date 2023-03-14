import 'dart:async';

import 'package:clean_flutter_login_app/domain/entities/authentication_params_entity.dart';
import 'package:clean_flutter_login_app/domain/usecases/authentication_usecase.dart';
import 'package:clean_flutter_login_app/ui/pages/login/login_presenter.dart';
import 'package:clean_flutter_login_app/utils/domain_error.dart';

import '../../dependecies/validation.dart';
import 'login_state.dart';

class StreamLoginPresenter implements LoginPresenter {
  final Validation validation;
  final AuthenticationUseCase authentication;
  StreamController<LoginState>? controller =
      StreamController<LoginState>.broadcast();
  final loginState = LoginState();

  StreamLoginPresenter({
    required this.validation,
    required this.authentication,
  });

  @override
  Stream<String?>? get emailErrorStream =>
      controller?.stream.map((state) => state.emailError).distinct();

  @override
  Stream<String?>? get passwordErrorStream =>
      controller?.stream.map((state) => state.passwordError).distinct();

  @override
  Stream<bool>? get formValidStream =>
      controller?.stream.map((state) => state.isFormValid).distinct();

  @override
  Stream<bool>? get loadingStream =>
      controller?.stream.map((state) => state.isLoading).distinct();

  @override
  Stream<String?>? get mainErrorStream =>
      controller?.stream.map((state) => state.mainError).distinct();

  void update() => controller?.add(loginState);

  @override
  void validateEmail(String email) {
    loginState.email = email;
    loginState.emailError = validation.validate(field: 'email', value: email);
    update();
  }

  @override
  void validatePassword(String password) {
    loginState.password = password;
    loginState.passwordError =
        validation.validate(field: 'password', value: password);
    update();
  }

  @override
  Future<void> auth() async {
    loginState.isLoading = true;
    update();
    try {
      await authentication.auth(AuthenticationParamsEntity(
        email: loginState.email!,
        password: loginState.password!,
      ));
    } on DomainError catch (error) {
      loginState.mainError = error.description;
    }
    loginState.isLoading = false;
    update();
  }

  @override
  void dispose() {
    controller?.close();
    controller = null;
  }

  @override
  // TODO: implement navigateToStream
  Stream<String?>? get navigateToStream => throw UnimplementedError();
}
