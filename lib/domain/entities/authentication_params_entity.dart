import 'package:equatable/equatable.dart';

class AuthenticationParamsEntity extends Equatable {
  final String email;
  final String password;

  const AuthenticationParamsEntity({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [
        email,
        password,
      ];
}
