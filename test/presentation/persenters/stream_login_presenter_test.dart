import 'package:clean_flutter_login_app/domain/entities/account_entity.dart';
import 'package:clean_flutter_login_app/domain/entities/authentication_params_entity.dart';
import 'package:clean_flutter_login_app/domain/usecases/authentication_usecase.dart';
import 'package:clean_flutter_login_app/presentation/dependecies/validation.dart';
import 'package:clean_flutter_login_app/presentation/presenters/login/stream_login_presenter.dart';
import 'package:clean_flutter_login_app/domain/helpers/errors/domain_error.dart';
import 'package:clean_flutter_login_app/ui/helpers/errors/ui_error.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockValidation extends Mock implements Validation {}

class MockAuthentication extends Mock implements AuthenticationUseCase {}

void main() {
  late Validation validation;
  late AuthenticationUseCase authentication;
  late StreamLoginPresenter systemUnderTest;
  final String email = faker.internet.email();
  final String password = faker.internet.password();

  When mockValidationCall(String? field) => when(() => validation.validate(
        field: field ?? any(named: 'field'),
        value: any(named: 'value'),
      ));

  void mockValidation({String? field, ValidationError? value}) {
    mockValidationCall(field).thenReturn(value);
  }

  When mockAuthenticationCall() => when(() => authentication.auth(any()));

  void mockAuthentication() {
    mockAuthenticationCall()
        .thenAnswer((_) async => AccountEntity(faker.guid.guid()));
  }

  void mockAuthenticationError(DomainError error) {
    mockAuthenticationCall().thenThrow(error);
  }

  setUp(() {
    validation = MockValidation();
    authentication = MockAuthentication();
    systemUnderTest = StreamLoginPresenter(
      validation: validation,
      authentication: authentication,
    );
    registerFallbackValue(
        AuthenticationParamsEntity(email: email, password: password));
    mockValidation();
    mockAuthentication();
  });

  test('should call validation with correct email', () async {
    systemUnderTest.validateEmail(email);

    verify(() => validation.validate(field: 'email', value: email)).called(1);
  });

  test('should emit a email a invalid field error if validation fails',
      () async {
    mockValidation(value: ValidationError.invalidField);

    systemUnderTest.emailErrorStream
        ?.listen(expectAsync1((error) => expect(error, UiError.invalidField)));
    systemUnderTest.formValidStream
        ?.listen(expectAsync1((isValid) => expect(isValid, false)));

    systemUnderTest.validateEmail(email);
    systemUnderTest.validateEmail(email);
  });

  test('should emit a email a required field error if validation fails',
      () async {
    mockValidation(value: ValidationError.requiredField);

    systemUnderTest.emailErrorStream
        ?.listen(expectAsync1((error) => expect(error, UiError.requiredField)));
    systemUnderTest.formValidStream
        ?.listen(expectAsync1((isValid) => expect(isValid, false)));

    systemUnderTest.validateEmail(email);
    systemUnderTest.validateEmail(email);
  });

  test('should emit a null if validation success', () async {
    systemUnderTest.emailErrorStream
        ?.listen(expectAsync1((error) => expect(error, null)));
    systemUnderTest.formValidStream
        ?.listen(expectAsync1((isValid) => expect(isValid, false)));

    systemUnderTest.validateEmail(email);
    systemUnderTest.validateEmail(email);
  });

  test('should call validation with correct password', () async {
    systemUnderTest.validatePassword(password);

    verify(() => validation.validate(field: 'password', value: password))
        .called(1);
  });

  test('should emit a password error if validation fails', () async {
    mockValidation(value: ValidationError.requiredField);

    systemUnderTest.passwordErrorStream
        ?.listen(expectAsync1((error) => expect(error, UiError.requiredField)));
    systemUnderTest.formValidStream
        ?.listen(expectAsync1((isValid) => expect(isValid, false)));

    systemUnderTest.validatePassword(password);
    systemUnderTest.validatePassword(password);
  });

  test('should emit a null if validation succed', () async {
    systemUnderTest.passwordErrorStream
        ?.listen(expectAsync1((error) => expect(error, null)));
    systemUnderTest.formValidStream
        ?.listen(expectAsync1((isValid) => expect(isValid, false)));

    systemUnderTest.validatePassword(password);
    systemUnderTest.validatePassword(password);
  });

  test('should disable the form buttom if any field is invalid', () async {
    mockValidation(field: 'email', value: ValidationError.invalidField);

    systemUnderTest.formValidStream
        ?.listen(expectAsync1((isValid) => expect(isValid, false)));

    systemUnderTest.validateEmail(email);
    systemUnderTest.validatePassword(password);
  });

  test('should enable form buttom if all field are valid', () async {
    systemUnderTest.emailErrorStream
        ?.listen(expectAsync1((error) => expect(error, null)));
    systemUnderTest.passwordErrorStream
        ?.listen(expectAsync1((error) => expect(error, null)));
    expectLater(systemUnderTest.formValidStream, emitsInOrder([false, true]));

    systemUnderTest.validateEmail(email);
    await Future.delayed(Duration.zero);
    systemUnderTest.validatePassword(password);
  });

  test('should call authentication with currect values', () async {
    systemUnderTest.validateEmail(email);
    systemUnderTest.validatePassword(password);

    await systemUnderTest.auth();

    verify(() => authentication
            .auth(AuthenticationParamsEntity(email: email, password: password)))
        .called(1);
  });

  test('should emit correct events on authentication success', () async {
    systemUnderTest.validateEmail(email);
    systemUnderTest.validatePassword(password);

    expectLater(systemUnderTest.loadingStream, emitsInOrder([true, false]));

    await systemUnderTest.auth();
  });

  test('should emit correct events on invalid credentials error', () async {
    mockAuthenticationError(DomainError.invalidCredentials);

    systemUnderTest.validateEmail(email);
    systemUnderTest.validatePassword(password);

    expectLater(systemUnderTest.loadingStream, emits(false));
    systemUnderTest.mainErrorStream?.listen(
        expectAsync1((error) => expect(error, UiError.invalidCredentials)));

    await systemUnderTest.auth();
  });

  test('should emit correct events on unexpected error', () async {
    mockAuthenticationError(DomainError.unexpected);

    systemUnderTest.validateEmail(email);
    systemUnderTest.validatePassword(password);

    expectLater(systemUnderTest.loadingStream, emits(false));
    systemUnderTest.mainErrorStream
        ?.listen(expectAsync1((error) => expect(error, UiError.unexpected)));

    await systemUnderTest.auth();
  });

  test('should not emit after dispose', () async {
    expectLater(systemUnderTest.emailErrorStream, neverEmits(null));

    systemUnderTest.dispose();
    systemUnderTest.validateEmail(email);
  });
}
