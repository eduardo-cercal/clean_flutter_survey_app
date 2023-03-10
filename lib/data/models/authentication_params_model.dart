import 'package:clean_flutter_login_app/domain/entities/authentication_params_entity.dart';

import '../../utils/constants.dart';

class AuthenticationParamsModel extends AuthenticationParamsEntity {
  const AuthenticationParamsModel({
    required super.email,
    required super.password,
  });

  factory AuthenticationParamsModel.fromEntity(
          AuthenticationParamsEntity entity) =>
      AuthenticationParamsModel(
        email: entity.email,
        password: entity.password,
      );

  Map<String, dynamic> toJson() => {
        emailKey: email,
        passwordKey: password,
      };
}
