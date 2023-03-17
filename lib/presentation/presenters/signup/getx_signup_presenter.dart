import 'dart:async';
import 'package:clean_flutter_login_app/domain/usecases/add_account_usecase.dart';
import 'package:clean_flutter_login_app/domain/usecases/save_current_account.dart';
import 'package:clean_flutter_login_app/ui/helpers/errors/ui_error.dart';

import 'package:get/get.dart';

import '../../../domain/entities/add_account_params_entity.dart';
import '../../../domain/helpers/errors/domain_error.dart';
import '../../../ui/pages/signup/signup_presenter.dart';
import '../../dependecies/validation.dart';

class GetxSignUpPresenter extends GetxController implements SignUpPresenter {
  String? _name;
  String? _email;
  String? _password;
  String? _confirmPassword;
  final Validation validation;
  final AddAccountUseCase addAccount;
  final SaveCurrentAccount saveCurrentAccount;
  final _nameError = Rxn<UiError>();
  final _emailError = Rxn<UiError>();
  final _passwordError = Rxn<UiError>();
  final _passwordConfirmationError = Rxn<UiError>();
  final _mainError = Rxn<UiError>();
  final _navigateTo = RxnString();
  final _isFormValid = false.obs;
  final _isLoading = false.obs;

  GetxSignUpPresenter({
    required this.validation,
    required this.addAccount,
    required this.saveCurrentAccount,
  });

  @override
  Stream<UiError?>? get emailErrorStream => _emailError.stream;

  @override
  Stream<bool>? get formValidStream => _isFormValid.stream;

  @override
  Stream<bool>? get loadingStream => _isLoading.stream;

  @override
  Stream<UiError?>? get mainErrorStream => _mainError.stream;

  @override
  Stream<UiError?>? get nameErrorStream => _nameError.stream;

  @override
  Stream<String?>? get navigateToStream => _navigateTo.stream;

  @override
  Stream<UiError?>? get passwordConfirmationErrorStream =>
      _passwordConfirmationError.stream;

  @override
  Stream<UiError?>? get passwordErrorStream => _passwordError.stream;

  @override
  Future<void> signUp() async {
    try {
      _mainError.value = null;
      _isLoading.value = true;
      final result = await addAccount.add(AddAccountParamsEntity(
          email: _email!,
          password: _password!,
          name: _name!,
          passwordConfirmation: _confirmPassword!));
      await saveCurrentAccount.save(result);
      _navigateTo.value = '/surveys';
    } on DomainError catch (error) {
      switch (error) {
        case DomainError.emailInUse:
          _mainError.value = UiError.emailInUse;
          break;
        default:
          _mainError.value = UiError.unexpected;
          break;
      }
      _isLoading.value = false;
    }
  }

  @override
  void validateEmail(String email) {
    _email = email;
    _emailError.value = validateField('email');
    _validateForm();
  }

  void _validateForm() {
    _isFormValid.value = _nameError.value == null &&
        _emailError.value == null &&
        _passwordError.value == null &&
        _passwordConfirmationError.value == null &&
        _name != null &&
        _email != null &&
        _password != null &&
        _confirmPassword != null;
  }

  @override
  UiError? validateField(String field) {
    final map = {
      'name': _name,
      'email': _email,
      'password': _password,
      'passwordConfirmation': _confirmPassword,
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
  void validateName(String name) {
    _name = name;
    _nameError.value = validateField('name');
    _validateForm();
  }

  @override
  void validatePassword(String password) {
    _password = password;
    _passwordError.value = validateField('password');
    _validateForm();
  }

  @override
  void validatePasswordConfirmation(String passwordConfirmation) {
    _confirmPassword = passwordConfirmation;
    _passwordConfirmationError.value = validateField('passwordConfirmation');
    _validateForm();
  }

  @override
  void goToLogin() {
    _navigateTo.value = '/login';
  }
}
