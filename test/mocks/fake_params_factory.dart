import 'package:clean_flutter_login_app/domain/entities/add_account_params_entity.dart';
import 'package:clean_flutter_login_app/domain/entities/authentication_params_entity.dart';
import 'package:faker/faker.dart';

class FakeParamsFactory {
  static AddAccountParamsEntity makeAddAccount() => AddAccountParamsEntity(
        email: faker.internet.email(),
        password: faker.internet.password(),
        name: faker.person.name(),
        passwordConfirmation: faker.internet.password(),
      );

  static AuthenticationParamsEntity makeAuthentication() =>
      AuthenticationParamsEntity(
        email: faker.internet.email(),
        password: faker.internet.password(),
      );
}
