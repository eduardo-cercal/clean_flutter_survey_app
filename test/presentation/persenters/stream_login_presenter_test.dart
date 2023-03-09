import 'dart:async';

import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

abstract class Validation {
  String? validate({
    required String field,
    required String value,
  });
}

class MockValidation extends Mock implements Validation {}

class LoginState {
  String? emailError = 'error';
}

class StreamLoginPresenter {
  final Validation validation;
  final controller = StreamController<LoginState>.broadcast();
  final loginState = LoginState();

  Stream<String?> get emailErrorStream =>
      controller.stream.map((state) => state.emailError);

  StreamLoginPresenter({required this.validation});

  void validateEmail(String email) {
    validation.validate(field: 'email', value: email);
    controller.add(loginState);
  }
}

void main() {
  late Validation validation;
  late StreamLoginPresenter systemUnderTest;
  final String email = faker.internet.email();

  setUp(() {
    validation = MockValidation();
    systemUnderTest = StreamLoginPresenter(validation: validation);
  });

  test('should call validation with correct email', () async {
    systemUnderTest.validateEmail(email);

    verify(() => validation.validate(field: 'email', value: email)).called(1);
  });

  test('should emit a email error if validation fails', () async {
    when(() => validation.validate(
        field: any(named: 'field'),
        value: any(named: 'value'))).thenReturn('error');

    expectLater(systemUnderTest.emailErrorStream, emits('error'));

    systemUnderTest.validateEmail(email);
  });
}
