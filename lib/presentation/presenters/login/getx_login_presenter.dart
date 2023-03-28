import 'dart:async';

import 'package:clean_flutter_login_app/domain/entities/authentication_params_entity.dart';
import 'package:clean_flutter_login_app/domain/usecases/authentication_usecase.dart';
import 'package:clean_flutter_login_app/domain/usecases/save_current_account.dart';
import 'package:clean_flutter_login_app/presentation/minixs/form_manager.dart';
import 'package:clean_flutter_login_app/presentation/minixs/loading_manager.dart';
import 'package:clean_flutter_login_app/presentation/minixs/navigation_manager.dart';
import 'package:clean_flutter_login_app/presentation/minixs/session_manager.dart';
import 'package:clean_flutter_login_app/presentation/minixs/ui_error_manager.dart';
import 'package:clean_flutter_login_app/ui/helpers/errors/ui_error.dart';
import 'package:clean_flutter_login_app/ui/pages/login/login_presenter.dart';
import 'package:clean_flutter_login_app/domain/helpers/errors/domain_error.dart';
import 'package:get/get.dart';

import '../../dependecies/validation.dart';

class GetxLoginPresenter extends GetxController
    with
        LoadingManager,
        SessionManager,
        FormManager,
        UiErrorManager,
        NavigationManager
    implements LoginPresenter {
  String? _email;
  String? _password;
  final Validation validation;
  final AuthenticationUseCase authentication;
  final SaveCurrentAccount saveCurrentAccount;
  final _emailError = Rxn<UiError>();
  final _passwordError = Rxn<UiError>();

  GetxLoginPresenter({
    required this.validation,
    required this.authentication,
    required this.saveCurrentAccount,
  });

  @override
  Stream<UiError?>? get emailErrorStream => _emailError.stream;

  @override
  Stream<UiError?>? get passwordErrorStream => _passwordError.stream;

  @override
  void validateEmail(String email) {
    _email = email;
    _emailError.value = validateField('email');
    _validateForm();
  }

  @override
  void validatePassword(String password) {
    _password = password;
    _passwordError.value = validateField('password');
    _validateForm();
  }

  @override
  Future<void> auth() async {
    try {
      mainError = null;
      isLoading = true;
      final result = await authentication.auth(AuthenticationParamsEntity(
        email: _email!,
        password: _password!,
      ));
      await saveCurrentAccount.save(result);
      navigateTo = '/surveys';
    } on DomainError catch (error) {
      switch (error) {
        case DomainError.invalidCredentials:
          mainError = UiError.invalidCredentials;
          break;
        default:
          mainError = UiError.unexpected;
          break;
      }
      isLoading = false;
    }
  }

  void _validateForm() {
    isFormValid = _emailError.value == null &&
        _passwordError.value == null &&
        _email != null &&
        _password != null;
  }

  @override
  UiError? validateField(String field) {
    final map = {
      'email': _email,
      'password': _password,
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
  void goToSignUp() {
    navigateTo = '/signup';
  }
}
