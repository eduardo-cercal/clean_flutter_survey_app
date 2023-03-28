import 'dart:async';

import 'package:clean_flutter_login_app/domain/entities/authentication_params_entity.dart';
import 'package:clean_flutter_login_app/domain/usecases/authentication_usecase.dart';
import 'package:clean_flutter_login_app/ui/helpers/errors/ui_error.dart';
import 'package:clean_flutter_login_app/ui/pages/login/login_presenter.dart';
import 'package:clean_flutter_login_app/domain/helpers/errors/domain_error.dart';

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
  Stream<UiError?>? get emailErrorStream =>
      controller?.stream.map((state) => state.emailError).distinct();

  @override
  Stream<UiError?>? get passwordErrorStream =>
      controller?.stream.map((state) => state.passwordError).distinct();

  @override
  Stream<bool>? get isFormValidStream =>
      controller?.stream.map((state) => state.isFormValid).distinct();

  @override
  Stream<bool>? get isLoadingStream =>
      controller?.stream.map((state) => state.isLoading).distinct();

  @override
  Stream<UiError?>? get mainErrorStream =>
      controller?.stream.map((state) => state.mainError).distinct();

  @override
  Stream<String?>? get navigateToStream => throw UnimplementedError();

  void update() => controller?.add(loginState);

  @override
  void validateEmail(String email) {
    loginState.email = email;
    loginState.emailError = validateField('email');
    update();
  }

  @override
  void validatePassword(String password) {
    loginState.password = password;
    loginState.passwordError = validateField('password');
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
      switch (error) {
        case DomainError.invalidCredentials:
          loginState.mainError = UiError.invalidCredentials;
          break;
        default:
          loginState.mainError = UiError.unexpected;
          break;
      }
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
  UiError? validateField(String field) {
    final map = {
      'email': loginState.email,
      'password': loginState.password,
    };
    final error = validation.validate(field: field, input: map);

    switch (error) {
      case ValidationError.requiredField:
        return UiError.requiredField;
      case ValidationError.invalidField:
        return UiError.invalidField;
      default:
        return null;
    }
  }

  @override
  void goToSignUp() {}
}
