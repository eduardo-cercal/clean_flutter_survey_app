import 'dart:async';

import 'package:clean_flutter_login_app/domain/entities/authentication_params_entity.dart';
import 'package:clean_flutter_login_app/domain/usecases/authentication_usecase.dart';
import 'package:clean_flutter_login_app/domain/usecases/save_current_account.dart';
import 'package:clean_flutter_login_app/ui/pages/login/login_presenter.dart';
import 'package:clean_flutter_login_app/utils/domain_error.dart';
import 'package:get/get.dart';

import '../../dependecies/validation.dart';

class GetxLoginPresenter extends GetxController implements LoginPresenter {
  String? _email;
  String? _password;
  final Validation validation;
  final AuthenticationUseCase authentication;
  final SaveCurrentAccount saveCurrentAccount;
  final _emailError = RxnString();
  final _passwordError = RxnString();
  final _mainError = RxnString();
  final _navigateTo = RxnString();
  final _isFormValid = false.obs;
  final _isLoading = false.obs;

  GetxLoginPresenter({
    required this.validation,
    required this.authentication,
    required this.saveCurrentAccount,
  });

  @override
  Stream<String?>? get emailErrorStream => _emailError.stream;

  @override
  Stream<String?>? get passwordErrorStream => _passwordError.stream;

  @override
  Stream<bool>? get formValidStream => _isFormValid.stream;

  @override
  Stream<bool>? get loadingStream => _isLoading.stream;

  @override
  Stream<String?>? get mainErrorStream => _mainError.stream;

  @override
  Stream<String?>? get navigateToStream => _navigateTo.stream;

  @override
  void validateEmail(String email) {
    _email = email;
    _emailError.value = validation.validate(field: 'email', value: email);
    _validateForm();
  }

  @override
  void validatePassword(String password) {
    _password = password;
    _passwordError.value =
        validation.validate(field: 'password', value: password);
    _validateForm();
  }

  @override
  Future<void> auth() async {
    try {
      _isLoading.value = true;
      final result = await authentication.auth(AuthenticationParamsEntity(
        email: _email!,
        password: _password!,
      ));
      await saveCurrentAccount.save(result);
      _navigateTo.value = '/surveys';
    } on DomainError catch (error) {
      _mainError.value = error.description;
      _isLoading.value = false;
    }
  }

  void _validateForm() {
    _isFormValid.value = _emailError.value == null &&
        _passwordError.value == null &&
        _email != null &&
        _password != null;
  }
}
