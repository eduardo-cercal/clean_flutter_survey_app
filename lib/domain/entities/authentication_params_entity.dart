import 'package:clean_flutter_login_app/utils/constants.dart';

class AuthenticationParamsEntity {
  final String email;
  final String password;

  AuthenticationParamsEntity({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
        emailKey: email,
        passwordKey: password,
      };
}
