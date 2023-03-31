import 'package:clean_flutter_login_app/domain/entities/account_entity.dart';
import 'package:clean_flutter_login_app/domain/entities/add_account_params_entity.dart';
import 'package:clean_flutter_login_app/domain/helpers/errors/domain_error.dart';
import 'package:clean_flutter_login_app/domain/usecases/add_account_usecase.dart';
import 'package:clean_flutter_login_app/domain/usecases/save_current_account.dart';
import 'package:clean_flutter_login_app/presentation/dependecies/validation.dart';
import 'package:clean_flutter_login_app/presentation/presenters/signup/getx_signup_presenter.dart';
import 'package:clean_flutter_login_app/ui/helpers/errors/ui_error.dart';

import 'package:clean_flutter_login_app/ui/pages/signup/signup_presenter.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/fake_account_factory.dart';

class MockValidation extends Mock implements Validation {}

class MockAddAccount extends Mock implements AddAccountUseCase {}

class MockSaveCurrentAccount extends Mock implements SaveCurrentAccount {}

void main() {
  late Validation validation;
  late AddAccountUseCase addAccount;
  late SignUpPresenter systemUnderTest;
  late SaveCurrentAccount saveCurrentAccount;
  final String name = faker.person.name();
  final String email = faker.internet.email();
  final String password = faker.internet.password();
  final String passwordConfirmation = faker.internet.password();
  late AccountEntity account;

  When mockValidationCall(String? field) => when(() => validation.validate(
        field: field ?? any(named: 'field'),
        input: any(named: 'input'),
      ));

  void mockValidation({String? field, ValidationError? value}) {
    mockValidationCall(field).thenReturn(value);
  }

  When mockAddAccountCall() => when(() => addAccount.add(any()));

  void mockAddAccount(AccountEntity data) {
    account = data;
    mockAddAccountCall().thenAnswer((_) async => data);
  }

  void mockAddAccountError(DomainError error) {
    mockAddAccountCall().thenThrow(error);
  }

  When mockSaveCurrentAccountCall() =>
      when(() => saveCurrentAccount.save(any()));

  void mockSaveCurrentAccount() {
    mockSaveCurrentAccountCall().thenAnswer((_) async {});
  }

  void mockSaveCurrentAccountError() {
    mockSaveCurrentAccountCall().thenThrow(DomainError.unexpected);
  }

  Map mockInput(
          {String? name,
          String? email,
          String? password,
          String? passwordConfirmation}) =>
      {
        'name': name,
        'email': email,
        'password': password,
        'passwordConfirmation': passwordConfirmation,
      };

  setUp(() {
    validation = MockValidation();
    addAccount = MockAddAccount();
    saveCurrentAccount = MockSaveCurrentAccount();
    systemUnderTest = GetxSignUpPresenter(
      validation: validation,
      addAccount: addAccount,
      saveCurrentAccount: saveCurrentAccount,
    );
    registerFallbackValue(AddAccountParamsEntity(
      name: name,
      email: email,
      password: password,
      passwordConfirmation: password,
    ));
    mockAddAccount(FakeAccountFactory.makeEntity());
    registerFallbackValue(account);
    mockValidation();

    mockSaveCurrentAccount();
  });

  test('should call validation with correct name', () async {
    systemUnderTest.validateName(name);

    verify(() =>
            validation.validate(field: 'name', input: mockInput(name: name)))
        .called(1);
  });

  test('should emit a invalid field error if name validation fails', () async {
    mockValidation(value: ValidationError.invalidField);

    systemUnderTest.nameErrorStream
        ?.listen(expectAsync1((error) => expect(error, UiError.invalidField)));
    systemUnderTest.isFormValidStream
        ?.listen(expectAsync1((isValid) => expect(isValid, false)));

    systemUnderTest.validateName(name);
    systemUnderTest.validateName(name);
  });

  test('should emit a requiered field error if name validation fails',
      () async {
    mockValidation(value: ValidationError.requiredField);

    systemUnderTest.nameErrorStream
        ?.listen(expectAsync1((error) => expect(error, UiError.requiredField)));
    systemUnderTest.isFormValidStream
        ?.listen(expectAsync1((isValid) => expect(isValid, false)));

    systemUnderTest.validateName(name);
    systemUnderTest.validateName(name);
  });

  test('should emit a null if name validation success', () async {
    systemUnderTest.nameErrorStream
        ?.listen(expectAsync1((error) => expect(error, null)));
    systemUnderTest.isFormValidStream
        ?.listen(expectAsync1((isValid) => expect(isValid, false)));

    systemUnderTest.validateName(name);
    systemUnderTest.validateName(name);
  });

  test('should call validation with correct email', () async {
    systemUnderTest.validateEmail(email);

    verify(() =>
            validation.validate(field: 'email', input: mockInput(email: email)))
        .called(1);
  });

  test('should emit a invalid field error if email validation fails', () async {
    mockValidation(value: ValidationError.invalidField);

    systemUnderTest.emailErrorStream
        ?.listen(expectAsync1((error) => expect(error, UiError.invalidField)));
    systemUnderTest.isFormValidStream
        ?.listen(expectAsync1((isValid) => expect(isValid, false)));

    systemUnderTest.validateEmail(email);
    systemUnderTest.validateEmail(email);
  });

  test('should emit a requiered field error if email validation fails',
      () async {
    mockValidation(value: ValidationError.requiredField);

    systemUnderTest.emailErrorStream
        ?.listen(expectAsync1((error) => expect(error, UiError.requiredField)));
    systemUnderTest.isFormValidStream
        ?.listen(expectAsync1((isValid) => expect(isValid, false)));

    systemUnderTest.validateEmail(email);
    systemUnderTest.validateEmail(email);
  });

  test('should emit a null if email validation success', () async {
    systemUnderTest.emailErrorStream
        ?.listen(expectAsync1((error) => expect(error, null)));
    systemUnderTest.isFormValidStream
        ?.listen(expectAsync1((isValid) => expect(isValid, false)));

    systemUnderTest.validateEmail(email);
    systemUnderTest.validateEmail(email);
  });

  test('should call validation with correct password', () async {
    systemUnderTest.validatePassword(password);

    verify(() => validation.validate(
        field: 'password', input: mockInput(password: password))).called(1);
  });

  test('should emit a invalid field error if password validation fails',
      () async {
    mockValidation(value: ValidationError.invalidField);

    systemUnderTest.passwordErrorStream
        ?.listen(expectAsync1((error) => expect(error, UiError.invalidField)));
    systemUnderTest.isFormValidStream
        ?.listen(expectAsync1((isValid) => expect(isValid, false)));

    systemUnderTest.validatePassword(password);
    systemUnderTest.validatePassword(password);
  });

  test('should emit a password error if validation fails', () async {
    mockValidation(value: ValidationError.requiredField);

    systemUnderTest.passwordErrorStream
        ?.listen(expectAsync1((error) => expect(error, UiError.requiredField)));
    systemUnderTest.isFormValidStream
        ?.listen(expectAsync1((isValid) => expect(isValid, false)));

    systemUnderTest.validatePassword(password);
    systemUnderTest.validatePassword(password);
  });

  test('should emit a null if password validation succed', () async {
    systemUnderTest.passwordErrorStream
        ?.listen(expectAsync1((error) => expect(error, null)));
    systemUnderTest.isFormValidStream
        ?.listen(expectAsync1((isValid) => expect(isValid, false)));

    systemUnderTest.validatePassword(password);
    systemUnderTest.validatePassword(password);
  });

  test('should call validation with correct password confirmation', () async {
    systemUnderTest.validatePasswordConfirmation(passwordConfirmation);

    verify(() => validation.validate(
            field: 'passwordConfirmation',
            input: mockInput(passwordConfirmation: passwordConfirmation)))
        .called(1);
  });

  test('should emit a invalid field error if password validation fails',
      () async {
    mockValidation(value: ValidationError.invalidField);

    systemUnderTest.passwordConfirmationErrorStream
        ?.listen(expectAsync1((error) => expect(error, UiError.invalidField)));
    systemUnderTest.isFormValidStream
        ?.listen(expectAsync1((isValid) => expect(isValid, false)));

    systemUnderTest.validatePasswordConfirmation(passwordConfirmation);
    systemUnderTest.validatePasswordConfirmation(passwordConfirmation);
  });

  test('should emit a password confirmation error if validation fails',
      () async {
    mockValidation(value: ValidationError.requiredField);

    systemUnderTest.passwordConfirmationErrorStream
        ?.listen(expectAsync1((error) => expect(error, UiError.requiredField)));
    systemUnderTest.isFormValidStream
        ?.listen(expectAsync1((isValid) => expect(isValid, false)));

    systemUnderTest.validatePasswordConfirmation(passwordConfirmation);
    systemUnderTest.validatePasswordConfirmation(passwordConfirmation);
  });

  test('should emit a null if password confirmation validation succed',
      () async {
    systemUnderTest.passwordConfirmationErrorStream
        ?.listen(expectAsync1((error) => expect(error, null)));
    systemUnderTest.isFormValidStream
        ?.listen(expectAsync1((isValid) => expect(isValid, false)));

    systemUnderTest.validatePasswordConfirmation(password);
    systemUnderTest.validatePasswordConfirmation(password);
  });

  test('should disable form buttom if any field is invalid', () async {
    mockValidation(field: 'email', value: ValidationError.invalidField);

    systemUnderTest.isFormValidStream
        ?.listen(expectAsync1((isValid) => expect(isValid, false)));

    systemUnderTest.validateEmail(email);
    systemUnderTest.validatePassword(password);
  });

  test('should enable form buttom if all fields are valid', () async {
    expectLater(systemUnderTest.isFormValidStream, emitsInOrder([false, true]));

    systemUnderTest.validateName(name);
    await Future.delayed(Duration.zero);
    systemUnderTest.validateEmail(email);
    await Future.delayed(Duration.zero);
    systemUnderTest.validatePassword(password);
    await Future.delayed(Duration.zero);
    systemUnderTest.validatePasswordConfirmation(passwordConfirmation);
  });

  test('should call add account with currect values', () async {
    systemUnderTest.validateName(name);
    systemUnderTest.validateEmail(email);
    systemUnderTest.validatePassword(password);
    systemUnderTest.validatePasswordConfirmation(passwordConfirmation);

    await systemUnderTest.signUp();

    verify(() => addAccount.add(AddAccountParamsEntity(
          email: email,
          password: password,
          name: name,
          passwordConfirmation: passwordConfirmation,
        ))).called(1);
  });

  test('should call saveCurrentAccount with currect value', () async {
    systemUnderTest.validateName(name);
    systemUnderTest.validateEmail(email);
    systemUnderTest.validatePassword(password);
    systemUnderTest.validatePasswordConfirmation(passwordConfirmation);

    await systemUnderTest.signUp();

    verify(() => saveCurrentAccount.save(account)).called(1);
  });

  test('should emit unexpected error if SaveCurrentAccount fails', () async {
    mockSaveCurrentAccountError();

    systemUnderTest.validateName(name);
    systemUnderTest.validateEmail(email);
    systemUnderTest.validatePassword(password);
    systemUnderTest.validatePasswordConfirmation(passwordConfirmation);

    expectLater(systemUnderTest.mainErrorStream,
        emitsInOrder([null, UiError.unexpected]));
    expectLater(systemUnderTest.isLoadingStream, emitsInOrder([true, false]));

    await systemUnderTest.signUp();
  });

  test('should emit correct events on signup success', () async {
    systemUnderTest.validateName(name);
    systemUnderTest.validateEmail(email);
    systemUnderTest.validatePassword(password);
    systemUnderTest.validatePasswordConfirmation(passwordConfirmation);

    expectLater(systemUnderTest.isLoadingStream, emits(true));

    await systemUnderTest.signUp();
  });

  test('should change page on success', () async {
    systemUnderTest.validateName(name);
    systemUnderTest.validateEmail(email);
    systemUnderTest.validatePassword(password);
    systemUnderTest.validatePasswordConfirmation(passwordConfirmation);

    systemUnderTest.navigateToStream
        ?.listen(expectAsync1((page) => expect(page, '/surveys')));

    await systemUnderTest.signUp();
  });

  test('should emit correct events on email in use error', () async {
    mockAddAccountError(DomainError.emailInUse);

    systemUnderTest.validateName(name);
    systemUnderTest.validateEmail(email);
    systemUnderTest.validatePassword(password);
    systemUnderTest.validatePasswordConfirmation(passwordConfirmation);

    expectLater(systemUnderTest.isLoadingStream, emitsInOrder([true, false]));
    expectLater(systemUnderTest.mainErrorStream,
        emitsInOrder([null, UiError.emailInUse]));

    await systemUnderTest.signUp();
  });

  test('should emit correct events on unexpected error', () async {
    mockAddAccountError(DomainError.unexpected);

    systemUnderTest.validateName(name);
    systemUnderTest.validateEmail(email);
    systemUnderTest.validatePassword(password);
    systemUnderTest.validatePasswordConfirmation(passwordConfirmation);

    expectLater(systemUnderTest.isLoadingStream, emitsInOrder([true, false]));
    expectLater(systemUnderTest.mainErrorStream,
        emitsInOrder([null, UiError.unexpected]));

    await systemUnderTest.signUp();
  });

  test('should go to login page on link click', () async {
    systemUnderTest.navigateToStream
        ?.listen(expectAsync1((page) => expect(page, '/login')));

    systemUnderTest.goToLogin();
  });
}
